//
//  RestaurantTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 9/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventRestaurant.h"

@interface RestaurantTableViewController : UITableViewController

@property (strong, nonatomic) NSString *keywords;

@property (strong , nonatomic)NSMutableArray<EventRestaurant *> *receivedData;

@end
