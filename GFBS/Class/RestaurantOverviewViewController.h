//
//  RestaurantOverviewViewController.h
//  GFBS
//
//  Created by Alice Jin on 24/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventRestaurant.h"

@interface RestaurantOverviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) EventRestaurant *thisRestaurant;

@end
