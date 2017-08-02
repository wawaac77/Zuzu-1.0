//
//  EventRestaurant.h
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwEn.h"
#import "MyEventImageModel.h"
#import "ZZTypicalInformationModel.h"

@class MyEventImageModel;
@class TwEn;
@class ZZTypicalInformationModel;

@interface EventRestaurant : NSObject


/****** selectively used by eventRestaurant Page *****/
@property (nonatomic, copy) NSString *restaurantId;
@property (nonatomic, strong) NSArray<NSNumber *> *phone;
@property (nonatomic, strong) MyEventImageModel *restaurantBanner;
@property (nonatomic, strong) MyEventImageModel *restaurantIcon;
@property (nonatomic, strong) TwEn *restaurantAddress;
@property (nonatomic, strong) TwEn *restaurantName;
@property (nonatomic, copy) NSString *operationHour;
@property (nonatomic, copy) NSString *features;


/****** for restaurant list page *****/
@property (nonatomic, assign) NSNumber *restaurantDistance;
@property (nonatomic, strong) ZZTypicalInformationModel *restaurantDistrict;
@property (nonatomic, strong) NSMutableArray <ZZTypicalInformationModel *> *restaurantCuisines;
@property (nonatomic, assign) NSNumber *restaurantMinPrice;
@property (nonatomic, assign) NSNumber *restaurantMaxPrice;
@property (nonatomic, strong) NSMutableArray <MyEventImageModel*> *restaurantImages;
@property (nonatomic, strong) NSMutableArray <MyEventImageModel*> *menuImages;


@end
