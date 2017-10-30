//
//  GFHomeViewController.m
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFHomeViewController.h"

#import "GFNearbyEventsViewController.h"
#import "GFUpcomingTableViewController.h"
#import "GFEventDetailViewController.h"
#import "GFSeeAllEventTableViewController.h"
#import "MapNearbyEventsViewController.h"
#import "CreateEventViewController.h"
#import "FilterTableViewController.h"
#import "SearchPageViewController.h"
#import "ZBLocalized.h"

@interface GFHomeViewController () <UIScrollViewDelegate, UISearchBarDelegate>

/*UIScrollView*/
@property (weak ,nonatomic) UIScrollView *scrollView;

/*TitleView*/
@property (weak ,nonatomic) UIView *nearbyTitleView;
@property (weak ,nonatomic) UIView *upcomingTitleView;

@property (weak ,nonatomic) UIButton *createButton;

@property (weak, nonatomic) GFNearbyEventsViewController *nearbyVC;
@property (weak, nonatomic) GFUpcomingTableViewController *upcomingVC;
@property (weak ,nonatomic) UISearchBar *searchBar;

@end

@implementation GFHomeViewController

//GFNearbyEventsViewController *nearbyVC;
//GFUpcomingTableViewController *upcomingVC;


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpNavBar];
    [self setUpScrollView];
    [self setUpChildViewControllers];
    
    [self setUpNearbyTitleView];
    [self setUpUpcomingTitleView];
    
    [self setUpCreateButton];
    
    //添加默认自控制器View
    //[self addChildViewController];
}

- (void)viewWillAppear:(BOOL)animated  {
    //[self setUpNavBar];
    [self.searchBar sizeToFit];
}


/**
 添加scrollView
 */
-(void)setUpScrollView
{
    
    //不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView = scrollView;
    
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.gf_width, 1000);
    NSLog(@"GFHomeVC self.view.gf_width is %f", self.view.gf_width);
    NSLog(@"GFHomeVC self.view.gf_width frame is %f", self.view.frame.size.width);
    
    [self.view addSubview:scrollView];
    
    
}

/**
 Add childVCs
 */

-(void)setUpChildViewControllers
{
    //NearbyEvents
    GFNearbyEventsViewController *nearbyVC = [[GFNearbyEventsViewController alloc] init];
    self.nearbyVC = nearbyVC;
    nearbyVC.view.backgroundColor = [UIColor lightGrayColor];
    [self addChildViewController:nearbyVC];
    [self.scrollView addSubview:nearbyVC.view];
    [nearbyVC didMoveToParentViewController:self];
    
    //UpcomingEvents
    GFUpcomingTableViewController *upcomingVC = [[GFUpcomingTableViewController alloc] init];
    self.upcomingVC = upcomingVC;
    upcomingVC.view.backgroundColor = [UIColor lightGrayColor];
    [self addChildViewController:upcomingVC];
    [self.scrollView addSubview:upcomingVC.view];
    [upcomingVC didMoveToParentViewController:self];
    
}

/*
- (void)addChildViewController {
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.gf_width;
    UIViewController *childVC = self.childViewControllers[index];
    if (childVC.view.superview) return;
    childVC.view.frame = CGRectMake(index * self.scrollView.gf_width, 0 , self.scrollView.gf_width,self.scrollView.gf_height);
    [self.scrollView addSubview:childVC.view];
}
*/ 


//************* set up nearby titleView ********************//
-(void)setUpNearbyTitleView
{
    //Add nearbyTitleView
    UIView *nearbyTitleView = [[UIView alloc] init];
    self.nearbyTitleView = nearbyTitleView;
    nearbyTitleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    nearbyTitleView.frame = CGRectMake(0, 0 , self.view.gf_width, 35);
    [self.scrollView addSubview:nearbyTitleView];
    
    /*
     NSArray *titleContens = @[@"Nearby Events"];
    //NSArray *titleContens = @[@"Attending"];
    NSInteger count = titleContens.count;
    
    CGFloat titleButtonW = nearbyTitleView.gf_width / count;
    CGFloat titleButtonH = nearbyTitleView.gf_height;
    */
    //Add subview:nearbyTitleLabel
    UILabel *nearbyTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 25)];
    nearbyTitle.text = ZBLocalized(@"Nearby Events", nil);
    [nearbyTitle setFont:[UIFont boldSystemFontOfSize:16]];
    [nearbyTitleView addSubview:nearbyTitle];
    
    //Add subview:nearbyIconView
    UIImageView *nearbyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    nearbyIcon.image = [UIImage imageNamed:@"ic_location"];
    nearbyIcon.contentMode = UIViewContentModeScaleAspectFit;
    [nearbyTitleView addSubview:nearbyIcon];
    
    //Add subview:seeAllButton
    UIButton *seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeAllButton setTitle:ZBLocalized(@"See All >", nil)  forState:UIControlStateNormal];
    [seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seeAllButton addTarget:self action:@selector(seeAllNearbyClicked) forControlEvents:UIControlEventTouchUpInside];
    seeAllButton.frame = CGRectMake(self.view.gf_width - 100, 0, 90, 35);
    NSLog(@"self.view.gf_width is %f", self.view.gf_width);
    seeAllButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //seeAllButton.backgroundColor = [UIColor redColor];
    NSLog(@"nearby title view width is %f", nearbyTitleView.gf_width);
    NSLog(@"nearby title view height is %f", nearbyTitleView.gf_height);
    NSLog(@"nearby title view _x is %f", nearbyTitleView.gf_x);
    NSLog(@"nearby title view _y is %f", nearbyTitleView.gf_y);
    
    [nearbyTitleView addSubview:seeAllButton];
}

