//
//  AddFriendViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加联系人";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchFriendAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    // 设置tableView
    self.tableView.rowHeight = 50;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:@"addFriendCell"];
    if (!cell) {
        cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addFriendCell"];
    }
    cell.avatarView.image = [UIImage imageNamed:@"chatListCellHead"];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *buddyName = [self.dataArray objectAtIndex:indexPath.row];
    if ([self didBuddyExist:buddyName]) {
        NSLog(@"%@已是你的好友",buddyName);
    } else if ([self hasSendBuddyRequest:buddyName]) {
        NSLog(@"你已经发送了好友请求给%@",buddyName);
    } else {
        [self sendFriendApplyBuddyName:buddyName andMessage:nil];
    }
}

#pragma mark - UITextFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private
// 搜索好友
- (void)searchFriendAction:(UIBarButtonItem *)sender {
    [_textField resignFirstResponder];
    if (_textField.text.length > 0) {
#warning 有用户体系的用户，需要添加方法在已有的用户体系中查询符合填写内容的用户
#warning 以下代码为测试代码，默认用户体系中有一个符合要求的同名用户
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        if ([_textField.text isEqualToString:loginUsername]) {
            NSLog(@"不能添加自己为好友");
            return;
        }
#warning 判断是否已发来申请
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:_textField.text];
        [self.tableView reloadData];
    }
}

// 验证搜索的用户是否已是好友
- (BOOL)didBuddyExist:(NSString *)buddyName {
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    for (NSString *username in userlist) {
        if ([username isEqualToString:buddyName]){
            return YES;
        }
    }
    return NO;
}

// 是否已发送好友请求
- (BOOL)hasSendBuddyRequest:(NSString *)buddyName {
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    for (NSString *username in userlist) {
        if ([username isEqualToString:buddyName]) {
            return YES;
        }
    }
    return NO;
}

// 发送好友请求
- (void)sendFriendApplyBuddyName:(NSString *)buddyName andMessage:(NSString *)message {
    if (buddyName && buddyName.length > 0) {
        [self showHudInView:self.view hint:@"正在发送请求"];
        EMError *error = [[EMClient sharedClient].contactManager addContact:buddyName message:message];
        [self hideHud];
        if (error) {
            [self showHint:@"好友请求发送失败，请重试！"];
        }
        else{
            [self showHint:@"好友请求发送成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - lazy
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        _headerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"输入要查找的好友";
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [_headerView addSubview:_textField];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
