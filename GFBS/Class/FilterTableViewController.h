//
//  FilterTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 26/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
//#import "SearchEventDetail.h"

@class SearchEventDetail;

@protocol PassValueDelegate <NSObject>

//-(void)passValue:(SearchEventDetail *)value;
-(SearchEventDetail *) passValue;

@end


@interface FilterTableViewController : UITableViewController<PassValueDelegate>

@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;

@end
