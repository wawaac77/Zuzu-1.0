//
//  GFEventDetailViewController.m
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFEventDetailViewController.h"
#import "EventOverviewViewController.h"
#import "EventDiscussionViewController.h"
#import "EventPhotoViewController.h"
#import "NotificationViewController.h"
#import "GFSettingViewController.h"
#import "GFTitleButton.h"
#import "ZBLocalized.h"

#import "UIBarButtonItem+Badge.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface GFEventDetailViewController () <UIScrollViewDelegate>

/*当前选中的Button*/
@property (weak ,nonatomic) GFTitleButton *selectTitleButton;

/*标题按钮地下的指示器*/
@property (weak ,nonatomic) UIView *indicatorView ;

/*UIScrollView*/
@property (weak ,nonatomic) UIScrollView *scrollView;

/*标题栏*/
@property (weak ,nonatomic) UIView *titleView;

//upper view
@property (weak, nonatomic) IBOutlet UILabel *bigTitleView;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
- (IBAction)shareButtonClicked:(id)sender;



@end


@implementation GFEventDetailViewController

//@synthesize eventDetail;
//@synthesize eventHere;


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    self.view.frame = [UIScreen mainScreen].bounds;
    [self loadNeweData];
    
    [self setUpNavBar];
    
    [self setUpChildViewControllers];
    
    [self setUpScrollView];
    
    [self setUpTitleView];
    
    [self setUpHeaderView];
    
    //添加默认自控制器View
    [self addChildViewController];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setUpNavBar1];
    
}
*/


- (void)setUpNavBar1 {
    
    //[self preferredStatusBarStyle];
    /*
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:YES];
     */
    //self.navigationController.navigationBar.translucent = YES;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
  
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}



- (void)loadNeweData {
    
    NSString *eventID = self.eventHere.listEventID;

    NSDictionary *forEventID = @ {@"eventId" : eventID};
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = @{
                             @"action" : @"getEventDetail",
                             @"data" : forEventID,
                             @"lang" : userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        EventInList *event = data[@"data"];
        self.eventHere = [EventInList mj_objectWithKeyValues:event];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
}


-(void)setUpChildViewControllers
{
    //Overview
    EventOverviewViewController *overviewVC = [[EventOverviewViewController alloc] init];
    //overviewVC.view.backgroundColor = [UIColor redColor];
    overviewVC.thisEvent = _eventHere;
    [self addChildViewController:overviewVC];
    
    //Discussion
    EventDiscussionViewController *discussionVC = [[EventDiscussionViewController alloc] init];
    discussionVC.eventID = _eventHere.listEventID;
    //discussionVC.view.backgroundColor = [UIColor purpleColor];
    [self addChildViewController:discussionVC];
    
    //Photo
    EventPhotoViewController *photoVC = [[EventPhotoViewController alloc] init];
    //photoVC.view.backgroundColor = [UIColor orangeColor];
    photoVC.thisEventID = _eventHere.listEventID;
    [self addChildViewController:photoVC];
   
}

- (void)setUpHeaderView {
    self.bigTitleView.text = _eventHere.listEventName;
    self.smallTitleView.text = _eventHere.listEventDescription;
    [self downloadImageFromURL:_eventHere.listEventBanner.eventBanner.imageUrl];
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
    scrollView.frame = CGRectMake(0, 235, self.view.gf_width, GFScreenHeight - 235 - GFNavMaxY);
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
    UIView *titleView = [[UIView alloc] init];
    self.titleView = titleView;
    titleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    titleView.frame = CGRectMake(0, 200 , self.view.gf_width, 35);
    NSLog(@"self.view.gf_width is %f", self.view.gf_width);
    [self.view addSubview:titleView];
    
    NSArray *titleContens = @[ZBLocalized(@"Overview", nil), ZBLocalized(@"Discussion", nil), ZBLocalized(@"Photo", nil)];
    NSInteger count = titleContens.count;
    NSLog(@"titlecontents count is %ld", (long)count);
    
    CGFloat titleButtonW = titleView.gf_width / count;
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

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    fixedButton.width = 20;
    UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    notificationBtn.badgeValue = @"2"; // I need the number of not checked through API
 
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, fixedButton, notificationBtn, nil]];
}

-(void)settingClicked
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GFSettingViewController class]) bundle:nil];
    GFSettingViewController *settingVc = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

-(void)notificationClicked
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationVC animated:YES];
    NSLog(@"notification clicked");
}


-(void)downloadImageFromURL :(NSString *)imageUrl{
    
    NSURL  *url = [NSURL URLWithString:imageUrl];
    NSLog(@"imageURL %@", url);
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSLog(@"Downloading started...");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"dwnld_image.png"];
        NSLog(@"FILE : %@",filePath);
        [urlData writeToFile:filePath atomically:YES];
        UIImage *image1=[UIImage imageWithContentsOfFile:filePath];
        self.headerImageView.image=image1;
        NSLog(@"Completed...");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonClicked:(id)sender {
    //NSURL *contentURL = _eventHere.listEventBanner.eventBanner.imageUrl;
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL =[NSURL URLWithString:@"http://developers.facebook.com"];
    
    //FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
    FBSDKSendButton *button = [[FBSDKSendButton alloc] init];
    button.frame = CGRectMake(GFScreenWidth - 65, 170, 20, 20);
    button.shareContent = content;
    
    [self.view addSubview: button];
    
}
@end
