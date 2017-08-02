//
//  ZZContentModel.h
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"
#import "EventRestaurant.h"
#import "GFImage.h"

@class ZZUser;
@class EventRestaurant;
@class GFImage;

typedef NS_ENUM(NSInteger , MyPublishContentType){
    
    AllPublishContent = 0,
    
    FriendsPublishContent = 1,

    MePublishContent = 2,
    
    CommentContent = 3,
    
    RestaurantReview = 4,
    
    UserProfileCheckin = 5,
    
};

@interface ZZContentModel : NSObject

@property (nonatomic, copy) NSString *listEventID;
@property (nonatomic, copy) NSString *listEventUpdatedBy;
@property (nonatomic, copy) NSString *listEventUpdatedAt;
@property (nonatomic, copy) NSString *listEventCreatedBy;
@property (nonatomic, copy) NSString *listEventCreatedAt;
@property (nonatomic, copy) NSString *listMessage;
@property (nonatomic, strong) ZZUser *listPublishUser;
@property (nonatomic, strong) EventRestaurant *listEventRestaurant;
@property (nonatomic, strong) GFImage *listImage;

@property (nonatomic, copy) NSNumber *listIsLike;

/*****额外增加的属性*****/
@property (nonatomic, strong) UIImage *listImage_UIImage;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** cell for comment高度 */
@property (nonatomic, assign) CGFloat cellHeightForComment;

/** 中间内容的Frame */
@property (nonatomic, assign) CGRect middleF;

/** 帖子类型 */
@property (nonatomic, assign) MyPublishContentType type;


@end
