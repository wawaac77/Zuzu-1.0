//
//  ZZUser.h
//  GFBS
//
//  Created by Alice Jin on 5/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFImage.h"
#import "ZZContentModel.h"
#import "ZZTypicalInformationModel.h"
#import "GFImage.h"

@class GFImage;
@class ZZContentModel;
@class ZZTypicalInformationModel;

@interface ZZUser : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userUpdatedAt;
@property (nonatomic, copy) NSString *userUpdatedBy;
@property (nonatomic, copy) NSString *userCreatedAt;
@property (nonatomic, copy) NSString *usertName;
@property (nonatomic, copy) NSString *userEmail;
@property (nonatomic, copy) NSString *usertPassword;
@property (nonatomic, copy) NSString *userUserName;
@property (nonatomic, copy) NSString *userStatus;
@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSString *userActivationKey;
@property (nonatomic, copy) NSString *userV;
@property (nonatomic, copy) NSString *userFacebookID;
@property (nonatomic, copy) NSString *userForgetPasswordKey;
@property (nonatomic, copy) NSString *userGoogleID;

@property (nonatomic, copy) NSNumber *userOrganizingLevel;
@property (nonatomic, copy) NSNumber *userOrganizingExp;
@property (nonatomic, copy) NSNumber *socialLevel;
@property (nonatomic, copy) NSNumber *socialExp;
@property (nonatomic, assign) NSNumber *checkinPoint;

@property (nonatomic, strong) NSMutableArray<ZZTypicalInformationModel *> *userInterests;
@property (nonatomic, strong) GFImage *userProfileImage;
@property (nonatomic, strong) ZZContentModel *userLastCheckIn;

@property (nonatomic, assign) NSNumber *age;
@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) ZZTypicalInformationModel *userIndustry;
@property (nonatomic, strong) ZZTypicalInformationModel *userProfession;

@property (nonatomic, assign) NSNumber *maxPrice;
@property (nonatomic, assign) NSNumber *minPrice;

@property (nonatomic, copy) NSString *preferredLanguage;
@property (nonatomic, strong) NSNumber *numOfFollower;

@property (nonatomic, assign) NSNumber *showOnLockScreen;
@property (nonatomic, assign) NSNumber *sounds;
@property (nonatomic, assign) NSNumber *emailNotification;
@property (nonatomic, assign) NSNumber *allowNotification;

@property (nonatomic, assign) NSNumber *canSeeMyProfile;
@property (nonatomic, assign) NSNumber *canMessageMe;
@property (nonatomic, assign) NSNumber *canMyFriendSeeMyEmail;


@property (nonatomic, copy) UIImage *userProfileImage_UIImage;
@property (nonatomic, strong) NSNumber *notificationNum;

+ (NSURLSessionDataTask *)login:(NSDictionary *)paramDic
                        Success:(void (^)(NSDictionary *result))success
                        Failure:(void (^)(NSError *error))failue;

//******************* others ****************************//
@property (nonatomic, copy) NSString *facebookEmail;
@property (nonatomic, copy) NSString *googleEmail;
@property (nonatomic, copy) NSURL *googleProfileImageUrl;

//******************* 单例 ****************************//
/**
 获取单例
 
 @return 对象
 */
+ (instancetype)shareUser;


@end

