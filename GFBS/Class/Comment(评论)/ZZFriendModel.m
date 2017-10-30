//
//  ZZFriendModel.m
//  GFBS
//
//  Created by Alice Jin on 18/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZFriendModel.h"

@implementation ZZFriendModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"ID" : @"_id",
             //@"listEventUpdatedBy" : @"updatedBy",
             //@"listEventUpdatedAt" : @"updatedAt",
             //@"listEventCreatedBy" : @"createdBy",
             //@"listEventCreatedAt" : @"createdAt",
        
             @"friendInfo" : @"friend",
             @"memberInfo" : @"member",
            };
}

@end
