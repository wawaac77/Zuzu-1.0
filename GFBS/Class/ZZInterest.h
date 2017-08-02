//
//  ZZInterest.h
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwEn.h"

@class TwEn;
@interface ZZInterest : NSObject

@property (nonatomic, copy) NSString *interestID;
@property (nonatomic, copy) NSString *interestUpdatedBy;
@property (nonatomic, copy) NSString *interestUpdatedAt;
@property (nonatomic, copy) NSString *interestCreatedBy;
@property (nonatomic, copy) NSString *interestCreatedAt;
@property (nonatomic, strong) TwEn *interestName;

@end
