//
//  ZZFriendCell.m
//  GFBS
//
//  Created by Alice Jin on 18/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZFriendCell.h"
#import "ZZFriendModel.h"

#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface ZZFriendCell()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZZFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMyFriend:(ZZFriendModel *)myFriend {
    ZZFriendModel *friend = myFriend;
    
    self.mainImageView.layer.cornerRadius = _mainImageView.frame.size.width / 2;
    _mainImageView.clipsToBounds = YES;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:friend.friendInfo.userProfileImage.imageUrl] placeholderImage:nil];
    self.nameLabel.text = friend.friendInfo.userUserName;
    
}
@end
