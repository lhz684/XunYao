//
//  UserTableView.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 16/2/27.
//  Copyright © 2016年 liuhuaizhi. All rights reserved.
//

#import "UserTableView.h"
#import "medicine.h"
#import "DataBaseManager.h"
#import "medicineDetailTableViewController.h"

@interface UserTableView ()

@property (nonatomic, strong) DataBaseManager *dataBase;
@property (nonatomic, strong) NSMutableArray *medArray;

@end

@implementation UserTableView

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%s",__func__);
//    self.medArray = [[NSMutableArray alloc]init];
    self.medArray = [NSMutableArray array];
    self.navigationItem.title = @"我的收藏";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataBase = [DataBaseManager defaultManager];
    self.medArray = [self.dataBase readYao];
        [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    NSLog(@"%s",__func__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//        NSLog(@"%s",__func__);
    return self.medArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"medCell" forIndexPath:indexPath];
    tableView.rowHeight = 65;
    medicine *amed = self.medArray[indexPath.row];
    UIImageView *cellImage = [self.tableView viewWithTag:100];
    amed.medicineImage = [UIImage imageWithData:amed.imageData];
    cellImage.image = amed.medicineImage;
    UILabel *cellName = [self.tableView viewWithTag:101];
    cellName.text = amed.name;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    medicine *abc = self.medArray[indexPath.row];
//    /**
//     *  从SB加载
//     */
//    NSString * storyboardName = @"Main";
//    NSString * viewControllerID = @"detailVC";
//    /**
//     *  Name则是自己起的，在.storyboard前面的名字，如果不动，则默认是Main，而且不需要添加文件的扩展名，如果加了，就会报错；
//     *  bundle：这个参数包含storyboard的文件以及和它相关的资源，如果为空，则会调用当前程序的main bundle
//     */
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//    medicineDetailTableViewController *detailVC = (medicineDetailTableViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
//    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
//}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        medicine *amedicine = self.medArray[indexPath.row];
        [self.medArray removeObject:amedicine];
        [self.dataBase deleteYao:amedicine.ID.stringValue];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%s",__func__);
//}
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
    NSLog(@"%s",__func__);

        medicineDetailTableViewController *controller = segue.destinationViewController;
        NSIndexPath *papth = [self.tableView indexPathForCell:sender];
        medicine *amedicine = self.medArray[papth.row];
        [controller setValue:amedicine forKey:@"aMedicine"];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
