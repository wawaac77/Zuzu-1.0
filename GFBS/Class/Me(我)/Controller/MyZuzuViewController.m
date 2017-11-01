//
//  MyZuzuViewController.m
//  GFBS
//
//  Created by Alice Jin on 13/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "MyZuzuViewController.h"
#import "ProgressView.h"

#import "GFWebViewController.h"
#import "GFSettingViewController.h"
#import "BadgesCollectionViewController.h"
#import "NotificationViewController.h"
#import "LeaderboardViewController.h"
#import "ZZFriendsTableViewController.h"
#import "ZBLocalized.h"

//#import "EventListTableViewController.h"
#import "ZZAttendingViewController.h"
#import "RestaurantViewController.h" //should be favourite restaurant
#import "ZZBadgeModel.h"
#import "NotificationItem.h"

#import "GFSquareItem.h"
#import "GFSquareCell.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "UIBarButtonItem+Badge.h"
#import "ZGAlertView.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MessageUI.h>

static NSString *const ID = @"ID";
static NSInteger const cols = 3;
static CGFloat  const margin = 0;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols

@interface MyZuzuViewController () <UICollectionViewDataSource,UICollectionViewDelegate, UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *changeProfilePicButton;
- (IBAction)changeProfilePicClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet ProgressView *SocialExpView;
@property (weak, nonatomic) IBOutlet ProgressView *OrganizingExpView;
@property (weak, nonatomic) IBOutlet UIView *badgesView;
@property (weak, nonatomic) IBOutlet UIView *functionsView;
@property (weak, nonatomic) IBOutlet UIButton *leaderboardButton;
- (IBAction)leaderboardButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialExpLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizeExpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *socialImageView;
@property (weak, nonatomic) IBOutlet UIImageView *organizeImageView;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizingLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBadgesLabel;

/*所有button内容*/
@property (strong , nonatomic)NSMutableArray<GFSquareItem *> *buttonItems;
@property (strong , nonatomic)NSMutableArray<ZZBadgeModel *> *badgesArray;
@property (strong , nonatomic)NSMutableArray<NotificationItem *> *myNotifications;
@property (weak, nonatomic) UIImage *pickedImage;
@property (strong, nonatomic) UIBarButtonItem *notificationBtn;

/**
 collectionView
 */
@property (weak ,nonatomic) UICollectionView *functionsCollectionView;

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) ZGAlertView *alertView;

@end

@implementation MyZuzuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    NSString *userUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_NAME"];
    NSString *userURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_PROFILE_PICURL"];
    //NSString *userName = [AppDelegate APP].user.userUserName;
    self.userNameLabel.text = userUserName;
    
    [self setUpExp];
    [self setUpCollectionItemsData];
    [self setUpFunctionsCollectionView];
    
    self.badgesArray = [[NSMutableArray alloc] init];
    self.myNotifications = [[NSMutableArray alloc] init];
    [self loadBadgesData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setUpNavBar];
}

