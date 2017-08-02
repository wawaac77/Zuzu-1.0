//
//  EventOverviewViewController.m
//  GFBS
//
//  Created by Alice Jin on 22/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "EventOverviewViewController.h"
#import "EventInList.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

@interface EventOverviewViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeopleLable;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *locationTextView;
@property (weak, nonatomic) IBOutlet UILabel *dishStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *featureLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionLabel;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong, nonatomic) EventInList *thisEvent;

@end

@implementation EventOverviewViewController

@synthesize thisEventID;

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
    // Do any additional setup after loading the view from its nib.
    [self setUpScrollView];
    [self loadNeweData];
    //[self setUpContent];
}


- (void)loadNeweData {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *eventID = thisEventID;
    NSLog(@"overview thisEventID %@", eventID);
    NSDictionary *forEventID = @ {@"eventId" : eventID};
    NSDictionary *inData = @{
                             @"action" : @"getEventDetail",
                             @"data" : forEventID};
    NSDictionary *parameters = @{@"data" : inData};
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        //EventInList *thisEvent = [[EventInList alloc] init];
        //self.thisEvent =thisEvent;
        //thisEvent = [EventInList mj_objectWithKeyValues:responseObject[@"data"]];
        EventInList *event = responseObject[@"data"];
        //NSLog(@"event in overview %@", event.listEventDescription);
        self.thisEvent = [EventInList mj_objectWithKeyValues:event];
        
        NSLog(@"overview thisEvent %@", self.thisEvent);
        [self setUpContent];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}



- (void)setUpContent {
    //[[UIScrollView appearance] setTintColor:[UIColor grayColor]];
    //EventInList *thisEvent = thisEventInformation;
    NSLog(@"overview thisEvent in setupContent %@", _thisEvent);
    _nameLabel.text = _thisEvent.eventHost.userUserName;
    _numberOfPeopleLable.text = [NSString stringWithFormat:@"%@/%@  People", _thisEvent.listEventJoinedCount,_thisEvent.listEventQuota];
    _startTimeLabel.text = _thisEvent.listEventStartDate;
    _endTimeLabel.text = [NSString stringWithFormat:@"Ends %@", _thisEvent.listEventEndDate];
    _placeTypeLabel.text = _thisEvent.listEventRestaurant.restaurantName.en;
    _locationTextView.text = _thisEvent.listEventRestaurant.restaurantAddress.en;
    
    _dishStyleLabel.text = _thisEvent.eventCuisine.informationName.en;
    NSString *features = [[NSString alloc] init];
    for (int i = 0; i < _thisEvent.listEventInterests.count; i++) {
        ZZInterest *thisInterest = [_thisEvent.listEventInterests objectAtIndex:i];
        
        if (i == _thisEvent.listEventInterests.count - 1) {
            features = [features stringByAppendingString:[NSString stringWithFormat:@"%@", thisInterest.interestName.en]];

        } else {
            features = [features stringByAppendingString:[NSString stringWithFormat:@"%@, ", thisInterest.interestName.en]];
        }
    }
    _featureLabel.text = features;
    _priceLabel.text = [NSString stringWithFormat:@"HK$%@ per person", _thisEvent.listEventBudget];
    _eventDescriptionLabel.text = _thisEvent.listEventDescription;
    
}

- (void)setUpScrollView {
    //UIScrollView *scrollView = [[UIScrollView alloc] init];
    //self.scrollView = scrollView;
    //[self.view addSubview:scrollView];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.gf_width, 1000);
    NSLog(@"self.view.gf_width is %f", self.view.gf_width);
    NSLog(@"self.view.gf_height is %f", self.view.gf_height);
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

@end
