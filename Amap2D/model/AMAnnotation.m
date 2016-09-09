//
//  MAAnnotation.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/6.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "AMAnnotation.h"

@implementation AMAnnotation

-(instancetype)initWithPointAnnotation:(MAPointAnnotation *)PointAnnotation{
    if (self = [super init]) {
        self.pointAnnotation = PointAnnotation;
    }
    return self;
}

@end
