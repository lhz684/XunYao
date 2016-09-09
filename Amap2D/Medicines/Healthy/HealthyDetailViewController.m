//
//  HealthyDetailViewController.m
//  Healthy
//
//  Created by 刘怀智 on 16/4/7.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "HealthyDetailViewController.h"
#import "downLoadManager.h"
#import "Healthy.h"
@interface HealthyDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *healthyWeb;
@property (nonatomic, strong) Healthy *healthy;
@property (nonatomic, strong) downLoadManager *down;

@end

@implementation HealthyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.down = [downLoadManager new];
    NSString *URLString = [NSString stringWithFormat:@"http://www.tngou.net/api/info/show?id=%d",self.healthy.healthyID.intValue];
    [self readDataFromURLString:URLString];
    self.healthyWeb.scrollView.showsVerticalScrollIndicator = NO;
    self.healthyWeb.scrollView.showsHorizontalScrollIndicator = NO;
}

-(void)readDataFromURLString:(NSString *)URLString{
    [self.down healthyRequest:URLString :^(NSData *data) {
        NSMutableDictionary *allDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *message = allDictionary[@"message"];
        self.healthy.message = message;
        [self.healthyWeb loadHTMLString:self.healthy.message baseURL:nil];
    }];
}
-(void)showInWebViewWithString:(NSString *)webString{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
