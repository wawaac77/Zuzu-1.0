//
//  LeaderboardHomeTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 13/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "LeaderboardHomeTableViewController.h"
#import "ZZLeaderboardCell.h"
#import "ZZLeaderboardModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const ID = @"ID";

@interface LeaderboardHomeTableViewController ()

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray<ZZLeaderboardModel *> *rankList;


@end

@implementation LeaderboardHomeTableViewController

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
    
    [self setupRefresh];
    [self setUpTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNeweData)];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadNeweData {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSDictionary *inData = [[NSDictionary alloc] init];
    inData = @{@"action" : @"getLeaderboardAttendees", @"token" : userToken};
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        NSMutableArray *rankArray = responseObject[@"data"];
        self.rankList = [ZZLeaderboardModel mj_objectArrayWithKeyValuesArray:rankArray];
        NSLog(@"rankList %@", self.rankList);
        [self saveUIImages];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}

- (void)saveUIImages {
    for (int i = 0; i < _rankList.count; i++) {
        NSURL *URL = [NSURL URLWithString:_rankList[i].leaderboardMember.userProfileImage.imageUrl];
        NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
        UIImage *image = [[UIImage alloc]initWithData:data];
        _rankList[i].leaderboardMember.userProfileImage_UIImage = image;
    }
}

-(void)setUpTable
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZZLeaderboardCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rankList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZLeaderboardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    ZZLeaderboardModel *thisRank = self.rankList[indexPath.row];
    cell.user = thisRank;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
