//
//  GFCommentViewController.m
//  GFBS
//
//  Created by apple on 2016/11/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "GFCommentViewController.h"

#import "GFCommentHeaderFooterView.h"
#import "GFCommentCell.h"
//#import "GFTopicCell.h"
#import "ZZGFEventsCell.h"
//#import "GFTopic.h"
#import "ZZContentModel.h"
//#import "GFComment.h"
#import "ZZComment.h"

#import "GFRefreshHeader.h"
#import "GFRefreshFooter.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>


static NSString *const commentID = @"commnet";
static NSString *const headID = @"head";
@interface GFCommentViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sendButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

/*请求管理者*/
@property (weak ,nonatomic) GFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray<ZZComment *> *comments;

/** 最热评论数据 */
//@property (nonatomic, strong) NSArray<ZZComment *> *hotestComments;

/** 最新评论数据 */
//@property (nonatomic, strong) NSMutableArray<ZZComment *> *latestComments;

/** 最热评论 */
//@property (nonatomic, strong) ZZComment *savedTopCmt;

@end

@implementation GFCommentViewController

-(MyPublishContentType)type
{
    return CommentContent;
}

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
    
    [self setUpTableView];

    [self setUpRefresh];
    
    [self setUpHeadView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavBar];
}

- (void)setUpNavBar {
    
    [self preferredStatusBarStyle];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setUpHeadView
{
    // 模型数据处理：把最热评论影藏
    //self.savedTopCmt = self.topic.top_cmt;
    //self.topic.top_cmt = nil;
    //self.topic.cellHeight = 0;
    
    //注册
    [self.tableView registerClass:[GFCommentHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headID];
    //嵌套一个View
    UIView *head = [[UIView alloc] init];
    head.backgroundColor = [UIColor whiteColor];
    ZZGFEventsCell *topicCell = [ZZGFEventsCell gf_viewFromXib];
    
    topicCell.backgroundColor = [UIColor whiteColor];
    //self.topic.type = CommentContent;
    topicCell.event = self.topic;
    topicCell.type = @"comment";
    topicCell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topic.cellHeightForComment);
    
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * GFMargin;
    CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
    CGSize textSize = [self.topic.listMessage boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    CGFloat textHeight = textSize.height;
    UILabel *fullTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFMargin, 337, GFScreenWidth - 2 * GFMargin, textHeight)];
    fullTextLabel.numberOfLines = 0;
    fullTextLabel.font = [UIFont systemFontOfSize:GFTextSize];
    fullTextLabel.text = self.topic.listMessage;
    fullTextLabel.backgroundColor = [UIColor whiteColor];

    //topicCell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    NSLog(@"self.topic.cellHeight %f", self.topic.cellHeight);
    
    // 设置header的高度
    //head.gf_height = topicCell.gf_height + GFMargin * 2;
    //head.gf_height = 230;
    head.gf_height = topicCell.gf_height + GFMargin;
    NSLog(@"topic cell height %f", topicCell.gf_height);
    NSLog(@"head height = %f", head.gf_height);
    [head addSubview:topicCell];
    [head addSubview:fullTextLabel]; //cover the cell label
    self.tableView.tableHeaderView = head;

    //头部View高度
    //self.tableView.sectionHeaderHeight = [UIFont systemFontOfSize:13].lineHeight + GFMargin;
    //self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionHeaderHeight = [UIFont systemFontOfSize:13].lineHeight;
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //self.tableView.contentInset = UIEdgeInsetsMake(GFNavMaxY, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    NSDictionary *checkinId = @{@"checkinId" : _topic.listEventID};
    NSDictionary *inData = @{@"action" : @"getCheckinCommentList" , @"token" : userToken, @"data" : checkinId};
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
        self.comments = [ZZComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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

/*
-(void)loadMoreComment
{
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"dataList";
    parameters[@"c"] = @"comment";
    parameters[@"data_id"] = self.topic.ID;
    parameters[@"lastcid"] = self.latestComments.lastObject.ID;
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:GFBSURL parameters:parameters progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            // 结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        // 字典数组转模型数组
        NSArray *moreComment = [GFComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [weakSelf.latestComments addObjectsFromArray:moreComment];
        
        [weakSelf.tableView reloadData];
        
        NSInteger total = [responseObject[@"total"] integerValue];
        
        if (weakSelf.latestComments.count ==  total) {
            
            //结束刷新
            weakSelf.tableView.mj_footer.hidden = YES;
            
        }else
        {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
*/

-(void)setUpTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFCommentCell class]) bundle:nil] forCellReuseIdentifier:commentID];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GFBgColor;

    
    //cell的高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

-(void)setUpBase
{
    self.navigationItem.title = @"Comments";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

#pragma mark - 监听
-(void)KeyboardWillChangeFrame:(NSNotification *)not
{
    //修改约束
    CGFloat kbY = [not.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y;
    CGFloat screenH = GFScreenHeight;
    
    self.bottomMargin.constant = screenH - kbY;
    
    CGFloat duration = [not.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:nil];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    //最热评论  这样返回到之前界面会出现最热评论
    //self.topic.top_cmt = self.savedTopCmt;
    //self.topic.cellHeight = 0;
}

/**
 当用户开始拖拽就会调用
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - tableview代理和数据源

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GFCommentHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    //第0组 并且 有最热评论数
    //if (section == 0 && self.hotestComments.count) {
    //    headView.textLabel.text = @"Comments";
    ///}else{
    //headView.textLabel.text = @"Comments";
    //}
    headView.textLabel.text = @"Comments";
    return headView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //第0组 并且 有最热评论数
    /*
    if (section == 0 && self.hotestComments.count) {
       return self.hotestComments.count;
    }
     */
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentID forIndexPath:indexPath];
    /*
    if (indexPath.section == 0 && self.hotestComments.count) {
        cell.comment = _hotestComments[indexPath.row];
    }else{
        cell.comment = _latestComments[indexPath.row];
    }
     */
    cell.comment = _comments[indexPath.row];
    
    return cell;
}


//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    //第0组 并且 有最热评论数
//    if (section == 0 && self.hotestComments.count) {
//        return @"最热评论";
//    }
//    return @"最新评论";
//
//}

- (IBAction)sendButtonClicked:(id)sender {
    
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSDictionary *inSubData = @{@"checkinId" : _topic.listEventID, @"message" :_commentTextField.text};
    NSDictionary *inData = @{@"action" : @"commentCheckin" , @"token" : userToken, @"data" : inSubData};
    NSDictionary *parameters = @{@"data" : inData};
    
    // 发送请求
    [self.manager POST:GetURL parameters:parameters progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"Comment success!");
        self.commentTextField.text = nil;
        [self loadNewComment];
        //[self setUpRefresh];
        
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });

        
    }];
    

    
}
@end
