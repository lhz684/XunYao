//
//  DetailMap.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/7.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "DetailMap.h"
#import "YaoPu.h"
#import "AmapPath.h"
#import "AmStep.h"
#import "ViewController.h"
#import "LinesDetaiTableViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailMap ()<MAMapViewDelegate,AMapSearchDelegate >

@property (nonatomic, strong) MAMapView *mapView;///<
@property (nonatomic, strong) AMapSearchAPI *search;///<
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;///<
@property (nonatomic, strong) NSMutableArray *YaoPuArray;///< 药铺对象数组
@property (nonatomic, strong) NSMutableArray *annotationArray;///< 标注数组
@property (nonatomic, strong) NSMutableArray *overlayArray;///< 路线overlay数组
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentDriving;
@property (nonatomic, strong) YaoPu *selectYaoPu;
@property (nonatomic, assign) CLLocationCoordinate2D selectedYaoPu;
@property (nonatomic, strong) NSMutableArray *pathsArray;
@property (nonatomic, strong) AmapPath *selectedPath;

@property (nonatomic, strong) UIView *lastButton;
@property (nonatomic, strong) UIView *nextButton;

@end

@implementation DetailMap

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    self.mapView.showsUserLocation = YES;//开启定位功能
    self.mapView.zoomEnabled = YES;//开启缩放手势
     self.mapView.scrollEnabled = YES;    //NO表示禁用滑动手势，YES表示开启
    //搜索功能
    
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];//地图跟随用户定位
    [self.view addSubview:self.mapView];
    self.selectedYaoPu = CLLocationCoordinate2DMake(self.selectYaoPu.location.latitude,self.selectYaoPu.location.longitude);
    self.mapView.showsCompass = YES;
    self.mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 65);
    self.mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    self.mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 65);  //设置比例尺位置
    self.navigationItem.rightBarButtonItem.enabled = NO;


}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 初始化每个标注
    
    
//        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.selectYaoPu.location.latitude , self.selectYaoPu.location.longitude);
//        pointAnnotation.title = self.selectYaoPu.name;
//        pointAnnotation.subtitle = [NSString stringWithFormat:@"%@ %ldm",self.selectYaoPu.address,(long)self.selectYaoPu.distance];
//        
//        
//        [self.annotationArray addObject:pointAnnotation];
//        [self.mapView addAnnotation:pointAnnotation];
    if(self.selectYaoPu.distance < 1000){
        self.segmentDriving.selectedSegmentIndex = 2;
    }else{
        self.segmentDriving.selectedSegmentIndex = 0;
    }
    [self segmentDriving:nil];
    }


