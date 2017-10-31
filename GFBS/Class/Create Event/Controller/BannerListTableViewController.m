//
//  BannerListTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 4/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BannerListTableViewController.h"
#import "ZZBannerModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

static NSString *const ID = @"ID";

@interface BannerListTableViewController ()

@property (strong, nonatomic) NSMutableArray <ZZBannerModel *> *bannerArray;
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation BannerListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setupRefresh];
    //[self loadNewData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpNavBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
}


- (void)setupRefresh
{
    self.tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 加载新数据
-(void)loadNewData
{
    NSDictionary *inData = @{@"action" : @"getEventBannerList"};
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
      
        self.bannerArray = [ZZBannerModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
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
        
        self.bannerArray = [ZZBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bannerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, 145)];
    bigImageView.clipsToBounds = YES;
    [cell.contentView addSubview:bigImageView];
    bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSURL *URL = [NSURL URLWithString:_bannerArray[indexPath.row].image.imageUrl];
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    UIImage *image = [[UIImage alloc]initWithData:data];
    _bannerArray[indexPath.row].image.image_UIImage= image;
    bigImageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)saveButtonClicked {
    [self passSelectedBannerBack];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passSelectedBannerBack {
    
    ZZBannerModel *banner = _bannerArray[[self.tableView indexPathForSelectedRow].row];
    NSLog(@"selectedRow %ld", [self.tableView indexPathForSelectedRow].row );
    NSLog(@"banner %@", banner);
    [_delegate passValue:banner];
}



@end
