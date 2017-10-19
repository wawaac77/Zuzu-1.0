//
//  BadgesCollectionViewController.m
//  GFBS
//
//  Created by Alice Jin on 14/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BadgesCollectionViewController.h"
#import "GFWebViewController.h"
#import "BadgesDetailViewController.h"
#import "AppDelegate.h"

//#import "GFSquareItem.h"
#import "ZZBadgeModel.h"
#import "BadgesSquareCell.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>

static NSString *const ID = @"ID";
static NSInteger const cols = 3;
static CGFloat  const margin = 0;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols
#define itemHH  itemHW + 25

@interface BadgesCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *badgesCollectionView;

/*所有button内容*/
@property (strong , nonatomic)NSMutableArray<ZZBadgeModel *> *buttonItems;
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation BadgesCollectionViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNewData];
    //[self setUpFunctionsCollectionView];
    [self setUpNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpFunctionsCollectionView
{
    //[self setUpCollectionItemsData];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置尺寸
    layout.itemSize = CGSizeMake(itemHW, itemHH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    UICollectionView *badgesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, self.view.gf_height) collectionViewLayout:layout];
    self.view.backgroundColor = [UIColor whiteColor];
    self.badgesCollectionView = badgesCollectionView;
    badgesCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:badgesCollectionView];
    //关闭滚动
    badgesCollectionView.scrollEnabled = NO;
    
    //设置数据源和代理
    badgesCollectionView.dataSource = self;
    badgesCollectionView.delegate = self;
    
    //注册
    [badgesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BadgesSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - Setup UICollectionView Data

/*
-(void)setUpCollectionItemsData {
    NSArray *buttonIcons = [NSArray arrayWithObjects:@"ic_badges_338x338-01.png", @"ic_badges_338x338-02.png", @"ic_badges_338x338-03.png", @"ic_badges_338x338-04.png", @"ic_badges_338x338-05.png", @"ic_badges_338x338-06.png",@"ic_badges_338x338-07.png", @"ic_badges_338x338-08.png",  nil];
    NSArray *buttonTitles = [NSArray arrayWithObjects:@"Early Bird", @"Lounge Cat", @"Heavyweight", @"Wallflower", @"Eclectic", @"Socialite",@"Researcher", @"Insomniac",  nil];
    NSArray *buttonPrice = [NSArray arrayWithObjects:@"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00",@"HK$ 5.00", @"HK$ 5.00",  nil];

    //NSMutableArray<GFSquareItem *> *buttonItems =[[NSMutableArray<GFSquareItem *> alloc]init];
    //self.buttonItems = buttonItems;
    self.buttonItems = [[NSMutableArray<ZZBadgeModel *> alloc]init];
    for (int i = 0; i < buttonIcons.count; i++) {
        GFSquareItem *squareItem = [[GFSquareItem alloc]init];
        squareItem.icon = buttonIcons[i];
        squareItem.name = buttonTitles[i];
        squareItem.price = buttonPrice[i];
        [_buttonItems addObject:squareItem];
    }
    NSLog(@"buttonItems:%@", _buttonItems);
}
*/

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"_buttonItems.count = %ld", _buttonItems.count);
    return _buttonItems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BadgesSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    NSLog(@"indexPath.item%ld", indexPath.item);
    NSLog(@"buttonItems indexPath.item%@", self.buttonItems[indexPath.item].name);
    
    cell.item = self.buttonItems[indexPath.item];
    
    return cell;
}

- (void)setUpNavBar
{
    //UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    //UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    //[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, notificationBtn, nil]];
    
    //Title
    self.navigationItem.title = @"Badges Collection";
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZBadgeModel *item = _buttonItems[indexPath.item];
    
    BadgesDetailViewController *detailVC = [[BadgesDetailViewController alloc] init];
    detailVC.item = item;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    /*
    //判断
    if (![item.url containsString:@"http"]) return;
    
    NSURL *url = [NSURL URLWithString:item.url];
    GFWebViewController *webVc = [[GFWebViewController alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
    
    //给Url赋值
    webVc.url = url;
     */
}

#pragma mark - 加载更多数据
-(void)loadNewData
{
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [AppDelegate APP].user.userToken;
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    NSDictionary *inData = @{
                             @"action" : @"getBadgeList",
                             @"token" : userToken,
                             @"lang" : userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        //字典转模型
        NSLog(@"Request is successful成功了");
        NSMutableArray<ZZBadgeModel *> *buttonItems = [ZZBadgeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.buttonItems = buttonItems;
        [self setUpFunctionsCollectionView];
        //[self.badgesCollectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request 失败");
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}



@end
