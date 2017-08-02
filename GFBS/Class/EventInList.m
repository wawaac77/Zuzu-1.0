//
//  EventInList.m
//  GFBS
//
//  Created by Alice Jin on 19/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "EventInList.h"

@implementation EventInList
/*全局变量 */
/*全局变量 */
static NSDateFormatter *fmt_;
static NSDateFormatter *outputFmt_;
static NSCalendar *calendar_;
static NSTimeZone *inputTimeZone_;
static NSTimeZone *outputTimeZone_;

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"eventsArray" : @"EventInList",
             @"listEventImages" : @"GFImage",
             //@"listEventRestaurant" : @"EventRestaurant",
             @"listEventInterests" : @"ZZInterest",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"listEventID" : @"_id",
             @"listEventUpdatedBy" : @"updatedBy",
             @"listEventUpdatedAt" : @"updatedAt",
             @"listEventCreatedBy" : @"createdBy",
             @"listEventCreatedAt" : @"createdAt",
             @"listEventGeo" : @"geo",
             @"listEventStatus" : @"status",
             @"listEventBudget" : @"budget",
             @"listEventDescription" : @"description",
             @"listEventEndDate" : @"endDate",
             @"listEventStartDate" : @"startDate",
             @"listEventJoinedCount" : @"joinedCount",
             @"listEventQuota" : @"quota",
             @"listEventName" : @"name",
             @"listEventProcessed" : @"processed",
             @"listEventExp" : @"exp",
             @"listEventCountNewAttendee" : @"countNewAttendee",
             //@"listEventImages" : @"images",
             @"listEventIsPrivate" : @"isPrivate",
             @"listEventInterests" : @"interests",
             @"version" : @"__v",
             @"listEventBanner" : @"banner",
             @"listEventDistance" : @"distance",
             @"listEventRestaurant" : @"restaurant",
             @"eventHost" : @"host",
             @"eventDistrict" : @"district",
             @"eventCuisine" : @"cuisine",
             
        
             };
}

+(void)initialize
{
    fmt_ = [[NSDateFormatter alloc] init];
    outputFmt_ = [[NSDateFormatter alloc] init];
    calendar_ = [NSCalendar gf_calendar];
    inputTimeZone_ = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    outputTimeZone_ = [NSTimeZone localTimeZone];
    
    [fmt_ setTimeZone:inputTimeZone_];
    [outputFmt_ setTimeZone:outputTimeZone_];
}


/**
 日期处理get方法
 */
-(NSString *)listEventStartDate
{
    //将服务器返回的数据进行处理
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    NSDate *creatAtDate = [fmt_ dateFromString:_listEventStartDate];
    NSLog(@"_listEventStartDate in content%@", _listEventStartDate);
    NSLog(@"createAtDate NSDate in content %@", creatAtDate);
    //判断
    if (creatAtDate.isThisYear) {//今年
        if ([calendar_ isDateInToday:creatAtDate]) {//今天
            //当前时间
            NSDate *nowDate = [NSDate date];
            
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *comps = [calendar_ components:unit fromDate:creatAtDate toDate:nowDate options:0];
            
            if (comps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd hours ago",comps.hour];
            }else if (comps.minute >= 1){
                return [NSString stringWithFormat:@"%zd minutes ago",comps.minute];
            }else
            {
                return @"Just now";
            }
            
        }else if ([calendar_ isDateInYesterday:creatAtDate]){//昨天
            outputFmt_.dateFormat = @"'Yesterday' HH:mm";
            return [outputFmt_ stringFromDate:creatAtDate];
            
        }else{//其他
            outputFmt_.dateFormat = @"dd MMM HH:mm";
            return [outputFmt_ stringFromDate:creatAtDate];
            
        }
        
    }else{//非今年
        outputFmt_.dateFormat = @"dd MMM yyyy";
        return [outputFmt_ stringFromDate:creatAtDate];
    }
    
    return _listEventStartDate;
}

-(NSString *) listEventEndDate
{
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *creatAtDate = [fmt_ dateFromString:_listEventStartDate];
    NSLog(@"createAtDate NSDate %@", creatAtDate);
    //判断
    if (creatAtDate.isThisYear) {//今年
        if ([calendar_ isDateInToday:creatAtDate]) {//今天
            //当前时间
            NSDate *nowDate = [NSDate date];
            
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *comps = [calendar_ components:unit fromDate:creatAtDate toDate:nowDate options:0];
            
            if (comps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd hours ago",comps.hour];
            }else if (comps.minute >= 1){
                return [NSString stringWithFormat:@"%zd minutes ago",comps.minute];
            }else
            {
                return @"Just now";
            }
            
        }else if ([calendar_ isDateInYesterday:creatAtDate]){//昨天
            fmt_.dateFormat = @"Yesterday HH:mm";
            return [fmt_ stringFromDate:creatAtDate];
            
        }else{//其他
            fmt_.dateFormat = @"dd MMM HH:mm";
            return [fmt_ stringFromDate:creatAtDate];
            
        }
        
    }else{//非今年
        return _listEventStartDate;
    }
    
    return _listEventStartDate;

}


@end
