//
//  NumOfGuestsTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 10/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchEventDetail.h"

@protocol NumOfGuestsChildViewControllerDelegate;

@interface NumOfGuestsTableViewController : UITableViewController

@property (weak)id <NumOfGuestsChildViewControllerDelegate> delegate;
@end

@protocol NumOfGuestsChildViewControllerDelegate <NSObject >

- (void) passValueNumOfGuests:(SearchEventDetail *) theValue;

@end
