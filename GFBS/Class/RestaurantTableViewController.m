//
//  RestaurantTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 9/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantTableViewController.h"

#import "RestaurantCell.h"
#import "EventRestaurant.h"

#import "RestaurantDetailViewController.h"
#import "GFSettingViewController.h"
#import "UIBarButtonItem+Badge.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>


static NSString *const restaurantID = @"restaurant";

@interface RestaurantTableViewController ()

/*All restaurant data*/
@property (strong , nonatomic)NSMutableArray<EventRestaurant *> *restaurants;
/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;


@end

@implementation RestaurantTableViewController

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
    [self setUpNavBar];
    [self setUpTable];
    [self setupRefresh];
    
    //[self setUpScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"loadNewEvents工作了");
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *keyFactors = @
    {
        @"keyword" : @"",
        @"address" : @"",
        @"maxPrice" : @"",
        @"minPrice" : @"",
        @"landmark" : @"",
        @"district" : @"",
        @"cuisine" : @"",
        @"page" : @"",
        @"geoPoint" : geoPoint
    };
    NSDictionary *inData = @{
                             @"action" : @"searchRestaurant",
                             @"data" : keyFactors};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"search Restaurant %@", parameters);
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject是接下来的%@", responseObject);
        NSLog(@"responseObject - data 是接下来的%@", responseObject[@"data"]);
        
        
        NSArray *restaurantsArray = responseObject[@"data"];
        
        self.restaurants = [EventRestaurant mj_objectArrayWithKeyValuesArray:restaurantsArray];
        
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

#pragma mark - NavBar
- (void)setUpNavBar
{
    UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    fixedButton.width = 20;
    UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    notificationBtn.badgeValue = @"2"; // I need the number of not checked through API
    //notificationBtn.badgePadding = 0;
    //notificationBtn.badgeMinSize = 0;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, fixedButton, notificationBtn, nil]];
    
    //Title
    self.navigationItem.title = @"Restaurants";
    
}

- (void)settingClicked
{
    //XIB加载
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GFSettingViewController class]) bundle:nil];
    
    GFSettingViewController *settingVc = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)notificationClicked {
    NSLog(@"Notification clicked");
}

#pragma mark - tableView
- (void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 35, 0, 0);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RestaurantCell class]) bundle:nil] forCellReuseIdentifier:restaurantID];
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //GFTopic *topic = _topics[indexPath.row];
    
    return 110.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.restaurants.count %zd", self.restaurants.count);
    return self.restaurants.count;
}

- (RestaurantCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:restaurantID forIndexPath:indexPath];
    EventRestaurant *thisRestaurant = self.restaurants[indexPath.row];
    cell.restaurant = thisRestaurant;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantDetailViewController *restaurantDetailVC = [[RestaurantDetailViewController alloc] init];
    restaurantDetailVC.thisRestaurant = self.restaurants[indexPath.row];
    [self.navigationController pushViewController:restaurantDetailVC animated:YES];
}



@end
