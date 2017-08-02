//
//  ZZInboxCell.m
//  GFBS
//
//  Created by Alice Jin on 14/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZInboxCell.h"

@interface ZZInboxCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ZZInboxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
