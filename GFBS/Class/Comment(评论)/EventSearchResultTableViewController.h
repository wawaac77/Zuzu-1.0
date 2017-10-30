//
//  EventSearchResultTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 3/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventInList;
@class EventRestaurant;

@interface EventSearchResultTableViewController : UITableViewController

@property (strong , strong) NSMutableArray<EventInList *> *events;
@property (strong , strong) EventRestaurant *thisRestaurant;
@property (strong , strong) NSString *keywords;

@end
