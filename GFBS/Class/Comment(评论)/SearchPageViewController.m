//
//  SearchPageViewController.m
//  GFBS
//
//  Created by Alice Jin on 3/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "SearchPageViewController.h"
#import "FilterTableViewController.h"
#import "EventSearchResultTableViewController.h"
#import "RestaurantViewController.h"
#import "ZBLocalized.h"
#import "ZZTypicalInformationModel.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>

@interface SearchPageViewController () <UISearchBarDelegate>{
    BOOL selected[2];
}

@property (strong ,nonatomic) UISearchBar *searchBar;
@property (strong ,nonatomic) UISearchBar *searchBar1;
@property (strong ,nonatomic) UIView *header;
@property (strong ,nonatomic) NSMutableArray <ZZTypicalInformationModel *> *recentSearches;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation SearchPageViewController

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
    self.recentSearches = [[NSMutableArray alloc] init];
    [self setUpNavBar];
    [self setUpTable];
    [self loadNewData];
    //[self setUpFooter];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController.navigationBar setFrame:CGRectMake(0, 0, GFScreenWidth, 90)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpNavBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    [_searchBar setImage:[UIImage imageNamed:@"ic_fa-search"] forSearchBarIcon:UISearchBarStyleDefault state:UIControlStateNormal];

    searchBar.placeholder = ZBLocalized(@"Event name, interest, restaurant", nil) ;
    self.navigationItem.titleView = searchBar;
    
    
    //**** 右边
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-filter"] WithHighlighted:[UIImage imageNamed:@"ic_fa-filter"] Target:self action:@selector(filterButtonClicked)];
    
   //**** table header
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, 55)];
    _header.backgroundColor = [UIColor blackColor];
    
    self.searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectMake(45, 5, GFScreenWidth - 80, 44)];
    [_searchBar1 setImage:[UIImage imageNamed:@"ic_fa-map-marker"] forSearchBarIcon:nil state:UIControlStateNormal];
    _searchBar1.placeholder = ZBLocalized(@"Location, Landmark, Street", nil) ;
    self.searchBar1.barTintColor = [UIColor blackColor];
    self.searchBar1.delegate = self;
    
    [_header addSubview:_searchBar1];
    
    self.tableView.tableHeaderView = _header;
    
    [self.searchBar.heightAnchor constraintEqualToConstant:44].active = YES;
    [self.searchBar1.heightAnchor constraintEqualToConstant:44].active = YES;
}

- (void)setUpFooter {
    //self.recentSearches = [[NSMutableArray alloc] initWithObjects:@"Causway Bay", @"Japanese Cuisine", @"hihi", @"happy hour", @"hahah", @"Causway Bay", @"Japanese Cuisine", @"hihi", @"happy hour", @"hahah", nil];
   
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, GFScreenHeight - GFNavMaxY - GFTabBarH - 88 - 50)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 44)];
    title.text = ZBLocalized(@"Recent Searches", nil);
    title.font = [UIFont boldSystemFontOfSize:16];
    [footer addSubview:title];
    CGFloat label_x = 10.0f;
    CGFloat label_y = 50.0f;
    CGFloat label_height = 30.0f;
    CGFloat margin = 10.0f;
    for (int i = 0; i < _recentSearches.count; i ++) {
        if ([_recentSearches[i].keyword isEqualToString:@""]) {
            continue;
        }
        
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.text = _recentSearches[i].keyword;
        
        itemLabel.numberOfLines = 1;
        itemLabel.font = [UIFont systemFontOfSize:16];
        itemLabel.textColor = [UIColor darkGrayColor];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.layer.borderWidth = 1.0f;
        itemLabel.layer.borderColor = [UIColor grayColor].CGColor;
        itemLabel.clipsToBounds = YES;
        itemLabel.layer.cornerRadius = 5.0f;
        CGFloat label_width = itemLabel.intrinsicContentSize.width + 10.0f;
        if ((label_x + label_width) <= (GFScreenWidth - 10.0f * 2)) {
            itemLabel.frame = CGRectMake(label_x, label_y, label_width, label_height);
            label_x = label_x + label_width + margin;
        } else {
            label_x = 10.0f;
            label_y = label_y + label_height + margin;
            itemLabel.frame = CGRectMake(label_x, label_y, label_width, label_height);
            label_x = label_x + label_width + margin;

        }
        [footer addSubview:itemLabel];
    }
    
    self.tableView.tableFooterView = footer;
}

- (void)setUpTable {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    selected[0] = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (cell == nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, GFScreenWidth, 1)];
        separator.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:separator];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = ZBLocalized(@"Search Events", nil);
    } else {
        cell.textLabel.text = ZBLocalized(@"Search Restaurants", nil);
    }
    
    if (selected[indexPath.row]) {
        cell.textLabel.textColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
        cell.tintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < 2; i++) {
        if (i == indexPath.row) {
            selected[i] = true;
        } else {
            selected[i] = false;
        }
    }
    [self.tableView reloadData];
}

- (void)filterButtonClicked {
    NSLog(@"filter button clicked");
    FilterTableViewController *filterVC = [[FilterTableViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchbar search %@", searchBar.text);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchbar searchbutton %@", searchBar.text);
    
    if (selected[0] == true) {
        EventSearchResultTableViewController *searchResultVC = [[EventSearchResultTableViewController alloc] init];
        searchResultVC.keywords = searchBar.text;
        [self.navigationController pushViewController:searchResultVC animated:YES];
    } else {
        RestaurantViewController *restaurantVC = [[RestaurantViewController alloc] init];
        restaurantVC.keywords = searchBar.text;
        [self.navigationController pushViewController:restaurantVC animated:YES];
    }
    
}

#pragma mark - 加载新数据
-(void)loadNewData
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inData = @{
                             @"action" : @"getRecentSearch",
                             @"token" : userToken,
                             @"lang" :userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        self.recentSearches = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self setUpFooter];
        
        //[self.tableView reloadData];
        
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

@end
