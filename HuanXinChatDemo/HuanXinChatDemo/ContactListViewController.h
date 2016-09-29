//
//  ContactListViewController.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "EaseUsersListViewController.h"

@interface ContactListViewController : EaseUsersListViewController

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//好友个数变化时，重新获取数据
- (void)reloadDataSource;

//群组变化时，更新群组页面
- (void)reloadGroupView;

@end
