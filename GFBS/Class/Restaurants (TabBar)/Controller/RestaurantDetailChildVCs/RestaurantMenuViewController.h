//
//  RestaurantMenuViewController.h
//  GFBS
//
//  Created by Alice Jin on 24/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyEventImageModel.h"

@interface RestaurantMenuViewController : UIViewController

@property (strong, nonatomic) NSMutableArray <MyEventImageModel*> *menuImages;

@end
