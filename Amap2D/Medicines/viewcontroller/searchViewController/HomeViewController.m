//
//  HomeViewController.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/18.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "HomeViewController.h"
#import "medicine.h"
#import "type.h"
#import "DataBaseManager.h"
#import "downLoadManager.h"
#import "FMDB.h"
#import "medicineTypeTableViewController.h"
#import "medicineDetailTableViewController.h"
#import "UserTableView.h"
#import "YaoPuTableViewController.h"
#import "MainHeadScrollerView.h"
#import "Healthy.h"
#import "HealthyDetailViewController.h"

#define kwidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

@interface HomeViewController ()

@property (nonatomic, strong) downLoadManager *DLManager;
@property (nonatomic, strong) DataBaseManager *dataBase;
//@property (nonatomic, strong) NSMutableArray  *ganMaoArray;
//@property (nonatomic, strong) NSMutableArray  *userArray;
@property (nonatomic,strong) MainHeadScrollerView * headView;
@property (nonatomic,copy) NSMutableArray *headImageList;
@property (nonatomic, strong) NSMutableArray *healthyArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DLManager = [[downLoadManager alloc]init];
//    self.ganMaoArray = [[NSMutableArray alloc]init];
    self.dataBase  = [DataBaseManager defaultManager];
//    self.userArray = [[NSMutableArray alloc]init];
//    self.userArray = [self.dataBase  readYao];
//    
    self.healthyArray = [[NSMutableArray alloc]init];
     _headImageList = [[NSMutableArray  alloc]initWithObjects:[UIImage imageNamed:@"yao1.jpg"],[UIImage imageNamed:@"yao2.jpg"],[UIImage imageNamed:@"yao3.jpg"],[UIImage imageNamed:@"yao4.jpg"] ,nil];
    
    NSString *URLString =[NSString stringWithFormat: @"http://www.tngou.net/api/info/news"];
    [self readDataFromURLString:URLString];
    
//    [self loadData];
    [self addHeaderView];

}



-(void)addHeaderView{
    _headView = [[MainHeadScrollerView alloc]initWithFrame:CGRectMake(0, 50, kwidth, 200)  delegate:self action:nil imageArray:_headImageList timer:5 selector:@selector(play)];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.headView;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)play{
    [self scrollviewDIdCircularly];
    CGPoint newPoint=self.headView.contentOffset;
    newPoint.x +=kwidth;
    [self.headView setContentOffset:newPoint animated:YES];
}
- (void)scrollviewDIdCircularly{
    if (self.headView.contentOffset.x==self.headView.contentSize.width-kwidth) {
        [self.headView
         setContentOffset:CGPointMake(kwidth, 0) animated:NO];
    }
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.healthyArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
//    if (indexPath.section == 0 || indexPath.section == 1) {
//       
//    cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
//    self.tableView.rowHeight = 65;
//    medicine *amedic;
//    if (indexPath.section == 0) {
//        amedic = self.userArray[indexPath.row];
//        amedic.medicineImage = [UIImage imageWithData:amedic.imageData];
//    }
//    else if(indexPath.section == 1){
//        amedic = self.ganMaoArray[indexPath.row];
//    }
//    
//    UIImageView *cellImage = [self.tableView viewWithTag:100];
//    cellImage.image = amedic.medicineImage;
//    UILabel *cellName = [self.tableView viewWithTag:101];
//    cellName.text = amedic.name;
//    }else{
    
        self.tableView.rowHeight = 100;
        cell = [tableView dequeueReusableCellWithIdentifier:@"healthyCell" forIndexPath:indexPath];
        Healthy *ahealthy = self.healthyArray[indexPath.row];
        
        UIImageView *image = (UIImageView *)[tableView viewWithTag:102];
        image.image = [UIImage imageWithData:ahealthy.healthyImageData];
        UILabel *nameLabel = (UILabel *)[tableView viewWithTag:101];
        nameLabel.text = ahealthy.healthyName;
        UILabel *timeLabel = (UILabel *)[tableView viewWithTag:100];
        timeLabel.text = ahealthy.HealthyTime;;
//    }
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        return (@"健康资讯");
    
}
//-(void)loadData{
//    NSString *word = @"感冒";
//    NSString *httpUrl = @"http://apis.baidu.com/tngou/drug/search";
//    NSString *httpArg = [NSString stringWithFormat:@"name=drug&keyword=%@=1&rows=3&type=name,message",[word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [self.DLManager request:httpUrl withHttpArg:httpArg :^(NSData *data) {
//        
//        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSMutableArray *array=dict[@"tngou"];
//        if (array.count == 0) {
//            
//            return ;
//        }
//        else{
//            for (NSMutableDictionary *dic in array) {
//                NSLog(@"%@",dic);
//                NSString *aname=dic[@"name"];
//                NSNumber *ID=dic[@"id"];
//                NSString *medDescription=dic[@"description"];
//                NSString *imageUrl= dic[@"img"];
//                NSLog(@"imageUrl %@",imageUrl);
//
//                //            NSLog(@"medDescription:%@",medDescription);
//                medicine *amed=[[medicine alloc]init];
//                amed.name=aname;
//                amed.ID=ID;
//                amed.about=medDescription;
//                [self.DLManager downLoadData:imageUrl :^(NSData *data) {
//                    amed.imageData = data;
//                    amed.medicineImage = [UIImage imageWithData:data];
//                    [self.tableView reloadData];
//                }];
//                [self.ganMaoArray addObject:amed];
//            }
//            [self.tableView reloadData];
//        }
//    }];
//    
//}
-(void)readDataFromURLString:(NSString *)URLString{
    
    [self.DLManager healthyRequest:URLString:^(NSData *data) {
        
        NSMutableDictionary *allDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *tngouArray = allDictionary[@"tngou"];
        for (NSMutableDictionary *dic in  tngouArray) {
            Healthy *ahealthy = [[Healthy alloc]init];
            NSString *ID = dic[@"id"];
            NSString *name = dic[@"title"];
            NSString *imageURl = [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@_82x70",dic[@"img"]];//在图片路径中添加图片大小
            NSString *time = dic[@"time"];
            ahealthy.HealthyTime = time;
            ahealthy.healthyID = ID;
            ahealthy.healthyName = name;
            ahealthy.healthyImageURL = imageURl;
//            ahealthy.healthyTypeID = self.healthType.healthyTypeID;
//            ahealthy.healthyTypeName = self.healthType.healthyTypeName;
            
            //下载图片
            [self.DLManager downLoadData:imageURl :^(NSData *data) {
                ahealthy.healthyImageData = data;
                [self.tableView reloadData];
            }];
            [self.healthyArray addObject:ahealthy];
            
        }
        [self.tableView reloadData];
    } ];
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
- (IBAction)leftMenu:(id)sender {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([segue.identifier isEqualToString:@"Home2Detail"]) {
//      
//        medicineDetailTableViewController *controller = segue.destinationViewController;
//        NSIndexPath *path = [self.tableView indexPathForCell:sender];
//        medicine *amedic ;
//        if (path.section == 0) {
//            amedic = self.userArray[path.row];
//        }else if (path.section == 1){
//            amedic = self.ganMaoArray[path.row];
//        }
//        [controller setValue:amedic forKey:@"aMedicine"];
//    }
    if ([segue.identifier isEqualToString:@"Home2healthy"]) {
        
        HealthyDetailViewController *controller = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Healthy *ahealthy = self.healthyArray[indexPath.row];
        [controller setValue:ahealthy forKey:@"healthy"];
    }
}


@end
