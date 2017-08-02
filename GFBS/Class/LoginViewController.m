//
//  LoginViewController.m
//  GFBS
//
//  Created by Alice Jin on 26/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#import "LoginChildViewController.h"
#import "SignUpChildViewController.h"
#import "LoginButton.h"
#import "GFTabBarController.h"

@interface LoginViewController () <UIScrollViewDelegate>

/*当前选中的Button*/
@property (weak ,nonatomic) LoginButton *selectTitleButton;

/*标题按钮地下的指示器*/
@property (weak ,nonatomic) UIView *indicatorView ;

/*UIScrollView*/
@property (weak ,nonatomic) UIScrollView *scrollView;

/*标题栏*/
@property (weak ,nonatomic) UIView *titleView;

@end

@implementation LoginViewController




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    if (![AppDelegate APP].user) {
        LoginViewController *login = [[LoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
     */
    if ([AppDelegate APP].user) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[GFTabBarController alloc]init];
    } else {
        return;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    //设置导航条
    [self setUpBackground];
    [self setUpNavBar];
    
    [self setUpChildViewControllers];
    
    [self setUpScrollView];
    
    [self setUpTitleView];
    
    //添加默认自控制器View
    [self addChildViewController];
    
}

- (void)setUpBackground
{
    //set background
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundImageView.image = [UIImage imageNamed:@"bg_login_page"];
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    //set logo
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 80, 80)];
    //logoImageView.frame = CGSizeMake(50, 50);
    logoImageView.center = CGPointMake(self.view.gf_width / 2, 70);
    logoImageView.image = [UIImage imageNamed:@"logo-292x341-homescreen.png"];
    [self.view insertSubview:logoImageView atIndex:1];
}

-(void)setUpChildViewControllers
{
    //SignUp
    SignUpChildViewController *signupVC = [[SignUpChildViewController alloc] init];
    [self addChildViewController:signupVC];

    //Login
    LoginChildViewController *loginVC = [[LoginChildViewController alloc] init];
    [self addChildViewController:loginVC];
    
}

/**
 添加scrollView
 */
-(void)setUpScrollView
{
    
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView = scrollView;
    
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, 155, self.view.gf_width, self.view.gf_height - 155);
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
    titleView.backgroundColor = [UIColor clearColor];
    titleView.frame = CGRectMake(0, 120 , self.view.gf_width, 35);
    //titleView.tintColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    //[self.view insertSubview:titleView atIndex:2];
    
    //NSArray *titleContens = @[@"LOGIN",@"SIGN UP"];
    NSArray *titleContens = @[@"SIGN UP",@"LOGIN"];
    NSInteger count = titleContens.count;
    
    CGFloat titleButtonW = (titleView.gf_width - 70) / count;
    CGFloat titleButtonH = titleView.gf_height;
    
    for (NSInteger i = 0;i < count; i++) {
        LoginButton *titleButton = [LoginButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i; //绑定tag
        [titleButton addTarget:self action:@selector(titelClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:titleContens[i] forState:UIControlStateNormal];
        CGFloat titleX = i * titleButtonW + 35;
        titleButton.frame = CGRectMake(titleX, 0, titleButtonW, titleButtonH);
        
        [titleView addSubview:titleButton];
        
    }
    //按钮选中颜色
    LoginButton *firstTitleButton = titleView.subviews.firstObject;
    //底部指示器
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    
    indicatorView.gf_height = 3;
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
-(void)titelClick:(LoginButton *)titleButton
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
        
        self.indicatorView.gf_width = titleButton.gf_width;
        self.indicatorView.gf_centerX = titleButton.gf_centerX;
    }];
    
    //让uiscrollView 滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.gf_width * titleButton.tag;
    [self.scrollView setContentOffset:offset animated:YES];
    
    [self.view endEditing:YES];
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
    LoginButton *titleButton = self.titleView.subviews[index];
    
    [self titelClick:titleButton];
    
    [self addChildViewController];
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    //左边
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_logo"] WithHighlighted:[UIImage imageNamed:@"ic_logo"] Target:self action:@selector(logo)];
    
    //右边
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-filter"] WithHighlighted:[UIImage imageNamed:@"ic_fa-filter"] Target:self action:@selector(filterButten)];
    
    //TitieView
    //self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //self.navigationItem.title = @"Search Bar should be here!";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
