//
//  ZZFriendModel.h
//  GFBS
//
//  Created by Alice Jin on 18/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"

@class ZZUser;

@interface ZZFriendModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *updatedBy;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSString *createdBy;
@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, strong) ZZUser *friendInfo;
@property (nonatomic, strong) ZZUser *memberInfo;
@property (nonatomic, copy) NSString *status;

@end
