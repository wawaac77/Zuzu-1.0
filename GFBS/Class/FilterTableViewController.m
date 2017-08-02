//
//  FilterTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 26/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "FilterTableViewController.h"
#import "LocationTableViewController.h"
#import "SearchEventDetail.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";

@interface FilterTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *cleanCell;
@property (weak, nonatomic) SearchEventDetail *eventDetail;
@property (strong , nonatomic)GFHTTPSessionManager *manager;
//@property (assign , nonatomic) BOOL *searchRestaurant;



@end

@implementation FilterTableViewController {
    BOOL searchRestaurant;
}
//@synthesize searchRestaurant = _searchRestaurant;

@synthesize delegate;
/*
- (void)passValue:(SearchEventDetail *)value {
    self.eventDetail = value;
    NSLog(@"_eventDetail.district in passValue %@", _eventDetail.district);
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    _eventDetail = [delegate passValue];
    NSLog(@"[delegate passValue] %@", [delegate passValue]);
    [self setUpParameters];
    self.navigationItem.title = @"Advanced Search";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpParameters {
    SearchEventDetail *eventDetail = [[SearchEventDetail alloc] init];
    self.eventDetail = eventDetail;
    
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
        return 80.0f;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (indexPath.row == 5) {
        UITableViewCell *cell5 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell = cell5;
        
        CGRect textLabelFrame = cell.textLabel.frame;
        textLabelFrame.origin.y -= 20;
        cell.textLabel.frame = textLabelFrame;
        cell.textLabel.text = @"Price Range";
        cell.accessoryType = NO;
        
        CGRect detailTextLabelFrame = cell.detailTextLabel.frame;
        detailTextLabelFrame.origin.y -= 20;
        cell.textLabel.frame = textLabelFrame;
        cell.detailTextLabel.text = @"0 - 200"; //initialize
        
        //add slider
        UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(10, 35, self.view.gf_width - 40, 40)];
        sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
        sliderView.value = 200; // initialize
        sliderView.maximumValue = 2000;
        [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:sliderView];
    
    }
    
    else if (!searchRestaurant) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Search Events";
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = DEFAULT_COLOR_GOLD;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.tintColor = DEFAULT_COLOR_GOLD;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Search Restaurant";
            cell.accessoryType = NO;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = _eventDetail.district;
            NSLog(@"_eventDetail.district %@", _eventDetail.district);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Interests";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"Cuisine";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 6) {
            cell.textLabel.text = @"Number of Guests";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    
    else if (searchRestaurant) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Search Events";
            cell.accessoryType = NO;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Search Restaurant";
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = DEFAULT_COLOR_GOLD;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.tintColor = DEFAULT_COLOR_GOLD;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"District";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Landmark";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 4) {
            //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.text = @"Cuisine";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
      return cell;
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *sliderControl = sender;
    //Default range should be get from backend
    NSString *priceRange = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    NSLog(@"The slider value is %@", priceRange);
    UITableViewCell *parentCell = (UITableViewCell *) sliderControl.superview;
    parentCell.detailTextLabel.text = [NSString stringWithFormat:@"0 - %@", priceRange];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
        if ([cell.textLabel.text isEqualToString:@"Location"]) {
            LocationTableViewController *locationVC = [[LocationTableViewController alloc] init];
            //restaurantDetailVC.topic = self.tableView[indexPath.row];
            [self.navigationController pushViewController:locationVC animated:YES];

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

-(void)searchButtonClicked {
    NSLog(@"Search button clicked");
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    NSDictionary *inData = @{
                             @"action" : @"getNearbyEventList",
                             @"data" : geoPointDic};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"Nearby events parameters %@", parameters);
    
    //发送请求
   //[_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        //字典转模型//这是给topics数组赋值的地方
        //NSLog(@"responseObject是接下来的%@", responseObject);
        //NSLog(@"responseObject - data 是接下来的%@", responseObject[@"data"]);
        
        
        //NSArray *eventsArray = responseObject[@"data"];
        /*
        
        self.nearbyEvents = [EventInList mj_objectArrayWithKeyValuesArray:eventsArray];
        NSLog(@"neaarbyEvents count in loadNewEvents%ld", _nearbyEvents.count);
        NSLog(@"nearbyEvents %@", self.nearbyEvents);
        [tableView reloadData];
        
        [tableView.mj_header endRefreshing];
        [self initGUI];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"call api failed");
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
         */
   // }];
    

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
