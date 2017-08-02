//
//  UserProfileCheckinViewController.m
//  GFBS
//
//  Created by Alice Jin on 30/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "UserProfileCheckinViewController.h"
#import "HomePostTableViewController.h"
#import "UserCheckinListChildTableViewController.h"
#import "ZZUser.h"
#import "ZZChatViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

@interface UserProfileCheckinViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *topUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *topScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLocationLabel;
- (IBAction)messageButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsButton;
- (IBAction)addFriendButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *checkinListView;

@property (strong, nonatomic) NSMutableArray <UIButton *> *barButtonArray;
@property (assign, nonatomic) NSInteger *numOfCheckins;

@property (strong, nonatomic) GFHTTPSessionManager *manager;

@end

@implementation UserProfileCheckinViewController

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
    //[self passValue];
    [self setUpTopView];
    [self loadNeweData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpAfterLoadNewData {
    _topLocationLabel.text = _myProfile.userLastCheckIn.listEventRestaurant.restaurantName.en;
    
    [self setUpTopLabelBar];
    [self setUpChildVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavBar];
    //[self loadNeweData];
    //[self setUpTopView];
}

- (void)setUpNavBar {
    
    [self preferredStatusBarStyle];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpTopView {
    _topProfileImageView.layer.cornerRadius = _topProfileImageView.frame.size.width / 2;
    _topProfileImageView.clipsToBounds = YES;
    //_topProfileImageView.image = [UIImage imageNamed:@"profile_image_animals.jpeg"];
    [self.topProfileImageView sd_setImageWithURL:[NSURL URLWithString:self.myProfile.userProfileImage.imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return ;
        self.topProfileImageView.image = [image gf_circleImage];
    }];
    
    
    _topUserLabel.text = _myProfile.userUserName;
    _topScoreLabel.text = [NSString stringWithFormat:@"%@", _myProfile.checkinPoint];;
    _topLocationLabel.text = _myProfile.userLastCheckIn.listEventRestaurant.restaurantName.en;
    NSLog(@"listEventRestaurant.restaurantName  %@",_myProfile.userLastCheckIn.listEventRestaurant.restaurantName.en );
}

- (void)setUpTopLabelBar {
    UIView *labelBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ZZNewNavH, GFScreenWidth, 40)];
    labelBarView.backgroundColor = [UIColor whiteColor];
    
    int n = 3;
    _barButtonArray = [[NSMutableArray alloc] init];
    CGFloat buttonMargin = 8.0f;
    CGFloat buttonW = (GFScreenWidth - buttonMargin * (n + 1)) / n;
    for (int i = 0; i < n; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(buttonMargin + i * (buttonW + buttonMargin), 5 + ZZNewNavH, buttonW, 25);
        button.layer.cornerRadius = 5.0f;
        button.clipsToBounds = YES;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1].CGColor;
        [button setTitleColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        if (i == 0) {
            [button setTitle:[NSString stringWithFormat:@"%zd Check-in", self.numOfCheckins] forState:UIControlStateNormal];
        }
        else if (i == 1) {
            [button setTitle:[NSString stringWithFormat:@"#%@ / %@", _myProfile.socialLevel, _myProfile.userOrganizingLevel ] forState:UIControlStateNormal];
        }
        else {
            [button setTitle:[NSString stringWithFormat:@"%@ Points", _myProfile.checkinPoint] forState:UIControlStateNormal];
        }
    
        [_barButtonArray addObject:button];
        [self.view addSubview:_barButtonArray[i]];
        
    }
}


- (void)setUpChildVC {
    UIView *checkinListView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 + ZZNewNavH, GFScreenWidth, GFScreenHeight - ZZNewNavH - 40 - GFTabBarH)];
    self.checkinListView = checkinListView;
    
    [self.view addSubview:_checkinListView];
    
    UserCheckinListChildTableViewController *checkinVC = [[UserCheckinListChildTableViewController alloc] init];
    checkinVC.view.frame = CGRectMake(0, 0, self.checkinListView.frame.size.width, self.checkinListView.frame.size.height);
    checkinVC.userID = _myProfile.userID;
    [self addChildViewController:checkinVC];
    //checkinVC.view.backgroundColor = [UIColor blueColor];
    checkinVC.delegate = self;
    //checkinVC.userID = _myProfile.userID;
    //NSLog(@"userID in userVC %@", _myProfile.userID);
    //checkinVC.receivingType = @"User checkin";r
    [self.checkinListView addSubview:checkinVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)passValue:(NSInteger *)theValue {
    NSLog(@"passValueDelegate %zd", theValue);
    _barButtonArray[0].titleLabel.text = [NSString stringWithFormat:@"%zd Check-in", theValue];
    
    [_barButtonArray[0] setTitle:[NSString stringWithFormat:@"%zd Check-in", theValue] forState:UIControlStateNormal];
    self.numOfCheckins = theValue;
}

- (void)loadNeweData {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inSubData = @{@"memberId" : _myProfile.userID};
    NSDictionary *inData = @{@"action" : @"getProfile", @"token" : userToken, @"data":inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        ZZUser *thisUser = [[ZZUser alloc] init];
        thisUser = [ZZUser mj_objectWithKeyValues:responseObject[@"data"]];
        self.myProfile = thisUser;
        
        [self setUpAfterLoadNewData];
        NSLog(@"this user %@", thisUser);
        NSLog(@"this user. userName %@", thisUser.usertName);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)messageButtonClicked:(id)sender {
    ZZChatViewController *chatVC = [[ZZChatViewController alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.title = _myProfile.userUserName;
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (IBAction)addFriendButtonClicked:(id)sender {
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSString *memberId = self.myProfile.userID;
    //NSLog(@"self.friend %@", self.friend);
    NSLog(@"memberId %@", memberId);
    
    NSDictionary *inSubData = @{@"memberId" : memberId};
    
    NSDictionary *inData = @{@"action" : @"addFriend",
                             @"token" : userToken,
                             @"data" : inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //self.imageView.image = nil;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ZUZU" message:@"Friend request is sent!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
    
}
@end
