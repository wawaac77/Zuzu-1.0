//
//  GFTopicViewController.m
//  GFBS
//
//  Created by Alice Jin on 2016/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GFTopicViewController.h"
#import "GFCommentViewController.h"

#import "GFTopic.h"
#import "GFTopicCell.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const topicID = @"topic";

@interface GFTopicViewController ()
/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<GFTopic *> *topics;
/*maxtime*/
@property (strong , nonatomic)NSString *maxtime;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;


@end

@implementation GFTopicViewController
#pragma mark - 消除警告
-(GFTopicType)type
{
    return 0;
}

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTable];
    
    [self setupRefresh];
    
    [self setUpNote];

}

-(void)setUpNote
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonRepeatClick) name:GFTabBarButtonDidRepeatShowClickNotificationCenter object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonRepeatClick) name:GFTitleButtonDidRepeatShowClickNotificationCenter object:nil];
}

#pragma mark - 监听
/**
 *  监听TabBar按钮的重复点击
 */
- (void)tabBarButtonRepeatClick
{
    // 如果当前控制器的view不在window上，就直接返回,否则这个方法调用五次
    if (self.view.window == nil) return;
    
    // 如果当前控制器的view跟window没有重叠，就直接返回
    if (![self.view isShowingOnKeyWindow]) return;
    
    // 进行下拉刷新
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  监听标题按钮的重复点击
 */
- (void)titleButtonRepeatClick
{
    [self tabBarButtonRepeatClick];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(GFTitleViewH + GFNavMaxY, 0, GFTabBarH, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = GFBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFTopicCell class]) bundle:nil] forCellReuseIdentifier:topicID];
    
}

- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
}
#pragma mark - 加载新数据
-(void)loadNewTopics
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    
    NSLog(@"%@", parameters);
    
    //发送请求
    [_manager GET:GFBSURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        //存取maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //字典转模型 //没有这句话显示不出数据
        self.topics = [GFTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        NSLog(@"%@", self.topics);
        NSLog(@"responseObject[list]%@", responseObject[@"list"]);
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

#pragma mark - 加载更多数据
-(void)loadMoreData
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"maxtime"] = self.maxtime;
    parameters[@"type"] = @(self.type);
    
    //发送请求
    [_manager GET:GFBSURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        //存储这一页的maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        NSLog(@"responseObject in topics %@", responseObject);
        
        [responseObject writeToFile:@"/Users/apple/Desktop/ceshi.plist" atomically:YES];
        
        //字典转模型
        NSMutableArray<GFTopic *> *moreTopics = [GFTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicID forIndexPath:indexPath];
    
    GFTopic *topic = self.topics[indexPath.row];
    
    NSLog(@"topic id are %@", topic.ID);
    NSLog(@"topic name are %@", topic.name);
    
    
    cell.topic = topic; //这个是将vc中刚刚从url拿到的信息，传给view文件夹中cell.topic数据类型，这样在cell view的地方可以给cell里面要展示的东西赋值
    
    return cell;
    
    
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFTopic *topic = _topics[indexPath.row];
    
    return topic.cellHeight;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFCommentViewController *commentVc = [[GFCommentViewController alloc] init];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES]; 
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清理缓存 放在这个个方法中调用频率过快
    [[SDImageCache sharedImageCache] clearMemory];
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    //清理缓存
//    [[SDImageCache sharedImageCache] clearMemory];
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
