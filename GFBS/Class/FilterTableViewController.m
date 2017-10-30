//
//  FilterTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 26/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "FilterTableViewController.h"
#import "LocationTableViewController.h"
#import "InterestsTableViewController.h"
#import "CuisineTableViewController.h"
#import "NumOfGuestsTableViewController.h"
#import "ZBLocalized.h"

//#import "GFSeeAllEventTableViewController.h"
#import "EventSearchResultTableViewController.h"
#import "RestaurantTableViewController.h"

#import "SearchEventDetail.h"
#import "EventRestaurant.h"
#import "EventInList.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";
static NSString*const sliderID = @"sliderID";

@interface FilterTableViewController () {
    float longitude;
    float latitude;
}

@property (weak, nonatomic) IBOutlet UITableViewCell *cleanCell;
@property (strong, nonatomic) SearchEventDetail *eventDetail;
@property (strong , nonatomic)GFHTTPSessionManager *manager;
@property (strong , nonatomic)UILabel *priceLabel;

@property (strong , nonatomic)NSMutableArray<EventRestaurant *> *restaurants;
@property (strong , nonatomic)NSMutableArray<EventInList *> *events;
//@property (assign , nonatomic) BOOL *searchRestaurant;

@end

@implementation FilterTableViewController {
    BOOL searchRestaurant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpParameters];
    self.eventDetail = [[SearchEventDetail alloc] init];
    self.navigationItem.title = ZBLocalized( @"Advanced Search", nil);
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sliderID];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"开始定位:%@",newLocation);
    [manager stopUpdatingHeading];
    //if (self.data == nil) {
    longitude = newLocation.coordinate.longitude;
    latitude =  newLocation.coordinate.latitude;
    NSLog(@"longtitude %f", longitude);
    NSLog(@"latitude %f", latitude);
    //}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位错误");
}


- (void)setUpParameters {
    self.eventDetail = [[SearchEventDetail alloc] init];
    
}

