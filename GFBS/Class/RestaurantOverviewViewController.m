//
//  RestaurantOverviewViewController.m
//  GFBS
//
//  Created by Alice Jin on 24/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantOverviewViewController.h"
#import "OverviewCell.h"

#import "UILabel+LabelHeightAndWidth.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

static NSString *const ID = @"ID";
static NSString *const basicID = @"basicID";
static NSString *const highLabelID = @"highLabelID";

@interface RestaurantOverviewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <NSString *> *iconImageArray;


@end

@implementation RestaurantOverviewViewController

@synthesize thisRestaurant;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _iconImageArray = [[NSArray alloc] initWithObjects:@"ic_location", @"ic_phone_call", @"ic_tag.png",@"ic_fa_dollar_on",@"ic_clock", @"ic_dishes",@"ic_fa-navicon", nil];
    //[self getCellHeight];
    [self setUpTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView
- (void)setUpTable
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, GFTabBarH, 0);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OverviewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:basicID];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:highLabelID];
    self.tableView.tintColor = [UIColor darkGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 44;
    
    [self.view addSubview:self.tableView];
}

/*
- (void)getCellHeight {
    cellHeight1 = [UILabel getHeightByWidth:GFScreenWidth - 45 - 10 title:thisRestaurant.restaurantAddress.en font:[UIFont systemFontOfSize:14]];
}
 */

#pragma mark - 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    if (indexPath.section == 0 && indexPath.row == 0) {
        return cellHeight1 + 20;
    }
     */
    
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    OverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.iconImageName = _iconImageArray[indexPath.row];
            cell.info = thisRestaurant.restaurantAddress;
            //cell.height = cellHeight1;
            //cellHeight1 = [UILabel getHeightByWidth:GFScreenWidth - 45 - 10 title:thisRestaurant.restaurantAddress.en font:[UIFont systemFontOfSize:14]];
        }
        
        else if (indexPath.row == 1) {
            cell.iconImageName = _iconImageArray[indexPath.row];
            
            NSString *phones = @"";
            for (int i = 0; i < thisRestaurant.phone.count; i++) {
                phones = [phones stringByAppendingString:[NSString stringWithFormat:@"%@",thisRestaurant.phone[i]]];
                NSLog(@"restaurant phone %zd", i);
                if (i != thisRestaurant.phone.count - 1) {
                    phones = [phones stringByAppendingString:@" / "];
                }
            }
            //phones = [phones stringByAppendingString:[NSString stringWithFormat:@"%@",thisRestaurant.phone[thisRestaurant.phone.count]]];
            
            cell.info = phones;
        }
        
        else if (indexPath.row == 2) {
            cell.iconImageName = _iconImageArray [indexPath.row];
            NSLog(@"thisRestaurant.restaurantCuisines %@", thisRestaurant.restaurantCuisines);
            NSLog(@"thisRestuarnat.cuisine.count %ld", thisRestaurant.restaurantCuisines.count);
            NSString *cuisines = @"";
            for (int i = 0; i < thisRestaurant.restaurantCuisines.count; i++) {
                NSLog(@"restaurant cuisine %zd", i);
                ZZTypicalInformationModel *cuisineModel = thisRestaurant.restaurantCuisines[i];
                NSLog(@"thisRestaurant.restaurantCuisines[i].informationName.en %@", cuisineModel.informationName);
                
                cuisines = [cuisines stringByAppendingString:thisRestaurant.restaurantCuisines[i].informationName];
                if (i != thisRestaurant.restaurantCuisines.count - 1) {
                cuisines = [cuisines stringByAppendingString:@", "];
                }
            }
            
            cell.info = cuisines;
            
            NSLog(@"thisRestaurant.restaurantCuisine.en %@", cuisines);
        }
        
        else if (indexPath.row == 3) {
            cell.iconImageName = _iconImageArray [indexPath.row];
            cell.info = [NSString stringWithFormat:@"HKD %@ - %@", thisRestaurant.restaurantMinPrice, thisRestaurant.restaurantMaxPrice];
        }
    }
    
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.iconImageName = _iconImageArray[indexPath.row + 4];
            cell.info = thisRestaurant.operationHour;
        }
        
        else if (indexPath.row == 1) {
            cell.iconImageName = _iconImageArray[indexPath.row + 4];
            cell.info = thisRestaurant.features;
        }
        
    }
    /*
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:basicID];
        if (cell == nil) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:basicID];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, GFScreenWidth - 40, 20)];
            [cell.contentView addSubview:label];
        }
        cell.imageView = [UIImage imageNamed:@"ic_location"];
        cell.label
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:highLabelID];
        if (cell == nil) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:highLabelID];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            [cell.contentView addSubview:imageView];
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, GFScreenWidth - 40, 0)];
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            CGFloat height = [UILabel getHeightByWidth:label.frame.size.width title:label.text font:label.font];
            label.gf_height = height;
            [cell.contentView addSubview:label];
            
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        [cell.contentView addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, GFScreenWidth - 40, 0)];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        
        CGFloat height = [UILabel getHeightByWidth:label.frame.size.width title:label.text font:label.font];
        
        
        
        
    }
    EventRestaurant *thisRestaurant = self.restaurants[indexPath.row];
    cell.restaurant = thisRestaurant;
     */
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
