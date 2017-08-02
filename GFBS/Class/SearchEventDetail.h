//
//  SearchEventDetail.h
//  GFBS
//
//  Created by Alice Jin on 27/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchEventDetail : NSObject

//@property (nonatomic, strong) NSArray<NSString *> *keyword;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) NSInteger *maxPrice;
@property (nonatomic, assign) NSInteger *minPrice;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, strong) NSString *cuisine;
@property (nonatomic, assign) NSInteger *guestNumber;
@property (nonatomic, assign) NSInteger *page;
@property (nonatomic, strong) NSString *interests;
@property (nonatomic, copy) NSArray *geoPoint;

@end
