//
//  ApplyCell.m
//  HuanXinChatDemo
//
//  Created by chocklee on 2016/9/26.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "ApplyCell.h"

@interface ApplyCell ()

@property (strong, nonatomic) UIButton *addButton;//接受按钮
@property (strong, nonatomic) UIButton *refuseButton;//拒绝按钮

@end

@implementation ApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatViews];
        [self installConstaints];
    }
    return self;
}

- (void)creatViews {
    _headerImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headerImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_contentLabel];

    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setTitle:@"接受" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addButton.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0];
    [_addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addButton];
    
    _refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _refuseButton.backgroundColor = [UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0];
    [_refuseButton addTarget:self action:@selector(refuseFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_refuseButton];
}

- (void)installConstaints {
    _headerImageView.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(40)
    .heightIs(40);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_headerImageView, 10)
    .topSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    _contentLabel.sd_layout
    .leftSpaceToView(_headerImageView, 10)
    .topSpaceToView(_titleLabel, 5)
    .autoHeightRatio(0);
    [_contentLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    _addButton.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .heightIs(30)
    .widthIs(50);
    
    _refuseButton.sd_layout
    .rightSpaceToView(_addButton, 10)
    .topSpaceToView(self.contentView, 15)
    .heightIs(30)
    .widthIs(50);
}

- (void)addFriend {
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellAddFriendAtIndexPath:)]) {
        [_delegate applyCellAddFriendAtIndexPath:self.indexPath];
    }
}

- (void)refuseFriend {
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellRefuseFriendAtIndexPath:)]) {
        [_delegate applyCellRefuseFriendAtIndexPath:self.indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
