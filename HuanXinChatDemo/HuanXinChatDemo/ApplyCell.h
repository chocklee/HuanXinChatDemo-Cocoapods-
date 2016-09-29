//
//  ApplyCell.h
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyCellDelegate <NSObject>
// 同意好友申请
- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath;
// 拒绝好友申请
- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ApplyCell : UITableViewCell

@property (assign, nonatomic) id<ApplyCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIImageView *headerImageView;//头像
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) UILabel *contentLabel;//详情

@end
