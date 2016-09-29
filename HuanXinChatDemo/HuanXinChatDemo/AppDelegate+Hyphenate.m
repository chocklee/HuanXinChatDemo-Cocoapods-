//
//  AppDelegate+EaseMob.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/23.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "AppDelegate+Hyphenate.h"

#import "LoginViewController.h"
#import "MainViewController.h"
#import "ApplyViewController.h"
#import "ChatCoordinator.h"

@implementation AppDelegate (Hyphenate)

// 环信初始化和注册推送
- (void)hyphenateApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appkey:(NSString *)appkey apnsCertName:(NSString *)apnsCertName otherConfig:(NSDictionary *)otherConfig {
    
    // 注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    // 环信初始化和注册推送
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appkey apnsCertName:apnsCertName otherConfig:otherConfig];
    // 初始化ChatCoordinator 注册回调
    [ChatCoordinator shareCoordinator];
    // 判断是否设置了自动登录
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#pragma mark - AppDeleate 注册推送后iOS自动回调以下方法，得到deviceToken
// 将 deviceToken 传给 SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

#pragma mark - login changed
- (void)loginStateChange:(NSNotification *)notification {
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {
        //加载申请通知的数据
        [[ApplyViewController shareController] loadDataFromLocalDB];
        if (!self.mainVC) {
            self.mainVC = [[MainViewController alloc] init];
            self.window.rootViewController = self.mainVC;
        } else {
            self.window.rootViewController = self.mainVC;
        }
        [ChatCoordinator shareCoordinator].mainVC = self.mainVC;
    } else {
        //登陆失败加载登陆页面控制器
        if (self.mainVC) {
            [self.mainVC.navigationController popToRootViewControllerAnimated:NO];
        }
        self.mainVC = nil;
        [ChatCoordinator shareCoordinator].mainVC = nil;
        // 登录、注册页面
        LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = rootVC;
    }
}

@end
