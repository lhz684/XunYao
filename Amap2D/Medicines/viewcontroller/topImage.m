//
//  topImage.m
//  Lshop
//
//  Created by 谭徐杨 on 16/3/15.
//  Copyright © 2016年 tanxuyang. All rights reserved.
//

#import "topImage.h"

@implementation topImage
- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action{
    
    self=[super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer*tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
        [self addGestureRecognizer:tapgesture];
        self.userInteractionEnabled=YES;
        
    }
    
    
    return self;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
