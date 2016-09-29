//
//  CreateGroupViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/27.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "ContactSelectionViewController.h"

@interface CreateGroupViewController () <UITextFieldDelegate,EMChooseViewDelegate>

@property (nonatomic, strong) UITextField *groupNameField;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"创建群组";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"添加成员" style:UIBarButtonItemStyleDone target:self action:@selector(addContacts)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.groupNameField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy
- (UITextField *)groupNameField {
    if (!_groupNameField) {
        _groupNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10 + 64, self.view.frame.size.width - 20, 40)];
        _groupNameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _groupNameField.layer.borderWidth = 0.5f;
        _groupNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
        _groupNameField.leftViewMode = UITextFieldViewModeAlways;
        _groupNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _groupNameField.font = [UIFont systemFontOfSize:15.0];
        _groupNameField.placeholder = @"请输入群组名称";
        _groupNameField.returnKeyType = UIReturnKeyDone;
        _groupNameField.delegate = self;
    }
    return _groupNameField;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private
- (void)addContacts {
    if (_groupNameField.text.length == 0) {
        NSLog(@"请输入群组名称");
        return;
    }
    [self.view endEditing:YES];
    ContactSelectionViewController *selectionVC = [[ContactSelectionViewController alloc] init];
    selectionVC.delegate = self;
    [self.navigationController showViewController:selectionVC sender:nil];
}

#pragma mark - EMChooseViewDelegate
/**
 *  选择完成之后代理方法
 *
 *  @param viewController  列表视图
 *  @param selectedSources 选择的联系人信息，每个联系人提供姓名和手机号两个字段，以字典形式返回
 *  @return 是否隐藏页面
 */
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources {
    NSInteger maxUsersCount = 200;
    if ([selectedSources count] > (maxUsersCount - 1)) {
        NSLog(@"群成员个数超了最大值了");
        return NO;
    }
    [self showHudInView:self.view hint:@"创建群组"];
    NSMutableArray *source = [NSMutableArray array];
    for (NSString *username in selectedSources) {
        [source addObject:username];
    }
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = maxUsersCount;
    setting.style = EMGroupStylePrivateMemberCanInvite;
    
    
    __weak typeof(self) weakSelf = self;
    NSString *username = [[EMClient sharedClient] currentUsername];
    NSString *messageStr = [NSString stringWithFormat:@"%@邀请你加入群组%@", username, self.groupNameField.text];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:weakSelf.groupNameField.text description:nil invitees:source message:messageStr setting:setting error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (group && !error) {
                [weakSelf showHint:@"创建群组成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else{
                [weakSelf showHint:@"创建群组失败"];
            }
        });
    });
    return YES;
}

@end
