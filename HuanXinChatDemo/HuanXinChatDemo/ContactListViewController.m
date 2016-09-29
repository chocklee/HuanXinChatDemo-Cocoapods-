//
//  ContactListViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "ContactListViewController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "GroupListViewController.h"
#import "ChatViewController.h"

@interface ContactListViewController ()

// 联系人数组
@property (nonatomic, strong) NSMutableArray *contactsArray;

@property (nonatomic, strong) NSArray *commonCellArray;

// 未读申请数量
@property (nonatomic, assign) NSInteger unapplyCount;

@property (nonatomic, strong) GroupListViewController *groupListVC;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系人";
    // 添加联系人按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 显示下拉刷新
    self.showRefreshHeader = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadApplyView];
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
        return 2;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EaseUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
        if (!cell) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commonCell"];
        }
        cell.avatarView.image = [UIImage imageNamed:self.commonCellArray[indexPath.row][@"image"]];
        cell.titleLabel.text = self.commonCellArray[indexPath.row][@"title"];
        if (indexPath.row == 0) {
            cell.avatarView.badge = self.unapplyCount;
        }
        return cell;
    } else {
        NSString *cellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        EaseUserModel *user = self.dataArray[indexPath.row];
        cell.indexPath = indexPath;
        cell.model = user;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ApplyViewController *applyVC = [ApplyViewController shareController];
            applyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:applyVC sender:nil];
        }
        
        if (indexPath.row == 1) {
            GroupListViewController *groupListVC = [[GroupListViewController alloc] init];
            groupListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:groupListVC sender:nil];
        }
    } else {
        EaseUserModel *user = self.dataArray[indexPath.row];
        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:user.buddy conversationType:EMConversationTypeChat];
        chatVC.title = user.buddy;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController showViewController:chatVC sender:nil];
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
    label.text = @"联系人";
    [contentView addSubview:label];
    return contentView;
}


#pragma mark - private
- (void)addFriendAction:(UIBarButtonItem *)sender {
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] init];
    addFriendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:addFriendVC sender:nil];
}

#pragma mark - public
//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView {
    NSInteger count = [ApplyViewController shareController].dataArray.count;
    self.unapplyCount = count;
    [self.tableView reloadData];
}

//好友个数变化时，重新获取数据
- (void)reloadDataSource {
    [self.dataArray removeAllObjects];
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    for (NSString *buddy in userlist) {
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

//群组变化时，更新群组页面
- (void)reloadGroupView {
    [self reloadApplyView];
    
    if (_groupListVC) {
        [_groupListVC reloadDataSource];
    }
}

#pragma mark - lazy
- (NSArray *)commonCellArray {
    if (!_commonCellArray) {
        _commonCellArray = @[@{@"image":@"newFriends",@"title":@"申请与通知"},@{@"image":@"groupPrivateHeader",@"title":@"群组"}];
    }
    return _commonCellArray;
}

@end
