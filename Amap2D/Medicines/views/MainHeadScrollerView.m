//
//  MainHeadScrollerView.m
//  Lshop
//
//  Created by 谭徐杨 on 16/3/15.
//  Copyright © 2016年 tanxuyang. All rights reserved.
//

#import "MainHeadScrollerView.h"
#import "UIImageView+AFNetworking.h"
#import "topImage.h"
#define kwidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
@implementation MainHeadScrollerView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate action:(SEL)action imageArray:(NSArray*)imageArray timer:(NSTimeInterval)timer selector:(SEL)selector{
    
    self=[super initWithFrame:frame];
    if (self) {
        NSMutableArray*insterimagearray=[NSMutableArray arrayWithArray:imageArray];
        [insterimagearray insertObject:imageArray.lastObject atIndex:0];
        [insterimagearray insertObject:imageArray.firstObject atIndex:insterimagearray.count];
        
        self.contentSize=CGSizeMake(insterimagearray.count*kwidth, 0);
        
        self.bounces=NO;
        self.delegate=delegate;
        self.pagingEnabled=YES;
        self.contentOffset=CGPointMake(kwidth, 0);
        for (int i=0; i<insterimagearray.count; i++) {
            topImage *tapimage=[[topImage alloc]initWithFrame:CGRectMake(i*kwidth + 10, 0, kwidth - 20, self.bounds.size.height)target:delegate action:action];
           
            tapimage.layer.cornerRadius = 10;
            tapimage.layer.masksToBounds = YES;
            [tapimage setImage:insterimagearray[i]];
            [self addSubview:tapimage];
        }
        [NSTimer  scheduledTimerWithTimeInterval:timer target:delegate selector:selector userInfo:nil repeats:YES];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
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
