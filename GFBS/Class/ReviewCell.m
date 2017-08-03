//
//  ReviewCell.m
//  GFBS
//
//  Created by Alice Jin on 3/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ReviewCell.h"
#import "ZZContentModel.h"
#import <HCSStarRatingView.h>
#import <UIImageView+WebCache.h>

@interface ReviewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallLabel;

@end

@implementation ReviewCell
//@synthesize thisComment;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThisComment:(ZZContentModel *)thisComment {
    NSLog(@"inReviewCell %@", self.thisComment);
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(40, 5, 100, 15)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = [thisComment.rating floatValue];
    starRatingView.tintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
    starRatingView.allowsHalfStars = YES;
    //[starRatingView addTarget:self action:@selector(didChangeValue:)  forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:starRatingView];
    
    self.bigLabel.text = thisComment.listTitle;
    
    self.smallLabel.text = thisComment.listMessage;
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"]gf_circleImage];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:thisComment.listPublishUser.userProfileImage.imageUrl] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return ;
        self.profileImageView.image = [image gf_circleImage];
    }];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.layer.cornerRadius = self.profileImageView.gf_width / 2;
    self.profileImageView.clipsToBounds = YES;
}

- (void)didChangeValue {
    
}

@end
