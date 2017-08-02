//
//  ZZComment.h
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"
#import "ZZContentModel.h"

@class ZZUser;
@class ZZContentModel;

@interface ZZComment : NSObject

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *commentUpdatedBy;
@property (nonatomic, copy) NSString *commentUpdatedAt;
@property (nonatomic, copy) NSString *commentCreatedBy;
@property (nonatomic, copy) NSString *commentCreatedAt;
@property (nonatomic, copy) NSString *commentMessage;
@property (nonatomic, strong) ZZContentModel *commentCheckInContent;
@property (nonatomic, strong) ZZUser *member;


@end
