//
//  CuisineTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 10/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "CuisineTableViewController.h"
#import "SearchEventDetail.h"
#import "ZZTypicalInformationModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";

@interface CuisineTableViewController ()

@property(nonatomic ,strong) NSMutableArray<ZZTypicalInformationModel *> *cuisineArray;//
@property(nonatomic ,strong) SearchEventDetail *eventDetail;

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation CuisineTableViewController


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
    self.navigationItem.title = @"Cuisine";
    self.eventDetail = [[SearchEventDetail alloc] init];
    [self setUpNavBar];
    [self setUpArray];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpArray {
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSDictionary *inData = [[NSDictionary alloc] init];
    if ([self.tableType isEqualToString: @"Cuisine"]) {
        inData = @{@"action" : @"getCuisineList"};
    }
    else if ([self.tableType isEqualToString: @"District"]) {
        inData = @{@"action" : @"getDistrictList"};
    }
    else if ([self.tableType isEqualToString: @"Landmark"]) {
        inData = @{@"action" : @"getLandmarkList"};
    }
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        self.cuisineArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cuisineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.textLabel setHighlightedTextColor: [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
    }
    cell.textLabel.text = _cuisineArray[indexPath.row].informationName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableType isEqualToString: @"Cuisine"]) {
        _eventDetail.cuisine = _cuisineArray[indexPath.row];
    }
    else if ([self.tableType isEqualToString: @"District"]) {
        _eventDetail.district = _cuisineArray[indexPath.row];
    }
    else if ([self.tableType isEqualToString: @"Landmark"]) {
        _eventDetail.landmark = _cuisineArray[indexPath.row];
    }
    
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)okButtonClicked {
    NSLog(@"eventDetail in okButtonClicked cuisine %@", _eventDetail.cuisine);
    [self passValueMethod];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passValueMethod
{
    [_delegate passValueCuisine:_eventDetail];
}

@end
