//
//  ZZCheckInViewController.h
//  GFBS
//
//  Created by Alice Jin on 13/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"
#import <CoreLocation/CoreLocation.h>

@interface ZZCheckInViewController : UIViewController <CLLocationManagerDelegate, DropDownChooseDelegate,DropDownChooseDataSource>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
