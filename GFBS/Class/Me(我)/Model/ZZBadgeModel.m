//
//  ZZBadgeModel.m
//  GFBS
//
//  Created by Alice Jin on 9/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZBadgeModel.h"

@implementation ZZBadgeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"badgeDescription" : @"description",
             };
}

@end
