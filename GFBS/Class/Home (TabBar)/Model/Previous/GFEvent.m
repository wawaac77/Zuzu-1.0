//
//  GFEvent.m
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFEvent.h"

#import <MJExtension.h>


@implementation GFEvent

/*全局变量 */
static NSDateFormatter *fmt_;
static NSCalendar *calendar_;

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"eventsArray" : @"GFEvent",
             //@"eventBanner" : @"GFImage"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"eventID" : @"_id",
             @"eventUpdatedBy" : @"updatedBy",
             @"eventUpdatedAt" : @"updatedAt",
             @"eventCreatedBy" : @"createdBy",
             @"eventCreatedAt" : @"createdAt",
             @"bannerName" : @"name",
             @"version" : @"__v",
             @"eventBanner" : @"image",
             };
}




@end
