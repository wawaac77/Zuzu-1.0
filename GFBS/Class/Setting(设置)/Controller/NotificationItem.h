//
//  NotificationItem.h
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZUser;

@interface NotificationItem : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *notificationText;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSString *notificationType;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSNumber *isRead;

@end