-(void) setUpExp {
    
    self.socialLabel.text = ZBLocalized(@"Social Experience", nil);
    self.organizingLabel.text = ZBLocalized(@"Organizing Experience", nil);
    self.myBadgesLabel.text = ZBLocalized(@"My Badges", nil);
    
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.gf_width / 2;
    //user.userProfileImage.imageUrl
    NSLog(@"[AppDelegate APP].user.userProfileImage.imageUrl %@", [AppDelegate APP].user.userProfileImage.imageUrl);
    //NSURL *URL = [NSURL URLWithString:[AppDelegate APP].user.userProfileImage.imageUrl];
    
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_PROFILE_PICURL"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [self.profileImageView setImageWithURL:url placeholderImage: nil];
    
    
    NSNumber *social = [AppDelegate APP].user.socialLevel;
    NSLog(@"[AppDelegate APP].user.socialExp %@", [AppDelegate APP].user.socialLevel);
    self.socialExpLabel.text = [NSString stringWithFormat:@"Lv. %@", social];
    float socialFloat = [social floatValue] / 15.0f;
    [self.SocialExpView setGradual:YES];
    _SocialExpView.progress = socialFloat;
    
    _socialImageView.contentMode = UIViewContentModeScaleAspectFill;
    _socialImageView.clipsToBounds = YES;
    int socialInt = [social intValue];
    if (socialInt <= 15 && socialInt >= 1) {
        _socialImageView.image = [UIImage imageNamed:@"profile-bg-white_01.jpg"];
    } else if (socialInt > 15 && socialInt <= 30) {
        _socialImageView.image = [UIImage imageNamed:@"profile-bg-yellow_01.jpg"];
    } else if (socialInt > 30 && socialInt <= 45) {
        _socialImageView.image = [UIImage imageNamed:@"profile-bg-green_01.jpg"];
    } else if (socialInt > 45 && socialInt <= 60) {
        _socialImageView.image = [UIImage imageNamed:@"profile-bg-blue_01.jpg"];
    } else if (socialInt > 60 && socialInt <= 75) {
        _socialImageView.image = [UIImage imageNamed:@"profile-bg-brown_01.jpg"];
    } else if (socialInt > 75 && socialInt <= 90) {
        _socialImageView.image = [UIImage imageNamed:@"profile-bg-black_01.jpg"];
    } else {
        _socialImageView.image = [UIImage imageNamed:@"profile-bg-gold_01.jpg"];
    }
    
    
    NSNumber *organize = [AppDelegate APP].user.userOrganizingLevel;
    NSLog(@"[AppDelegate APP].user.organize %@", [AppDelegate APP].user.userOrganizingExp);
    self.organizeExpLabel.text = [NSString stringWithFormat:@"Lv. %@", organize];
    float organizeFloat = [organize floatValue] / 15.0f;
    [self.OrganizingExpView setGradual:YES];
    _OrganizingExpView.progress = organizeFloat;
    
    _organizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    _organizeImageView.clipsToBounds = YES;
    int organizeInt = [organize intValue];
    if (organizeInt <= 15 && organizeInt >= 1) {
        _organizeImageView.image = [UIImage imageNamed:@"profile-bg-white_02.jpg"];
    } else if (organizeInt > 15 && organizeInt <= 30) {
        _organizeImageView.image = [UIImage imageNamed:@"profile-bg-yellow_02.jpg"];
    } else if (organizeInt > 30 && organizeInt <= 45) {
        _organizeImageView.image = [UIImage imageNamed:@"profile-bg-green_02.jpg"];
    } else if (organizeInt > 45 && organizeInt <= 60) {
        _organizeImageView.image = [UIImage imageNamed:@"profile-bg-blue_02.jpg"];
    } else if (organizeInt > 60 && organizeInt <= 75) {
        _organizeImageView.image = [UIImage imageNamed:@"profile-bg-brown_02.jpg"];
    } else if (organizeInt > 75 && organizeInt <= 90) {
        _organizeImageView.image = [UIImage imageNamed:@"profile-bg-black_02.jpg"];
    } else {
        _organizeImageView.image = [UIImage imageNamed:@"profile-bg-gold_02.jpg"];
    }
}

#pragma mark - 设置底部视图
-(void)setUpFunctionsCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置尺寸
    layout.itemSize = CGSizeMake(itemHW, itemHW);
    NSLog(@"itemHW %f", itemHW);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    UICollectionView *functionsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, GFScreenWidth, itemHW * 2) collectionViewLayout:layout];
    self.functionsCollectionView = functionsCollectionView;
    self.functionsCollectionView.backgroundColor = [UIColor whiteColor];

    [self.functionsView addSubview:functionsCollectionView];
    //关闭滚动
    functionsCollectionView.scrollEnabled = NO;
    
    //设置数据源和代理
    functionsCollectionView.dataSource = self;
    functionsCollectionView.delegate = self;
    
    //注册
    [functionsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GFSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
}

#pragma mark - Setup UICollectionView Data
-(void)setUpCollectionItemsData {
    NSArray *buttonIcons = [NSArray arrayWithObjects:@"my-event", @"f-restaurant-icon", @"my-review", @"invite-friends", @"my-friends",@"", nil];
    
    NSArray *buttonTitles = [NSArray arrayWithObjects:ZBLocalized(@"My Events", nil), ZBLocalized(@"Favourite Restaurants", nil), ZBLocalized(@"My Reviews", nil), ZBLocalized(@"Invite Friends", nil), ZBLocalized(@"My Friends", nil),@"", nil];
    //NSMutableArray<GFSquareItem *> *buttonItems =[[NSMutableArray<GFSquareItem *> alloc]init];
    //self.buttonItems = buttonItems;
    self.buttonItems = [[NSMutableArray<GFSquareItem *> alloc]init];
    for (int i = 0; i < buttonIcons.count; i++) {
        GFSquareItem *squareItem = [[GFSquareItem alloc]init];
        squareItem.icon = buttonIcons[i];
        squareItem.name = buttonTitles[i];
        [_buttonItems addObject:squareItem];
    }
    NSLog(@"buttonItems:%@", _buttonItems);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"_buttonItems.count = %ld", _buttonItems.count);
    return _buttonItems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    NSLog(@"indexPath.item%ld", indexPath.item);
    NSLog(@"buttonItems indexPath.item%@", self.buttonItems[indexPath.item].name);
    
    cell.item = self.buttonItems[indexPath.item];
    
    return cell;
}

