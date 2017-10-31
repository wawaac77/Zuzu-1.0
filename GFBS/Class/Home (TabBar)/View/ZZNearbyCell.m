//
//  ZZNearbyCell.m
//  GFBS
//
//  Created by Alice Jin on 30/10/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZNearbyCell.h"
#import "EventInList.h"
#import <UIImageView+WebCache.h>

@interface ZZNearbyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation ZZNearbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEventInfo:(EventInList *)eventInfo {
    _eventInfo = eventInfo;
    
    self.timeLabel.text = eventInfo.listEventStartDate;
    _timeLabel.backgroundColor = ZZGoldColor;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.layer.cornerRadius = 5.0f;
    _timeLabel.layer.masksToBounds = YES;
    
    self.titleLabel.text = eventInfo.listEventName;
    self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    //_titleLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    _titleLabel.textColor = [UIColor whiteColor];
    //_titleLabel.layer.cornerRadius = 5.0f;
    //_titleLabel.layer.masksToBounds = YES;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:eventInfo.listEventBanner.eventBanner.imageUrl] placeholderImage:nil];
    
}

@end
