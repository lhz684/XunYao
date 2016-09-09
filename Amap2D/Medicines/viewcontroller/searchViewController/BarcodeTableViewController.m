//
//  BarcodeTableViewController.m
//  Amap2D
//
//  Created by 刘怀智 on 16/4/21.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "BarcodeTableViewController.h"
#import "downLoadManager.h"
#import <AVFoundation/AVFoundation.h>
#import "medicine.h"
#import "medicineDetailTableViewController.h"
#import "BarcodeView.h"

#define DeviceMaxHeight self.view.frame.size.height
#define DeviceMaxWidth self.view.frame.size.width

@interface BarcodeTableViewController ()
<AVCaptureMetadataOutputObjectsDelegate,BarcodeViewDelegate>

//@property (nonatomic, strong) AVCaptureDevice *device;
//@property (nonatomic, strong) AVCaptureDeviceInput *input;
//@property (nonatomic, strong) AVCaptureMetadataOutput *output;
//@property (nonatomic, strong) AVCaptureSession *session;
//@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) downLoadManager *downManager;
@property (nonatomic, copy) NSString *barcodeString;
@property (nonatomic, strong) BarcodeView *codeView;
@end

@implementation BarcodeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downManager = [[downLoadManager alloc]init];
    self.resultArray = [NSMutableArray new];
//    [self setupCamera];
    self.codeView = [[BarcodeView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    self.codeView.delegate = self;
    [self.tableView addSubview:self.codeView];
    UIView *footView = [UIView new];
    self.tableView.tableFooterView = footView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)readerScanResult:(NSString *)result{
    [self.codeView removeFromSuperview];
    self.barcodeString = result;
    [self loadDataWithword:self.barcodeString];
}
//#pragma mark - 条形码
//- (void)setupCamera
//{
//    // Device
//    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//    // Input
//    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
//    
//    // Output
//    self.output = [[AVCaptureMetadataOutput alloc]init];
//    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    // Session
//    self.session = [[AVCaptureSession alloc]init];
//    //    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
//    if ([self.session canAddInput:self.input])
//    {
//        [self.session addInput:self.input];
//    }
//    if ([self.session canAddOutput:self.output])
//    {
//        [self.session addOutput:self.output];
//    }
//    
//    // 条码类型
//    self.output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    
//    // Preview
//    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
//    self.preview.frame = self.view.bounds;
//    [self.view.layer addSublayer:self.preview];
//    
//    
//    // Start
//    [self.session startRunning];
//}
//#pragma mark AVCaptureMetadataOutputObjectsDelegate
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
//{
//    
//    NSString *stringValue;
//    
//    if ([metadataObjects count] >0) {
//        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
//        stringValue = metadataObject.stringValue;
//        NSLog(@"%@",stringValue);
//        self.barcodeString = stringValue;
//    }
//    
//    [self.session stopRunning];
//    [self.preview removeFromSuperlayer];
//    [self loadDataWithword:self.barcodeString];
//    
//}

#pragma mark - loadData

-(void)loadDataWithword:(NSString *)word{
    if (word.length <= 0) {
        return;
    }
    NSString *httpUrl = @"http://www.tngou.net/api/drug/code";
    NSString *httpArg = [NSString stringWithFormat:@"code=%@",word];
    NSLog(@"%@%@",httpUrl,httpArg);
    [self.downManager request:httpUrl withHttpArg:httpArg :^(NSData *data) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (!dic) {
            NSLog(@"loadDataWithword: 未找到数据");
            return ;
        }

        NSString *aname=dic[@"name"];
        NSNumber *ID=dic[@"id"];
        NSString *medDescription=dic[@"description"];
        
        //            NSLog(@"medDescription:%@",medDescription);
        medicine *amed=[[medicine alloc]init];
        amed.name=aname;
        amed.ID=ID;
        amed.about=medDescription;
        NSString *Url=dic[@"img"];
        NSString *imageUrl = [NSString stringWithFormat:@"http://tnfs.tngou.net/img%@",Url];
        [self.downManager downLoadData:imageUrl :^(NSData *data) {
            amed.imageData = data;
            amed.medicineImage = [UIImage imageWithData:data];
            [self.tableView reloadData];
        }];
        
        [self.resultArray addObject:amed];
    
        [self.tableView reloadData];
        
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count;
    count = self.resultArray.count;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    tableView.rowHeight = 65;
    medicine *amed = self.resultArray[indexPath.row];
    UIImageView *cellImage = [self.tableView viewWithTag:100];
    cellImage.image = amed.medicineImage;
    UILabel *cellName = [self.tableView viewWithTag:101];
    cellName.text = amed.name;
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    medicineDetailTableViewController *controller = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"barcode2detail"]) {
        NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
        medicine *amedi = self.resultArray[indexpath.row];
        [controller setValue:amedi forKey:@"aMedicine"];
    }
}


@end
