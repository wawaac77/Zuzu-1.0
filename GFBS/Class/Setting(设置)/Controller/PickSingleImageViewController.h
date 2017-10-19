//
//  PickSingleImageViewController.h
//  GFBS
//
//  Created by Alice Jin on 16/10/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickSingleImageDelegate;

@protocol PickSingleImageDelegate <NSObject >

- (void) passSingleImage:(NSString *) theURL;

@end

@interface PickSingleImageViewController : UIViewController

@property (weak, nonatomic)id <PickSingleImageDelegate> delegate;

@end
