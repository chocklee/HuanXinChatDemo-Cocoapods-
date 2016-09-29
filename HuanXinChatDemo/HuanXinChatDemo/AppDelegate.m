//
//  AppDelegate.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/23.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Hyphenate.h"

@interface AppDelegate ()

@end

// 环信AppKey
#define EaseMobAppKey @"chaoxin#hupchat"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 网络已连接
    _connectionState = EMConnectionConnected;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    // 推送证书名字
    NSString *apnsCertName = [NSString string];
#if DEBUG
    apnsCertName = @"hupchat_dev";
#else
    apnsCertName = @"hupchat";
#endif
    
    // 存取AppKey
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appKey = [ud objectForKey:@"identifier_appkey"];
    if (!appKey) {
        appKey = EaseMobAppKey;
        [ud setObject:appKey forKey:@"identifier_appkey"];
    }
    
    // 环信初始化
    [self hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appKey apnsCertName:apnsCertName otherConfig:nil];
    
    [self.window makeKeyWindow];
    return YES;
}

#pragma mark -  APNS推送处理函数
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    
}

#warning iOS10 APNS推送处理函数 在新增的UserNotifications Framework中的UNUserNotificationCenterDelegate方法中
#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response {
    
}

@end
