//
//  SearchEventDetail.h
//  GFBS
//
//  Created by Alice Jin on 27/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTypicalInformationModel.h"

@interface SearchEventDetail : NSObject

//@property (nonatomic, strong) NSArray<NSString *> *keyword;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, strong) NSNumber *maxPrice;
@property (nonatomic, strong) NSNumber *minPrice;
@property (nonatomic, strong) ZZTypicalInformationModel *district;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) ZZTypicalInformationModel *cuisine;
@property (nonatomic, strong) ZZTypicalInformationModel *landmark;
@property (nonatomic, assign) NSString *guestNumber;
@property (nonatomic, assign) NSNumber *page;
@property (nonatomic, strong) NSString *interests;
@property (nonatomic, copy) NSArray *geoPoint;

@end
