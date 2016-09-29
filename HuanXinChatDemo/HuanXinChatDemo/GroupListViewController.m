//
//  GroupListViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/27.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "GroupListViewController.h"
#import "CreateGroupViewController.h"
#import "ChatViewController.h"

@interface GroupListViewController () <EMGroupManagerDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群组";
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 加载群聊数据
    [self reloadDataSource];
    
    // 移除群组代理
    [[EMClient sharedClient].groupManager removeDelegate:self];
    // 注册群组代理
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    if (!cell) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"];
    }
    if (indexPath.section == 0) {
        cell.avatarView.image = [UIImage imageNamed:@"group_creategroup"];
        cell.titleLabel.text = @"新建群聊";
        return cell;
    } else {
        EMGroup *group = self.dataArray[indexPath.row];
        cell.avatarView.image = [UIImage imageNamed:@"group_header"];
        if (group.subject && group.subject.length > 0) {
            cell.titleLabel.text = group.subject;
        } else {
            cell.titleLabel.text = group.groupId;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 32;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 32)];
    label.text = @"群组";
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        CreateGroupViewController *createGroupVC = [[CreateGroupViewController alloc] init];
        [self.navigationController showViewController:createGroupVC sender:nil];
    } else {
        EMGroup *group = self.dataArray[indexPath.row];
        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
        chatVC.title = group.subject;
        [self.navigationController showViewController:chatVC sender:nil];
    }
}

#pragma mark - getter
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - public
- (void)reloadDataSource {
    [self.dataArray removeAllObjects];
    NSArray *groups = [[EMClient sharedClient].groupManager getJoinedGroups];
    [self.dataArray addObjectsFromArray:groups];
    [self.tableView reloadData];
}

#pragma mark - EMGroupManagerDelegate 
// 群组列表发生变化
- (void)groupListDidUpdate:(NSArray *)aGroupList {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:aGroupList];
    [self.tableView reloadData];
}

@end
