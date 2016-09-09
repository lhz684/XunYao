//
//  ViewController.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/2.
//  Copyright © 2016年 lhz. All rights reserved.
//
#import "YaoPu.h"
#import "AmapPath.h"
#import "AmStep.h"
#import "ViewController.h"
#import "DetailMap.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate >

@property (nonatomic, strong) MAMapView *mapView;///<
@property (nonatomic, strong) AMapSearchAPI *search;///<
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;///<
@property (nonatomic, strong) NSMutableArray *YaoPuArray;///< 药铺对象数组
@property (nonatomic, strong) NSMutableArray *annotationArray;///< 标注数组
@property (nonatomic, strong) NSMutableArray *overlayArray;///< 路线overlay数组

@property (nonatomic, assign) CLLocationCoordinate2D selectedYaoPu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
     self.mapView.zoomEnabled = YES;//开启缩放手势
    self.mapView.showsUserLocation = YES;//开启定位功能
    self.mapView.scrollEnabled = YES;    //NO表示禁用滑动手势，YES表示开启
    //搜索功能
    
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];//地图跟随用户定位
    [self.view addSubview:self.mapView];
    self.mapView.showsCompass = YES;
    self.mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 65);
    self.mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    self.mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 65);  //设置比例尺位置

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 初始化每个标注
    self.annotationArray = [[NSMutableArray alloc]init];
    for (YaoPu *aYaoPu in self.YaoPuArray ) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(aYaoPu.location.latitude , aYaoPu.location.longitude);
        pointAnnotation.title = aYaoPu.name;
        pointAnnotation.subtitle = [NSString stringWithFormat:@"%@ %ldm",aYaoPu.address,(long)aYaoPu.distance];
        
        
        [self.annotationArray addObject:pointAnnotation];
        [self.mapView addAnnotation:pointAnnotation];
    }
    
}


#pragma mark - 标注（大头针）
// 标注气泡按钮 回调 移除点击的大头针之外的所有大头针
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    [self.annotationArray removeObject:view.annotation];//从标注数组中移除点击的标注
//    [self.mapView removeAnnotations:self.annotationArray];//在地图中移除标注数组中的所有标注
    MAPointAnnotation *annotion = view.annotation;
//    self.selectedYaoPu = annotion.coordinate;
//    self.segmentDriving.hidden = NO;
//    self.segmentDriving.selectedSegmentIndex = 0;
//    [self segmentDriving:nil];
//    DetailMap *controller = [[DetailMap alloc]init];
    NSString *storyboardName = @"Main";
    NSString *sbIdentifier = @"detailMap";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
   DetailMap *controller = [storyboard instantiateViewControllerWithIdentifier:sbIdentifier];
    
    for (YaoPu *ayaoPu in self.YaoPuArray) {
        if ([ayaoPu.name isEqualToString: annotion.title]) {
            [controller setValue:ayaoPu forKey:@"selectYaoPu"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    
    NSLog(@"%@",view.reuseIdentifier);
    
}
// 添加大头针
static int i = 0;
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    MAPointAnnotation *a = annotation;
    BOOL flag = NO;
    if ([a.title isEqualToString:@"中间"] || [a.title isEqualToString:@"起点"] || [a.title isEqualToString:@"终点"]) {
        flag = YES;
    }
    BOOL isSelf = [a.title isEqualToString:@"当前位置"];
    if (flag == NO && isSelf == NO)
    {
         NSString *pointReuseIndentifier = [[NSString alloc]initWithFormat:@"pointReuseIndentifier%d",i];
        
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];//添加气泡中的按钮；
        i++;
//        [self.mapView setZoomLevel:15 animated:YES]; //设置地图的缩放
        [self.mapView setCenterCoordinate:self.coordinate animated:YES]; //设置地图的中心位置
        return annotationView;
    }
    [self.mapView setZoomLevel:15 animated:YES];  //设置地图的缩放
    return nil;
}

#pragma mark - 定位
// 定位

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        if (userLocation.coordinate.latitude == self.coordinate.latitude && userLocation.coordinate.longitude == self.coordinate.longitude) {
            return;
        }
        else{
            self.coordinate = userLocation.coordinate;
//            [self searchPOI:userLocation.coordinate];
            NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            
         }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
