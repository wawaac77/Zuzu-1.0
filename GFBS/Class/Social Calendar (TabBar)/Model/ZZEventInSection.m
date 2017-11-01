//
//  ZZEventInSection.m
//  GFBS
//
//  Created by Alice Jin on 1/11/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZEventInSection.h"
#import "EventInList.h"

@implementation ZZEventInSection

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"pendingApproval" : @"EventInList",
             @"rejectecd" : @"EventInList",
             @"approved" : @"EventInList",
             @"incomplete" : @"EventInList",
             @"cancelled" : @"EventInList",
             };
}


@end
