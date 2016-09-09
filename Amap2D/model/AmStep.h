//
//  AmStep.h
//  Amap2D
//
//  Created by 刘怀智 on 16/3/6.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface AmStep : NSObject

@property (nonatomic, strong) NSString *instruction;///<具体步骤
@property (nonatomic, strong) NSString *orientation;///<方向
@property (nonatomic, strong) NSString *road;
@property (nonatomic, assign) NSInteger distance;///<距离
@property (nonatomic, assign) NSInteger duration;///<时间
@property (nonatomic, strong) NSString *polyline;///<行进路线坐标串
@property (nonatomic, strong) NSArray *polyLineArray;///<行进路线坐标数组
@property (nonatomic, strong) NSString *action;///<最后的动作
@property (nonatomic, strong) NSString *assistantAction;///<
@property (nonatomic, strong) NSString *tollRoad;///<
@property (nonatomic, strong) NSArray *cities;///<城市信息


-(instancetype)initWithStep:(AMapStep *) step;

@end
