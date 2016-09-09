//
//  BarcodeView.m
//  Amap2D
//
//  Created by 刘怀智 on 16/4/22.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "BarcodeView.h"
#import <AVFoundation/AVFoundation.h>
#define DeviceMaxHeight self.frame.size.height//设备屏幕高度
#define DeviceMaxWidth self.frame.size.width//设备屏幕宽度
#define widthRate DeviceMaxWidth/320//当前设备屏幕宽度与320的比例

#define contentTitleColorStr @"666666"//覆盖层颜色
@interface BarcodeView()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, assign) CGRect scanCrop;
@property (nonatomic, strong) UIImageView *readLineView;

@end
@implementation BarcodeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupCamera];
    }    
    return self;
}

#pragma mark - 条形码
- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    //    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    // 条码类型
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.bounds;
    [self.layer addSublayer:self.preview];
    //添加覆盖层，扫描框
    [self addVoerViews];
    self.output.rectOfInterest = self.scanCrop;
    // Start
    [self.session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        NSLog(@"%@",metadataObject.stringValue);
        [self.session stopRunning];
        if (self.delegate && [self.delegate respondsToSelector:@selector(readerScanResult:)]) {
            [self.delegate readerScanResult:metadataObject.stringValue];
        }
    }
    
}
#pragma mark - 覆盖层、扫描框、扫描线
-(void)addVoerViews
{
    CGFloat wid = 60*widthRate;
    CGFloat heih = ((DeviceMaxHeight-200*widthRate)/2)-64;
//    扫描区域
    UIImage *hbImage = [UIImage imageNamed:@"scanscanBg.png"];
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = hbImage;
    [self loopDrawLine];
    //添加一个背景图片
    CGRect mImagerect = CGRectMake(wid, heih, 200*widthRate, 200*widthRate);
    [scanZomeBack setFrame:mImagerect];
    self.scanCrop=[self getScanCrop:mImagerect readerViewBounds:self.frame];//扫描框范围
    [self addSubview:scanZomeBack];
    //最上部view
    CGFloat alpha = 0.8;
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, heih)];
    upView.alpha = alpha;
    upView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6];
    [self addSubview:upView];
    //左侧的view
    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, heih, wid, 200*widthRate)];
    cLeftView.alpha = alpha;
    cLeftView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6];
    [self addSubview:cLeftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-wid, heih, wid, 200*widthRate)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6];
    [self addSubview:rightView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, heih+200*widthRate, DeviceMaxWidth, DeviceMaxHeight - heih-200*widthRate)];
    downView.alpha = alpha;
    downView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.6];
    [self addSubview:downView];
    
}
-(void)loopDrawLine
{
    
    CGRect rect = CGRectMake(60*widthRate, ((DeviceMaxHeight-200*widthRate)/2)-64, 200*widthRate, 2);
    if (self.readLineView) {
        self.readLineView.alpha = 1;
        self.readLineView.frame = rect;
    }
    else{
        self.readLineView = [[UIImageView alloc] initWithFrame:rect];
        [self.readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [self addSubview:self.readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改fream的代码写在这里
        self.readLineView.frame =CGRectMake(60*widthRate, ((DeviceMaxHeight-200*widthRate)/2)-64+200*widthRate-5, 200*widthRate, 2);
    } completion:^(BOOL finished) {
        [self loopDrawLine];
    }];
}

//计算扫码框的范围
/* 扫描框的x、y、宽、高 都是按照比例的方式表示 */
-(CGRect)getScanCrop:(CGRect) rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat X = (CGRectGetWidth(readerViewBounds) - CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    CGFloat Y = (CGRectGetHeight(readerViewBounds) - CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    CGFloat width = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    CGFloat height = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    return CGRectMake(X, Y, width, height);
}
@end
