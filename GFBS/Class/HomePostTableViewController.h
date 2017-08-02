//
//  HomePostTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZContentModel.h"


@protocol ChildViewControllerDelegate <NSObject>

- (void) passValue: (NSInteger *)theValue;

@end

@protocol ChildViewControllerDelegate;

@interface HomePostTableViewController : UITableViewController

-(MyPublishContentType)type;
-(NSString *)restaurantID;
-(NSString *)userID;

//@property (nonatomic, copy) NSString *restaurantID;
@property (weak)id <ChildViewControllerDelegate> delegate;

//@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *receivingType;

@end

