//
//  LocationTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 27/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableViewController.h"
//#import "PassValueDelegate.h"

@interface LocationTableViewController : UITableViewController <PassValueDelegate>

@property (nonatomic, retain) SearchEventDetail *eventDetail;
@property (strong, nonatomic) FilterTableViewController *filterVC;

//@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;

@end
