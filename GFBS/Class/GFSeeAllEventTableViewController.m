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

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

static NSString *const eventID = @"event";

@interface GFSeeAllEventTableViewController ()

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<EventInList *> *upcomingEvents;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation GFSeeAllEventTableViewController

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

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
    self.navigationItem.title = @"Upcoming Events";
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
    NSLog(@"table width %f",self.view.gf_width);
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
    
    NSLog(@"indexPath.row%ld", indexPath.row);
    EventInList *thisEvent = self.upcomingEvents[indexPath.row];
    NSLog(@"this event.listEventID%@", thisEvent.listEventID);
    cell.event = thisEvent; //topic 数据类型完全与event的数据类型一样，这样才能直接赋值
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventDetailViewController *eventDetailVC = [[GFEventDetailViewController alloc] init];
    eventDetailVC.eventHere = _upcomingEvents[indexPath.row];
    eventDetailVC.view.frame = CGRectMake(0, 200, self.view.gf_width, self.view.gf_height - 200);
    
    NSLog(@" _upcomingEvents[indexPath.row] %@", _upcomingEvents[indexPath.row]);
    //eventDetailVC.eventHere = self.topics[indexPath.row];
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
    NSLog(@"loadNewEvents工作了");
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    //NSDictionary *action = @{@"action" : @"getEventBannerList"};
    //NSDictionary *parameters = @{@"data" : action};
    
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    NSDictionary *inData = @{
                             @"action" : @"getUpcomingEventList",
                             @"data" : geoPointDic};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"upcoming events parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        NSArray *eventsArray = responseObject[@"data"];
        
        
        self.upcomingEvents = [EventInList mj_objectArrayWithKeyValuesArray:eventsArray];
        
        //NSLog(@"upcomingevents %@", self.upcomingEvents);
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

#pragma mark - 加载更多数据
-(void)loadMoreData
{
    NSLog(@"loadMoreData工作了le");
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    NSDictionary *inData = @{
                             @"action" : @"getUpcomingEventList",
                             @"data" : geoPointDic};
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        //存储这一页的maxtime
        //self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //[responseObject writeToFile:@"/Users/apple/Desktop/ceshi.plist" atomically:YES];
        
        //字典转模型
        NSLog(@"Request is successful成功了");
        NSMutableArray<EventInList *> *moreEvents = [EventInList mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.upcomingEvents addObjectsFromArray:moreEvents];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request 失败");
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
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
