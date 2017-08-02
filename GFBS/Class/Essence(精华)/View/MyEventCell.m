//
//  MyEventCell.m
//  GFBS
//
//  Created by Alice Jin on 6/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyEventCell.h"

#import "MyEvent.h"
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

-(void)setEvent:(MyEvent *)event
{
    MyEvent *thisEvent = event;
    //[self downloadImageFromURL:thisEvent.eventImage.imageUrl];
    self.peopleIcon.image = [UIImage imageNamed:@"ic_fa-users"];
    self.bigTitleLabel.text = thisEvent.eventName;
    self.timeLabel.text = thisEvent.eventStartDate;
    self.attendeeNumLabel.text = [NSString stringWithFormat:@"%@%@%@", thisEvent.joinedCount, @"/", thisEvent.eventQuota];
    self.placeLabel.text = thisEvent.restaurant.restaurantName.en;
    [self.expLabel setTextColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
    self.expLabel.text = thisEvent.exp;
    self.expLabel.text = @"+10 XP";
    //self.attendeeNumLabel.text = [NSString stringWithFormat:@" / %@", thisEvent.eventQuota];
    // self.placeLabel.text = thisEvent.;

    //self.timeLabel.text = thisEvent.eventCreatedAt;
    //self.placeLabel.text = @"WildFire Steak House";
    
    
}

/*
-(void) downloadImageFromURL :(NSString *)imageUrl{
    
    NSURL  *url = [NSURL URLWithString:imageUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSLog(@"Downloading started...");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"dwnld_image.png"];
        NSLog(@"FILE : %@",filePath);
        [urlData writeToFile:filePath atomically:YES];
        UIImage *image1=[UIImage imageWithContentsOfFile:filePath];
        self.bigImageView.image=image1;
        NSLog(@"Completed...");
    }
}
*/


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
