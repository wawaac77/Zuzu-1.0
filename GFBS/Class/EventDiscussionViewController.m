//
//  EventDiscussionViewController.m
//  GFBS
//
//  Created by Alice Jin on 2/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "EventDiscussionViewController.h"
#import "GFCommentCell.h"
#import "ZZContentModel.h"
#import "ZZComment.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

static NSString *const commentID = @"commnet";

@interface EventDiscussionViewController ()

/*请求管理者*/
@property (weak ,nonatomic) GFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray<ZZContentModel *> *comments;

@end

@implementation EventDiscussionViewController

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComment)];
    [self.tableView.mj_header beginRefreshing];
    
    //self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComment)];
}

#pragma mark - 加载网络数据
-(void)loadNewComment
{
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSDictionary *checkinId = @{@"event" : _eventID};
    NSDictionary *inData = @{@"action" : @"getEventDiscussion" , @"token" : userToken, @"data" : checkinId};
    NSDictionary *parameters = @{@"data" : inData};
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager POST:GetURL parameters:parameters progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 没有任何评论数据
        //if (![responseObject isKindOfClass:[NSDictionary class]]) {
        // 结束刷新
        //  [weakSelf.tableView.mj_header endRefreshing];
        //return;
        //}
        
        // 字典数组转模型数组
        //weakSelf.latestComments = [GFComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //weakSelf.hotestComments = [GFComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.comments = [ZZContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 刷新表格
        [self.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        /*
         NSInteger total = [responseObject[@"total"] intValue];
         if (weakSelf.latestComments.count == total) { // 全部加载完毕
         // 隐藏
         weakSelf.tableView.mj_footer.hidden = YES;
         }
         */
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
    
}

-(void)setUpTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFCommentCell class]) bundle:nil] forCellReuseIdentifier:commentID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //cell的高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentID forIndexPath:indexPath];
    
    cell.comment.commentCheckInContent = _comments[indexPath.row];
    
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