- (void)setUpNavBar
{
    UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    fixedButton.width = 20;
    
    self.notificationBtn = [[UIBarButtonItem alloc] init];
    self.notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    _notificationBtn.badgeValue = @"2"; // I need the number of not checked through API
    //notificationBtn.badgePadding = 0;
    //notificationBtn.badgeMinSize = 0; //I changed their default value in category
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, fixedButton, _notificationBtn, nil]];
    
    //Title
    self.navigationItem.title = ZBLocalized(@"My Zuzu", nil);
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareItem *item = _buttonItems[indexPath.item];
    
    if ([item.name isEqualToString: ZBLocalized(@"My Events", nil)]) {
        ZZAttendingViewController *eventVC = [[ZZAttendingViewController alloc] init];
        eventVC.navigationItem.title = ZBLocalized(@"My Events", nil);
        eventVC.view.frame = [UIScreen mainScreen].bounds;
        [self.navigationController pushViewController:eventVC animated:YES];
    } else if ([item.name isEqualToString: ZBLocalized(@"Favourite Restaurants", nil)]) {
        RestaurantViewController *restaurantVC = [[RestaurantViewController alloc] init];
        [self.navigationController pushViewController:restaurantVC animated:YES];
    } else if ([item.name isEqualToString: ZBLocalized(@"My Friends", nil)]) {
        ZZFriendsTableViewController *friendVC = [[ZZFriendsTableViewController alloc] init];
        [self.navigationController pushViewController:friendVC animated:YES];
    } else if ([item.name isEqualToString: ZBLocalized(@"Invite Friends", nil)]) {
        [self showShareView];
    }
    
    //判断
    /*
    if (![item.url containsString:@"http"]) return;
    
    NSURL *url = [NSURL URLWithString:item.url];
    GFWebViewController *webVc = [[GFWebViewController alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
    
    //给Url赋值
    webVc.url = url;
    */
}

#pragma mark - BadgesView
- (void)loadBadgesData {

    NSString *userToken = [AppDelegate APP].user.userToken;
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    NSDictionary *inData = @{@"action" : @"getBadgeList", @"token" : userToken, @"lang" : userLang};
        
    NSDictionary *parameters = @{@"data" : inData};

    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.badgesArray = [ZZBadgeModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
      
        [self setUpBadgesView];
        [self getNotificationList];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)getNotificationList {
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = @{@"action" : @"getNotificationList", @"token" : userToken, @"lang" : userLang};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.myNotifications = [NotificationItem mj_objectArrayWithKeyValuesArray:data[@"data"]];
        self.notificationBtn.badge = [NSString stringWithFormat:@"%lu", _myNotifications.count];
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];

}


-(void)setUpBadgesView {
    int i = 0;
    int x = 10;
    int y = 5;
    while (i < _badgesArray.count) {
        if (x >= GFScreenWidth - 45 - 10) {
            x = 10;
            y = y + 50;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 45, 45)];
        //button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [button.imageView sd_setImageWithURL:[NSURL URLWithString:self.badgesArray[i].icon.imageUrl] placeholderImage:nil];
        [self.badgesView addSubview:button];
        i++;
        x = x + 50;
    }
    
    /*
    for (int i = 0; i < _badgesArray.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i * 50, 5, 45, 45)];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        //[button setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
       
        NSURL *URL = [NSURL URLWithString:_badgesArray[i].icon.imageUrl];
        NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
        UIImage *image = [[UIImage alloc]initWithData:data];
        _badgesArray[i].icon.image_UIImage = image;
        [button setImage:image forState:UIControlStateNormal];
        /*
        if (i == _badgesArray.count - 1) {
            [button addTarget:self action:@selector(addBadgesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
         */
    /*
        [self.badgesView addSubview:button];
    }
    */
    if (x >= GFScreenWidth - 45 - 10) {
        x = 10;
    }

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 5, 45, 45)];
    //button.contentMode = UIViewContentModeScaleAspectFill;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [button setImage:[UIImage imageNamed:@"plus_badges.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addBadgesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.badgesView addSubview:button];
}

