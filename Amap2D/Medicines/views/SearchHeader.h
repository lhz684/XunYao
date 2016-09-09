//
//  SearchHeader.h
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 16/2/2.
//  Copyright © 2016年 liuhuaizhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchHeader;
@protocol  SearchHeader<NSObject>

-(void)searchHeader:(SearchHeader *)header withWord: (NSString *)word;

@end
@interface SearchHeader : UIView

@property (weak, nonatomic)id<SearchHeader> delegate;
@property (weak, nonatomic) UIButton *button;
-(instancetype)init;

@end
