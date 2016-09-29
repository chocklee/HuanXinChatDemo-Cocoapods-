//
//  ChatCoordinator.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/27.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MainViewController.h"
#import "ContactListViewController.h"

@interface ChatCoordinator : NSObject

+ (instancetype)shareCoordinator;

@property (nonatomic, weak) MainViewController *mainVC;
@property (nonatomic, weak) ContactListViewController *contactListVC;

@end
