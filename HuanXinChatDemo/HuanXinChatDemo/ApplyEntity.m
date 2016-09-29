//
//  ApplyEntity.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "ApplyEntity.h"

@interface ApplyEntity () <NSCoding>

@end

@implementation ApplyEntity

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_applicantUsername forKey:@"applicantUsername"];
    [aCoder encodeObject:_applicantNick forKey:@"applicantNick"];
    [aCoder encodeObject:_reason forKey:@"reason"];
    [aCoder encodeObject:_receiverUsername forKey:@"receiverUsername"];
    [aCoder encodeObject:_receiverNick forKey:@"receiverNick"];
    [aCoder encodeObject:_style forKey:@"style"];
    [aCoder encodeObject:_groupId forKey:@"groupId"];
    [aCoder encodeObject:_groupSubject forKey:@"subject"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        _applicantUsername = [aDecoder decodeObjectForKey:@"applicantUsername"];
        _applicantNick = [aDecoder decodeObjectForKey:@"applicantNick"];
        _reason = [aDecoder decodeObjectForKey:@"reason"];
        _receiverUsername = [aDecoder decodeObjectForKey:@"receiverUsername"];
        _receiverNick = [aDecoder decodeObjectForKey:@"receiverNick"];
        _style = [aDecoder decodeObjectForKey:@"style"];
        _groupId = [aDecoder decodeObjectForKey:@"groupId"];
        _groupSubject = [aDecoder decodeObjectForKey:@"subject"];
    }
    return self;
}

@end
