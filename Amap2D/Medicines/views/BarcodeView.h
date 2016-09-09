//
//  BarcodeView.h
//  Amap2D
//
//  Created by 刘怀智 on 16/4/22.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BarcodeViewDelegate <NSObject>

- (void)readerScanResult:(NSString *)result;

@end

@interface BarcodeView : UIView

@property (nonatomic, weak) id<BarcodeViewDelegate> delegate;

@end
