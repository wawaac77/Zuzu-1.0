//
//  GFEventsCell.h
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventInList; //Use data model of GFTopic
@interface GFEventsCell : UITableViewCell

/*数据*/
@property (strong, nonatomic) EventInList *event;

@end
