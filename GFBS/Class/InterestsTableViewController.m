//
//  InterestsTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 10/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "InterestsTableViewController.h"
#import "SearchEventDetail.h"
#import "ZZTypicalInformationModel.h"
#import "ZBLocalized.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";
@protocol ChildViewControllerDelegate;

@interface InterestsTableViewController ()

@property(nonatomic ,strong) NSMutableArray<ZZTypicalInformationModel *> *interestsArray;//
@property(nonatomic ,strong) SearchEventDetail *eventDetail;

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation InterestsTableViewController

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
    self.navigationItem.title = ZBLocalized(@"Interests", nil);
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

    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    //2.凭借请求参数
    NSDictionary *inData = @{@"action" : @"getInterestList", @"lang" : userLang};
    NSDictionary *parameters = @{@"data" : inData};
  
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.interestsArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];

    /*
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        self.interestsArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    }];
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.interestsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.textLabel setHighlightedTextColor: [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
        
    }
    cell.textLabel.text = _interestsArray[indexPath.row].informationName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _eventDetail.interests = _interestsArray[indexPath.row].informationName;
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)okButtonClicked {
    NSLog(@"eventDetail in okButtonClicked interests %@", _eventDetail.interests);
    [self passValueMethod];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passValueMethod
{
    [_delegate passValueInterests:_eventDetail];
}


@end