#pragma mark - 标注（大头针）
// 标注气泡按钮 回调 移除点击的大头针之外的所有大头针
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    [self.annotationArray removeObject:view.annotation];//从标注数组中移除点击的标注
//    [self.mapView removeAnnotations:self.annotationArray];//在地图中移除标注数组中的所有标注
//    MAPointAnnotation *annotion = view.annotation;
//    self.selectedYaoPu = annotion.coordinate;
//    self.segmentDriving.hidden = NO;
//    self.segmentDriving.selectedSegmentIndex = 0;
//    [self segmentDriving:nil];
//    NSLog(@"%@",view.reuseIdentifier);
    
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
        return annotationView;
    }
    
    if (isSelf == NO) {
        
        NSString *pointReuseIndentifier = [[NSString alloc]initWithFormat:@"pointReuseIndentifier%d",i];
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        UIImage  *image;
        if ([a.title isEqualToString:@"起点"]) {
            image = [UIImage imageNamed:@"startPoint.png"];
        }
        else if ([a.title isEqualToString:@"终点"]){
            image = [UIImage imageNamed:@"endPoint.png"];
        }
        else{
            switch (self.segmentDriving.selectedSegmentIndex) {
                case 0:
                    image = [UIImage imageNamed:@"car.png"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"bus.png"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"man.png"];
                    break;
                default:
                    break;
            }
            
        }
        annotationView.image = image;
        i++;
        return annotationView;
    }
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
#pragma mark - 发起路径搜索
//路径搜索
- (IBAction)segmentDriving:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.mapView removeOverlays:self.overlayArray];
    [self.mapView removeAnnotations:self.annotationArray];
    
    if (self.segmentDriving.selectedSegmentIndex == 0) {
        AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
        request.origin = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        request.destination = [AMapGeoPoint locationWithLatitude:self.selectedYaoPu.latitude longitude:self.selectedYaoPu.longitude];
        request.strategy = 2;//距离优先
        request.requireExtension = YES;
        //发起路径搜索
        [self.search AMapDrivingRouteSearch: request];
    }else if (self.segmentDriving.selectedSegmentIndex == 1){
        AMapTransitRouteSearchRequest *request = [[AMapTransitRouteSearchRequest alloc] init];
        request.origin = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        request.destination = [AMapGeoPoint locationWithLatitude:self.selectedYaoPu.latitude longitude:self.selectedYaoPu.longitude];
        request.strategy = 1;
        request.nightflag = YES;
        request.requireExtension = YES;
        [self.search AMapTransitRouteSearch:request];
    }else{
        AMapWalkingRouteSearchRequest *request = [[AMapWalkingRouteSearchRequest alloc] init];
        request.origin = [AMapGeoPoint locationWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        request.destination = [AMapGeoPoint locationWithLatitude:self.selectedYaoPu.latitude longitude:self.selectedYaoPu.longitude];
        [self.search AMapWalkingRouteSearch:request];
        
    }
    
    
}
//路径搜索回调
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSLog(@"%@ 路线个数 ：%lu", route,(unsigned long)response.route.paths.count);
    [self stepsFromPaths:response.route.paths];
    if (self.pathsArray.count <= 0) {
        [self.mapView removeOverlays:self.overlayArray];
        [self.mapView removeAnnotations:self.annotationArray];
        UIAlertView *alertView= [ [ UIAlertView alloc] initWithTitle:nil  message: @"未找到路线"  delegate: self  cancelButtonTitle: @"知道了"  otherButtonTitles: nil];
        [alertView show];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;

    self.selectedPath = self.pathsArray[0];
    [self addLinesFromPath:self.selectedPath];
    
}

