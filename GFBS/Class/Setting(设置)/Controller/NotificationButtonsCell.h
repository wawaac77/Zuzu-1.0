//
//  NotificationButtonsCell.h
//  GFBS
//
//  Created by Alice Jin on 26/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFriendRequestModel.h"
#import "ZZUser.h"
@class ZZFriendRequestModel;

@interface NotificationButtonsCell : UITableViewCell

@property (strong, nonatomic) ZZFriendRequestModel *request;

@end
