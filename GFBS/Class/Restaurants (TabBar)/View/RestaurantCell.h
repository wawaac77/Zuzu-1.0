//
//  RestaurantCell.h
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventRestaurant.h"

@class EventRestaurant;
@interface RestaurantCell : UITableViewCell

/*数据*/
@property (strong, nonatomic) EventRestaurant *restaurant;

@end
