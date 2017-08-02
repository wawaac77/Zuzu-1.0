//
//  UserCheckinListChildTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 31/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "UserCheckinListChildTableViewController.h"

@interface UserCheckinListChildTableViewController ()

@end

@implementation UserCheckinListChildTableViewController

@synthesize userID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MyPublishContentType)type
{
    return UserProfileCheckin;
}

- (NSString *)userID
{
    NSLog(@"userID in childVC %@", userID);
    return userID;
}


@end
