//
//  YaoPu.h
//  Amap2D
//
//  Created by 刘怀智 on 16/3/3.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
@interface YaoPu : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) AMapGeoPoint *location;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) NSInteger distance;

@end
