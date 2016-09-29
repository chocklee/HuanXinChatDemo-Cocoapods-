//
//  AppDelegate+Hyphenate.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/23.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Hyphenate)

// 环信初始化
- (void)hyphenateApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appkey:(NSString *)appkey apnsCertName:(NSString *)apnsCertName otherConfig:(NSDictionary *)otherConfig;

@end
