//
//  FilterTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 26/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "LocationTableViewController.h"
#import "InterestsTableViewController.h"
#import "CuisineTableViewController.h"
#import "NumOfGuestsTableViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface FilterTableViewController : UITableViewController<ChildViewControllerDelegate, InterestsChildViewControllerDelegate,CuisineChildViewControllerDelegate, NumOfGuestsChildViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
