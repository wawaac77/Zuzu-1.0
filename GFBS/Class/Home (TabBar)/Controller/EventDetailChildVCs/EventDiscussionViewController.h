//
//  EventDiscussionViewController.h
//  GFBS
//
//  Created by Alice Jin on 2/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZContentModel;

@interface EventDiscussionViewController : UITableViewController

/** 帖子模型数据 */
@property (nonatomic, strong) ZZContentModel *topic;

@property (nonatomic, strong) NSString *eventID;

@end
