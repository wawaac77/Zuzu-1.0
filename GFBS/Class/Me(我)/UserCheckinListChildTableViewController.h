//
//  UserCheckinListChildTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 31/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePostTableViewController.h"

@interface UserCheckinListChildTableViewController : HomePostTableViewController <ChildViewControllerDelegate>

@property (copy, nonatomic) NSString *userID;

@end
