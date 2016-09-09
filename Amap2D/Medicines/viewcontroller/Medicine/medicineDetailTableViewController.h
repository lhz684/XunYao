//
//  medicineDetailTableViewController.h
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/26.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "medicineListTableViewController.h"
#import "medicine.h"
#import "downLoadManager.h"
@interface medicineDetailTableViewController : UITableViewController
@property (strong,nonatomic) medicine *aMedicine;
@end
