//
//  EventOverviewViewController.h
//  GFBS
//
//  Created by Alice Jin on 26/10/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventInList.h"

@interface EventOverviewViewController : UITableViewController

@property (strong, nonatomic) EventInList *thisEvent;

@end
