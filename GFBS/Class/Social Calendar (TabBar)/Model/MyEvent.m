//
//  MyEvent.m
//  GFBS
//
//  Created by Alice Jin on 6/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyEvent.h"
#import <MJExtension.h>

@implementation MyEvent

/*全局变量 */
static NSDateFormatter *fmt_;
static NSCalendar *calendar_;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"eventID" : @"_id",
             @"eventUpdatedBy" : @"updatedBy",
             @"eventUpdatedAt" : @"updatedAt",
             @"eventCreatedBy" : @"createdBy",
             @"eventCreatedAt" : @"createdAt",
             @"geo" : @"geo",
             @"status" : @"status",
             @"budget" : @"budget",
             @"eventDescription" : @"description",
             @"eventEndDate" : @"endDate",
             @"eventStartDate" : @"startDate",
             @"joinedCount" : @"joinedCount",
             @"eventQuota" : @"quota",
             @"eventName" : @"name",
             @"eventV" : @"__v",
             @"eventProcessed" : @"processed",
             @"countNewAttendee" : @"countNewAttendee",
             @"eventImage" : @"image",
             @"isPrivate" : @"isPrivate",
             @"eventInterests" : @"interests",
             @"restaurant" : @"restaurant",
            };
}

/**
 只调用一次
 */
+(void)initialize
{
    fmt_ = [[NSDateFormatter alloc] init];
    calendar_ = [NSCalendar gf_calendar];
}

/**
 日期处理get方法
 */
-(NSString *)eventStartDate
{
    //将服务器返回的数据进行处理
    //[dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+11:00'"];
    //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.sss'Z'";
    NSDate *creatAtDate = [fmt_ dateFromString:_eventStartDate];
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
        return _eventStartDate;
    }
    
    return _eventStartDate;
}

/**
 今年
 今天
 时间间隔 >= 一个小时 @“5小时前”
 1分钟 > 时间间隔 >= 1分钟  @"10分钟前"
 1分钟 < 时间间隔  @“刚刚”
 昨天
 @“昨天 23:13:02”
 其他
 @“10-13 12:13:02”
 
 
 非今年
 @“2015-02-10 08:09:10”
 */

@end
