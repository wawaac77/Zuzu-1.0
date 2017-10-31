//
//  MyEvent.h
//  GFBS
//
//  Created by Alice Jin on 6/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEventImageModel.h"
#import "EventRestaurant.h"

typedef NS_ENUM(NSInteger , MyEventType){
    //全部
    MyEventTypeAttending = 0,
    //图片
    MyEventTypeHosting = 1,
    //段子
    MyEventTypeDraft = 2,
    //声音
    MyEventTypeHistory = 3,
   
};

//@class MyEventImageModel;
@interface MyEvent : NSObject

@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, copy) NSString *eventUpdatedBy;
@property (nonatomic, copy) NSString *eventUpdatedAt;
@property (nonatomic, copy) NSString *eventCreatedBy;
@property (nonatomic, copy) NSString *eventCreatedAt;
@property (nonatomic, strong) NSArray *eventGeo;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *budget;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic, copy) NSString *eventEndDate;
@property (nonatomic, copy) NSString *eventStartDate;
@property (nonatomic, copy) NSString *joinedCount;
@property (nonatomic, copy) NSString *eventQuota;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventV;
@property (nonatomic, copy) NSString *eventProcessed;
@property (nonatomic, copy) NSString *exp;
@property (nonatomic, copy) NSString *countNewAttendee;
@property (nonatomic, strong) MyEventImageModel *eventImage;
@property (nonatomic, assign) NSString *isPrivate;
@property (nonatomic, strong) NSArray *eventInterests;
@property (nonatomic, strong) EventRestaurant *restaurant;



@end
