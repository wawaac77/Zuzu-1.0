//
//  EventSearchResultTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 3/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "EventSearchResultTableViewController.h"
#import "GFEventDetailViewController.h"
#import "EventInList.h"
#import "EventListCell.h"
#import "ZBLocalized.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

#define Str(str) str?str:@""
#define Num(num) num?num:@0

static NSString *const listEventID = @"event";

@interface EventSearchResultTableViewController ()

@end

@implementation EventSearchResultTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZBLocalized(@"Events", nil);
    [self setupRefresh];
    [self setUpTable];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [self.tableView.mj_header beginRefreshing];
    
    //tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/*******Here is reloading data place*****/
#pragma mark - 加载新数据
-(void)loadNewEvents
{

    NSArray *geoPoint = @[@114, @22];
    NSString *userToken = [AppDelegate APP].user.userToken;
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inSubData = @{@"geoPoint" : geoPoint,
                                @"keyword" : Str(self.keywords),
                                };
    
    NSDictionary *inData = @{
                             @"action" : @"searchEvent",
                             @"token" : userToken,
                             @"data" : inSubData,
                             @"lang" : userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.events = [EventInList mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
    /*
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        //字典转模型//这是给topics数组赋值的地方
        NSLog(@"responseObject是接下来的%@", responseObject);
        NSLog(@"responseObject - data 是接下来的%@", responseObject[@"data"]);
        
        self.events = [EventInList mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
      
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
     */
    
}

- (void)setUpTable {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EventListCell class]) bundle:nil] forCellReuseIdentifier:listEventID];
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _events.count;
}

- (EventListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:listEventID forIndexPath:indexPath];
    EventInList *thisEvent = self.events[indexPath.row];
    NSLog(@"thisEvent %@", thisEvent);
    cell.event = thisEvent;
    NSLog(@"-------------%ld", indexPath.row);
    NSLog(@"neaarbyEvents count in tableview cellForRowAtIndexPath%ld", _events.count);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventDetailViewController *eventDetailVC = [[GFEventDetailViewController alloc] init];
    eventDetailVC.eventHere = self.events[indexPath.row];
    [self.navigationController pushViewController:eventDetailVC animated:YES];
}
@end
