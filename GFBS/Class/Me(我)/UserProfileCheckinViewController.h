//
//  UserProfileCheckinViewController.h
//  GFBS
//
//  Created by Alice Jin on 30/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePostTableViewController.h"

@interface UserProfileCheckinViewController : UIViewController <ChildViewControllerDelegate>

@property (strong, nonatomic) ZZUser *myProfile;

@end
