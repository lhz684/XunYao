//
//  MenuTableController.m
//  Amap2D
//
//  Created by 刘怀智 on 16/4/25.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "MenuTableController.h"
#import "UserTableView.h"

@interface MenuTableController ()
@property (nonatomic, strong) NSArray *menuNameArray;
@end

@implementation MenuTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuNameArray = @[@"我的收藏",@"服药提醒",@"关于我们"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.menuNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell ;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Menu2User" forIndexPath:indexPath];
    }else{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"menuCell"];
    }
    cell.textLabel.text = self.menuNameArray[indexPath.row];
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
