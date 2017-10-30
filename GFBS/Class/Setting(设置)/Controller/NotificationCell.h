//
//  NotificationCell.h
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationItem;
@interface NotificationCell : UITableViewCell

@property (strong, nonatomic) NotificationItem *notification;

@end
