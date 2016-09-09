//
//  Healthy.h
//  Healthy
//
//  Created by 刘怀智 on 16/4/7.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Healthy : NSObject

@property (nonatomic, copy) NSString *healthyTypeName;///<分类名
@property (nonatomic, copy) NSString *healthyTypeID;///<分类ID

@property (nonatomic, copy) NSString *healthyName;///<名称
@property (nonatomic, copy) NSString *healthyID;///<ID
@property (nonatomic, copy) NSString *healthyAbout;///<简介
@property (nonatomic, copy) NSString *healthyImageURL;///<图片地址
@property (nonatomic, strong) NSData *healthyImageData;///<图片数据
@property (nonatomic, copy) NSString *message;///<内容
@property (nonatomic, copy) NSString *HealthyTime;///<时间

@end
