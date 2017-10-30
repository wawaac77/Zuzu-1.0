//
//  SubFillTableViewController.h
//  GFBS
//
//  Created by Alice Jin on 14/9/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FillinChildViewControllerDelegate;

@interface SubFillTableViewController : UITableViewController

@property (weak)id <FillinChildViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *tableType;
//@property (strong, nonatomic) NSString *information;

@end

@protocol FillinChildViewControllerDelegate <NSObject >

- (void) passValue:(NSNumber *) theValue;

@end
