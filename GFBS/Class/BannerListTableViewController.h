//
//  BannerListTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 4/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBannerModel.h"

@protocol ChildViewControllerDelegate;

@interface BannerListTableViewController : UITableViewController

@property (weak)id <ChildViewControllerDelegate> delegate;

@end

@protocol ChildViewControllerDelegate <NSObject >

- (void) passValue:(ZZBannerModel *) theValue;

@end
