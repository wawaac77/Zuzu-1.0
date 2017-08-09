//
//  EventInList.h
//  GFBS
//
//  Created by Alice Jin on 19/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFEvent.h"
#import "GFImage.h"
#import "ZZInterest.h"
#import "EventRestaurant.h"
#import "ZZTypicalInformationModel.h"
#import "TwEn.h"
#import "ZZUser.h"


@class GFEvent;
@class GFImage;
@class ZZInterest;
@class EventRestaurant;
@class ZZTypicalInformationModel;
@class TwEn;
@class ZZUser;

@interface EventInList : NSObject

@property (nonatomic, copy) NSString *listEventID;
@property (nonatomic, copy) NSString *listEventUpdatedBy;
@property (nonatomic, copy) NSString *listEventUpdatedAt;
@property (nonatomic, copy) NSString *listEventCreatedBy;
@property (nonatomic, copy) NSString *listEventCreatedAt;
@property (nonatomic, copy) NSArray *listEventGeo; //Received by arrary first, then need to be tranlate as CLLocationCoordinate2D
@property (nonatomic, copy) NSString *listEventStatus;
@property (nonatomic, assign) NSNumber *listEventBudget;
@property (nonatomic, copy) NSString *listEventDescription;
@property (nonatomic, copy) NSString *listEventEndDate;
@property (nonatomic, copy) NSString *listEventStartDate;
@property (nonatomic, assign) NSNumber *listEventJoinedCount;
@property (nonatomic, assign) NSNumber *listEventQuota;
@property (nonatomic, copy) NSString *listEventName;
@property (nonatomic, copy) NSString *listEventProcessed;
@property (nonatomic, copy) NSString *listEventExp;
@property (nonatomic, copy) NSString *listEventCountNewAttendee;
@property (nonatomic, strong) NSArray<GFImage *> *listEventImages;
@property (nonatomic, copy) NSString *listEventIsPrivate;
@property (nonatomic, copy) NSArray<ZZInterest *> *listEventInterests;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, strong) GFEvent *listEventBanner;
@property (nonatomic, copy) NSString *listEventDistance;
@property (nonatomic, strong) EventRestaurant *listEventRestaurant;

@property (nonatomic, strong) ZZUser *eventHost;
@property (nonatomic, strong) ZZTypicalInformationModel *eventDistrict;
@property (nonatomic, strong) ZZTypicalInformationModel *eventCuisine;
//@property (nonatomic, strong) NSArray<ZZTypicalInformationModel *>  *eventInterests;




@end
