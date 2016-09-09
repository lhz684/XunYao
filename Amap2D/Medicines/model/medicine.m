
//
//  medicine.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/25.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import "medicine.h"

@implementation medicine
-(instancetype)initWithName:(NSString *)name withMessage: (NSString *) message withImage: (UIImage *) image{
    if (self=[super init]) {
        self.name=name;
        self.message=message;
        self.medicineImage=image;
    }
    return self;
}
@end
