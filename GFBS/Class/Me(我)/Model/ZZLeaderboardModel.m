//
//  ZZLeaderboardModel.m
//  GFBS
//
//  Created by Alice Jin on 10/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZLeaderboardModel.h"

@implementation ZZLeaderboardModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"leaderboardMember" : @"member",
             @"leaderboardRank" : @"rank",
             @"leaderboardLevel" : @"level",
             @"leaderboardRating" : @"rating",
             @"leaderboardRankChange" : @"rankChange",
             @"leaderboardType" : @"type",
            };
}


@end
