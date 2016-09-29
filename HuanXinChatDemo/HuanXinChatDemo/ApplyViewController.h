//
//  ApplyViewController.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@interface ApplyViewController : UITableViewController {
    NSMutableArray *_dataArray;
}

@property (nonatomic, strong, readonly) NSMutableArray *dataArray;

+ (instancetype)shareController;

// 添加新的申请
- (void)addNewApply:(NSDictionary *)dictionary;

// 从本地数据库获取申请
- (void)loadDataFromLocalDB;

// 清空申请
- (void)clear;

@end
