//
//  MAAnnotation.h
//  Amap2D
//
//  Created by 刘怀智 on 16/3/6.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
@interface AMAnnotation : MAPointAnnotation<MAAnnotation>

@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;

-(instancetype)initWithPointAnnotation:(MAPointAnnotation *)PointAnnotation;
@end
