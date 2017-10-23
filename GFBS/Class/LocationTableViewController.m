//
//  LocationTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 27/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "LocationTableViewController.h"
//#import "FilterTableViewController.h"
#import "SearchEventDetail.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import "PassValueDelegate.h"
#import "ZBLocalized.h"

//@class FilterTableViewController;

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";

@interface LocationTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *cleanCell;
@property(nonatomic ,strong) NSMutableArray *markArray;//要显示mark的数组
@property(nonatomic ,strong) NSMutableArray<NSString *> *cities;//要显示mark的数组
@property (strong , nonatomic)UILabel *distanceLabel;
//@property(nonatomic ,strong) SearchEventDetail *eventDetail;

@end

@implementation LocationTableViewController

@synthesize eventDetail;
//@synthesize filterVC;
//@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  ZBLocalized(@"Location", nil);
    eventDetail = [[SearchEventDetail alloc] init];
    [self setUpNavBar];
    [self setUpArray];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    //UILabel *blankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, 1)];
    //[self.tableView.tableFooterView addSubview:blankLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpArray {
    NSMutableArray *cities = [[NSMutableArray alloc] initWithObjects:ZBLocalized(@"Hong Kong", nil), ZBLocalized(@"Singapore", nil), nil];
    self.cities = cities;
    NSMutableArray *markArray = [[NSMutableArray alloc] init];
    self.markArray = markArray;
    [markArray addObject:@1];
    for (int i = 1; i < cities.count; i++) {
        [markArray addObject:@0];
    }
    NSLog(@"cities %@", cities);
    NSLog(@"markArray %@", markArray);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 90;
    } else {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sliderID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sliderID"];
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
            leftLabel.text =ZBLocalized(@"Distance", nil);
            leftLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:leftLabel];
            
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 80, 40, 65, 30)];
            self.distanceLabel = rightLabel;
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.text = @"2 km";
            rightLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:rightLabel];
            
            UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(15, 35, self.view.gf_width - 90, 40)];
            sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            sliderView.maximumValue = 10;
            sliderView.minimumValue = 0;
            sliderView.value = 2; // initialize
            [sliderView addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sliderView];
        }
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Change Country", nil);
            //cell.accessoryType = NO;
        } else {
            for (int i = 2; i < _cities.count + 2; i++) {
                NSLog(@"start for loop");
                if (indexPath.row == i) {
                    cell.textLabel.text = [NSString stringWithFormat:@"  %@", [_cities objectAtIndex:i - 2]];
                    //NSLog(@"cell text %@", cell.textLabel.text);
                    if ([[_markArray objectAtIndex:i - 2] isEqual: @1]) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        cell.textLabel.textColor = DEFAULT_COLOR_GOLD;
                        cell.tintColor = DEFAULT_COLOR_GOLD;
                        NSLog(@"_markArray i-2 %@" , [_markArray objectAtIndex:i - 2]);
                        
                    } else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.textLabel.textColor = [UIColor darkGrayColor];
                    }
                    
                }
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 2; i < _cities.count + 2; i++) {
        if (indexPath.row == i) {
            [_markArray replaceObjectAtIndex:i - 2 withObject:@1];
            NSString *city = [NSString stringWithFormat:@"%@", [_cities objectAtIndex:i - 2]];
            //SearchEventDetail *detail = [[SearchEventDetail alloc] init];
            eventDetail.district = city;
            //[self.delegate passValue:detail];
            [tableView reloadData];
        } else {
            [_markArray replaceObjectAtIndex:i - 2 withObject:@0];
            [tableView reloadData];
        }
    }
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *sliderControl = sender;
    NSString *distanceRange = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ km", distanceRange];
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)okButtonClicked {
    for (int i = 0; i < _markArray.count; i++) {
        if ([[_markArray objectAtIndex:i] isEqual:@1]) {
            eventDetail.location = [_cities objectAtIndex:i];
            break;
        }
    }
    eventDetail.distance = _distanceLabel.text;
    NSLog(@"eventDetail in okButtonClicked %@", eventDetail.location);
    NSLog(@"eventDetail in okButtonClicked %@", eventDetail.distance);
    [self passValueMethod];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passValueMethod
{
    [_delegate passValue:eventDetail];
}

- (IBAction)rowSelected:(id)sender {
}


@end
