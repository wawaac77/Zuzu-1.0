//
//  RestaurantDetailViewController.m
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "RestaurantDetailViewController.h"
#import "RestaurantOverviewViewController.h"
#import "RestaurantCheckinViewController.h"
//#import "RestaurantCheckinTableViewController.h"
//#import "RestaurantReviewViewController.h"
#import "RestaurantPhotoViewController.h"
#import "RestaurantMenuViewController.h"
#import "RestaurantEventViewController.h"
#import "ZZCheckInViewController.h"

#import "GFTitleButton.h"
#import "EventRestaurant.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface RestaurantDetailViewController () <UIScrollViewDelegate>

/*当前选中的Button*/
@property (weak ,nonatomic) GFTitleButton *selectTitleButton;

/*标题按钮地下的指示器*/
@property (weak ,nonatomic) UIView *indicatorView ;

/*UIScrollView*/
@property (weak ,nonatomic) UIScrollView *scrollView;

/*标题栏*/
@property (weak ,nonatomic) UIScrollView *titleView;

/*TopImageView*/
@property (strong ,nonatomic) UIImageView *topImageView ;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<ZZContentModel *> *contents;

@end


@implementation RestaurantDetailViewController

@synthesize thisRestaurant;

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
    _contents = [[NSMutableArray alloc] init];
    [self setUpTopImageView];
    [self loadNeweData];
    
}


- (void)setUpAfterLoadData {
    
    UILabel *numOfCheckinLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, GFScreenWidth - 20, 40)];
    numOfCheckinLabel.textAlignment = NSTextAlignmentCenter;
    numOfCheckinLabel.text = [NSString stringWithFormat:@"%ld Check-in", _contents.count];
    numOfCheckinLabel.textColor = [UIColor whiteColor]; // pay attention to text color
    [self.view addSubview:numOfCheckinLabel];
    
    [self setUpChildViewControllers];
    [self setUpScrollView];
    [self setUpTitleView];
    //添加默认自控制器View
    [self addChildViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavBar];
}

- (void)setUpNavBar {
    
    [self preferredStatusBarStyle];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.title = thisRestaurant.restaurantName.en;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpTopImageView {
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, 200)];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:thisRestaurant.restaurantBanner.imageUrl] placeholderImage:nil];
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.clipsToBounds = YES;
    [self.view addSubview:_topImageView];
    
    //**************** add checkin button *****************//
    UIButton *checkinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.topImageView.gf_width - 45, self.topImageView.gf_height - 45, 30, 30)];
    [checkinButton setImage:[UIImage imageNamed:@"ic_checkin-restaurant"] forState:UIControlStateNormal];
    checkinButton.contentMode = UIViewContentModeScaleAspectFit;
    [checkinButton addTarget:self action:@selector(checkinButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkinButton];
    
    
    
    
}

- (void)checkinButtonClicked {
    ZZCheckInViewController *checkinVC = [[ZZCheckInViewController alloc] init];
    [self.navigationController pushViewController:checkinVC animated:YES];
}

-(void)setUpChildViewControllers
{
    //Overview
    RestaurantOverviewViewController *overviewVC = [[RestaurantOverviewViewController alloc] init];
    overviewVC.thisRestaurant = thisRestaurant;
    [self addChildViewController:overviewVC];
    
    //Check-in
    /*
    RestaurantCheckinTableViewController *reviewVC = [[RestaurantCheckinTableViewController alloc] init];
    //reviewVC.view.backgroundColor = [UIColor orangeColor];
    reviewVC.restaurant = thisRestaurant.restaurantId;
    */
    
    RestaurantCheckinViewController *reviewVC = [[RestaurantCheckinViewController alloc] init];
    reviewVC.contents = self.contents;
     NSLog(@"selfContentsinRestaurantDetail in setupChildVC %@", self.contents);
    [self addChildViewController:reviewVC];
    
    //Photo
    RestaurantPhotoViewController *photoVC = [[RestaurantPhotoViewController alloc] init];
    photoVC.restaurantImages = thisRestaurant.restaurantImages;
    
    [self addChildViewController:photoVC];
    
    //Menu
    RestaurantMenuViewController *menuVC = [[RestaurantMenuViewController alloc] init];
    menuVC.menuImages = thisRestaurant.menuImages;
    [self addChildViewController:menuVC];
    
    /*
    //Event
    RestaurantEventViewController *eventVC = [[RestaurantEventViewController alloc] init];
    eventVC.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:eventVC];
     */
    
}

/**
 添加scrollView
 */
-(void)setUpScrollView
{
    
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    
    scrollView.delegate = self;
    //CGFloat scrollHeight = GFScreenHeight * 0.6;
    scrollView.frame = CGRectMake(0, 235, GFScreenWidth, GFScreenHeight - 235 - GFTabBarH - GFNavMaxY);
    NSLog(@"self.view.gf_width in first claim scrollView is %f", self.view.gf_width);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(self.view.gf_width * self.childViewControllers.count, 0);
}


/**
 添加标题栏View
 */
