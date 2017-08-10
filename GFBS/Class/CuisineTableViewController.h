//
//  CuisineTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 10/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchEventDetail.h"

@protocol CuisineChildViewControllerDelegate;

@interface CuisineTableViewController : UITableViewController
@property (weak)id <CuisineChildViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *tableType;

@end

@protocol CuisineChildViewControllerDelegate <NSObject >

- (void) passValueCuisine:(SearchEventDetail *) theValue;

@end
