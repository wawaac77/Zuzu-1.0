//
//  GFEventsCell.m
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFEventsCell.h"

#import "EventInList.h"
#import "GFImage.h"
#import "ZZInterest.h"

//#import "GFTopicVideoView.h"
//#import "GFTopicVoiceView.h"
//#import "GFTopicPictureView.h"

#import <SVProgressHUD.h>
#import <Social/Social.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

@interface GFEventsCell()

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *peopleIcon;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

/*图片View*/
//@property (weak ,nonatomic) GFTopicPictureView *pictureView;
/*声音View*/
//@property (weak ,nonatomic) GFTopicVoiceView *voiceView;
/*视频View*/
//@property (weak ,nonatomic) GFTopicVideoView *videoView;


@end

@implementation GFEventsCell

/*
#pragma mark - 懒加载
-(GFTopicPictureView *)pictureView
{
    if (!_pictureView) {
        _pictureView = [GFTopicPictureView gf_viewFromXib];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}

-(GFTopicVideoView *)videoView
{
    if (!_videoView) {
        _videoView = [GFTopicVideoView gf_viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}

-(GFTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        _voiceView = [GFTopicVoiceView gf_viewFromXib];
        [self.contentView addSubview:_voiceView];
    }
    return _voiceView;
}
*/

-(void)setupFrameandColor {
    
}

-(void)setEvent:(EventInList *)event
{
    
    //NSString *eventImageName = thisEvent.eventBanner.imageFilename;
    //self.bigImageView.image = [UIImage imageNamed:eventImageName];
  
    /*
    self.bigImageView.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, 130);
    self.bottomView.frame = CGRectMake(5, 130, [UIScreen mainScreen].bounds.size.width - 10, 30);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.timeLabel.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width / 3, 30);
    self.placeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 3 + 10, 0, [UIScreen mainScreen].bounds.size.width / 3 * 2 - 30 , 30);
    self.calendarButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 35, 5, 20, 20);
    */
    EventInList *thisEvent = event;
    self.calendarButton.imageView.image = [UIImage imageNamed:@"ic_fa-calendar-check-o"];
    [_calendarButton setImage:[UIImage imageNamed:@"ic_fa-calendar-check-o"] forState:UIControlStateNormal];
    
    //[self downloadImageFromURL:thisEvent.listEventBanner.eventBanner.imageUrl];
    
    UIImage *placeholder = [[UIImage alloc] init];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImageView.clipsToBounds = YES;
    placeholder = [UIImage imageNamed:@"imageplaceholder.png"];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listEventBanner.eventBanner.imageUrl] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.bigImageView.image = placeholder;
            return ;
        }
    }];
    
    
    //UIImage *image = [[UIImage alloc] init];
    //if (_event.listEventBanner.eventBanner.image_UIImage == nil) {
    /*
        NSURL *URL = [NSURL URLWithString:thisEvent.listEventBanner.eventBanner.imageUrl];
        NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
        UIImage *image = [[UIImage alloc]initWithData:data];
        _event.listEventBanner.eventBanner.image_UIImage = image;
     */
    //}
    //self.bigImageView.image = _event.listEventBanner.eventBanner.image_UIImage;
  
    self.bigTitleLabel.text = thisEvent.listEventName;
    self.bigTitleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    ZZInterest *interest = [thisEvent.listEventInterests objectAtIndex:0];
    self.smallTitleLabel.text = [NSString stringWithFormat:@"%@ | %@/%@", interest.interestName, thisEvent.listEventJoinedCount,thisEvent.listEventQuota ];
    self.smallTitleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    
    self.timeLabel.text = thisEvent.listEventStartDate;
    
    self.placeLabel.text = thisEvent.listEventRestaurant.restaurantName;
    [_placeLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_placeLabel setTextColor:[UIColor darkGrayColor]];
    
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

/*
-(void)setTopic:(GFTopic *)topic
{
    _event = topic;
    
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"]gf_circleImage];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return ;
        self.bigImageView.image = [image gf_circleImage];
    }];
    self.bigTitleLabel.text = topic.name;
    self.smallTitleLabel.text = topic.created_at;
    self.timeLabel.text = topic.created_at;
    self.placeLabel.text = @"Alice's restaurant";
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
