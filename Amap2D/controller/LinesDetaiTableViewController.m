//
//  LinesDetaiTableViewController.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/7.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "LinesDetaiTableViewController.h"
#import "PlanDetailTableViewController.h"
#import "DetailMap.h"
#import "YaoPu.h"
#import "AmapPath.h"
#import "AmStep.h"
@interface LinesDetaiTableViewController ()

@property (nonatomic, strong) NSMutableArray *pathsArray;
@property (nonatomic, strong) YaoPu *selectedYaoPu;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation LinesDetaiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pathsArray = [[NSMutableArray alloc]init];
    self.pathsArray = self.array[0];
    self.selectedYaoPu = [[YaoPu alloc]init];
    self.selectedYaoPu = self.array[1];
    self.navigationItem.title = self.selectedYaoPu.name;
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
    
    return  self.pathsArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plan" forIndexPath:indexPath];
    AmapPath *path = self.pathsArray[indexPath.row];
    cell.textLabel.text = path.PathName ;
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    tableView.rowHeight = 50;
    
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
    PlanDetailTableViewController *destVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"lines2plans"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        AmapPath *path = self.pathsArray[indexPath.row];
        [destVC setValue:path forKey:@"path"];
    }
}


@end
