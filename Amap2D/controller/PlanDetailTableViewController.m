//
//  PlanDetailTableViewController.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/7.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "PlanDetailTableViewController.h"
#import "DetailMap.h"
#import "YaoPu.h"
#import "AmapPath.h"
#import "AmStep.h"

@interface PlanDetailTableViewController ()

@property (nonatomic, strong) AmapPath *path;
@property (nonatomic, strong) NSMutableArray *stepsArray;

@end

@implementation PlanDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.path.PathName;
    self.stepsArray = [[NSMutableArray alloc]init];
    self.stepsArray = self.path.stepsArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.stepsArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0){        
        cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        UILabel *distance = [self.tableView viewWithTag:1];
        distance.text = [NSString stringWithFormat:@"%ld (米)",self.path.distance];
        UILabel *time = [self.tableView viewWithTag:2];
        int min = self.path.duration/60;
        int mis = self.path.duration%60;
        
        
        time.text = [NSString stringWithFormat:@"%d(分)%d(秒)",min,mis];
        UILabel *tolls =  [self.tableView viewWithTag:3];
        tolls.text = [NSString stringWithFormat:@"%f (元)",self.path.tolls];
        UILabel *tollstep = [self.tableView viewWithTag:4];
        tableView.rowHeight = 160;
        
    }
    else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"stepsCell"];
        AmStep *step = self.path.stepsArray[indexPath.row];
        cell.textLabel.text = step.instruction;
        tableView.rowHeight = 50;
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0 ){
        return @"基础列表";
    }else{
        return @"路段";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        AmStep *step = self.path.stepsArray[indexPath.row];
        UIAlertView *alertView= [ [ UIAlertView alloc] initWithTitle:nil  message: step.instruction  delegate: self  cancelButtonTitle: @"知道了"  otherButtonTitles: nil];
        [alertView show];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
