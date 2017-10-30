//
//  EventRestaurant.m
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "EventRestaurant.h"

@implementation EventRestaurant

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             //@"listEventRestaurant" : @"EventRestaurant",
             @"restaurantImages" : @"MyEventImageModel",
             @"menuImages" : @"MyEventImageModel",
             @"restaurantCuisines" : @"ZZTypicalInformationModel",
             @"phone" : @"NSNumber",

             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"restaurantId" : @"_id",
             @"phone" : @"phone",
             @"restaurantBanner" : @"banner",
             @"restaurantIcon" : @"icon",
             @"restaurantAddress" : @"address",
             @"restaurantName" : @"name",
             
             @"restaurantDistance" : @"distance",
             @"restaurantDistrict" : @"district",
             @"restaurantCuisines" : @"cuisine",
             @"restaurantMinPrice" : @"minPrice",
             @"restaurantMaxPrice" : @"maxPrice",
             @"restaurantImages" : @"images",
             @"menuImages" : @"menus",
             };
}


@end
