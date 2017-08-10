//
//  InterestsTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 10/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchEventDetail.h"

@protocol InterestsChildViewControllerDelegate;

@interface InterestsTableViewController : UITableViewController

@property (weak)id <InterestsChildViewControllerDelegate> delegate;

@end


@protocol InterestsChildViewControllerDelegate <NSObject >

- (void) passValueInterests:(SearchEventDetail *) theValue;

@end
