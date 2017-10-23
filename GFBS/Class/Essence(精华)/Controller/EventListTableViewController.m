//
//  EventListTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 6/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "EventListTableViewController.h"
#import "GFEventDetailViewController.h"
#import "CreateEventViewController.h"
//#import "GFUpcomingTableViewController.h"
#import "GFSeeAllEventTableViewController.h"

#import "MyEvent.h"
#import "MyEventCell.h"
#import "ZBLocalized.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

//#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];

static NSString *const eventID = @"myEvent";
//@class MyEvent;

@interface EventListTableViewController ()

/*所有event数据*/
@property (strong , nonatomic)NSMutableArray<EventInList *> *myEvents;
/*maxtime*/
@property (strong , nonatomic)NSString *maxtime;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong , nonatomic)UIAlertView *alertView;

@end

@implementation EventListTableViewController

#pragma mark - 消除警告
-(MyEventType)type
{
    return 0;
}

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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUpTable];
    [self setupRefresh];
    
    [self setUpNote];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self preferredStatusBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setUpNote
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonRepeatClick) name:GFTabBarButtonDidRepeatShowClickNotificationCenter object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonRepeatClick) name:GFTitleButtonDidRepeatShowClickNotificationCenter object:nil];
}

#pragma mark - 监听
/**
 *  监听TabBar按钮的重复点击
 */
- (void)tabBarButtonRepeatClick
{
    // 如果当前控制器的view不在window上，就直接返回,否则这个方法调用五次
    if (self.view.window == nil) return;
    
    // 如果当前控制器的view跟window没有重叠，就直接返回
    if (![self.view isShowingOnKeyWindow]) return;
    
    // 进行下拉刷新
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  监听标题按钮的重复点击
 */
- (void)titleButtonRepeatClick
{
    [self tabBarButtonRepeatClick];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyEventCell class]) bundle:nil] forCellReuseIdentifier:eventID];
    /*
    if (_myEvents.count == 0) {
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + GFNavMaxY + 35, 10, GFScreenWidth - 20, 50)];
        hintLabel.numberOfLines = 3;
        hintLabel.text = @"You have not yet had a chance to organise a fun social gathering %n Take a plunge";
        self.tableView.tableHeaderView.gf_height = 50;
        [self.tableView.tableHeaderView addSubview:hintLabel];
    }
     */
    
}

- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [self.tableView.mj_header beginRefreshing];
    
    //self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
}

#pragma mark - 加载新数据
-(void)loadNewEvents
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSLog(@"user token %@", userToken);
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    NSDictionary *inData = [[NSDictionary alloc] init];
    if (self.type == 0) {
        inData = @{@"action" : @"getAttendingEventList", @"token" : userToken, @"lang" : userLang};
    } else if (self.type == 1) {
        inData = @{@"action" : @"getHostingEventList", @"token" : userToken, @"lang" : userLang};
    } else if (self.type == 2) {
        inData = @{@"action" : @"getDraftEventList", @"token" : userToken, @"lang" : userLang};
    } else if (self.type == 1) {
        inData = @{@"action" : @"getHistoryEventList", @"token" : userToken, @"lang" : userLang};
    }
    
    //NSDictionary *inData = @{@"action" : @"getAttendingEventList", @"token" : userToken};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"%@", parameters);
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        //字典转模型 //没有这句话显示不出数据
        self.myEvents = [EventInList mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        NSLog(@"%@", self.myEvents);
        
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
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    /*
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"action"] = @"getAttendingEventList";
    parameters[@"token"] = @"857a710374676eeaa1f48c900b2715787c0edb5a49a04b5c";
    */
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inData = @{@"action" : @"getAttendingEventList", @"token" : userToken };
    
    NSDictionary *parameters = @{@"data" : inData};

    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        
        NSLog(@"responseObject in topics %@", responseObject);
        
        [responseObject writeToFile:@"/Users/apple/Desktop/ceshi.plist" atomically:YES];
        
        //字典转模型
        NSMutableArray<EventInList *> *moreEvents = [EventInList mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.myEvents addObjectsFromArray:moreEvents];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
    
}

#pragma mark - setUpTable

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyEventCell *cell = (MyEventCell *)[tableView dequeueReusableCellWithIdentifier:eventID forIndexPath:indexPath];

    NSLog(@"indexPath.row = %ld", indexPath.row);
    NSLog(@"eventID %@", eventID);
        
    EventInList *thisEvent = self.myEvents[indexPath.row];
        
    NSLog(@"event id are %@", thisEvent.listEventID);
    NSLog(@"event start date are %@", thisEvent.listEventStartDate);
        
    cell.event = thisEvent; //这个是将vc中刚刚从url拿到的信息，传给view文件夹中cell.topic数据类型，这样在cell view的地方可以给cell里面要展示的东西赋值
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(GFScreenWidth - 40, 8, 15, 15)];
    cancelButton.tag = indexPath.row;
    [cancelButton setImage:[UIImage imageNamed:@"ic_cross"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cancelButton];
    
    return cell;
    
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, 50)];
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinButton.frame = CGRectMake(5, 10, self.view.gf_width - 10, 35);
    joinButton.layer.cornerRadius = 5.0f;
    joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [joinButton setClipsToBounds:YES];
    
    [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinButton setBackgroundColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
    
    
    if (self.type == MyEventTypeDraft) {
        [joinButton setTitle:@"Organise an Event" forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(organizeClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:joinButton];
    } else if (self.type == MyEventTypeHistory) {
        
    } else {
        [joinButton setTitle: ZBLocalized(@"Join More Events", nil)  forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(joinButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:joinButton];
    }

    
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row %ld", indexPath.row);
    
    GFEventDetailViewController *detailVC = [[GFEventDetailViewController alloc] init];
    detailVC.eventHere = self.myEvents[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}



-(void)joinButtonClicked {
    NSLog(@"Join more events button clicked");
    GFSeeAllEventTableViewController *upcomingVC = [[GFSeeAllEventTableViewController alloc] init];
    //self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.parentViewController.navigationController pushViewController:upcomingVC animated:YES];
}

- (void)organizeClicked {
    CreateEventViewController *createVC = [[CreateEventViewController alloc] init];
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)deleteButtonClicked :(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Do you want to decline this event?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    self.alertView = alertView;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        EventInList *thisEvent = _myEvents[[self.tableView indexPathForSelectedRow].row];
        [_myEvents removeObjectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [self.tableView reloadData];
        //NSString *eventID = _myEvents[[self.tableView indexPathForSelectedRow].row].listEventID;
        [self declineEvent: thisEvent.listEventID];
        
    }
}

#pragma mark - 加载更多数据
-(void)declineEvent: (NSString *)eventID
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [AppDelegate APP].user.userToken;
    NSDictionary *inSubData = @{@"eventId" : eventID};
    NSDictionary *inData = @{@"action" : @"declineEvent", @"token" : userToken, @"data" : inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        
        NSLog(@"responseObject in decline event %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
    
}

-(void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"UpcomingEventsVC moving to or from parent view controller");
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"UpcomgingEventsVC did move to or from parent view controller");
    self.view.frame = CGRectMake(0, 200, self.view.gf_width, self.view.gf_height - GFTabBarH);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清理缓存 放在这个个方法中调用频率过快
    [[SDImageCache sharedImageCache] clearMemory];
}


@end
