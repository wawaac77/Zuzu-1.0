//
//  NotificationViewController.h
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationItem.h"
#import "ZZFriendRequestModel.h"

@protocol ChildViewControllerDelegate <NSObject>

- (void) passValue: (NSInteger *)theValue;

@end

@protocol ChildViewControllerDelegate;

@interface NotificationViewController : UITableViewController
/*所有notification数据*/
@property (strong , nonatomic)NSMutableArray<NotificationItem *> *myNotifications;
@property (strong , nonatomic)NSMutableArray<ZZFriendRequestModel *> *myFriendsRequests;

@property (weak)id <ChildViewControllerDelegate> delegate;

@end
