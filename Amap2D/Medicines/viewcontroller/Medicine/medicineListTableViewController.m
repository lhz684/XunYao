//
//  medicineListTableViewController.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/21.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import "medicineListTableViewController.h"
#import "downLoadManager.h"
#import "medicineDetailTableViewController.h"
#import "medicine.h"
@interface medicineListTableViewController ()

@property downLoadManager  *manger;

@property (strong,nonatomic)type *meType;///<分类
@property (assign,nonatomic) NSInteger page;///<显示的页数
@property (strong,nonatomic) NSMutableArray *medicineArray;
@end

@implementation medicineListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.meType.typeName;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor whiteColor]];

    self.page=1;
    self.manger=[[downLoadManager alloc]init];
   
    self.medicineArray=[[NSMutableArray alloc]init];
    
    NSString *httpUrl = @"http://www.tngou.net/api/drug/list";
    NSString *httpArg = [NSString stringWithFormat:@"id=%ld&rows=20",(long)self.meType.typeID.intValue] ;
//    获取数据解析数据
    [self.manger request:httpUrl withHttpArg:httpArg :^(NSData *data) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *array=dict[@"tngou"];
        NSString *count = dict[@"total"];
        self.meType.count = count.integerValue;
        
        for (NSMutableDictionary *dic in array) {
            NSString *aname=dic[@"name"];
            NSNumber *ID=dic[@"id"];
            NSString *medDescription=dic[@"description"];
            NSString *imageUrl=[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",dic[@"img"]];
//            NSLog(@"imageUrl:%@",imageUrl);
            medicine *amed=[[medicine alloc]init];
            amed.name=aname;
            amed.ID=ID;
            amed.about=medDescription;
            [self.manger downLoadData:imageUrl :^(NSData *data) {
                amed.imageData = data;
                amed.medicineImage = [UIImage imageWithData:data];
                [self.tableView reloadData];
            }];
            [self.medicineArray addObject:amed];
            
        }
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.medicineArray.count == 0 || self.medicineArray.count == self.meType.count) {
        return self.medicineArray.count;
    }
    else{
        return self.medicineArray.count+1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    medicine *amed;
    if(indexPath.row==self.medicineArray.count && self.medicineArray.count != 0 && self.medicineArray.count < self.meType.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingMoreCell" forIndexPath:indexPath];
        return cell;
    }
    else{
        
        UITableViewCell *cell ;
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
        tableView.rowHeight = 65;
        amed=self.medicineArray[indexPath.row];
        UIImageView *cellImage = [self.tableView viewWithTag:100];
        cellImage.image = amed.medicineImage;
        UILabel *cellName = [self.tableView viewWithTag:101];
        cellName.text = amed.name;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row==self.medicineArray.count) {
        UIActivityIndicatorView *act=(UIActivityIndicatorView *)[self.view viewWithTag:100];
        [ act startAnimating];
        act.hidden=NO;
        self.page++;
        NSString *httpUrl = @"http://www.tngou.net/api/drug/list";
        NSString *httpArg = [NSString stringWithFormat:@"id=%ld&rows=20&page=%ld",(long)self.meType.typeID,self.page];
        NSLog(@"%ld",(long)self.meType.typeID);
        
        [self.manger request:httpUrl withHttpArg:httpArg :^(NSData *data) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray *array=dict[@"tngou"];
            for (NSMutableDictionary *dic in array) {
                NSString *aname=dic[@"name"];
                NSNumber *ID=dic[@"id"];
                NSString *medDescription=dic[@"description"];
                
                medicine *amed=[[medicine alloc]init];
                amed.name=aname;
                amed.ID=ID;
                amed.about=medDescription;
                NSString *imageUrl=[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",dic[@"img"]];
                [self.manger downLoadData:imageUrl :^(NSData *data) {
                    amed.imageData = data;
                    amed.medicineImage = [UIImage imageWithData:data];
                    [self.tableView reloadData];
                }];
                [self.medicineArray addObject:amed];

            }
            [self.tableView reloadData];

        }];

    }
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    medicineDetailTableViewController *controller=segue.destinationViewController;
    medicine *amed;
    NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
    amed=self.medicineArray[indexPath.row];
    
    [controller setValue:amed forKey:@"aMedicine"];
}


@end
