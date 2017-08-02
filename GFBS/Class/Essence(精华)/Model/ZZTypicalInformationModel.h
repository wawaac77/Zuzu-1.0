//
//  ZZTypicalInformationModel.h
//  GFBS
//
//  Created by Alice Jin on 6/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwEn.h"

@class TwEn;

@interface ZZTypicalInformationModel : NSObject

@property (nonatomic, copy) NSString *informationID;
//@property (nonatomic, copy) NSString *informationUpdatedBy;
//@property (nonatomic, copy) NSString *informationUpdatedAt;
//@property (nonatomic, copy) NSString *informationCreatedBy;
//@property (nonatomic, copy) NSString *informationCreatedAt;
//@property (nonatomic, assign) NSNumber *informationV;
@property (nonatomic, strong) TwEn *informationName;

@end
