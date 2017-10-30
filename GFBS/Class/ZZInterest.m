//
//  ZZInterest.m
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZInterest.h"

@implementation ZZInterest

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"listEventInterests" : @"ZZInterest"
             };
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"interestID" : @"_id",
             @"interestUpdatedBy" : @"updatedBy",
             @"interestUpdatedAt" : @"updatedAt",
             @"interestCreatedBy" : @"createdBy",
             @"interestCreatedAt" : @"createdAt",
             @"interestName" : @"name",
             };
}

@end
