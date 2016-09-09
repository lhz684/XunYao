//
//  HealthyTableController.m
//  Healthy
//
//  Created by 刘怀智 on 16/4/7.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "HealthyTableController.h"
#import "HealthyDetailViewController.h"
#import "downLoadManager.h"
#import "Healthy.h"
#import "LiuXSegmentView.h"
@interface HealthyTableController ()

@property (nonatomic, strong) downLoadManager *down;
@property (nonatomic, strong) Healthy *healthType;
@property (nonatomic, strong) NSMutableArray *healthyArray;
@property (nonatomic, strong) NSMutableArray *healthyTypeArray;///<显示的数据 数组
@property (nonatomic, strong) NSMutableArray * NSstringList;
@end

@implementation HealthyTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.down = [downLoadManager new];
    self.healthyArray = [NSMutableArray new];
    self.healthyTypeArray = [NSMutableArray new];
    self.NSstringList = [NSMutableArray new];
    NSString * urlStr = @"http://www.tngou.net/api/info/classify";
    NSString *URLString =@"http://www.tngou.net/api/info/list?id=6&rows=10";
    [self readDataFromURLString:URLString];
    [self readDataFromURLStringOne:urlStr];
}
-(void)readDataFromURLStringOne: (NSString *)URLstring{
    [self.down healthyRequest:URLstring :^(NSData *data) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *array=dict[@"tngou"];
        for (NSMutableDictionary *dic in  array) {
            Healthy *ahealthy = [Healthy new];
            NSString *ID = dic[@"id"];
            NSString *name = dic[@"name"];
            ahealthy.healthyTypeID = ID;
            ahealthy.healthyTypeName = name;
            [self.NSstringList addObject:name];
            [self.healthyTypeArray addObject:ahealthy];
        }
        LiuXSegmentView *view=[[LiuXSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60) titles:self.NSstringList clickBlick:^void(NSInteger index) {
            self.healthType = self.healthyTypeArray[index-1];
            NSString *URLString =[NSString stringWithFormat: @"http://www.tngou.net/api/info/list?id=%d&rows=10",self.healthType.healthyTypeID.intValue];
            [self readDataFromURLString:URLString];
            self.navigationItem.title = self.healthType.healthyTypeName;
        }];
        self.tableView.tableHeaderView =view;

        [self.tableView reloadData];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)readDataFromURLString:(NSString *)URLString{
    if (_healthyArray) {
        [_healthyArray removeAllObjects];
    }
    [self.down healthyRequest:URLString:^(NSData *data) {
        
        NSMutableDictionary *allDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *tngouArray = allDictionary[@"tngou"];
        for (NSMutableDictionary *dic in  tngouArray) {
            Healthy *ahealthy = [Healthy new];
            NSString *ID = dic[@"id"];
            NSString *name = dic[@"title"];
            NSString *imageURl = [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@_82x70",dic[@"img"]];//在图片路径中添加图片大小
            NSString *time = dic[@"time"];
            ahealthy.HealthyTime = time;
            ahealthy.healthyID = ID;
            ahealthy.healthyName = name;
            ahealthy.healthyImageURL = imageURl;
            ahealthy.healthyTypeID = self.healthType.healthyTypeID;
            ahealthy.healthyTypeName = self.healthType.healthyTypeName;
            
                       //下载图片
            [self.down downLoadData:imageURl :^(NSData *data) {
                ahealthy.healthyImageData = data;
                [self.tableView reloadData];
            }];
            [self.healthyArray addObject:ahealthy];

        }
        [self.tableView reloadData];
    } ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.healthyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.rowHeight = 100;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healthyCell" forIndexPath:indexPath];
    Healthy *ahealthy = self.healthyArray[indexPath.row];
    
    UIImageView *image = (UIImageView *)[tableView viewWithTag:102];
    image.image = [UIImage imageWithData:ahealthy.healthyImageData];
    UILabel *nameLabel = (UILabel *)[tableView viewWithTag:101];
    nameLabel.text = ahealthy.healthyName;
    UILabel *timeLabel = (UILabel *)[tableView viewWithTag:100];
    timeLabel.text = ahealthy.HealthyTime;
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
    
    HealthyDetailViewController *controller = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Healthy *ahealthy = self.healthyArray[indexPath.row];
    [controller setValue:ahealthy forKey:@"healthy"];
}


@end
