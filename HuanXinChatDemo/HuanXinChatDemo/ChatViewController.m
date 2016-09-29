//
//  ChatViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/28.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController () <EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource
// 消息能否长按
- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 长按消息的响应
- (BOOL)messageViewController:(EaseMessageViewController *)viewController didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"长按了第%ld行",indexPath.row);
    return YES;
}

// 点击用户的头像
- (void)messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>)messageModel {
    NSLog(@"点击了用户头像");
}

@end
