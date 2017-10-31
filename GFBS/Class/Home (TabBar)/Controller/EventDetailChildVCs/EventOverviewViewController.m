//
//  EventOverviewViewController.m
//  GFBS
//
//  Created by Alice Jin on 26/10/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "EventOverviewViewController.h"
#import "OverviewCell.h"

#import "UILabel+LabelHeightAndWidth.h"
#import "ZBLocalized.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

static NSString *const ID = @"ID";
static NSString *const basicID = @"basicID";
static NSString *const highLabelID = @"highLabelID";

@interface EventOverviewViewController ()

@property (strong, nonatomic) NSArray <NSString *> *iconImageArray;

@end

@implementation EventOverviewViewController

@synthesize thisEvent;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iconImageArray = [[NSArray alloc] initWithObjects:@"ic_fa-star_gold", @"ic_fa-users-on", @"ic_clock", @"ic_location", @"ic_tag", @"ic_fa-coffee", @"ic_fa_dollar_on", nil];
    [self setUpTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTable {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OverviewCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
 */


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 1;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.iconImageName = _iconImageArray[indexPath.row];
            cell.info = thisEvent.eventHost.userUserName;
        }
        
        else if (indexPath.row == 1) {
            cell.iconImageName = _iconImageArray[indexPath.row];
            NSString *peopleStr = ZBLocalized(@"People", nil);
            cell.info = [NSString stringWithFormat:@"%@/%@ %@", thisEvent.listEventJoinedCount ,thisEvent.listEventQuota, peopleStr];
        }
        
        else if (indexPath.row == 2) {
            cell.iconImageName = _iconImageArray [indexPath.row];
            cell.info = [NSString stringWithFormat:@"%@, Ends %@", thisEvent.listEventStartDate, thisEvent.listEventEndDate];
        }
        
        else if (indexPath.row == 3) {
            cell.iconImageName = _iconImageArray [indexPath.row];
            NSString *restaurantBarStr = ZBLocalized(@"Restaurant & Bar", nil);
            cell.info = [NSString stringWithFormat:@"%@ %@",restaurantBarStr, thisEvent.listEventRestaurant.restaurantAddress];
        }
    }
    
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.iconImageName = _iconImageArray[indexPath.row + 4];
            cell.info = thisEvent.eventCuisine.informationName;
        }
        
        else if (indexPath.row == 1) {
            cell.iconImageName = _iconImageArray[indexPath.row + 4];
            cell.info = thisEvent.listEventRestaurant.features;
        }
        else if (indexPath.row == 1) {
            cell.iconImageName = _iconImageArray[indexPath.row + 4];
            cell.info = thisEvent.listEventRestaurant.features;
        }
        else if (indexPath.row == 2) {
            cell.iconImageName = _iconImageArray[indexPath.row + 4];
            NSString *perPersonStr = ZBLocalized(@"per person", nil);
            cell.info = [NSString stringWithFormat:@"HK%@ %@", thisEvent.listEventBudget, perPersonStr];
        }
    }
    
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.iconImageName = @"";
            cell.info = thisEvent.listEventDescription;
        }
    }
    return cell;
}

@end
