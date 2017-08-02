//
//  EventListCell.h
//  GFBS
//
//  Created by Alice Jin on 16/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFEvent;

@interface EventListCell : UITableViewCell

/*数据*/
@property (strong, nonatomic)GFEvent *event;

@end
