//
//  MainHeadScrollerView.h
//  Lshop
//
//  Created by 谭徐杨 on 16/3/15.
//  Copyright © 2016年 tanxuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHeadScrollerView : UIScrollView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate action:(SEL)action imageArray:(NSArray*)imageArray timer:(NSTimeInterval)timer selector:(SEL)selector;

@end
