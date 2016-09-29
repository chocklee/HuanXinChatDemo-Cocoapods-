//
//  MainViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "MainViewController.h"

#import "ConversationListViewController.h"
#import "ContactListViewController.h"
#import "SettingViewController.h"

#import "ApplyViewController.h"
#import "ChatCoordinator.h"

@interface MainViewController ()

@property (strong, nonatomic) UINavigationController *conversationNVC;
@property (strong, nonatomic) UINavigationController *contactNVC;
@property (strong, nonatomic) UINavigationController *settingNVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    // 统计未读请求数
    [self setupUntreatedApplyCount];
    
    [ChatCoordinator shareCoordinator].contactListVC = _contactNVC.viewControllers[0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)setupViews {
    // 会话
    _conversationNVC = [[UINavigationController alloc] initWithRootViewController:[[ConversationListViewController alloc] init]];
    UIImage *conversationImage = [UIImage imageNamed:@"tabbar_chats"];
    _conversationNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"会话" image:conversationImage tag:1001];
    
    // 联系人
    _contactNVC = [[UINavigationController alloc] initWithRootViewController:[[ContactListViewController alloc] init]];
    UIImage *contactImage = [UIImage imageNamed:@"tabbar_contacts"];
    _contactNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:contactImage tag:1002];
    
    // 设置
    _settingNVC = [[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]];
    UIImage *settingImage = [UIImage imageNamed:@"tabbar_setting"];
    _settingNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:settingImage tag:1003];
    
    self.viewControllers = @[_conversationNVC, _contactNVC, _settingNVC];
    self.selectedIndex = 0;
}

#pragma mark - public
// 统计未读请求数
- (void)setupUntreatedApplyCount {
    NSUInteger unreadCount = [ApplyViewController shareController].dataArray.count;
    if (_contactNVC) {
        if (unreadCount > 0) {
            _contactNVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",unreadCount];
        } else {
            _contactNVC.tabBarItem.badgeValue = nil;
        }
    }
}

@end