//************* set up upcoming events titleView ********************//
-(void)setUpUpcomingTitleView
{
    //Add upcomingTitleView
    UIView *upcomingTitleView = [[UIView alloc] init];
    self.upcomingTitleView = upcomingTitleView;
    upcomingTitleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0];
    upcomingTitleView.frame = CGRectMake(0, 200 , self.view.gf_width, 35);
    [self.scrollView addSubview:upcomingTitleView];
    
    //Add subview:titleLabel
    UILabel *nearbyTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 25)];
    nearbyTitle.text = ZBLocalized(@"Upcoming Events", nil) ;
    [nearbyTitle setFont:[UIFont boldSystemFontOfSize:16]];
    [upcomingTitleView addSubview:nearbyTitle];
    
    //Add subview:nearbyIconView
    UIImageView *nearbyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 25, 25)];
    nearbyIcon.image = [UIImage imageNamed:@"ic_upcoming_event"];
    nearbyIcon.contentMode = UIViewContentModeScaleAspectFit;
    [upcomingTitleView addSubview:nearbyIcon];
    
    //Add subview:seeAllButton
    UIButton *seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeAllButton setTitle:ZBLocalized(@"See All >", nil)  forState:UIControlStateNormal];
    [seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seeAllButton addTarget:self action:@selector(seeAllUpcomingClicked) forControlEvents:UIControlEventTouchUpInside];
    seeAllButton.frame = CGRectMake(self.view.gf_width - 100, 0, 90, 35);
    NSLog(@"self.view.gf_width is %f", self.view.gf_width);

    seeAllButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [upcomingTitleView addSubview:seeAllButton];
}

- (void)setUpCreateButton {
    UIButton *createButton = [[UIButton alloc] init];
    self.createButton = createButton;
    //createButton.backgroundColor = [UIColor greenColor];
    createButton.frame = CGRectMake(self.view.gf_width - 80, self.view.gf_height - 200 , 60, 60);
    [createButton setImage:[UIImage imageNamed:@"ic_create_event_plus_o_shadow.png"] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:createButton aboveSubview:_scrollView];
    
}

- (void)createButtonClicked {
    NSLog(@"create button clicked");
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([CreateEventViewController class]) bundle:nil];
    
    CreateEventViewController *createEventVC = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:createEventVC animated:YES];
}

- (void)seeAllNearbyClicked {
    NSLog(@"SeeAllNearby button clicked");
    MapNearbyEventsViewController *mapVC = [[MapNearbyEventsViewController alloc] init];
    [self.navigationController pushViewController:mapVC animated:YES];
    
}

- (void)seeAllUpcomingClicked {
    NSLog(@"SeeAllUpcoming button clicked");
    GFSeeAllEventTableViewController *eventListVC = [[GFSeeAllEventTableViewController alloc] init];
    [self.navigationController pushViewController:eventListVC animated:YES];

}



#pragma mark - 设置导航条
-(void)setUpNavBar
{
    //左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_logo"] WithHighlighted:[UIImage imageNamed:@"ic_logo"] Target:self action:@selector(logo)];
    
    //右边
    UIBarButtonItem *rightItem =  [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-filter"] WithHighlighted:[UIImage imageNamed:@"ic_fa-filter"] Target:self action:@selector(filterButton)];
    //add search bar
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(45, 5, GFScreenWidth - 80, 44)];
    self.searchBar = searchBar;
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    searchBar.placeholder = ZBLocalized(@"Event name, interest, restaurant", nil) ;
    self.navigationItem.titleView = searchBar;
 
    //[self searchBarShouldBeginEditing:searchBar];
    //[self.navigationController.navigationBar addSubview:searchBar1];

    UIButton *searchBarButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, GFScreenWidth - 50, 30)];
    [searchBarButton addTarget:self action:@selector(searchBarClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:searchBarButton];

    self.navigationItem.rightBarButtonItem = rightItem;
    
    //[self.searchBar.heightAnchor constraintEqualToConstant:44].active = YES;
    //[self.searchBar.widthAnchor constraintEqualToConstant:GFScreenWidth - 250].active = YES;
    
}


- (void)logo {
    NSLog(@"Logo button clicked");
    SearchPageViewController *searchVC = [[SearchPageViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)filterButton{
    NSLog(@"filter button clicked");
    FilterTableViewController *filterVC = [[FilterTableViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
    

}

/*
- (void)searBarClicked {
    SearchPageViewController *searchVC = [[SearchPageViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
 */

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    SearchPageViewController *searchVC = [[SearchPageViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return YES;
}

/*
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end