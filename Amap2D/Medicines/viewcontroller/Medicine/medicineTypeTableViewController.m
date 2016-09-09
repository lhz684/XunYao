//
//  medicineTypeTableViewController.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/18.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import "medicineTypeTableViewController.h"
#import "medicineListTableViewController.h"
#import "downLoadManager.h"
#import "DataBaseManager.h"
#import "type.h"
@interface medicineTypeTableViewController ()

@property (strong,nonatomic) NSString *typeLink;
@property downLoadManager *manger;
@property (strong,nonatomic) DataBaseManager *dataManager;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong,nonatomic) NSMutableArray *typeDict;
@property (strong,nonatomic) NSMutableArray *name;

@end

@implementation medicineTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"药品分类";
    
    self.name=[[NSMutableArray alloc]init];
    self.manger=[[downLoadManager alloc]init];
    self.dataManager = [DataBaseManager defaultManager];
    
    NSInteger count = 0;
    count = [self.dataManager countOfType];
    if (count > 0) {
        self.name = [self.dataManager readType];
    }
    else{
        NSString *httpUrl = @"http://apis.baidu.com/tngou/drug/classify";
        NSString *httpArg = @"id=0";
        [self.manger request:httpUrl withHttpArg:httpArg :^(NSData *data) {
            NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray *array = Dic[@"tngou"];
            
            for (NSMutableDictionary *dic in array) {
                NSString *aname=dic[@"name"];
                NSNumber *ID=dic[@"id"];
                type *atype=[[type alloc]initWithName:aname withID:ID.integerValue];
              
                [self.name addObject:atype];///<存入显示数组
            }
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
            [self.name sortUsingDescriptors:sortDescriptors];
            [self.dataManager addType:self.name];
            [self.tableView reloadData];
        }];
        
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.name.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell" forIndexPath:indexPath];
    type *atype=self.name[indexPath.row];
    cell.textLabel.text=atype.typeName;
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"listSegue"]) {
        medicineListTableViewController *controller=segue.destinationViewController;
        NSIndexPath *path=[self.tableView indexPathForCell:sender];
        type * atype=self.name[path.row];
        [controller setValue:atype forKey:@"meType"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
