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
#import "ZBLocalized.h"

#import "RestaurantDetailViewController.h"
#import "NotificationViewController.h"
#import "GFSettingViewController.h"
#import "UIBarButtonItem+Badge.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>


static NSString *const restaurantID = @"restaurantID";

@interface RestaurantTableViewController ()

/*All restaurant data*/
@property (strong , nonatomic)NSMutableArray<EventRestaurant *> *restaurants;

@end

@implementation RestaurantTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    [self setUpTable];
    if (self.receivedData == nil || self.receivedData == NULL) {
        [self setupRefresh];
    } else {
        self.restaurants = self.receivedData;
        [self.tableView reloadData];
    }
    [self setUpNote];
    //[self setUpScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    //self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - 加载新数据
-(void)loadNewData
{
    
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
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    NSDictionary *inData = @{
                             @"action" : @"searchRestaurant",
                             @"data" : keyFactors,
                             @"lang" : userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"search Restaurant %@", parameters);
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        NSArray *restaurantsArray = data[@"data"];
        
        self.restaurants = [EventRestaurant mj_objectArrayWithKeyValuesArray:restaurantsArray];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
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
    self.navigationItem.title = ZBLocalized(@"Restaurants", nil);
    
}

- (void)settingClicked
{
    //XIB加载
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GFSettingViewController class]) bundle:nil];
    
    GFSettingViewController *settingVc = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)notificationClicked {
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

#pragma mark - tableView
- (void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 35, 0, 0);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RestaurantCell class]) bundle:nil] forCellReuseIdentifier:restaurantID];
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:restaurantID];
    cell.restaurant = self.restaurants[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantDetailViewController *restaurantDetailVC = [[RestaurantDetailViewController alloc] init];
    restaurantDetailVC.thisRestaurant = self.restaurants[indexPath.row];
    [self.navigationController pushViewController:restaurantDetailVC animated:YES];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清理缓存 放在这个个方法中调用频率过快
    [[SDImageCache sharedImageCache] clearMemory];
}

//************************* update cell which is hearted in commentVC ******************************//
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"indexPathForSlectedRow in viewWillAppear %@", [self.tableView indexPathForSelectedRow]);
    NSLog(@"indexPathForSlectedRow in viewWillAppear.row %ld", [self.tableView indexPathForSelectedRow].row);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
