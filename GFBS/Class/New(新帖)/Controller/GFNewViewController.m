//
//  GFNewViewController.m
//  GFBS
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GFNewViewController.h"
#import "GFSubTagViewController.h"

#import "GFMemberViewController.h"
#import "GFSettingViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "NotificationViewController.h"

@interface GFNewViewController ()

@end

@implementation GFNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}


#pragma mark - 设置导航条
-(void)setUpNavBar
{
    
    UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    fixedButton.width = 20;
    UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    notificationBtn.badgeValue = @"2"; // I need the number of not checked through API
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, fixedButton, notificationBtn, nil]];

    
    self.navigationItem.title = @"My Events";
}

- (void)settingClicked
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GFSettingViewController class]) bundle:nil];
    GFSettingViewController *settingVc = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)notificationClicked
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}



@end
