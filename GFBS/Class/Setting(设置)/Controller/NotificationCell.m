//
//  NotificationCell.m
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationCell.h"
#import "NotificationItem.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface NotificationCell()

@property (weak, nonatomic) IBOutlet UIView *checkedSignView;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong , nonatomic) GFHTTPSessionManager *manager;

@end

@implementation NotificationCell

//@synthesize notification;

-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

-(void)setNotification:(NotificationItem *)notification
{
    NotificationItem *thisNotification = notification;
    //[self downloadImageFromURL:thisEvent.eventImage.imageUrl];
    self.bigLabel.text = thisNotification.notificationText;
    self.timeLabel.text = thisNotification.updatedAt;
    if ([thisNotification.isRead isEqualToNumber: [NSNumber numberWithBool:true]]) {
        NSLog(@"thisNotification.isRead %@", thisNotification.isRead );
        self.checkedSignView.backgroundColor = [UIColor darkGrayColor];
    } else {
        self.checkedSignView.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
        self.bigLabel.textColor = [UIColor blackColor];
        self.bigLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.checkedSignView.backgroundColor != [UIColor darkGrayColor]) {
        self.checkedSignView.backgroundColor = [UIColor darkGrayColor];
        _notification.isRead = @1;
    }
    // Configure the view for the selected state
}

@end
