//
//  downLoadManager.h
//  xunYaoMedicinesList
//
//  Created by 刘怀智 on 15/11/18.
//  Copyright © 2015年 liuhuaizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface downLoadManager : NSObject
-(void)downLoadData: (NSString *) urlLink :(void(^)(NSData *data))block;
-(void)request: (NSString *)httpUrl withHttpArg: (NSString *)HttpArg :(void(^)(NSData *data))block ;
-(void)healthyRequest: (NSString *)httpUrl  :(void(^)(NSData *data))block;
@end
