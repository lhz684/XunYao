//
//  AmapPath.h
//  Amap2D
//
//  Created by 刘怀智 on 16/3/6.
//  Copyright © 2016年 lhz. All rights reserved.
//

/* 路线对象 */

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
@interface AmapPath : NSObject ///<路线

@property (nonatomic, strong) NSString *PathName;///<路线名称
@property (nonatomic, strong) NSArray *steps;///<路线途径
@property (nonatomic, strong) NSString *strategy;///<路径类型
@property (nonatomic, assign) NSInteger distance;///<距离
@property (nonatomic, assign) NSInteger duration;///<耗时
@property (nonatomic, assign) float tolls;///<花费的总金额
@property (nonatomic, assign) float tollDistance;///<单位距离花费的金额
@property (nonatomic, strong) NSMutableArray *stepsArray;///<行进步骤坐标数组

-(instancetype)initWithPaths:(AMapPath *)path andName: (NSString *) name;

@end
