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

//#import "EventListTableViewController.h"
#import "ZZAttendingViewController.h"
#import "RestaurantViewController.h" //should be favourite restaurant
#import "ZZBadgeModel.h"

#import "GFSquareItem.h"
#import "GFSquareCell.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "UIBarButtonItem+Badge.h"

static NSString *const ID = @"ID";
static NSInteger const cols = 3;
static CGFloat  const margin = 0;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols

@interface MyZuzuViewController () <UICollectionViewDataSource,UICollectionViewDelegate, UIImagePickerControllerDelegate>
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

@property (strong , nonatomic)GFHTTPSessionManager *manager;

/*所有button内容*/
@property (strong , nonatomic)NSMutableArray<GFSquareItem *> *buttonItems;
@property (strong , nonatomic)NSMutableArray<ZZBadgeModel *> *badgesArray;
@property (weak, nonatomic) UIImage *pickedImage;

/**
 collectionView
 */
@property (weak ,nonatomic) UICollectionView *functionsCollectionView;


@end

@implementation MyZuzuViewController

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
    self.view.frame = [UIScreen mainScreen].bounds;
    NSString *userName = [AppDelegate APP].user.userUserName;
    self.userNameLabel.text = userName;
    [self setUpNavBar];
    [self setUpExp];
    [self setUpCollectionItemsData];
    [self setUpFunctionsCollectionView];
    
    self.badgesArray = [[NSMutableArray alloc] init];
    [self loadBadgesData];
    // Do any additional setup after loading the view from its nib.
}

-(void) setUpExp {
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.gf_width / 2;
    //user.userProfileImage.imageUrl
    NSLog(@"[AppDelegate APP].user.userProfileImage.imageUrl %@", [AppDelegate APP].user.userProfileImage.imageUrl);
    NSURL *URL = [NSURL URLWithString:[AppDelegate APP].user.userProfileImage.imageUrl];
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    UIImage *image = [[UIImage alloc]initWithData:data];
    self.profileImageView.image = image;
    
    
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
    
    UICollectionView *functionsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.functionsView.gf_width, itemHW * 2) collectionViewLayout:layout];
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
    NSArray *buttonTitles = [NSArray arrayWithObjects:@"My Events", @"Favourite Restaurants", @"My Reviews", @"Invite Friends", @"My Friends",@"", nil];
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
    UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    notificationBtn.badgeValue = @"2"; // I need the number of not checked through API
    //notificationBtn.badgePadding = 0;
    //notificationBtn.badgeMinSize = 0; //I changed their default value in category
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, fixedButton, notificationBtn, nil]];
    
    //Title
    self.navigationItem.title = @"My Zuzu";
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareItem *item = _buttonItems[indexPath.item];
    
    if ([item.name isEqualToString: @"My Events"]) {
        ZZAttendingViewController *eventVC = [[ZZAttendingViewController alloc] init];
        eventVC.view.frame = [UIScreen mainScreen].bounds;
        [self.navigationController pushViewController:eventVC animated:YES];
    } else if ([item.name isEqualToString: @"Favourite Restaurants"]) {
        RestaurantViewController *restaurantVC = [[RestaurantViewController alloc] init];
        [self.navigationController pushViewController:restaurantVC animated:YES];
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

    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inData = @{@"action" : @"getBadgeList", @"token" : userToken};
        
    NSDictionary *parameters = @{@"data" : inData};

    NSLog(@"publish content parameters %@", parameters);
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        
        
        NSLog(@"responseObject is %@", responseObject);
        
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        
        
        self.badgesArray = [ZZBadgeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSLog(@"self.badgesArray.count %zd", self.badgesArray.count);
        
        [self setUpBadgesView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)leaderboardButtonClicked:(id)sender {
    LeaderboardViewController *leaderboardVC = [[LeaderboardViewController alloc] init];
    [self.navigationController pushViewController:leaderboardVC animated:YES];
}
- (IBAction)changeProfilePicClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = chosenImage;
    self.pickedImage = chosenImage;
    NSLog(@"chosenImage %@", chosenImage);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self uploadProfilePic];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
            break;
        case 0x42:
            return @"image/bmp";
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}


- (void)uploadProfilePic {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    NSLog(@"userToken in checkinVC %@", userToken);
    
    NSString *imageBase64 = [UIImagePNGRepresentation(_pickedImage)
                             base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSData *imageData = UIImagePNGRepresentation(_pickedImage);
    NSString *imageType = [self contentTypeForImageData:imageData];
    NSString *imageInfo = [NSString stringWithFormat:@"data:%@;base64,%@",imageType, imageBase64];
    
    NSDictionary *inSubData = @{@"profilePic": imageInfo};
    
    NSDictionary *inData = @{@"action" : @"uploadProfilePic",
                             @"token" : userToken,
                             @"data" : inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //self.profileImageView.image = nil;
        
        [AppDelegate APP].user.userProfileImage_UIImage = _pickedImage;
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ZUZU" message:@"Profile image uploaded!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
        ZZUser *sucessBack = [[ZZUser alloc] init];
        sucessBack = [ZZUser mj_objectWithKeyValues:responseObject[@"data"]];
        [AppDelegate APP].user.userProfileImage.imageUrl = sucessBack.userProfileImage.imageUrl;
        NSLog(@"[appDelegate]sucessBack.userProfileImage.imageUrl %@", sucessBack.userProfileImage.imageUrl);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:sucessBack.userProfileImage.imageUrl forKey:@"KEY_USER_PROFILE_PICURL"];
        [userDefaults synchronize];

        
        //[self textView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}


@end