-(void)addLinesFromPath:(AmapPath *)amapPath{
    
    self.overlayArray = [[NSMutableArray alloc]init];
    self.annotationArray = [[NSMutableArray alloc]init];
    int i = 0;
    for (AmStep *amstep in amapPath.stepsArray) {
        int isend = 2 ;
        if (i == 0) {
            isend = 0;
        }
        if (i == amapPath.stepsArray.count-1) {
            isend = 1;
        }
        if (i == 0) {
            NSLog( @"aa");
        }
        [self creatCommonpopline:amstep.polyLineArray BeginorEnd:isend];
        i++;
    }

}
//获取所有路径各自的步骤数组
-(void)stepsFromPaths:(NSArray *) paths{
    self.pathsArray = [[NSMutableArray alloc]init];
    int i = 1;
    for (AMapPath *path in paths) {
        NSString *PathName = [[NSString alloc]initWithFormat:@"路线%d",i ];
        AmapPath *mapPath = [[AmapPath alloc]initWithPaths:path andName:PathName];
        NSMutableArray *stepsArray = [[NSMutableArray alloc]init];
        
        for (AMapStep *astep in mapPath.steps) {
            AmStep *step = [[AmStep alloc]initWithStep:astep];
            [stepsArray addObject:step];
        }
        mapPath.stepsArray = stepsArray;
        [self.pathsArray addObject:mapPath];
        i++;
    }
    [self addButtons];
    if (self.pathsArray.count <= 1) {
        self.nextButton.hidden = YES;
    }
    self.lastButton.hidden = YES;
}
//在地图添加折线，显示路径
-(void)creatCommonpopline:(NSArray *)lineArray BeginorEnd:(int) isEnd{
    
    CLLocationCoordinate2D commonPolylineCoords[lineArray.count];
    int i = 0;
    for (NSDictionary *dic in  lineArray) {
        NSString *latitude = dic[@"latitude"];
        NSString *longitude = dic[@"longitude"];
        commonPolylineCoords[i].latitude = latitude.floatValue;
        commonPolylineCoords[i].longitude = longitude.floatValue;
        if (i == lineArray.count-1 && (isEnd == 2 || isEnd == 0)) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(commonPolylineCoords[i].latitude, commonPolylineCoords[i].longitude);
            pointAnnotation.title = @"中间";
            [self.annotationArray addObject:pointAnnotation];
            [self.mapView addAnnotation:pointAnnotation];
        }
        if (isEnd == 0 && i == 0) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(commonPolylineCoords[i].latitude, commonPolylineCoords[i].longitude);
            pointAnnotation.title = @"起点";
            [self.annotationArray addObject:pointAnnotation];
            [self.mapView addAnnotation:pointAnnotation];
        }
        else if (isEnd == 1 && i == lineArray.count-1) {
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(commonPolylineCoords[i].latitude, commonPolylineCoords[i].longitude);
            pointAnnotation.title = @"终点";
            [self.annotationArray addObject:pointAnnotation];
            [self.mapView addAnnotation:pointAnnotation];
        }
        i++;
    }
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:lineArray.count];
    [self.overlayArray addObject:commonPolyline];
    //在地图上添加折线对象
    [self.mapView addOverlay:commonPolyline];
    
    //    NSLog(@"经度：%f, 纬度: %f \n",commonPolylineCoords.longitude, commonPolylineCoords.latitude);
    
}
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
    MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
    
    polylineView.lineWidth = 5.f;
    polylineView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    polylineView.lineJoin = kCALineJoinRound;//连接类型
    polylineView.lineCap = kCALineCapRound;//端点类型
    
    [self.mapView setZoomLevel:15 animated:YES];
    [self.mapView setCenterCoordinate:self.coordinate animated:YES];
    return polylineView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addButtons{
    CGSize size = self.view.bounds.size;
    UIColor *buttonColor = [[UIColor alloc]initWithRed:0.4 green:0.7 blue:1 alpha:0.7];
    UIView *last = [[UIView alloc]initWithFrame:CGRectMake(size.width-123, size.height-82, 53, 30)];
    last.backgroundColor = buttonColor;
    UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, last.frame.size.width, last.frame.size.height)];
    lastLabel.text = @"上一个";
    lastLabel.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *lastTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapLast:)];
    [last addSubview:lastLabel];
    [last addGestureRecognizer:lastTap];
    [self.view addSubview:last];
    self.lastButton = last;
    
    UIView *next = [[UIView alloc]initWithFrame:CGRectMake(size.width-63, size.height-82, 53, 30)];
    next.backgroundColor = buttonColor;
    UILabel *nextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, next.frame.size.width, next.frame.size.height)];
    nextLabel.text = @"下一个";
    nextLabel.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapNext:)];
    [next addSubview:nextLabel];
    [next addGestureRecognizer:nextTap];
    [self.view addSubview:next];
    self.nextButton = next;
}
-(void)OnTapLast:(UITapGestureRecognizer *)sender{
    NSLog( @"上一个");
   int index = [self indexOfPathForPathsArray:self.selectedPath];
    
    if (index > 0 && index < self.pathsArray.count){
        index --;
        self.selectedPath = self.pathsArray[index];
        [self addLinesFromPath:self.selectedPath];
        self.nextButton.hidden = NO;
    }
    if (index == 0) {
        self.lastButton.hidden = YES;
    }
}
-(void)OnTapNext:(UITapGestureRecognizer *)sender{
    NSLog(@"下一个");
    int index = [self indexOfPathForPathsArray:self.selectedPath];
    
    if (index >= 0 && index < self.pathsArray.count - 1){
        index ++;
        self.selectedPath = self.pathsArray[index];
        [self addLinesFromPath:self.selectedPath];
        self.lastButton.hidden = NO;
    }
    if (index == self.pathsArray.count - 1) {
        self.nextButton.hidden = YES;
    }
}
-(int)indexOfPathForPathsArray:(AmapPath *)path{
    int index = 0;
    for (int i = 0; i < self.pathsArray.count; i++) {
        AmapPath *apath = self.pathsArray[i];
        if ([apath.PathName isEqualToString:path.PathName]) {
            index = i;
        }
    }
    return index;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"detailMap2LineDetail"]) {
        LinesDetaiTableViewController *destVC = segue.destinationViewController;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:self.pathsArray];
        [array addObject:self.selectYaoPu];
        [destVC setValue: array forKey:@"array"];
    }
}

@end
