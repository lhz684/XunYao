//
//  searchTableViewController.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/12/5.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import "searchTableViewController.h"
#import "medicine.h"
#import "downLoadManager.h"
#import "medicineDetailTableViewController.h"
#import "SearchHeader.h"
@interface searchTableViewController ()<SearchHeader>

@property (strong,nonatomic) UISearchController *searchBar;//搜索
@property (strong, nonatomic)NSPredicate *predicate;//谓语
@property (strong,nonatomic) medicine *aMedicine;
@property (strong,nonatomic) NSMutableArray *searchArray;
@property (strong,nonatomic) downLoadManager *DLManager;
@property (assign, nonatomic) NSInteger  count;
@property (assign, nonatomic) int page;
@property (copy, nonatomic) NSString *word;
@property (nonatomic, strong) SearchHeader *searchView;//搜索视图
@end

@implementation searchTableViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchArray=[[NSMutableArray alloc]init];
    self.DLManager=[[downLoadManager alloc]init];
    self.searchView = [[SearchHeader alloc]init];
    self.searchView.delegate = self;
    self.tableView.tableHeaderView = self.searchView;
    self.page = 1;

}



-(void)searchHeader:(SearchHeader *)header withWord:(NSString *)word{
    if(word.length < 1 || word == nil)
    {
        return;
    }
    self.word = word;
    self.searchArray=[[NSMutableArray alloc]init];
    [self loadDataWithword:word];
}
#pragma mark - loadData

-(void)loadDataWithword:(NSString *)word{
    if (word.length <= 0) {
        return;
    }
    NSString *httpUrl = @"http://apis.baidu.com/tngou/drug/search";
    NSString *httpArg = [NSString stringWithFormat:@"name=drug&keyword=%@=1&rows=20&page=%d&type=name,message",[word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.page];
    [self.DLManager request:httpUrl withHttpArg:httpArg :^(NSData *data) {
       
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray *array=dict[@"tngou"];
        if (array.count == 0) {
            
            return ;
        }
        else{
            NSString *count = dict[@"total"];
            self.count = count.integerValue;
            
                for (NSMutableDictionary *dic in array) {
                   
                    NSString *aname=dic[@"name"];
                    NSNumber *ID=dic[@"id"];
                    NSString *medDescription=dic[@"description"];
                    
                    //            NSLog(@"medDescription:%@",medDescription);
                    medicine *amed=[[medicine alloc]init];
                    amed.name=aname;
                    amed.ID=ID;
                    amed.about=medDescription;
                    NSString *imageUrl=dic[@"img"];
                    [self.DLManager downLoadData:imageUrl :^(NSData *data) {
                        amed.imageData = data;
                        amed.medicineImage = [UIImage imageWithData:data];
                        [self.tableView reloadData];
                    }];

                    [self.searchArray addObject:amed];
                }
                [self.tableView reloadData];
            self.searchView.button.enabled = YES;
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchArray.count == 0 || self.searchArray.count == self.count) {
        return self.searchArray.count;
    }
    else{
        return self.searchArray.count+1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    medicine *amed;
    if(indexPath.row==self.searchArray.count && self.searchArray.count != 0 && self.searchArray.count < self.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingMoreCell" forIndexPath:indexPath];
        return cell;
    }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
        tableView.rowHeight = 65;
        amed=self.searchArray[indexPath.row];
        UIImageView *cellImage = [self.tableView viewWithTag:100];
        cellImage.image = amed.medicineImage;
        UILabel *cellName = [self.tableView viewWithTag:101];
        cellName.text = amed.name;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.searchArray.count) {
        UIActivityIndicatorView *act=(UIActivityIndicatorView *)[self.view viewWithTag:100];
        [ act startAnimating];
        act.hidden=NO;
        self.page++;
        [self loadDataWithword:self.word];
    }
}

//小儿
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
    
    
    medicineDetailTableViewController *controller=segue.destinationViewController;
    medicine *amed;
    NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
    amed=self.searchArray[indexPath.row];
    if (amed == nil) {
        return;
    }
    else{
        [controller setValue:amed forKey:@"aMedicine"];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
