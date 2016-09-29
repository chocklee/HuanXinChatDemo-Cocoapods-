//
//  ApplyEntity.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyEntity : NSObject

@property (nonatomic, strong) NSString *applicantUsername;
@property (nonatomic, strong) NSString *applicantNick;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *receiverUsername;
@property (nonatomic, strong) NSString *receiverNick;
@property (nonatomic, strong) NSNumber *style;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *groupSubject;

@end
