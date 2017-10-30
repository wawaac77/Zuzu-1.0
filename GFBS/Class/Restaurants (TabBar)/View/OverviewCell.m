//
//  OverviewCell.m
//  GFBS
//
//  Created by Alice Jin on 28/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "OverviewCell.h"
@interface OverviewCell ()



@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation OverviewCell
//@synthesize height;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(NSString *)info {
    _infoLabel.text = info;
    _infoLabel.numberOfLines = 0;
    
    //_infoLabel.textColor = [UIColor darkGrayColor];
}

- (void)setIconImageName:(NSString *)iconImageName {
    _iconImageView.image = [UIImage imageNamed:iconImageName];
    //_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
