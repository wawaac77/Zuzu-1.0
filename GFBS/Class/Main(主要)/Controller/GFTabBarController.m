//
//  GFTabBarController.m
//  GFBS
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GFTabBarController.h"
#import "GFNavigationController.h"
#import "ZBLocalized.h"

//#import "GFMeViewController.h"
//#import "ZZHomeViewController.h"
#import "GFHomeViewController.h"
#import "ZZCheckInViewController.h"
#import "ZZInboxTableViewController.h"
#import "MyZuzuViewController.h"
#import "GFEssenceViewController.h"
#import "GFPublishView.h"
#import "GFFriendTrendViewController.h"
#import "RestaurantTableViewController.h"

#import "GFTabBar.h"

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];

@interface GFTabBarController ()

@end

@implementation GFTabBarController

//只加载一次
#pragma mark - 设置tabBar字体格式
+(void)load
{
    UITabBarItem *titleItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //正常
    NSMutableDictionary *normalDict = [NSMutableDictionary dictionary];
    normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    normalDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [titleItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    //选中
    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionary];
    selectedDict[NSForegroundColorAttributeName] = DEFAULT_COLOR_GOLD;
    [titleItem setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.bounds = [UIScreen mainScreen].bounds;
    //添加子控制器
    [self setUpAllChildView];
    //添加所有按钮内容
    [self setUpTabBarBtn];
    //更换系统tabbar
    [self setUpTabBar];
}

#pragma mark - 更换系统tabbar
-(void)setUpTabBar
{
    GFTabBar *tabBar = [[GFTabBar alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.tintColor = DEFAULT_COLOR_GOLD;
    tabBar.unselectedItemTintColor = [UIColor grayColor];
    //把系统换成自定义
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - 添加所有按钮内容
-(void)setUpTabBarBtn
{
    
    GFNavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = ZBLocalized(@"Home", nil);
    nav.tabBarItem.image = [UIImage imageNamed:@"ic_home"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_home-on"];
    
    
    GFNavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = ZBLocalized(@"Social Calendar", nil) ;
    nav1.tabBarItem.image = [UIImage imageNamed:@"ic_social"];
    nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_social_on"];
    
    
    GFNavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = ZBLocalized(@"Restaurants", nil) ;
    nav2.tabBarItem.image = [UIImage imageNamed:@"ic_restaurant"];
    nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_restaurant-o"];
    
    
    GFNavigationController *nav3 = self.childViewControllers[3];
    nav3.tabBarItem.title = ZBLocalized(@"My Zuzu", nil);
    nav3.tabBarItem.image = [UIImage imageNamed:@"ic_my_zuzu"];
    nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_my_zuzu_on"];
    
}

#pragma mark - 添加子控制器
-(void)setUpAllChildView
{
    /** Home */
    GFHomeViewController *homepage = [[GFHomeViewController alloc] init];
    homepage.view.frame = [UIScreen mainScreen].bounds;
    GFNavigationController *nav = [[GFNavigationController alloc]initWithRootViewController:homepage];
    [self addChildViewController:nav];
    NSLog(@"homeViewController essence width is %f", homepage.view.frame.size.width);
    NSLog(@"mainscreen width is %f", [UIScreen mainScreen].bounds.size.width);
    
    /** Social Calendar */
    GFEssenceViewController *social = [[GFEssenceViewController alloc] init];
    GFNavigationController *nav1 = [[GFNavigationController alloc]initWithRootViewController:social];
    [self addChildViewController:nav1];
    
    /** Restaurants */
    RestaurantTableViewController *restaurantVC = [[RestaurantTableViewController alloc] init];
    GFNavigationController *nav2 = [[GFNavigationController alloc]initWithRootViewController:restaurantVC];
    [self addChildViewController:nav2];
    
    /** My Zuzu */
    MyZuzuViewController *me = [[MyZuzuViewController alloc] initWithNibName:@"MyZuzuViewController" bundle:nil];
    
    GFNavigationController *nav3 = [[GFNavigationController alloc]initWithRootViewController:me];
    [self addChildViewController:nav3];
     
    
}

@end
