//
//  AmapPath.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/6.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "AmapPath.h"

@implementation AmapPath

-(instancetype)initWithPaths:(AMapPath *)path andName:(NSString *)name{
    if (self = [super init]) {
        self.PathName = name;
        self.distance = path.distance;
        self.duration = path.duration;
        self.strategy = path.strategy;
        self.steps = path.steps;
        self.tolls = path.tolls;
        self.tollDistance = path.tollDistance;
        
    }
    return self;
}
@end
