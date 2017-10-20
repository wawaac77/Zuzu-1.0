//
//  GFSettingViewController.h
//  高仿百思不得不得姐
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "CuisineTableViewController.h"
#import "SubFillTableViewController.h"
#import "PickSingleImageViewController.h"

@interface GFSettingViewController : UITableViewController <FillinChildViewControllerDelegate, CuisineChildViewControllerDelegate, PickSingleImageDelegate, GIDSignInUIDelegate>

@end
