//
//  downLoadManager.m
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/18.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import "downLoadManager.h"

@implementation downLoadManager
-(void)downLoadData: (NSString *) urlLink :(void(^)(NSData *data))block{
    NSURL *url=[NSURL URLWithString:urlLink];//下载,生成 URL;
    NSURLRequest *request=[NSURLRequest requestWithURL:url];// 生成一个请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {//block 函数 在主线程中完成这个函数
        if (connectionError) {
            NSLog(@"连接错误%@",connectionError);
            return ;
        }
        NSInteger code = ((NSHTTPURLResponse *)response).statusCode;
        if (code!=200) {
            NSLog(@"请求错误%ld",(long)code);
            return ;
        }
       block(data);//用 block 传回去 data
    }];
}
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg :(void(^)(NSData *data))block {
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?%@", httpUrl, HttpArg];
    NSLog( @"%@",urlStr);
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"f8d32dc3686a5cf4096b84f45a806a1d" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
   queue: [NSOperationQueue mainQueue]completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
       if (error) {
           NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
           return ;
       }
       else{
           NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
           NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           NSLog(@"HttpResponseCode:%ld", responseCode);
//           NSLog(@"HttpResponseBody %@",responseString);
       }
       block(data);
       
   }];
}

-(void)healthyRequest: (NSString*)httpUrl  :(void(^)(NSData *data))block {
    NSURL *url =[NSURL URLWithString:httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"f8d32dc3686a5cf4096b84f45a806a1d" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                           if (error) {
                                               NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                               return ;
                                           }
                                           else{
                                               NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                               NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                               NSLog(@"HttpResponseCode:%ld", responseCode);
                                               //           NSLog(@"HttpResponseBody %@",responseString);
                                           }
                                           block(data);
                                           
                                       }];
}

@end
