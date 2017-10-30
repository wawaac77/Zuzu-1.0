//
//  GFEvent.h
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFImage.h"

@class GFImage;
@interface GFEvent : NSObject

@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, copy) NSString *eventUpdatedBy;
@property (nonatomic, copy) NSString *eventUpdatedAt;
@property (nonatomic, copy) NSString *eventCreatedBy;
@property (nonatomic, copy) NSString *eventCreatedAt;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, retain) GFImage *eventBanner;



/*
@property (nonatomic, copy) NSString *bigEventName;
@property (nonatomic, copy) NSString *smallEventDetail;
@property (nonatomic, copy) UIImage *eventImage;
@property (nonatomic, copy) NSString *eventDate;
@property (nonatomic, copy) NSString *eventPlace;
@property (nonatomic, assign) BOOL is_onCalendar;
 */

@end
