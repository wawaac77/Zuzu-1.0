//
//  ZZEventImages.m
//  GFBS
//
//  Created by Alice Jin on 9/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZEventImages.h"

@implementation ZZEventImages

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"eventImages" : @"MyEventImageModel",
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"eventImages" : @"images",
            };
}

@end
