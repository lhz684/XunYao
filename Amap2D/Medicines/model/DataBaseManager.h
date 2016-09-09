//
//  DataBaseManager.h
//  GuPiao
//
//  Created by 刘怀智 on 15/12/22.
//  Copyright © 2015年 lhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "medicine.h"
#import "type.h"
@interface DataBaseManager : NSObject
+(instancetype)defaultManager;

-(void)addYao:(medicine *) medicine;///<详情存入数据库
-(void)addType:(NSMutableArray *)array;///<分类存入数据库

-(NSMutableArray *)readYao;///<读取详情数据
-(NSMutableArray *)readType;

-(void)deleteYao:(NSString *)code;

-(NSUInteger)countOfType;
@end
