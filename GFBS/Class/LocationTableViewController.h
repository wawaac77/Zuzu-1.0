//
//  LocationTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 27/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchEventDetail.h"

@protocol ChildViewControllerDelegate;

@interface LocationTableViewController : UITableViewController

@property (weak)id <ChildViewControllerDelegate> delegate;

@property (nonatomic, retain) SearchEventDetail *eventDetail;

@end

@protocol ChildViewControllerDelegate <NSObject >

- (void) passValue:(SearchEventDetail *) theValue;

@end
