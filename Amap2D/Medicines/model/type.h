//
//  type.h
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/21.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface type : NSObject
@property (strong,nonatomic) NSString *typeName;///<分类名称
@property (strong,nonatomic) NSNumber * typeID;///<分类ID
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSString *pinYin;///<首拼
-(instancetype)initWithName:(NSString *) name withID:(NSInteger) ID;
@end
