//
//  AppDelegate.m
//  Amap2D
//
//  Created by 刘怀智 on 16/3/2.
//  Copyright © 2016年 lhz. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface AppDelegate ()

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationIconBadgeNumber = 0;//图标编号为0
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
        [self addLocalNotification];//注册通知
    }else{
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    [AMapSearchServices sharedServices].apiKey = @"b5db1174142d345aadc892dc7ddf3c2d";//地图 API钥匙
     [MAMapServices sharedServices].apiKey = @"b5db1174142d345aadc892dc7ddf3c2d";
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];//设置 bar 的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//设置字体颜色
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];//字典
    [[UINavigationBar appearance] setTitleTextAttributes:navTitleArr];//设置字体颜色
    return YES;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //点击提示框的打开
    application.applicationIconBadgeNumber = 0;
}

#pragma  mark - addLocalNotfication

- (void)addLocalNotification{
    UILocalNotification * notification = [[UILocalNotification alloc]init];//注册通知
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10.0];//设置10秒过后提醒
    notification.repeatInterval = 2;//重复次数为2此
    
    
    notification.alertBody=@"亲,该吃药了喔 !!!";//提醒信息
    notification.applicationIconBadgeNumber=1;//应用上显示的消息数
    notification.alertAction=@"打开应用";//待机界面的滑动动作提示
//    notification.alertLaunchImage=@"11123";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.soundName=UILocalNotificationDefaultSoundName;
    //收到通知时播放的声音，默认消息声音
    
    //notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    
    
    notification.userInfo=@{@"id":@1,@"user":@"kenshin cui"};//绑定到通知上的其他附加信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark 调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        
        [self addLocalNotification];
        
        
    }
    
}

@end
