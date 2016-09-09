//
//  YaoPuTableViewController.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/4.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "YaoPuTableViewController.h"
#import "ViewController.h"
#import "DetailMap.h"
@interface YaoPuTableViewController ()<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSMutableArray *YaoPuArray;
@property (nonatomic, strong) UIRefreshControl *refresh;

@end

@implementation YaoPuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MAMapView alloc]init];
    self.mapView.delegate = self;
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    self.mapView.showsUserLocation = YES;//yes为打开定位，no为关闭定位；
//    下拉刷新
    self.refresh = [[UIRefreshControl alloc]init];
    [self.refresh addTarget:self action:@selector(reloadFromServer:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.refresh ;
}
//定位
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        if (userLocation.coordinate.latitude == self.coordinate.latitude && userLocation.coordinate.longitude == self.coordinate.longitude) {
            return;
        }
        else{
            self.coordinate = userLocation.coordinate;
            [self searchPOI:userLocation.coordinate];
            NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        }
        
    }
}

//搜索
-(void)searchPOI:(CLLocationCoordinate2D)coordinate{
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    request.keywords = @"药房";
    request.types = @"医疗保健服务";
    request.sortrule = 1;
    request.requireExtension = YES;
    [self.search AMapPOIAroundSearch:request];
    return;
}


- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        UIAlertView *alertView= [ [ UIAlertView alloc] initWithTitle:nil  message: @"未获取到数据"  delegate: self  cancelButtonTitle: @"知道了"  otherButtonTitles: nil];
        [alertView show];

        [self.refresh endRefreshing];
        return;
    }
    self.YaoPuArray = [[NSMutableArray alloc]init];
    for (AMapPOI *mapPoi in response.pois){
        YaoPu *aYaoPu = [[YaoPu alloc]init];
        aYaoPu.name = mapPoi.name;
        aYaoPu.uid = mapPoi.uid;
        aYaoPu.address = mapPoi.address;
        aYaoPu.location = mapPoi.location;
        aYaoPu.tel = mapPoi.tel;
        aYaoPu.distance = mapPoi.distance ;
        [self.YaoPuArray addObject:aYaoPu];
    }
    [self.tableView reloadData];
    [self.refresh endRefreshing];
    
}

//下拉刷新
-(void)reloadFromServer:(UIRefreshControl *)sender{
    [self searchPOI:self.coordinate];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.YaoPuArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    YaoPu *ayaoPu = self.YaoPuArray[indexPath.row];
    cell.textLabel.text = ayaoPu.name;
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@  %ldm",ayaoPu.address,ayaoPu.distance ];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"button2map"]) {
        ViewController *controller = segue.destinationViewController;
        [controller setValue:self.YaoPuArray forKey:@"YaoPuArray"];
    }
    if ([segue.identifier isEqualToString:@"list2detail"]) {
        DetailMap *destVC = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        YaoPu *aYaoPu = self.YaoPuArray[path.row];
        [destVC setValue: aYaoPu forKey:@"selectYaoPu"];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
