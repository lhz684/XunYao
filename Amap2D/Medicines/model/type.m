//
//  type.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/21.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import "type.h"

@implementation type
-(instancetype)initWithName:(NSString *) name withID:(NSInteger) ID{
    if (self=[super init]) {
        self.typeName=name;
        self.typeID=@(ID);
    }
    return self;
}
//NSArray *list2 = [str componentsSeparatedByString:@"[收起]"];
-(void)setTypeName:(NSString *)typeName{
    if(_typeName != typeName){
        _typeName  = typeName;
        [self getPinYInFromName:_typeName];
    }
}
-(void)getPinYInFromName:(NSString *)name{
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",name];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    self.pinYin = [mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end


//*使用UIView父容器开启UserInterface Enable*/