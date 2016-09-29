/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "InvitationManager.h"
#import "ApplyEntity.h"

@interface InvitationManager (){
    NSUserDefaults *_defaults;
}

@end

static InvitationManager *sharedInstance = nil;
@implementation InvitationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init {
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

-(void)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username {
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    [appleys addObject:applyEntity];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(void)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username {
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    ApplyEntity *needDelete;
    for (ApplyEntity *entity in appleys) {
        if ([entity.groupId isEqualToString:applyEntity.groupId] &&
            [entity.receiverUsername isEqualToString:applyEntity.receiverUsername]) {
            needDelete = entity;
            break;
        }
    }
    [appleys removeObject:needDelete];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(NSArray *)applyEmtitiesWithloginUser:(NSString *)username {
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    return ary;
}

@end



