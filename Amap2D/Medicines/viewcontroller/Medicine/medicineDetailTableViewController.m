//
//  medicineDetailTableViewController.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/26.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import "medicineDetailTableViewController.h"
#import "DataBaseManager.h"

@interface medicineDetailTableViewController ()

@property(strong,nonatomic) downLoadManager *loadManager;

@property (strong,nonatomic)DataBaseManager *dataBaseManager;

@property (strong,nonatomic) UIImage *mediImage;
@end

@implementation medicineDetailTableViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.loadManager =[[downLoadManager alloc]init];
    self.dataBaseManager = [DataBaseManager defaultManager];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    BOOL flag = [self findMedInDataArray:self.aMedicine];
    if (flag == YES) {
        self.aMedicine = [self medOfDataBase];
        
        self.aMedicine.medicineImage = [UIImage imageWithData:self.aMedicine.imageData];
        if (self.aMedicine.medicineImage == nil) {
            [self getAllWith:self.aMedicine.ID isAddToDataBase:YES];
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.tableView reloadData];
    }
    else{
        [self getAllWith:self.aMedicine.ID isAddToDataBase:NO];
    }
}
//判断传过来的药品是否已经存入数据库
-(BOOL)findMedInDataArray:(medicine *)med{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [self.dataBaseManager readYao];
    if (array.count > 0) {
        for (int i = 0; i <= array.count - 1 ; i++) {
            medicine *amed = array[i];
            if (med.ID.intValue == amed.ID.intValue) {
                return YES;
            }
        }
    }
    return NO;
}
//在数据库中查找并取出传入的药品
-(medicine *)medOfDataBase{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    medicine *med;
    array = [self.dataBaseManager readYao];
    for (medicine *yao in array) {
        if (yao.ID.intValue == self.aMedicine.ID.intValue) {
            med = yao;
        }
    }
    return med;
}
-(void)getAllWith:(NSNumber *)medID isAddToDataBase:(BOOL)isAdd {
    
    NSString *httpUrl = @"http://www.tngou.net/api/drug/show";
    NSString *httpArg = [NSString stringWithFormat:@"id=%@",medID.stringValue];
    
    [self.loadManager request:httpUrl withHttpArg:httpArg :^(NSData *data) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];//获取json数据
        NSString *message=dict[@"message"];
        NSString *imageUrl=[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",dict[@"img"]];
        NSString *name=dict[@"name"];
        NSString *about=dict[@"description"];
        
        self.aMedicine.message = [self cutUselessSting:message];
        self.aMedicine.name = name;
        self.aMedicine.about=about;
        
        if (!self.aMedicine.medicineImage) {
            
            [self.loadManager downLoadData:imageUrl :^(NSData *data) {
                self.aMedicine.imageData = data;
                self.mediImage = [UIImage imageWithData:data];
                self.aMedicine.medicineImage=self.mediImage;
                if (isAdd == YES) {
                    [self.dataBaseManager addYao:self.aMedicine];
                }
                [self.tableView reloadData];
            }];
        }
        [self.tableView reloadData];
    }];

}
-(NSString *)cutUselessSting:(NSString *)string {
    
    NSArray *list = [string componentsSeparatedByString:@"[展开]"];
    NSString *allString = [[NSString alloc]init];
    for (int i = 0; i < list.count; i++) {
        NSString *str;
        NSString *usefulStr;
        
        str = list[i];
        NSArray *list2 = [str componentsSeparatedByString:@"[收起]"];
        usefulStr = list2.lastObject;
        allString = [NSString stringWithFormat:@"%@%@",allString,usefulStr];
    }
    return allString;
}

#pragma mark - tabel View

- (IBAction)saveButton:(id)sender {
    self.aMedicine.isAdd = YES;
    [self.dataBaseManager addYao:self.aMedicine];
    if (self.aMedicine.isAdd == YES) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        UIAlertView *alertView= [ [ UIAlertView alloc] initWithTitle:nil  message: @"已添加到收藏"  delegate: self  cancelButtonTitle: @"知道了"  otherButtonTitles: nil];
        [alertView show];

    }
}

#pragma mark - tabel View
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
        UITextView *description=(UITextView *)[self.tableView viewWithTag:102];
        description.text=self.aMedicine.about;
        UIImageView *image=(UIImageView *)[self.tableView viewWithTag:100];
        image.image=self.aMedicine.medicineImage;
        UILabel *name=(UILabel *)[self.tableView viewWithTag:101];
        name.text=self.aMedicine.name;
        self.tableView.rowHeight = 150;
        
    }
    else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
        UIWebView *messageWeb=(UIWebView *)[self.tableView viewWithTag: 103];
        
        self.tableView.rowHeight = 480;
        [messageWeb loadHTMLString:self.aMedicine.message baseURL:nil];
        
    }
    return cell;
}
/*
 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 }
 */

@end
