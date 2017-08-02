//
//  MyZuzuViewController.m
//  GFBS
//
//  Created by Alice Jin on 13/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyZuzuViewController.h"
#import "ProgressView.h"

#import "GFWebViewController.h"
#import "GFSettingViewController.h"
#import "BadgesCollectionViewController.h"
#import "NotificationViewController.h"
#import "LeaderboardViewController.h"

#import "EventListTableViewController.h"
#import "RestaurantViewController.h" //should be favourite restaurant

#import "GFSquareItem.h"
#import "GFSquareCell.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import "UIBarButtonItem+Badge.h"

static NSString *const ID = @"ID";
static NSInteger const cols = 3;
static CGFloat  const margin = 0;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols

@interface MyZuzuViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet ProgressView *SocialExpView;
@property (weak, nonatomic) IBOutlet ProgressView *OrganizingExpView;
@property (weak, nonatomic) IBOutlet UIView *badgesView;
@property (weak, nonatomic) IBOutlet UIView *functionsView;
@property (weak, nonatomic) IBOutlet UIButton *leaderboardButton;
- (IBAction)leaderboardButtonClicked:(id)sender;

/*所有button内容*/
@property (strong , nonatomic)NSMutableArray<GFSquareItem *> *buttonItems;


/**
 collectionView
 */
@property (weak ,nonatomic) UICollectionView *functionsCollectionView;


@end

@implementation MyZuzuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpNavBar];
    [self setUpExp];
    [self setUpCollectionItemsData];
    [self setUpFunctionsCollectionView];
    
    [self setUpBadgesView];
    // Do any additional setup after loading the view from its nib.
}

-(void) setUpExp {
    [self.SocialExpView setGradual:YES];
    _SocialExpView.progress = 0.20;
    
    [self.OrganizingExpView setGradual:YES];
    _OrganizingExpView.progress = 0.70;
}

#pragma mark - 设置底部视图
-(void)setUpFunctionsCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置尺寸
    layout.itemSize = CGSizeMake(itemHW, itemHW);
    NSLog(@"itemHW %f", itemHW);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    UICollectionView *functionsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.functionsView.gf_width, itemHW * 2) collectionViewLayout:layout];
    self.functionsCollectionView = functionsCollectionView;
    self.functionsCollectionView.backgroundColor = [UIColor whiteColor];

    [self.functionsView addSubview:functionsCollectionView];
    //关闭滚动
    functionsCollectionView.scrollEnabled = NO;
    
    //设置数据源和代理
    functionsCollectionView.dataSource = self;
    functionsCollectionView.delegate = self;
    
    //注册
    [functionsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GFSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
}

#pragma mark - Setup UICollectionView Data
-(void)setUpCollectionItemsData {
    NSArray *buttonIcons = [NSArray arrayWithObjects:@"my-event", @"f-restaurant-icon", @"my-review", @"invite-friends", @"my-friends",@"", nil];
    NSArray *buttonTitles = [NSArray arrayWithObjects:@"My Events", @"Favourite Restaurants", @"My Reviews", @"Invite Friends", @"My Friends",@"", nil];
    //NSMutableArray<GFSquareItem *> *buttonItems =[[NSMutableArray<GFSquareItem *> alloc]init];
    //self.buttonItems = buttonItems;
    self.buttonItems = [[NSMutableArray<GFSquareItem *> alloc]init];
    for (int i = 0; i < buttonIcons.count; i++) {
        GFSquareItem *squareItem = [[GFSquareItem alloc]init];
        squareItem.icon = buttonIcons[i];
        squareItem.name = buttonTitles[i];
        [_buttonItems addObject:squareItem];
    }
    NSLog(@"buttonItems:%@", _buttonItems);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"_buttonItems.count = %ld", _buttonItems.count);
    return _buttonItems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSLog(@"indexPath.item%ld", indexPath.item);
    NSLog(@"buttonItems indexPath.item%@", self.buttonItems[indexPath.item].name);
    
    cell.item = self.buttonItems[indexPath.item];
    
    return cell;
}

- (void)setUpNavBar
{
    UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    fixedButton.width = 20;
    UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    notificationBtn.badgeValue = @"2"; // I need the number of not checked through API
    //notificationBtn.badgePadding = 0;
    //notificationBtn.badgeMinSize = 0; //I changed their default value in category
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, fixedButton, notificationBtn, nil]];
    
    //Title
    self.navigationItem.title = @"My Zuzu";
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareItem *item = _buttonItems[indexPath.item];
    
    if ([item.name isEqualToString: @"My Events"]) {
        EventListTableViewController *eventVC = [[EventListTableViewController alloc] init];
        [self.navigationController pushViewController:eventVC animated:YES];
    } else if ([item.name isEqualToString: @"Favourite Restaurants"]) {
        RestaurantViewController *restaurantVC = [[RestaurantViewController alloc] init];
        [self.navigationController pushViewController:restaurantVC animated:YES];
    }
    //判断
    if (![item.url containsString:@"http"]) return;
    
    NSURL *url = [NSURL URLWithString:item.url];
    GFWebViewController *webVc = [[GFWebViewController alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
    
    //给Url赋值
    webVc.url = url;
    
}

#pragma mark - BadgesView
-(void)setUpBadgesView {
    NSMutableArray *badges = [[NSMutableArray alloc]initWithObjects:@"ic_pen",@"ic_trophy", nil];
    [badges addObject:@"plus_badges.png"];
    for (int i = 0; i < badges.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i * 50, 5, 45, 45)];
        [button setImage:[UIImage imageNamed:badges[i]] forState:UIControlStateNormal];
        if (i == badges.count - 1) {
            [button addTarget:self action:@selector(addBadgesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.badgesView addSubview:button];
    }
    
}

- (void)addBadgesButtonClicked {
    BadgesCollectionViewController *BadgesCollectionVC = [[BadgesCollectionViewController alloc] init];
    BadgesCollectionVC.view.frame = CGRectMake(0, 200, self.view.gf_width, self.view.gf_height - 200);
    BadgesCollectionVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:BadgesCollectionVC animated:YES];
}

- (void)settingClicked
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GFSettingViewController class]) bundle:nil];
    GFSettingViewController *settingVc = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)notificationClicked
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)leaderboardButtonClicked:(id)sender {
    LeaderboardViewController *leaderboardVC = [[LeaderboardViewController alloc] init];
    [self.navigationController pushViewController:leaderboardVC animated:YES];
}
@end
