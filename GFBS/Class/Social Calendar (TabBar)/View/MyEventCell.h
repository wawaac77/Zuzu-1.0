//
//  MyEventCell.h
//  GFBS
//
//  Created by Alice Jin on 6/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventInList;
@interface MyEventCell : UITableViewCell

/*数据*/
@property (strong , nonatomic)EventInList *event ;

@end
