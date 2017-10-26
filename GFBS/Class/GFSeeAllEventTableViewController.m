//
//  GFSeeAllEventTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 2/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFSeeAllEventTableViewController.h"
#import "GFEventsCell.h"
#import "EventInList.h"
#import "GFEventDetailViewController.h"
#import "ZBLocalized.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

static NSString *const eventID = @"event";

@interface GFSeeAllEventTableViewController ()

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<EventInList *> *upcomingEvents;

@end

@implementation GFSeeAllEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    NSLog(@"seeAllVC height %f",[UIScreen mainScreen].bounds.size.height);
    if (self.receivedData == nil) {
        [self setupRefresh];
    } else {
        self.upcomingEvents = self.receivedData;
    }
    [self setUpTable];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setUpNavBar];
}



- (void)setUpNavBar {
    
    [self preferredStatusBarStyle];
    self.navigationItem.title = ZBLocalized(@"Upcoming Events", nil);
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
  
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    //[self.tableView setFrame:self.view.bounds];
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFEventsCell class]) bundle:nil] forCellReuseIdentifier:eventID];
    
    //[self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.upcomingEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:eventID forIndexPath:indexPath];
    
    EventInList *thisEvent = self.upcomingEvents[indexPath.row];
    cell.event = thisEvent; //topic 数据类型完全与event的数据类型一样，这样才能直接赋值
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventDetailViewController *eventDetailVC = [[GFEventDetailViewController alloc] init];
    eventDetailVC.eventHere = _upcomingEvents[indexPath.row];
    eventDetailVC.view.frame = CGRectMake(0, 200, self.view.gf_width, self.view.gf_height - 200);
    
    [self.navigationController pushViewController:eventDetailVC animated:YES];
}


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
                             @"lang" : userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"upcoming events parameters %@", parameters);
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        NSArray *eventsArray = data[@"data"];
        self.upcomingEvents = [EventInList mj_objectArrayWithKeyValuesArray:eventsArray];

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
        
        [self.tableView.mj_footer endRefreshing];
        
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清理缓存 放在这个个方法中调用频率过快
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
