//
//  ZZFriendRequestModel.h
//  GFBS
//
//  Created by Alice Jin on 26/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZUser;

@interface ZZFriendRequestModel : NSObject
@property (nonatomic,copy) NSString *friendshipID;
@property (nonatomic, strong) ZZUser *friendRequest;
@property (nonatomic, strong) ZZUser *memberRequest;
@property (nonatomic, strong) NSString *status;

//******** other property ***************//
@property (nonatomic, strong) NSNumber *isRead;

@end
