//
//  SearchHeader.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 16/2/2.
//  Copyright © 2016年 liuhuaizhi. All rights reserved.
//

#import "SearchHeader.h"
@interface SearchHeader()<UITextFieldDelegate>

@property (weak, nonatomic) UITextField *searchText;


@end
@implementation SearchHeader
-(instancetype)init{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 80;
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    self.searchText.delegate = self;
    if (self) {
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, height-1, width, 1)];
        backImage.image = [UIImage imageNamed:@"xian"];
        [self addSubview:backImage];
        [self initViews];
    }
    return self;
}
-(void)initViews{
    CGFloat margin = 20;
    UITextField *text = [UITextField new];
    text.clearsOnBeginEditing = YES;
    text.placeholder  = @"输入关键字";
    text.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.6];
    CGFloat textWidth = self.frame.size.width - margin * 3 - 40;
    text.frame = CGRectMake(margin, margin, textWidth, 40);
    [self addSubview:text];
    self.searchText = text;
    
    CGFloat imageX = textWidth + margin * 2;
    CGFloat width = 40;
//    UIImageView *image = [UIImageView new];    
//    image.frame = CGRectMake(0, 0, width, width);
//    image.image = [UIImage imageNamed:@"search1.png"];
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(imageX, margin, width, width)];
    buttonView.tag = 10;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapButtonView:)];//手指单击事件。
//    [button addGestureRecognizer:tap];
//    [button addSubview:image];
//    [self addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect fram = CGRectMake(0, 0, width, width);
    button1.frame = fram;
    [button1 setImage:[UIImage imageNamed:@"search1.png"] forState:nil];
   UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnTapButtonView:)];//手指单击事件。
    [button1 addGestureRecognizer:tap1];
    [buttonView addSubview:button1];
    [self addSubview:buttonView];
    self.button = button1;
}
-(void)OnTapButtonView:(UITapGestureRecognizer *) sender{
    NSLog(@"搜索");
    if (self.searchText.text.length<1) {
        return;
    }
    self.button.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(searchHeader:withWord:)]) {
            [self.delegate searchHeader:self withWord:self.searchText.text ];
        }
//    感冒
}

@end