- (void)addBadgesButtonClicked {
    BadgesCollectionViewController *BadgesCollectionVC = [[BadgesCollectionViewController alloc] init];
    BadgesCollectionVC.view.frame = CGRectMake(0, 200, self.view.gf_width, self.view.gf_height - 200);
    BadgesCollectionVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:BadgesCollectionVC animated:YES];
}

- (void)settingClicked
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([GFSettingViewController class]) bundle:nil];
    GFSettingViewController *settingVc = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVc animated:YES];
}

- (void)notificationClicked
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leaderboardButtonClicked:(id)sender {
    LeaderboardViewController *leaderboardVC = [[LeaderboardViewController alloc] init];
    [self.navigationController pushViewController:leaderboardVC animated:YES];
}
- (IBAction)changeProfilePicClicked:(id)sender {
    
    PickSingleImageViewController *pickVC = [[PickSingleImageViewController alloc] init];
    [self.navigationController pushViewController:pickVC animated:YES];
    
}

- (void)showShareView {
    /*
     NSString *shareText = @"I'm having fun on ZUZU. Come and join me!";
     NSArray *itemsToShare = @[shareText];
     UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
     activityVC.excludedActivityTypes = @[];
     [self presentViewController:activityVC animated:YES completion:nil];
     */
    
    ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle: ZBLocalized(@"Invite Friends", nil) message:@"" cancelButtonTitle:nil otherButtonTitles:nil, nil];
    self.alertView = alertView;
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1];
    [facebookButton setTitle:ZBLocalized(@"Find friends on Facebook", nil) forState:UIControlStateNormal];
    [alertView addCustomButton:facebookButton toIndex:0];
    
    UIButton *googlePlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    googlePlusButton.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:72.0/255.0 blue:54.0/255.0 alpha:1];
    [googlePlusButton setTitle:ZBLocalized(@"Connect with Google+", nil) forState:UIControlStateNormal];
    [alertView addCustomButton:googlePlusButton toIndex:1];
    
    UIButton *smsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    smsButton.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:194.0/255.0 blue:54.0/255.0 alpha:1];
    [smsButton setTitle:ZBLocalized(@"SMS Your Friends", nil) forState:UIControlStateNormal];
    [smsButton addTarget:self action:@selector(showMessageView) forControlEvents:UIControlEventTouchUpInside];
    [alertView addCustomButton:smsButton toIndex:2];
    
    UIButton *shareUrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareUrlButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0 alpha:1];
    [shareUrlButton setTitle:ZBLocalized(@"Share URL", nil) forState:UIControlStateNormal];
    [shareUrlButton addTarget:self action:@selector(shareURLButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [alertView addCustomButton:shareUrlButton toIndex:3];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitle:ZBLocalized(@"Cancel", nil) forState:UIControlStateNormal];
    //[shareUrlButton addTarget:self action:@selector(shareURLButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [alertView addCustomButton:cancelButton toIndex:4];
    
    alertView.titleColor = [UIColor whiteColor];
    alertView.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithObjects:facebookButton, googlePlusButton, smsButton, shareUrlButton,cancelButton, nil];
    NSArray *iconArray = [[NSArray alloc] initWithObjects:@"ic_facebook-logo",@"ic_google-plus", @"ic_sms",@"",@"",nil];
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [buttonArray objectAtIndex:i];
        button.layer.cornerRadius = 5.0f;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [button addSubview:imageView];
        imageView.frame = CGRectMake(15, 10, 44 - 20, 44 - 20);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[iconArray objectAtIndex:i]];
    }
    
    [alertView show];
    
}

- (void)smsButtonClicked {
    NSLog(@"smsButtonClicked!");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://"]];//发短信
}

- (void)shareURLButtonClicked {
    NSLog(@"shareURLButtonClicked!");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mailto://"]];//发email
}

- (void)dismissViews {
    if ([self.alertView isFirstResponder]) {
        [self.alertView resignFirstResponder];
    }
    
}

- (void)showMessageView
{
    
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
        controller.recipients = [NSArray arrayWithObject:@""];
        controller.body = @"测试发短信";
        controller.messageComposeDelegate = self;
        
        [self presentModalViewController:controller animated:YES];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
    }else{
        
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
}



//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            
            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        default:
            break;
    }
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

@end
