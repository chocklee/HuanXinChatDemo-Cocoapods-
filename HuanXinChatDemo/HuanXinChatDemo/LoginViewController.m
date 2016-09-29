//
//  LoginViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/23.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    _usernameField.delegate = self;
    _passwordField.delegate = self;
    
    NSString *username = [self lastLoginUsername];
    if (username && username.length > 0) {
        _usernameField.text = username;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 点击注册
- (IBAction)registerPressed:(UIButton *)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        // 用户名不支持中文
        if ([_usernameField.text isChinese]) {
            NSLog(@"用户名不支持中文");
            return;
        }
        [self showHudInView:self.view hint:@"正在注册..."];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] registerWithUsername:weakSelf.usernameField.text password:weakSelf.passwordField.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    NSLog(@"注册成功");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        // 设置推送昵称
                        [[EMClient sharedClient] setApnsNickname:weakSelf.usernameField.text];
                    });
                } else {
                    NSLog(@"错误代码:%u",error.code);
                }
            });
        });
    }
}

// 点击登录
- (IBAction)loginPressed:(UIButton *)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        // 用户名不支持中文
        if ([_usernameField.text isChinese]) {
            NSLog(@"用户名不支持中文");
            return;
        }
        [self loginWithUsername:_usernameField.text andPassword:_passwordField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _usernameField) {
        _passwordField.text = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameField) {
        [_usernameField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }

    if (textField == _passwordField){
        [_passwordField resignFirstResponder];
        // 登录
    }
    return YES;
}

#pragma mark - private
// 保存上次登录的用户名
- (void)saveLastLoginUsername {
    NSString *username = [EMClient sharedClient].currentUsername;
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:@"em_lastLogin_username"];
        [ud synchronize];
    }
}

// 获取上次登录的用户名
- (NSString *)lastLoginUsername {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"em_lastLogin_username"];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL res = NO;
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    if (username.length == 0 || password.length == 0) {
        res = YES;
        NSLog(@"用户名或密码不能为空");
    }
    return res;
}

// 登录方法
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    [self showHudInView:self.view hint:@"正在登录..."];
    // 异步登录账号
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                NSLog(@"登录成功");
                // 设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                // 获取数据库中的数据
                [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // 升级到SDK3.0版本需要调用该方法，开发者需要等该方法执行完后再进行数据库相关操作
                    [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 执行获取数据的方法
#warning 执行获取数据的方法
                        
                        // 发送自动登录通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn ])];
                        // 保存最近一次的登录名
                        [weakSelf saveLastLoginUsername];
                    });
                });
            } else {
                NSLog(@"错误代码:%u",error.code);
            }
        });
    });
}

@end
