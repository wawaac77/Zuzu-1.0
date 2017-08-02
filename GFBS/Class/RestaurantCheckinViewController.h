//
//  RestaurantCheckinViewController.h
//  GFBS
//
//  Created by Alice Jin on 31/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZContentModel.h"

@interface RestaurantCheckinViewController : UITableViewController

@property (strong , nonatomic)NSMutableArray<ZZContentModel *> *contents;

@end