-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 90.0f;
    } else {
        return 44.0f;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!searchRestaurant) {
        return 7;
    } else {
        return 6;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID;
    UITableViewCell *cell; //消除error
    
    if (indexPath.row == 5) {
        cellID = @"sliderID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
            leftLabel.text = ZBLocalized(@"Price Range", nil) ;
            leftLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:leftLabel];
            
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 80, 40, 65, 30)];
            self.priceLabel = rightLabel;
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.text = @"0 - 200";
            rightLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:rightLabel];
           
           UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(15, 35, self.view.gf_width - 90, 40)];
            sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            
            sliderView.maximumValue = 2000;
            sliderView.minimumValue = 0;
            sliderView.value = 200; // initialize
            [sliderView addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sliderView];
        }
        return cell;
        
    } else {
        
        if (!searchRestaurant) {
            cellID = @"eventID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            }
            if (indexPath.row == 0) {
                cell.textLabel.text = ZBLocalized( @"Search Events", nil);
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.textColor = DEFAULT_COLOR_GOLD;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
                cell.tintColor = DEFAULT_COLOR_GOLD;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = ZBLocalized(@"Search Restaurant", nil);
                cell.accessoryType = NO;
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.font = [UIFont systemFontOfSize:17];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = ZBLocalized(@"Location", nil);
                cell.detailTextLabel.text = _eventDetail.location;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 3) {
                cell.textLabel.text = ZBLocalized(@"Interests", nil) ;
                cell.detailTextLabel.text = _eventDetail.interests;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 4) {
                cell.textLabel.text = ZBLocalized(@"Cuisine", nil) ;
                cell.detailTextLabel.text = _eventDetail.cuisine.informationName;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 6) {
                cell.textLabel.text = ZBLocalized(@"Number of Guests", nil);
                cell.detailTextLabel.text = _eventDetail.guestNumber;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        }
        
        else if (searchRestaurant) {
            cellID = @"restaurantID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            }
            
            if (indexPath.row == 0) {
                cell.textLabel.text = ZBLocalized(@"Search Events", nil);
                cell.accessoryType = NO;
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                
            } else if (indexPath.row == 1) {
                cell.textLabel.text = ZBLocalized(@"Search Restaurant", nil);
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.textColor = DEFAULT_COLOR_GOLD;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
                cell.tintColor = DEFAULT_COLOR_GOLD;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = ZBLocalized(@"District", nil);
                cell.detailTextLabel.text = _eventDetail.district.informationName;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 3) {
                cell.textLabel.text = ZBLocalized(@"Landmark", nil);
                cell.detailTextLabel.text = _eventDetail.landmark.informationName;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 4) {
                //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.textLabel.text = ZBLocalized(@"Cuisine", nil) ;
                cell.detailTextLabel.text = _eventDetail.cuisine.informationName;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
             return cell;
        }
    }
    return cell;
}

/*
- (IBAction)sliderValueChanged:(id)sender {
    UISlider *sliderControl = sender;
    //Default range should be get from backend
    NSString *priceRange = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    NSLog(@"The slider value is %@", priceRange);
    UITableViewCell *parentCell = (UITableViewCell *) sliderControl.superview;
    parentCell.detailTextLabel.text = [NSString stringWithFormat:@"0 - %@", priceRange];
}
 */

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && searchRestaurant == YES) {
        searchRestaurant = NO;
        [tableView reloadData];
            
    } else if (indexPath.row == 1 && searchRestaurant == NO) {
        searchRestaurant = YES;
        [tableView reloadData];
        
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:ZBLocalized(@"Location", nil)]) {
            LocationTableViewController *locationVC = [[LocationTableViewController alloc] init];
            locationVC.delegate = self;
            [self.navigationController pushViewController:locationVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:ZBLocalized(@"Interests", nil)]) {
            CuisineTableViewController *interestsVC = [[CuisineTableViewController alloc] init];
            interestsVC.tableType = @"Interests";
            interestsVC.delegate = self;
            [self.navigationController pushViewController:interestsVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:ZBLocalized(@"Cuisine", nil)]) {
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Cuisine";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:ZBLocalized(@"Number of Guests", nil)]) {
            NumOfGuestsTableViewController *numOfGuestsVC = [[NumOfGuestsTableViewController alloc] init];
            numOfGuestsVC.delegate = self;
            [self.navigationController pushViewController:numOfGuestsVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:ZBLocalized(@"District", nil)]) {
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"District";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
        } else if ([cell.textLabel.text isEqualToString:ZBLocalized(@"Landmark", nil)]) {
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Landmark";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
        }
    }
        /*
        RestaurantDetailViewController *restaurantDetailVC = [[RestaurantDetailViewController alloc] init];
        //restaurantDetailVC.topic = self.tableView[indexPath.row];
        [self.navigationController pushViewController:restaurantDetailVC animated:YES];
         */
}

#pragma -mark TableView footer

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, 50)];
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinButton.frame = CGRectMake(5, 10, self.view.gf_width - 10, 35);
    joinButton.layer.cornerRadius = 5.0f;
    joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [joinButton setClipsToBounds:YES];
    [joinButton setTitle:@"Search" forState:UIControlStateNormal];
    [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinButton setBackgroundColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
    [joinButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:joinButton];
    return footerView;
}


