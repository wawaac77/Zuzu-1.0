//
//  RestaurantCheckinTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 30/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantCheckinTableViewController.h"

@interface RestaurantCheckinTableViewController ()

@end

@implementation RestaurantCheckinTableViewController
@synthesize restaurant;

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
    return RestaurantReview;
}

-(NSString *)restaurantID {
    return restaurant;
}

@end
