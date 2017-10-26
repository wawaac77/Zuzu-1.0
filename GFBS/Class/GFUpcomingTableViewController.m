//
//  GFUpcomingTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFUpcomingTableViewController.h"
#import "GFCommentViewController.h"

#import "GFEventsCell.h"
//#import "GFEvent.h"
#import "EventInList.h"
//#import "GFTopic.h"
#import "GFEventDetailViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "ZBLocalized.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString *const eventID = @"event";

//@class EventInList;

@interface GFUpcomingTableViewController ()


/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<EventInList *> *upcomingEvents;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation GFUpcomingTableViewController
/*
#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.frame = [UIScreen mainScreen].bounds;
    self.view.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - GFTabBarH - 200);
    NSLog(@"main screen width %f",[UIScreen mainScreen].bounds.size.width);
    [self setUpNavBar];
    [self setUpTable];
    [self setupRefresh];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"[FBSDKAccessToken currentAccessToken] %@", [FBSDKAccessToken currentAccessToken]);
    }
    //[self setUpNote];
    
}

-(void)willMoveToParentViewController:(UIViewController *)parent {
    self.view.backgroundColor = [UIColor lightGrayColor];
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    self.view.frame = CGRectMake(0, 200, self.view.gf_width, self.view.gf_height - GFTabBarH);
    //self.view.frame = CGRectMake(0, 235, 300, 200);

}

#pragma mark - 设置导航条

-(void)setUpNavBar
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
    self.navigationItem.title = ZBLocalized(@"Upcoming Events", nil);
    
}

-(void)setUpTable
{
    self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    [self.tableView setFrame:self.view.bounds];
    NSLog(@"table width %f",self.view.gf_width);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewStylePlain;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFEventsCell class]) bundle:nil] forCellReuseIdentifier:eventID];
    
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.upcomingEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:eventID forIndexPath:indexPath];
    
    NSLog(@"indexPath.row%ld", indexPath.row);
    EventInList *thisEvent = self.upcomingEvents[indexPath.row];
    NSLog(@"this event.listEventID%@", thisEvent.listEventID);
    cell.event = thisEvent; //topic 数据类型完全与event的数据类型一样，这样才能直接赋值
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventDetailViewController *eventDetailVC = [[GFEventDetailViewController alloc] init];
    eventDetailVC.eventHere = _upcomingEvents[indexPath.row];
    eventDetailVC.view.frame = CGRectMake(0, 200, self.view.gf_width, self.view.gf_height - 200);
    
    NSLog(@" _upcomingEvents[indexPath.row] %@", _upcomingEvents[indexPath.row]);
    //eventDetailVC.eventHere = self.topics[indexPath.row];
    [self.navigationController pushViewController:eventDetailVC animated:YES];
}


- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/*******Here is reloading data place*****/
#pragma mark - 加载新数据
-(void)loadNewEvents
{
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = @{
                             @"action" : @"getUpcomingEventList",
                             @"data" : geoPointDic,
                             @"lang" :userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"upcoming events parameters %@", parameters);
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.upcomingEvents = [EventInList mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];

    /*
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        NSArray *eventsArray = responseObject[@"data"];
        
        
        self.upcomingEvents = [EventInList mj_objectArrayWithKeyValuesArray:eventsArray];
       
        //NSLog(@"upcomingevents %@", self.upcomingEvents);
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
       
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    */
    
}

#pragma mark - 加载更多数据
-(void)loadMoreData
{
    
NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    NSDictionary *inData = @{
                             @"action" : @"getUpcomingEventList",
                             @"data" : geoPointDic};
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        NSMutableArray<EventInList *> *moreEvents = [EventInList mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [self.upcomingEvents addObjectsFromArray:moreEvents];
        [self.tableView reloadData];
        //[_ibMenu reloadData];
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
    /*

    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        //存储这一页的maxtime
        //self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //[responseObject writeToFile:@"/Users/apple/Desktop/ceshi.plist" atomically:YES];
        
        //字典转模型
        NSLog(@"Request is successful成功了");
        NSMutableArray<EventInList *> *moreEvents = [EventInList mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.upcomingEvents addObjectsFromArray:moreEvents];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request 失败");
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
    */
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清理缓存 放在这个个方法中调用频率过快
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
