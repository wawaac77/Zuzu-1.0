//
//  ZZTypicalInformationModel.m
//  GFBS
//
//  Created by Alice Jin on 6/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZTypicalInformationModel.h"

@implementation ZZTypicalInformationModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"informationID" : @"_id",
             //@"informationUpdatedBy" : @"updatedBy",
             //@"informationUpdatedAt" : @"updatedAt",
             //@"informationCreatedBy" : @"createdBy",
             //@"informationCreatedAt" : @"createdAt",
             //@"informationV" : @"__v",
             @"informationName" : @"name",
             };
}



@end