#pragma -search Button Clicked ----------------------
-(void)searchButtonClicked {
    NSArray *geoPoint = [[NSArray alloc] init];
    //if (longitude) {
    NSNumber *longtitudeNS = [NSNumber numberWithFloat:longitude];
    NSNumber *latitudeNS = [NSNumber numberWithFloat:latitude];
    geoPoint = [[NSArray alloc] initWithObjects:longtitudeNS, latitudeNS, nil];
    NSLog(@"longtitudeNS & latitudeNS %@,  %@", longtitudeNS, latitudeNS);
    geoPoint = @[@114, @22];
    
    if (!searchRestaurant) {
        EventSearchResultTableViewController *searchResultVC = [[EventSearchResultTableViewController alloc] init];
        //searchResultVC.keywords = searchBar.text;
        [self.navigationController pushViewController:searchResultVC animated:YES];
    } else {
        RestaurantTableViewController *restaurantVC = [[RestaurantTableViewController alloc] init];
        //restaurantVC.keywords = searchBar.text;
        [self.navigationController pushViewController:restaurantVC animated:YES];
    }

    
    NSDictionary *keyFactors = [[NSDictionary alloc] init];
    NSDictionary *inData = [[NSDictionary alloc] init];
    
    /*
    if (searchRestaurant) {
        keyFactors = @{
            @"keyword" : @"",
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

    } else {
        keyFactors = @{
            @"keyword" : @"",
            //@"maxPrice" : _eventDetail.maxPrice,
            //@"minPrice" : @0,
            //@"landmark" : _eventDetail.landmark.informationID,
            //@"district" : _eventDetail.district.informationID,
            //@"cuisine" : _eventDetail.cuisine.informationID,
            //@"interests" : _eventDetail.interests,
            //@"page" : @1,
            @"geoPoint" : geoPoint
            //@"distance" : _eventDetail.distance;
        };
        
        inData = @{
                   @"action" : @"searchEvent",
                   @"data" : keyFactors
                   };
        
    }
    
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"search Restaurant %@", parameters);
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject是接下来的%@", responseObject);
        NSLog(@"responseObject - data 是接下来的%@", responseObject[@"data"]);
        if (searchRestaurant) {
            self.restaurants = [EventRestaurant mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            RestaurantTableViewController *restaurantVC = [[RestaurantTableViewController alloc] init];
            restaurantVC.receivedData = self.restaurants;
            [self.navigationController pushViewController:restaurantVC animated:YES];

        } else {
            self.events = [EventInList mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            GFSeeAllEventTableViewController *eventsVC = [[GFSeeAllEventTableViewController alloc] init];
            eventsVC.receivedData = self.events;
            [self.navigationController pushViewController:eventsVC animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"not successful");
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
     */
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *sliderControl = sender;
    //Default range should be get from backend
    NSString *priceRange = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    NSLog(@"The slider value is %@", priceRange);
    self.priceLabel.text = [NSString stringWithFormat:@"0 - %@", priceRange];
    _eventDetail.maxPrice = [NSNumber numberWithInt:sliderControl.value];
    /*UITableViewCell *parentCell = (UITableViewCell *) sliderControl.superview;
    parentCell.detailTextLabel.text = [NSString stringWithFormat:@"0 - %@", priceRange];
     */
    
}

- (void)passValue:(SearchEventDetail *)theValue {
    
    _eventDetail.location = theValue.location;
   
    _eventDetail.distance = theValue.distance;
    
    [self.tableView reloadData];
}

- (void)passValueInterests:(SearchEventDetail *)theValue {
    _eventDetail.interests = theValue.interests;
    [self.tableView reloadData];
}

- (void)passValueCuisine:(SearchEventDetail *)theValue {
    if (theValue.cuisine != NULL) {
        _eventDetail.cuisine = theValue.cuisine;
    }
    
    if (theValue.district != NULL) {
        _eventDetail.district = theValue.district;
    }
    
    if (theValue.landmark != NULL) {
        _eventDetail.landmark = theValue.landmark;
    }
    
    [self.tableView reloadData];
}

- (void)passValueNumOfGuests:(SearchEventDetail *)theValue {
    _eventDetail.guestNumber = theValue.guestNumber;
    [self.tableView reloadData];
}

/*
- (void)passValueDistrict:(SearchEventDetail *)theValue {
    _eventDetail.district = theValue.district;
    [self.tableView reloadData];
}

- (void)passValueLandmark:(SearchEventDetail *)theValue {
    _eventDetail.landmark = theValue.landmark;
    [self.tableView reloadData];
}
 */

@end
