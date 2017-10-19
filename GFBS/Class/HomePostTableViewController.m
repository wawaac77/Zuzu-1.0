//
//  HomePostTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 17/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePostTableViewController.h"
#import "GFEventsCell.h"
#import "ZZContentModel.h"
//#import "ZZCommentsViewController.h"
#import "GFCommentViewController.h"
#import "RestaurantDetailViewController.h"
#import "UserProfileCheckinViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const ID = @"ID";
//@class ZZContentModel;

@interface HomePostTableViewController ()

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<ZZContentModel *> *contents;

/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<ZZContentModel *> *selectedContents;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong, nonatomic) NSIndexPath *recordIndexPath;

@end


@implementation HomePostTableViewController

//@synthesize receivingType;
//@synthesize userID;

#pragma mark - 消除警告
-(MyPublishContentType)type
{
    return 0;
}

/*
#pragma mark - 消除警告
-(NSString *)restaurantID
{
    return @"";
}
 */

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
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self setUpTable];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    //[self.tableView setFrame:self.view.bounds];
    //NSLog(@"table width %f",self.view.gf_width);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 400;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFEventsCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    //[self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZContentModel *content = _contents[indexPath.row];
    NSLog(@"contentCellHeightInPostVC %f", content.cellHeight);
    return content.cellHeight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventsCell *cell = (GFEventsCell *)[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    //**** set up restaurant button **//
    UIButton *restaurantButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 16, 264, 30)];
    restaurantButton.backgroundColor = [UIColor clearColor];
    [restaurantButton addTarget:self action:@selector(restaurantButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    restaurantButton.tag = indexPath.row;
    [cell.contentView addSubview:restaurantButton];
    
    UIButton *profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 4, 50, 50)];
    profileImageButton.backgroundColor = [UIColor clearColor];
    [profileImageButton addTarget:self action:@selector(profileImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    profileImageButton.tag = indexPath.row;
    [cell.contentView addSubview:profileImageButton];

    
    ZZContentModel *thisContent = self.contents[indexPath.row];
    if (_contents[indexPath.row].listImage_UIImage == nil) {
        NSURL *URL = [NSURL URLWithString:_contents[indexPath.row].listImage.imageUrl];
        NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
        UIImage *image = [[UIImage alloc]initWithData:data];
        _contents[indexPath.row].listImage_UIImage = image;
    }
    cell.event = thisContent;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *recordIndexPath = [[NSIndexPath alloc] init];
    self.recordIndexPath = recordIndexPath;
    recordIndexPath = indexPath;
    
    GFCommentViewController *commentsVC = [[GFCommentViewController alloc] init];
    commentsVC.topic = [_contents objectAtIndex:indexPath.row];
    commentsVC.view.frame = CGRectMake(0, ZZNewNavH, self.view.gf_width, self.view.gf_height - ZZNewNavH - GFTabBarH);
    commentsVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:commentsVC animated:YES];
   
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}


- (void) restaurantButtonClicked: (UIButton *) sender {
    ZZContentModel *thisContent = _contents[sender.tag];
    RestaurantDetailViewController *restaurantVC = [[RestaurantDetailViewController alloc] init];
    restaurantVC.thisRestaurant = thisContent.listEventRestaurant;
    [self.navigationController pushViewController:restaurantVC animated:YES];
}

- (void) profileImageButtonClicked: (UIButton *) sender {
    ZZContentModel *thisContent = _contents[sender.tag];
    UserProfileCheckinViewController *userVC = [[UserProfileCheckinViewController alloc] init];
    userVC.myProfile = thisContent.listPublishUser;
    [self.navigationController pushViewController:userVC animated:YES];
}


- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [self.tableView.mj_header beginRefreshing];
    
    //self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/*************************Here is reloading data place************************/
#pragma mark - 加载新数据
-(void)loadNewEvents
{
    NSLog(@"loadNewEvents工作了");
    //NSLog(@"receivingType %@",receivingType);
    //NSLog(@"userID in HomePostVC %@", userID);

    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSLog(@"user token %@", userToken);
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = [[NSDictionary alloc] init];
    if (self.type == 0) {
        inData = @{@"action" : @"getAllCheckinList", @"token" : userToken, @"lang" : userLang};
    } else if (self.type == 1) {
        inData = @{@"action" : @"getFriendCheckinList", @"token" : userToken, @"lang" : userLang};
    } else if (self.type == 2) {
        inData = @{@"action" : @"getMyCheckinList", @"token" : userToken, @"lang" : userLang};
    } else if (self.type == 4) {
        NSDictionary *inSubData = @{@"restaurantId" : self.restaurantID};
        inData = @{@"action" : @"getRestaurantCheckinList", @"token" : userToken, @"data":inSubData, @"lang" : userLang};
    } else if (self.type == 5) {
        inData = @{@"action" : @"getAllCheckinList", @"token" : userToken, @"lang" : userLang};
    }
    /*
    else if ([receivingType isEqualToString:@"User checkin"]) {
        inData = @{@"action" : @"getAllCheckinList", @"token" : userToken};
        NSLog(@"getUserCheckinListworks");
    }
     */
    
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"publish content parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        self.contents = [ZZContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //[self saveUIImages];
        
        self.selectedContents = [[NSMutableArray alloc] init];
        if (self.type == 5) {
            NSLog(@"select process starts working");
            for (int i = 0; i < _contents.count ; i++) {
                if ([_contents[i].listPublishUser.userID isEqualToString:self.userID]) {
                    [_selectedContents addObject:_contents[i]];
                }
            }
            
            [_contents removeAllObjects];
            [_contents addObjectsFromArray:_selectedContents];
        }
        
        [self passValueMethod];
        
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
    
}

- (void)passValueMethod {
    NSInteger *num = self.contents.count;
    NSLog(@"passValueMethod %zd", num);
    [_delegate passValue:num];
}

- (void)saveUIImages {
    for (int i = 0; i < _contents.count; i++) {
        NSURL *URL = [NSURL URLWithString:_contents[i].listImage.imageUrl];
        NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
        UIImage *image = [[UIImage alloc]initWithData:data];
        _contents[i].listImage_UIImage = image;
    }
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


//************************* update cell which is hearted in commentVC ******************************//
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"indexPathForSlectedRow in viewWillAppear %@", [self.tableView indexPathForSelectedRow]);
    NSLog(@"indexPathForSlectedRow in viewWillAppear.row %ld", [self.tableView indexPathForSelectedRow].row);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
