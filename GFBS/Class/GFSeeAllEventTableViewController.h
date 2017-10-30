//
//  GFSeeAllEventTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 2/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventInList.h"

@interface GFSeeAllEventTableViewController : UITableViewController

@property (strong , nonatomic)NSMutableArray<EventInList *> *receivedData;

@end
