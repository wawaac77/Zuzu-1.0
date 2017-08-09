//
//  MyEventCell.m
//  GFBS
//
//  Created by Alice Jin on 6/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyEventCell.h"

//#import "MyEvent.h"
#import "EventInList.h"
#import "MyEventImageModel.h"

#import <SVProgressHUD.h>
#import <Social/Social.h>
#import <UIImageView+WebCache.h>

@interface MyEventCell ()

@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendeeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *peopleIcon;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MyEventCell

-(void)setEvent:(EventInList *)event
{
    EventInList *thisEvent = event;
    //[self downloadImageFromURL:thisEvent.eventImage.imageUrl];
    self.peopleIcon.image = [UIImage imageNamed:@"ic_fa-users"];
    self.bigTitleLabel.text = thisEvent.listEventName;
    self.timeLabel.text = thisEvent.listEventStartDate;
    self.attendeeNumLabel.text = [NSString stringWithFormat:@"%@%@%@", thisEvent.listEventJoinedCount, @"/", thisEvent.listEventQuota];
    self.placeLabel.text = thisEvent.listEventRestaurant.restaurantName.en;
    [self.expLabel setTextColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
    if (thisEvent.listEventExp == NULL) {
        self.expLabel.text = [NSString stringWithFormat:@"+0 XP"];
    } else {
        self.expLabel.text = [NSString stringWithFormat:@"+%@ XP", thisEvent.listEventExp];
    }
    
    
   // [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //self.attendeeNumLabel.text = [NSString stringWithFormat:@" / %@", thisEvent.eventQuota];
    // self.placeLabel.text = thisEvent.;

    //self.timeLabel.text = thisEvent.eventCreatedAt;
    //self.placeLabel.text = @"WildFire Steak House";
    
    
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
