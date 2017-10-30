//
//  NotificationItem.m
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "NotificationItem.h"
#import <MJExtension.h>

@implementation NotificationItem

/*全局变量 */
static NSDateFormatter *fmt_;
static NSDateFormatter *outputFmt_;
static NSCalendar *calendar_;
static NSTimeZone *inputTimeZone_;
static NSTimeZone *outputTimeZone_;

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"notificationText" : @"title",
             @"updatedAt" : @"updatedAt",
             @"notificationType" : @"type",
             @"memberId" : @"member",
             @"isRead" : @"isRead",
            };
}

/**
 只调用一次
 */
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


- (NSString *)updatedAt {
    //将服务器返回的数据进行处理
    fmt_.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    NSDate *creatAtDate = [fmt_ dateFromString:_updatedAt];
    NSLog(@"_listEventUpdatedAt %@", _updatedAt);
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
    
    return _updatedAt;

}

@end
