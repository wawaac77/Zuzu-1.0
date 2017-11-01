//
//  ZZEventInSection.h
//  GFBS
//
//  Created by Alice Jin on 1/11/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventInList;

@interface ZZEventInSection : NSObject

@property (nonatomic, strong) NSMutableArray <EventInList *>  *pendingApproval;
@property (nonatomic, strong) NSMutableArray <EventInList *>  *rejectecd;
@property (nonatomic, strong) NSMutableArray <EventInList *>  *approved;
@property (nonatomic, strong) NSMutableArray <EventInList *>  *incomplete;
@property (nonatomic, strong) NSMutableArray <EventInList *>  *cancelled;


@end
