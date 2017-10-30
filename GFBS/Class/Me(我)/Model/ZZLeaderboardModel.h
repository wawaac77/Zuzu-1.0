//
//  ZZLeaderboardModel.h
//  GFBS
//
//  Created by Alice Jin on 10/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUser.h"

@class ZZUser;

@interface ZZLeaderboardModel : NSObject

@property (nonatomic, strong) ZZUser *leaderboardMember;
@property (nonatomic, assign) NSNumber *leaderboardRank;
@property (nonatomic, assign) NSNumber *leaderboardLevel;
@property (nonatomic, assign) NSNumber *leaderboardRating;
@property (nonatomic, assign) NSNumber *leaderboardRankChange;
@property (nonatomic, copy) NSString *leaderboardType;

@end
