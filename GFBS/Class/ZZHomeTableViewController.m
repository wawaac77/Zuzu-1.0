//
//  ZZHomeTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 27/10/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZHomeTableViewController.h"
#import "CreateEventViewController.h"
#import "FilterTableViewController.h"
#import "SearchPageViewController.h"
#import "GFEventDetailViewController.h"
#import "GFSeeAllEventTableViewController.h"
#import "MapNearbyEventsViewController.h"

#import "GFEventsCell.h"
#import "EventInList.h"

#import "ZBLocalized.h"
#import "UIBarButtonItem+Badge.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString *const eventID = @"event";

@interface ZZHomeTableViewController () <UISearchBarDelegate> {
    CGFloat headerH;
}

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<EventInList *> *upcomingEvents;

@end

@implementation ZZHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    headerH = 200;
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200;
    }
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, headerH)];
    
    UIView *titleView = [self titleViewForTitle:@"Nearby Events" icon:@"ic_location" tag:0];
    [header addSubview:titleView];
    
    UIView *upcomingTitleView = [self titleViewForTitle:@"Upcoming Events" icon:@"ic_upcoming_event" tag:1];
    upcomingTitleView.frame = CGRectMake(0, 165, GFScreenWidth, 35);
    [header addSubview:upcomingTitleView];
    
    
    return header;
}

- (UIView *)titleViewForTitle:(NSString *)title icon:(NSString *)icon tag:(NSInteger)tag {
    //Add nearbyTitleView
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, 35)];
    titleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    
    //Add subview:nearbyTitleLabel
    UILabel *nearbyTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 25)];
    nearbyTitle.text = ZBLocalized(title, nil);
    [nearbyTitle setFont:[UIFont boldSystemFontOfSize:15]];
    [titleView addSubview:nearbyTitle];
    
    //Add subview:nearbyIconView
    UIImageView *nearbyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    nearbyIcon.image = [UIImage imageNamed:icon];
    nearbyIcon.contentMode = UIViewContentModeScaleAspectFit;
    [titleView addSubview:nearbyIcon];
    
    //Add subview:seeAllButton
    UIButton *seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeAllButton setTitle:ZBLocalized(@"See All >", nil)  forState:UIControlStateNormal];
    [seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    seeAllButton.tag = tag;
    [seeAllButton addTarget:self action:@selector(seeAllNearbyClicked:) forControlEvents:UIControlEventTouchUpInside];
    seeAllButton.frame = CGRectMake(GFScreenWidth - 100, 0, 90, 35);
    seeAllButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleView addSubview:seeAllButton];
    
    return titleView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _upcomingEvents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GFEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:eventID forIndexPath:indexPath];
    
    EventInList *thisEvent = self.upcomingEvents[indexPath.row];
    
    cell.event = thisEvent; //topic 数据类型完全与event的数据类型一样，这样才能直接赋值
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
             
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GFEventDetailViewController *eventDetailVC = [[GFEventDetailViewController alloc] init];
    eventDetailVC.eventHere = _upcomingEvents[indexPath.row];

    [self.navigationController pushViewController:eventDetailVC animated:YES];
    
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    //左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_logo"] WithHighlighted:[UIImage imageNamed:@"ic_logo"] Target:self action:@selector(logo)];
    
    //右边
    UIBarButtonItem *rightItem =  [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-filter"] WithHighlighted:[UIImage imageNamed:@"ic_fa-filter"] Target:self action:@selector(filterButton)];
    
    //add search bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = ZBLocalized(@"Event name, interest, restaurant", nil) ;
    self.navigationItem.titleView = searchBar;
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark - setup fresh
- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/*******Here is reloading data place*****/
#pragma mark - 加载新数据
-(void)loadNewEvents
{
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = @{
                             @"action" : @"getUpcomingEventList",
                             @"data" : geoPointDic,
                             @"lang" :userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.upcomingEvents = [EventInList mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 加载更多数据
-(void)loadMoreData
{
    
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    NSDictionary *inData = @{
                             @"action" : @"getUpcomingEventList",
                             @"data" : geoPointDic};
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        NSMutableArray<EventInList *> *moreEvents = [EventInList mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [self.upcomingEvents addObjectsFromArray:moreEvents];
        [self.tableView reloadData];
        //[_ibMenu reloadData];
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
}

#pragma -button clicked
- (void)logo {
    //NSLog(@"Logo button clicked");
}

- (void)filterButton{
    NSLog(@"filter button clicked");
    FilterTableViewController *filterVC = [[FilterTableViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    SearchPageViewController *searchVC = [[SearchPageViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return YES;
}

- (void)createButtonClicked {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([CreateEventViewController class]) bundle:nil];
    
    CreateEventViewController *createEventVC = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:createEventVC animated:YES];
}

- (void)seeAllNearbyClicked:(UIButton *)button {
    NSLog(@"SeeAllNearby button clicked");
    if (button.tag == 0) {
        MapNearbyEventsViewController *mapVC = [[MapNearbyEventsViewController alloc] init];
        [self.navigationController pushViewController:mapVC animated:YES];
    } else if (button.tag == 1) {
        GFSeeAllEventTableViewController *eventListVC = [[GFSeeAllEventTableViewController alloc] init];
        [self.navigationController pushViewController:eventListVC animated:YES];
    }
   
    
}

- (void)seeAllUpcomingClicked {
    NSLog(@"SeeAllUpcoming button clicked");
    GFSeeAllEventTableViewController *eventListVC = [[GFSeeAllEventTableViewController alloc] init];
    [self.navigationController pushViewController:eventListVC animated:YES];
    
}

@end
