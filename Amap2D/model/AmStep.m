//
//  AmStep.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/6.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "AmStep.h"
#import <CoreLocation/CoreLocation.h>

@implementation AmStep

-(instancetype)initWithStep:(AMapStep *)step{
    if (self = [super init]) {
        self.instruction = step.instruction;
        self.orientation = step.orientation;
        self.road = step.road;
        self.distance = step.distance;
        self.duration = step.duration;
        self.polyline = step.polyline;
        self.action = step.action;
        self.assistantAction = step.assistantAction;
        self.tollRoad = step.tollRoad;
        self.cities = step.cities;
        self.polyLineArray = [[NSArray alloc]init];
        self.polyLineArray = [self polylineArrayFrom:self.polyline];
        
    }
    return self;
}
-(NSArray *)polylineArrayFrom:(NSString *)polyline{
    
    NSArray *stringArray=[polyline componentsSeparatedByString:@";"];//以分号为断点分割为两部分
    
    NSMutableArray *coorArray = [[NSMutableArray alloc]init];
    
    for ( NSString *string in stringArray) {
        
        NSArray *coorString = [string componentsSeparatedByString:@","];
        
        NSString *longitude = coorString.firstObject;
        NSString *latitide = coorString.lastObject;
        NSDictionary *dic = @{@"longitude":longitude,@"latitude":latitide};
        [coorArray addObject:dic];
        
    }
    return [coorArray copy];
}

@end
