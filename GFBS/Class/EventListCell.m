//
//  EventListCell.m
//  GFBS
//
//  Created by Alice Jin on 16/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "EventListCell.h"
#import "EventInList.h"
#import "GFEvent.h"
#import "GFImage.h"

#import <SVProgressHUD.h>
#import <Social/Social.h>
#import <UIImageView+WebCache.h>

@interface EventListCell()
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

/*
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *peopleIcon;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
*/
@end

@implementation EventListCell

-(void)setEvent:(EventInList *)event
{
    EventInList *thisEvent = event;
    [self downloadImageFromURL:thisEvent.listEventBanner.eventBanner.imageUrl];
    self.bigTitleLabel.text = thisEvent.listEventName;
    self.smallTitleLabel.text = thisEvent.listEventStartDate;
 
    /*
    self.bigImageView.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, 130);
    self.bottomView.frame = CGRectMake(5, 130, [UIScreen mainScreen].bounds.size.width - 10, 30);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.timeLabel.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width / 3, 30);
    self.placeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 3 + 10, 0, [UIScreen mainScreen].bounds.size.width / 3 * 2 - 30 , 30);
    self.calendarButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 35, 5, 20, 20);
    
    self.calendarButton.imageView.image = [UIImage imageNamed:@"ic_fa-calendar-check-o"];
    [_calendarButton setImage:[UIImage imageNamed:@"ic_fa-calendar-check-o"] forState:UIControlStateNormal];
    
    [self downloadImageFromURL:thisEvent.eventBanner.imageUrl];
    self.peopleIcon.image = [UIImage imageNamed:@"ic_fa-user-on"];
    self.bigTitleLabel.text = thisEvent.eventCreatedBy;
    self.smallTitleLabel.text = @"Music | 16/20";
    self.timeLabel.text = thisEvent.eventCreatedAt;
    
    self.placeLabel.text = @"WildFire Steak House";
    [_placeLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_placeLabel setTextColor:[UIColor darkGrayColor]];
    */
        
}

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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
