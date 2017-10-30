//
//  GFNearbyEventsViewController.m
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFNearbyEventsViewController.h"
#import "GFEventDetailViewController.h"
#import "EventInList.h"
#import "GFEventsCell.h"

#import "GFTopic.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

#import "MinScrollMenu.h"
#import "MinScrollMenuItem.h"

@interface GFNearbyEventsViewController () <MinScrollMenuDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) MinScrollMenu *menu;
@property (weak, nonatomic) IBOutlet MinScrollMenu *ibMenu;
/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;
/*所有帖子数据*/
@property (strong , nonatomic)NSMutableArray<EventInList *> *nearbyEvents;

@end

@implementation GFNearbyEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, 165);
    
    [self loadNewEvents];

    //[self setUpTable];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _menu.frame = CGRectMake(0.0, 0.0, ScreenWidth, self.view.gf_height);
}

- (void)setUpTable {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _count = self.nearbyEvents.count;
    _ibMenu.delegate = self;
    
    _menu = [[MinScrollMenu alloc] initWithFrame:self.view.frame];
    _menu.delegate = self;
    
    [self.view addSubview:_menu];
    
}

- (IBAction)reload:(UIBarButtonItem *)sender {
    _count = arc4random() % 100;
    [_ibMenu reloadData];
    _count = arc4random() % 1000;
    [_menu reloadData];
}

#pragma MinScrollMenuDelegate Method

- (NSInteger)numberOfMenuCount:(MinScrollMenu *)menu {
    return _count;
}

- (CGFloat)scrollMenu:(MinScrollMenu *)menu widthForItemAtIndex:(NSInteger)index {
    return self.view.gf_width / 2;
}

- (MinScrollMenuItem *)scrollMenu:(MinScrollMenu *)menu itemAtIndex:(NSInteger)index {
    
    MinScrollMenuItem *item = [menu dequeueItemWithIdentifer:@"imageItem"];
    
    item.backgroundColor = [UIColor redColor];
    
    if (item == nil) {
        item = [[MinScrollMenuItem alloc] initWithType:ImageType reuseIdentifier:@"imageItem"];
        //[item.imageView sd_setImageWithURL:[NSURL URLWithString:self.nearbyEvents[index].listEventBanner.eventBanner.imageUrl] placeholderImage:nil];
    }
    
    [item.imageView sd_setImageWithURL:[NSURL URLWithString:self.nearbyEvents[index].listEventBanner.eventBanner.imageUrl] placeholderImage:nil];
    
    item.imageView.clipsToBounds = YES;
    item.textLabel.text = self.nearbyEvents[index].listEventName;
    item.timeLabel.text = [NSString stringWithFormat:@"  %@", self.nearbyEvents[index].listEventStartDate];
    item.timeLabel.layer.cornerRadius = 5.0f;
    
    return item;
}

- (void)scrollMenu:(MinScrollMenu *)menu didSelectedItem:(MinScrollMenuItem *)item atIndex:(NSInteger)index {
    NSLog(@"tap index: %ld", index);
    GFEventDetailViewController *detailVC = [[GFEventDetailViewController alloc] init];
    detailVC.eventHere = _nearbyEvents[index];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"NearbyVC moving to or from parent view controller");
    //self.view.backgroundColor = [UIColor redColor];
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"NearbyVC did move to or from parent view controller");
    //self.view.frame = CGRectMake(0, 35, self.view.gf_width, 165);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*******Here is reloading data place*****/
#pragma mark - 加载新数据
-(void)loadNewEvents
{
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = @{
                             @"action" : @"getNearbyEventList",
                             @"data" : geoPointDic,
                             @"lang" : userLang,
                             };
    NSDictionary *parameters = @{@"data" : inData};
   
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        NSArray *eventsArray = data[@"data"];
        NSLog(@"eventsArray %@", eventsArray);
        
        self.nearbyEvents = [EventInList mj_objectArrayWithKeyValuesArray:eventsArray];
        [self setUpTable];
        //[_ibMenu reloadData];
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
}


@end