-(void)setUpTitleView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *titleView = [[UIScrollView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    self.titleView = titleView;
    
    titleView.delegate = self;
    titleView.frame = CGRectMake(0, 200, self.view.gf_width, 35);
    //titleView.contentSize = CGSizeMake(self.view.gf_width + 50, 0);
    titleView.contentSize = CGSizeMake(self.view.gf_width, 0);
    NSLog(@"self.view.gf_width in first claim scrollView is %f", self.view.gf_width);
    titleView.pagingEnabled = YES;
    titleView.scrollEnabled = YES;
    titleView.showsVerticalScrollIndicator = NO;
    titleView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:titleView];
    
    /*
    UIScrollView *titleView = [[UIView alloc] init];
    self.titleView = titleView;
    titleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    titleView.frame = CGRectMake(0, 200 , self.view.gf_width + 100, 35);
    NSLog(@"self.view.gf_width is %f", self.view.gf_width);
    [self.view addSubview:titleView];
     */
    
    NSArray *titleContens = @[@"Overview",@"Check-in",@"Photo",@"Menu"];
    NSInteger count = titleContens.count;
    NSLog(@"titlecontents count is %ld", (long)count);
    
    CGFloat titleButtonW = titleView.contentSize.width / count;
    NSLog(@"titleView.gf_width is %f", titleView.gf_width);
    NSLog(@"titleButtonW is %f", titleButtonW);
    CGFloat titleButtonH = titleView.gf_height;
    
    for (NSInteger i = 0; i < count; i++) {
        GFTitleButton *titleButton = [GFTitleButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.tag = i; //绑定tag
        [titleButton addTarget:self action:@selector(titelClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:titleContens[i] forState:UIControlStateNormal];
        CGFloat titleX = i * titleButtonW;
        NSLog(@"i is %ld", (long) i);
        NSLog(@"titleX is %f", titleX);
        titleButton.frame = CGRectMake(titleX, 0, titleButtonW, titleButtonH);
        
        [titleView addSubview:titleButton];
        
    }
    //按钮选中颜色
    GFTitleButton *firstTitleButton = titleView.subviews.firstObject;
    //底部指示器
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    
    indicatorView.gf_height = 2;
    indicatorView.gf_y = titleView.gf_height - indicatorView.gf_height;
    
    [titleView addSubview:indicatorView];
    
    //默认选择第一个全部TitleButton
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.gf_width = firstTitleButton.titleLabel.gf_width;
    indicatorView.gf_centerX = firstTitleButton.gf_centerX;
    [self titelClick:firstTitleButton];
}

/**
 标题栏按钮点击
 */
-(void)titelClick:(GFTitleButton *)titleButton
{
    if (self.selectTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter]postNotificationName:GFTitleButtonDidRepeatShowClickNotificationCenter object:nil];
    }
    
    //控制状态
    self.selectTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectTitleButton = titleButton;
    
    //指示器
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.gf_width = titleButton.titleLabel.gf_width;
        self.indicatorView.gf_centerX = titleButton.gf_centerX;
    }];
    
    //让uiscrollView 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.gf_width * titleButton.tag;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 添加子控制器View
-(void)addChildViewController
{
    //在这里面添加自控制器的View
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.gf_width;
    //取出自控制器
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview) return; //判断添加就不用再添加了
    childVc.view.frame = CGRectMake(index * self.scrollView.gf_width, 0, self.scrollView.gf_width, self.scrollView.gf_height);
    NSLog(@"index is %ld", (long) index);
    [self.scrollView addSubview:childVc.view];
    
}

#pragma mark - <UIScrollViewDelegate>

/**
 点击动画后停止调用
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildViewController];
}


/**
 人气拖动的时候，滚动动画结束时调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //点击对应的按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.gf_width;
    GFTitleButton *titleButton = self.titleView.subviews[index];
    
    [self titelClick:titleButton];
    
    [self addChildViewController];
}

/*
- (void)setUpTopImageView
{
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.gf_width, 200 - GFNavMaxY)];
    self.topImageView = topImageView;
    topImageView.backgroundColor = [UIColor blackColor];
    topImageView.image = [UIImage imageNamed:@"pexels-photo-262918.png"];
    [self.view addSubview:topImageView];
}
*/
/*
#pragma mark - 设置导航条
-(void)setUpNavBar
{
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.alpha = 0.0f;
    //左边
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_logo"] WithHighlighted:[UIImage imageNamed:@"ic_logo"] Target:self action:@selector(logo)];
    
    //右边
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-filter"] WithHighlighted:[UIImage imageNamed:@"ic_fa-filter"] Target:self action:@selector(filterButten)];
    
    //TitieView
    //self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //self.navigationItem.title = @"Search Bar should be here!";
}
*/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadNeweData {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *restaurantID = thisRestaurant.restaurantId;
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    NSDictionary *inSubData = @{@"restaurantId" : restaurantID};
    NSDictionary *inData = @{
                             @"action" : @"getRestaurantDetail",
                             @"token" : userToken,
                             @"data" : inSubData
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        EventRestaurant *response = responseObject[@"data"];
        NSLog(@"response in restaurant %@", response);
        thisRestaurant = [EventRestaurant mj_objectWithKeyValues:response];
        
        [self loadCheckins];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}

#pragma mark - 加载新数据
-(void)loadCheckins
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inData = [[NSDictionary alloc] init];
    
    NSDictionary *inSubData = @{@"restaurantId" : thisRestaurant.restaurantId};
    inData = @{@"action" : @"getRestaurantCheckinList", @"token" : userToken, @"data":inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"publish content parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        self.contents = [ZZContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //reviewVC.contents = self.contents;
        NSLog(@"selfContentsinRestaurantDetail %@", self.contents);
        //[self saveUIImages];
        [self setUpAfterLoadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}


@end
