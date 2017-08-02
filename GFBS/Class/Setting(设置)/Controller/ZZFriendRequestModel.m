//
//  ZZFriendRequestModel.m
//  GFBS
//
//  Created by Alice Jin on 26/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZFriendRequestModel.h"

@implementation ZZFriendRequestModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"friendshipID" : @"_id",
             @"friendRequest" : @"friend",
             @"memberRequest" : @"member",
            };
}

@end
