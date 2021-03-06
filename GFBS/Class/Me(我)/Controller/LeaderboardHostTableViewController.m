//
//  LeaderboardHostTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 10/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "LeaderboardHostTableViewController.h"

#import "ZZLeaderboardModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const ID = @"ID";

@interface LeaderboardHostTableViewController ()

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray<ZZLeaderboardModel *> *rankList;

@end

@implementation LeaderboardHostTableViewController

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
    //self.view.frame = [UIScreen mainScreen].bounds;
    [self setupRefresh];
    [self setUpTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"leaderboard attendees moving to or from parent view controller");
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"leaderboard host did move to or from parent view controller");
    self.view.backgroundColor = [UIColor blueColor];
}

-(void)setUpTable
{
    
    [self.tableView reloadData];
    
}


- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNeweData)];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadNeweData {

    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    NSDictionary *inData = [[NSDictionary alloc] init];
    inData = @{@"action" : @"getLeaderboardHost", @"token" : userToken, @"lang" : userLang};
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        NSMutableArray *rankArray = data[@"data"];
        self.rankList = [ZZLeaderboardModel mj_objectArrayWithKeyValuesArray:rankArray];
       
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
    /*
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSMutableArray *rankArray = responseObject[@"data"];
        self.rankList = [ZZLeaderboardModel mj_objectArrayWithKeyValuesArray:rankArray];
        NSLog(@"rankList %@", self.rankList);
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _rankList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    ZZLeaderboardModel *thisRank = [_rankList objectAtIndex:indexPath.row];
    
    /****name and level****/
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSString *str0 = [NSString stringWithFormat:@"%ld. %@  ", indexPath.row + 1, thisRank.leaderboardMember.userUserName];
    NSDictionary *dicAttr0 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    NSAttributedString *attr0 = [[NSAttributedString alloc] initWithString:str0 attributes:dicAttr0];
    [attributedString appendAttributedString:attr0];
    
    NSString *str1 = [NSString stringWithFormat:@"Lv. %@", thisRank.leaderboardLevel];
    NSDictionary *dicAttr1 = @{NSFontAttributeName : [UIFont italicSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor grayColor]};
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:str1 attributes:dicAttr1];
    [attributedString appendAttributedString:attr1];
    
    cell.textLabel.attributedText = attributedString;
    
    /******level up or down********/
    NSMutableAttributedString *attributedString_1 = [[NSMutableAttributedString alloc] init];
    
    NSString *str0_1 = [NSString stringWithFormat:@"Ratings %@ / ", thisRank.leaderboardRating];
    NSDictionary *dicAttr0_1 = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]};
    NSAttributedString *attr0_1 = [[NSAttributedString alloc] initWithString:str0_1 attributes:dicAttr0_1];
    [attributedString_1 appendAttributedString:attr0_1];
    
    //////////later part
    NSString *str1_1 = [[NSString alloc] init];
    NSDictionary *dicAttr1_1 = [[NSDictionary alloc] init];
    NSNumber *rank = thisRank.leaderboardRankChange;
    int rankChange = [rank intValue];
    if (rankChange == 0) {
        str1_1 = @"0";
        dicAttr1_1 = @{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor grayColor]};
    } else if (rankChange > 0) {
        str1_1 = [NSString stringWithFormat:@"↑%d", rankChange];
        dicAttr1_1 = @{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor greenColor]};
    } else {
        str1_1 = [NSString stringWithFormat:@"↓%d", rankChange];
        dicAttr1_1 = @{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor redColor]};
    }
    NSAttributedString *attr1_1 = [[NSAttributedString alloc] initWithString:str1_1 attributes:dicAttr1_1];
    [attributedString_1 appendAttributedString:attr1_1];

    cell.detailTextLabel.attributedText = attributedString_1;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld row is selected",indexPath.row);
}

@end
