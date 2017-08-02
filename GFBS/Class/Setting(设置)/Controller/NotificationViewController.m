//
//  NotificationViewController.m
//  GFBS
//
//  Created by Alice Jin on 4/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationViewController.h"
#import "NotificationItem.h"
#import "ZZFriendRequestModel.h"

#import "NotificationCell.h"
#import "NotificationButtonsCell.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const notificationID = @"myNotification";
static NSString *const friendRequestID = @"friendRequest";

@interface NotificationViewController ()

@property (assign , nonatomic)NSInteger *notificationNum;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation NotificationViewController

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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadFriendsRequest];
    [self setUpTable];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*******Here is reloading data place*****/
#pragma mark - 加载新数据
-(void)loadFriendsRequest
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inData = @{@"action" : @"getFriendRequestList", @"token" : userToken};
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        self.myFriendsRequests = [ZZFriendRequestModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self loadNewData];
        
        //[self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

#pragma mark - 加载新数据
-(void)loadNewData
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inData = @{@"action" : @"getNotificationList", @"token" : userToken};
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        self.myNotifications = [NotificationItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self passValueMethod];
        [self.tableView reloadData];
        
        //[self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

- (void) setUpData {
    NSLog(@"notification array %@", _myNotifications);
}

-(void)setUpTable
{
    
    //self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //self.tableView.backgroundColor = GFBgColor;
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NotificationCell class]) bundle:nil] forCellReuseIdentifier:notificationID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NotificationButtonsCell class]) bundle:nil] forCellReuseIdentifier:friendRequestID];
    
    [self.tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //GFTopic *topic = _topics[indexPath.row];
    if (indexPath.section == 0) {
        return 70.0f;
    } else {
        return 60.0f;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _myFriendsRequests.count;
    } else {
        return _myNotifications.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:friendRequestID];
    if (indexPath.section == 0) {
        NotificationButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:friendRequestID];
        ZZFriendRequestModel *thisFriendRequest = self.myFriendsRequests[indexPath.row];
        cell.request = thisFriendRequest;
        return cell;
        
    } else if (indexPath.section == 1) {
        NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationID];
        NotificationItem *thisNotification = self.myNotifications[indexPath.row];
        cell.notification = thisNotification;
        NSLog(@"cell.notification.isRead%@",cell.notification.isRead);
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.myFriendsRequests[indexPath.row].isRead = [NSNumber numberWithBool:true];
        //[self markNotificatinIsRead:_myFriendsRequests[indexPath.row].friendshipID];
    }
    else if (indexPath.section == 1) {
       self.myNotifications[indexPath.row].isRead = [NSNumber numberWithBool:true];
        [self markNotificatinIsRead:_myNotifications[indexPath.row]._id];
    }
}

- (void)markNotificatinIsRead: (NSString *) notificationID {
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inSubData = @{@"notificationId" : notificationID};
    NSDictionary *inData = @{@"action" : @"markNotificationIsRead", @"token" : userToken, @"data" : inSubData};
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        //[self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}


- (void)passValueMethod {
    NSInteger *num = 0;
    for (int i = 0; i < self.myNotifications.count; i++) {
        if (! self.myNotifications[i].isRead) {
            num ++;
        }
    }
    for (int i = 0; i < self.myFriendsRequests.count; i++) {
        if (! self.myFriendsRequests[i].isRead) {
            num ++;
        }
    }

    self.notificationNum = num;
    NSLog(@"passValueMethod in notificationVC %zd  %zd", self.notificationNum, num);
    [_delegate passValue:self.notificationNum];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
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
