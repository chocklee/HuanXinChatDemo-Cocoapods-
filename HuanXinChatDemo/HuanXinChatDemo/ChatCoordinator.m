//
//  ChatCoordinator.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/27.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "ChatCoordinator.h"
#import "ApplyViewController.h"

@interface ChatCoordinator () <EMContactManagerDelegate,EMGroupManagerDelegate>

@end

@implementation ChatCoordinator

+ (instancetype)shareCoordinator {
    static ChatCoordinator *coordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coordinator = [[ChatCoordinator alloc] init];
    });
    return coordinator;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initCoordinator];
    }
    return self;
}

- (void)initCoordinator {
    // 注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //注册群组回调
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

- (void)dealloc {
    // 移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
    // 移除好友回调
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

#pragma mark - EMContactManagerDelegate
// 用户B申请加A为好友后，用户A会收到这个回调
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage {
    if (!aUsername) {
        return;
    }
    if (!aMessage) {
        aMessage = [NSString stringWithFormat:@"%@添加你为好友", aUsername];
    }
    NSMutableDictionary *dic = @{@"title":aUsername, @"username":aUsername, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}.mutableCopy;
    [[ApplyViewController shareController] addNewApply:dic];
    if (self.mainVC) {
        [self.mainVC setupUntreatedApplyCount];
    }
    [self.contactListVC reloadApplyView];
}

// 用户B拒绝用户A的加好友请求后，用户A会收到这个回调
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername {
    NSLog(@"%@拒绝了您的好友申请",aUsername);
}

// 用户B删除与用户A的好友关系后，用户A会收到这个回调
- (void)friendshipDidRemoveByUser:(NSString *)aUsername {
    
}

// 用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
- (void)friendshipDidAddByUser:(NSString *)aUsername {
    // 更新联系人列表
    [self.contactListVC reloadDataSource];
}

#pragma mark - EMGroupManagerDelegate
// 用户A邀请用户B入群,用户B接收到该回调
- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage {
    if (!aGroupId || !aInviter) {
        return;
    }
    if (!aMessage && aMessage.length == 0) {
        aMessage = [NSString stringWithFormat:@"%@邀请你加入群组%@", aInviter, aGroupId];
    }
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aGroupId, @"groupId":aGroupId, @"username":aInviter, @"groupname":aGroupId, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
    [[ApplyViewController shareController] addNewApply:dic];
    if (self.mainVC) {
        [self.mainVC setupUntreatedApplyCount];
    }
    
    if (self.contactListVC) {
        [self.contactListVC reloadApplyView];
    }
}

// 用户B同意用户A的入群邀请后，用户A接收到该回调
- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee {
    NSLog(@"%@已经同意加入群组%@",aInvitee, aGroup.subject);
}

// 用户B拒绝用户A的入群邀请后，用户A接收到该回调
- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason {
    NSLog(@"%@已经拒绝加入群组%@",aInvitee, aGroup.subject);
}

// 用户A需要设置EMOptions的isAutoAcceptGroupInvitation为YES,SDK会自动同意用户B的入群邀请后，用户B接收到该回调
- (void)didJoinGroup:(EMGroup *)aGroup
             inviter:(NSString *)aInviter
             message:(NSString *)aMessage {
    NSLog(@"%@邀请你加入群组%@:%@",aInviter, aGroup, aMessage);
}

@end
