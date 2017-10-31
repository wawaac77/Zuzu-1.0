//
//  ZZComment.m
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZComment.h"

@implementation ZZComment

/*全局变量 */
static NSDateFormatter *fmt_;
static NSCalendar *calendar_;

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"commentID" : @"_id",
             @"commentUpdatedBy" : @"updatedBy",
             @"commentUpdatedAt" : @"updatedAt",
             @"commentCreatedBy" : @"createdBy",
             @"commentCreatedAt" : @"createdAt",
             @"commentMessage" : @"message",
             @"commentCheckInContent" : @"checkin",
             @"member" : @"member",
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


-(NSString *)commentCreatedAt {
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.sss'Z'";
    NSDate *creatAtDate = [fmt_ dateFromString:_commentCreatedAt];
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
        return _commentCreatedAt;
    }
    
    return _commentCreatedAt;
    
}

/**
 日期处理get方法
 */
-(NSString *)commentUpdatedAt
{
    //将服务器返回的数据进行处理
    //[dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'+11:00'"];
    //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.sss'Z'";
    NSDate *creatAtDate = [fmt_ dateFromString:_commentUpdatedAt];
    NSLog(@"_listEventUpdatedAt %@", _commentUpdatedAt);
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
        return _commentUpdatedAt;
    }
    
    return _commentUpdatedAt;
}


@end
