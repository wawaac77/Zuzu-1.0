//
//  LeaderboardViewController.m
//  GFBS
//
//  Created by Alice Jin on 10/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "LeaderboardViewController.h"
#import "LeaderboardAttendeesTableViewController.h"
#import "LeaderboardHostTableViewController.h"
#import "GFTitleButton.h"

@interface LeaderboardViewController () <UIScrollViewDelegate>

/*当前选中的Button*/
@property (weak ,nonatomic) GFTitleButton *selectTitleButton;
/*标题按钮地下的指示器*/
@property (weak ,nonatomic) UIView *indicatorView;
/*标题栏*/
@property (weak ,nonatomic) UIView *titleView;
/*DisplayView*/
@property (weak ,nonatomic) UIScrollView *scrollView;
/*请求管理者*/
@property (strong , nonatomic) GFHTTPSessionManager *manager;

@end

@implementation LeaderboardViewController

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
    self.navigationItem.title = @"Leaderboard";
    //[self loadNeweData];
    [self setUpChildViewControllers];
    [self setUpDisplayView];
    [self setUpTitleView];
    //添加默认自控制器View
    [self addChildViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 添加scrollView
 */
-(void)setUpDisplayView
{
    
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, 35, self.view.gf_width, 1000);
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
    titleView.frame = CGRectMake(0, 0 , self.view.gf_width, 35);
    //NSLog(@"self.view.gf_width is %f", self.view.gf_width);
    [self.view addSubview:titleView];
    
    NSArray *titleContens = @[@"Attendees",@"Host"];
    NSInteger count = titleContens.count;
    //NSLog(@"titlecontents count is %ld", (long)count);
    
    CGFloat titleButtonW = (titleView.gf_width - 70) / count;
    //NSLog(@"titleView.gf_width is %f", titleView.gf_width);
    //NSLog(@"titleButtonW is %f", titleButtonW);
    CGFloat titleButtonH = titleView.gf_height;
    
    for (NSInteger i = 0; i < count; i++) {
        GFTitleButton *titleButton = [GFTitleButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.tag = i; //绑定tag
        [titleButton addTarget:self action:@selector(titelClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:titleContens[i] forState:UIControlStateNormal];
        CGFloat titleX = i * titleButtonW + 35;
        NSLog(@"i is %ld", (long) i);
        NSLog(@"titleX is %f", titleX);
        titleButton.frame = CGRectMake(titleX, 0, titleButtonW, titleButtonH);
        
        [titleView addSubview:titleButton];
        
    }
    //按钮选中颜色
    GFTitleButton *firstTitleButton = titleView.subviews.firstObject;
    //底部指示器
    UIView *indicatorView = [[UIView alloc] init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.gf_height = 2;
    indicatorView.gf_y = titleView.gf_height - indicatorView.gf_height;
    
    [titleView addSubview:indicatorView];
    
    //默认选择第一个全部TitleButton
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.gf_width = firstTitleButton.gf_width;
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
    //NSLog(@"titleButton.tag at clicked %ld", titleButton.tag);
    //控制状态
    self.selectTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectTitleButton = titleButton;
    
    //指示器
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.gf_width = titleButton.gf_width;
        self.indicatorView.gf_centerX = titleButton.gf_centerX;
    }];
    
    //让uiscrollView 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.gf_width * titleButton.tag;
    NSLog(@"tittlebutton.tag %ld", titleButton.tag);
    NSLog(@"offset.x %f", offset.x);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 添加子控制器View
-(void)addChildViewController
{
    //在这里面添加自控制器的View
    //NSInteger index = self.scrollView.contentOffset.x / self.scrollView.gf_width;
    NSLog(@"self.scrollView.contentOffset.x %f", self.scrollView.contentOffset.x);
    NSLog(@"self.scrollView.gf_width %f", self.scrollView.gf_width);
    for (int i = 0; i < 2; i++) {
        int index = i;
        //取出自控制器
        UIViewController *childVc = self.childViewControllers[index];
        
        if (childVc.view.superview) return; //判断添加就不用再添加了
        childVc.view.frame = CGRectMake(index * self.scrollView.gf_width, 0, self.scrollView.gf_width, self.scrollView.gf_height);
        NSLog(@"index in leaderboard is %ld", (long) index);
        [self.scrollView addSubview:childVc.view];
    }
    
    
}

-(void)setUpChildViewControllers
{
    //Attendees
    LeaderboardAttendeesTableViewController *attendeesVC = [[LeaderboardAttendeesTableViewController alloc] init];
    NSLog(@"self.view.gf_width in leaderboard is %f", self.view.gf_width);
    [self addChildViewController:attendeesVC];
    
    //Host
    LeaderboardHostTableViewController *hostVC = [[LeaderboardHostTableViewController alloc] init];
  
    [self addChildViewController:hostVC];
    
    
    
}



@end
