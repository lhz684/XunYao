//
//  Healthy.m
//  Healthy
//
//  Created by 刘怀智 on 16/4/7.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "Healthy.h"

@implementation Healthy

- (void)setHealthyTime:(NSString *)HealthyTime{
    
    NSTimeInterval time = HealthyTime.doubleValue/1000;//转换为时间（时间戳目前十位，取到的值多了三位）
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970: time];//转换为日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];//日期格式
    NSString *timeStr = [dateFormatter stringFromDate:timeDate];//转换为字符串
    _HealthyTime = timeStr;//重新给时间赋值
}
@end
