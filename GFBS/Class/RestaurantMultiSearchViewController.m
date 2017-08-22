//
//  RestaurantMultiSearchViewController.m
//  GFBS
//
//  Created by Alice Jin on 21/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantMultiSearchViewController.h"
#import "CuisineTableViewController.h"
#import "RestaurantTableViewController.h"
#import "EventRestaurant.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>

@interface RestaurantMultiSearchViewController () <UITextViewDelegate>
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong, nonatomic) UITextField *keywordField;
@property (strong, nonatomic) UILabel *budgetLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *cuisineLabel;

@property (strong , nonatomic)NSMutableArray<EventRestaurant *> *restaurants;
@property (strong, nonatomic) SearchEventDetail *eventDetail;

@end

@implementation RestaurantMultiSearchViewController

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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 30.0f;
    } else {
        return 50.0f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, 30)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, GFScreenWidth - 20, 20)];
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.text = @"- or search by -";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont systemFontOfSize:14];
        [footerView addSubview:headerLabel];
        return footerView;
    }
    if (section == 1) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, 50)];
        UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.frame = CGRectMake(5, 10, self.view.gf_width - 10, 35);
        joinButton.layer.cornerRadius = 5.0f;
        joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [joinButton setClipsToBounds:YES];
        
        [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [joinButton setBackgroundColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
        
        [joinButton setTitle:@"Next" forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:joinButton];
        return footerView;
    }
    return NULL;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"section%ldrow%ld", indexPath.section, indexPath.row];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, self.view.gf_width - 15 - 30, 50)];
                [textField setFont:[UIFont systemFontOfSize:15]];
                
                textField.delegate = self;
                textField.tag = indexPath.row;
                self.keywordField = textField;
                textField.placeholder = @"Restaurant, Cuisine, Dish";
                [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:textField];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
        }
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
                title1.font = [UIFont systemFontOfSize:15];
                title1.textColor = [UIColor grayColor];
                title1.text = @"Distance";
                [cell.contentView addSubview:title1];
                
                UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 120, 25)];
                title2.font = [UIFont systemFontOfSize:14];
                title2.textColor = [UIColor grayColor];
                title2.text = @"(km)";
                [cell.contentView addSubview:title2];
                
                //************** add slider
                UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(100, 0, self.view.gf_width - 200, 70)];
                sliderView.tag = indexPath.row;
                sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
                sliderView.continuous = YES;
                sliderView.maximumValue = 10;
                sliderView.minimumValue = 0;
                sliderView.value = 1; // initialize
                [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:sliderView];
                
                UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 90, 20, 80, 30)];
                self.distanceLabel = distanceLabel;
                distanceLabel.textAlignment = NSTextAlignmentRight;
                distanceLabel.font = [UIFont systemFontOfSize:15];
                distanceLabel.textColor = [UIColor grayColor];
                distanceLabel.text = @"0 - 1";
                [cell.contentView addSubview:distanceLabel];
            }
            
            else if (indexPath.row == 1) {
                UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
                title1.font = [UIFont systemFontOfSize:15];
                title1.textColor = [UIColor grayColor];
                title1.text = @"Price";
                [cell.contentView addSubview:title1];
                
                UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 120, 25)];
                title2.font = [UIFont systemFontOfSize:14];
                title2.textColor = [UIColor grayColor];
                title2.text = @"(HK$)";
                [cell.contentView addSubview:title2];
                
                //************** add slider
                UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(100, 0, self.view.gf_width - 200, 70)];
                sliderView.tag = indexPath.row;
                sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
                sliderView.continuous = YES;
                sliderView.maximumValue = 2000;
                sliderView.minimumValue = 0;
                sliderView.value = 200; // initialize
                [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:sliderView];
                
                UILabel *budgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 90, 20, 80, 30)];
                self.budgetLabel = budgetLabel;
                budgetLabel.textAlignment = NSTextAlignmentRight;
                budgetLabel.font = [UIFont systemFontOfSize:15];
                budgetLabel.textColor = [UIColor grayColor];
                budgetLabel.text = @"0 - 200";
                [cell.contentView addSubview:budgetLabel];

            }
            else if (indexPath.row == 2) {
                UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.gf_width - 15 - 30, 50)];
                [textField setFont:[UIFont systemFontOfSize:15]];
                textField.textColor = [UIColor grayColor];
                self.cuisineLabel = textField;
                textField.text = @"Cuisine";
                
                //textField.delegate = self;
                //textField.tag = indexPath.row;
                //textField.placeholder = @"Cuisine";
                //[textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:textField];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 && indexPath.section == 1) {
        CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
        cuisineVC.tableType = @"Cuisine";
        cuisineVC.delegate = self;
        [self.navigationController pushViewController:cuisineVC animated:YES];
    }
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *sliderControl = sender;
    NSString *range = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    if (sliderControl.tag == 0) {
        self.distanceLabel.text = [NSString stringWithFormat:@"0 - %@", range];
        self.eventDetail.distance = [NSNumber numberWithFloat:sliderControl.value];
    } else {
        self.budgetLabel.text = [NSString stringWithFormat:@"0 - %@", range];
        self.eventDetail.maxPrice = [NSNumber numberWithFloat:sliderControl.value];
    }
}

- (void)passValueCuisine:(SearchEventDetail *)theValue {
    self.cuisineLabel.text = [NSString stringWithFormat:@"%@", theValue.cuisine.informationName.en];
}

- (void)buttonClicked {
    
    NSArray *geoPoint = [[NSArray alloc] init];
    //NSNumber *longtitudeNS = [NSNumber numberWithFloat:longitude];
    //NSNumber *latitudeNS = [NSNumber numberWithFloat:latitude];
    //geoPoint = [[NSArray alloc] initWithObjects:longtitudeNS, latitudeNS, nil];
    //NSLog(@"longtitudeNS & latitudeNS %@,  %@", longtitudeNS, latitudeNS);
    geoPoint = @[@114, @22];
    
    NSDictionary *keyFactors = [[NSDictionary alloc] init];
    NSDictionary *inData = [[NSDictionary alloc] init];
    
    keyFactors = @{
    @"keyword" : self.keywordField.text,
    //@"maxPrice" : _eventDetail.maxPrice,
    //@"minPrice" : @0,
    //@"landmark" : _eventDetail.landmark.informationID,
    //@"district" : _eventDetail.district.informationID,
    //@"cuisine" : _eventDetail.cuisine.informationID,
    //@"page" : @1,
    @"geoPoint" : geoPoint
    };
     
     inData = @{
     @"action" : @"searchRestaurant",
     @"data" : keyFactors
     };
     
     NSDictionary *parameters = @{@"data" : inData};
     
     NSLog(@"search Restaurant %@", parameters);
     
     [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
     
     NSLog(@"responseObject是接下来的%@", responseObject);
     NSLog(@"responseObject - data 是接下来的%@", responseObject[@"data"]);

     self.restaurants = [EventRestaurant mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
     RestaurantTableViewController *restaurantVC = [[RestaurantTableViewController alloc] init];
     restaurantVC.receivedData = self.restaurants;
     [self.navigationController pushViewController:restaurantVC animated:YES];
     
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     NSLog(@"%@", [error localizedDescription]);
     NSLog(@"not successful");
     [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     [SVProgressHUD dismiss];
     });
     }];
    
}



@end
