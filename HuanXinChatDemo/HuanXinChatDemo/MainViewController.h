//
//  MainViewController.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController {
    EMConnectionState _connectionState;
}

- (void)setupUntreatedApplyCount;

@end
