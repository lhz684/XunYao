//
//  medicine.h
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/25.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface medicine : NSObject

@property (copy,nonatomic) NSString *message;///<说明书
@property (copy,nonatomic) NSString *name;///<名称
@property (strong,nonatomic) NSNumber *ID;///<ID
@property (copy,nonatomic) NSString *about;///<简介
@property(strong,nonatomic) UIImage *medicineImage;
@property (strong,nonatomic) NSData *imageData;///<图片数据
@property (assign,nonatomic) BOOL isAdd;///<是否添加收藏

-(instancetype)initWithName:(NSString *)name withMessage: (NSString *) message withImage: (UIImage *) image;
@end
