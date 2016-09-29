//
//  AppDelegate.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/23.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate> {
    // 网络连接状态
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainVC;

@end

