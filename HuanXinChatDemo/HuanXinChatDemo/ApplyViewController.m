//
//  ApplyViewController.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "ApplyViewController.h"
#import "ApplyCell.h"
#import "InvitationManager.h"
#import "ApplyEntity.h"

@interface ApplyViewController () <ApplyCellDelegate>

@end

@implementation ApplyViewController

+ (instancetype)shareController {
    static ApplyViewController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[ApplyViewController alloc] init];
    });
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请与通知";
    
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UITableView alloc] init];
    
    [self loadDataFromLocalDB];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 发送通知，更新applyCount
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyCell *cell = (ApplyCell*)[tableView dequeueReusableCellWithIdentifier:@"applyCell"];
    if (!cell) {
        cell = [[ApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"applyCell"];
    }
    cell.delegate = self;
    if (self.dataArray.count > indexPath.row) {
        ApplyEntity *entity = self.dataArray[indexPath.row];
        if (entity) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = @"群组邀请";
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            } else if (applyStyle == ApplyStyleJoinGroup) {
                cell.titleLabel.text = @"进群申请";
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            } else if(applyStyle == ApplyStyleFriend) {
                cell.titleLabel.text = entity.applicantUsername;
                cell.headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
            }
            cell.contentLabel.text = entity.reason;
        }
    }
    return cell;
}

#pragma mark - ApplyCellDelegate
- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        [self showHudInView:self.view hint:@"正在发送申请..."];

        ApplyEntity *entity = self.dataArray[indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error;
            if (applyStyle == ApplyStyleGroupInvitation) {
                [[EMClient sharedClient].groupManager acceptInvitationFromGroup:entity.groupId inviter:entity.applicantUsername error:&error];
            } else if (applyStyle == ApplyStyleJoinGroup) {
                error = [[EMClient sharedClient].groupManager acceptJoinApplication:entity.groupId applicant:entity.applicantUsername];
            } else if(applyStyle == ApplyStyleFriend) {
                error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:entity.applicantUsername];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    [weakSelf.dataArray removeObject:entity];
                    NSString *loginUsername = [weakSelf loginUserName];
                    [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
                    [weakSelf.tableView reloadData];
                }
                else{
                    [weakSelf showHint:@"接受好友请求失败"];
                }
            });
        });
    }
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        [self showHudInView:self.view hint:@"正在发送申请..."];
        
        ApplyEntity *entity = self.dataArray[indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error;
            if (applyStyle == ApplyStyleGroupInvitation) {
                error = [[EMClient sharedClient].groupManager declineInvitationFromGroup:entity.groupId inviter:entity.applicantUsername reason:nil];
            } else if (applyStyle == ApplyStyleJoinGroup) {
                error = [[EMClient sharedClient].groupManager declineJoinApplication:entity.groupId applicant:entity.applicantUsername reason:nil];
            } else if(applyStyle == ApplyStyleFriend) {
                [[EMClient sharedClient].contactManager declineInvitationForUsername:entity.applicantUsername];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    [weakSelf.dataArray removeObject:entity];
                    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
                    [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
                    [weakSelf.tableView reloadData];
                } else {
                    [weakSelf showHint:@"拒绝好友请求失败"];
                    [weakSelf.dataArray removeObject:entity];
                    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
                    [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
                    [weakSelf.tableView reloadData];
                }
            });
        });
    }
}

#pragma mark - lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - private
// 获取当前用户名
- (NSString *)loginUserName {
    return [[EMClient sharedClient] currentUsername];
}

#pragma mark - public
- (void)addNewApply:(NSDictionary *)dictionary {
    if (dictionary && dictionary.count > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [dictionary[@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataArray count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = _dataArray[i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend) {
                        NSString *newGroupid = dictionary[@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = dictionary[@"applyMessage"];
                    [_dataArray removeObject:oldEntity];
                    [_dataArray insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSString *loginName = [[EMClient sharedClient] currentUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataArray insertObject:newEntity atIndex:0];
            [self.tableView reloadData];
        }
    }

}

- (void)loadDataFromLocalDB {
    [self.dataArray removeAllObjects];
    NSString *loginName = [self loginUserName];
    if (loginName && loginName.length > 0) {
        NSArray *applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataArray addObjectsFromArray:applyArray];
        [self.tableView reloadData];
    }
}

- (void)clear {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}



@end
