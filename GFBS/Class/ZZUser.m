//
//  ZZUser.m
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZUser.h"

@implementation ZZUser

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"userInterests" : @"ZZTypicalInformationModel",
            };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"userID" : @"_id",
             @"userUpdatedBy" : @"updatedBy",
             @"userUpdatedAt" : @"updatedAt",
             @"userCreatedAt" : @"createdAt",
             @"userName" : @"name",
             @"userEmail" : @"email",
             @"usertPassword" : @"password",
             @"userUserName" : @"username",
             @"userStatus" : @"status",
             @"userToken" : @"token",
             @"userActivationKey" : @"activationKey",
             @"userV" : @"__v",
             @"userFacebookID" : @"facebookID",
             @"userForgetPasswordKey" : @"forgetPasswordKey",
             @"userGoogleID" : @"googleId",
             @"userOrganizingLevel" : @"organizingLevel",
             @"userOrganizingExp" : @"organizingExp",
             @"listEventIsPrivate" : @"isPrivate",
             @"userInterests" : @"interests",
             @"userProfileImage" : @"profilePic",
             @"userLastCheckIn" : @"lastCheckin",
             
             @"userIndustry" : @"industry",
             @"userProfession" : @"profession",
             };
}


@end
