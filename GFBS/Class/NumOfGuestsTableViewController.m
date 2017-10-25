//
//  NumOfGuestsTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 10/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "NumOfGuestsTableViewController.h"
#import "SearchEventDetail.h"
#import "ZBLocalized.h"

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";

@interface NumOfGuestsTableViewController ()

@property(nonatomic ,strong) NSMutableArray<NSString *> *numOfGuestsArray;
@property(nonatomic ,strong) NSMutableArray<NSNumber *> *selected;
@property(nonatomic ,strong) SearchEventDetail *eventDetail;

@end

@implementation NumOfGuestsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ZBLocalized(@"Number of Guests", nil);
    self.eventDetail = [[SearchEventDetail alloc] init];
    self.selected = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, nil];
    [self setUpNavBar];
    [self setUpArray];
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpArray {
    self.numOfGuestsArray = [[NSMutableArray alloc] initWithObjects:@"2 - 4", @"5 - 10", @"11 - 20", @"More than 20", nil];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.numOfGuestsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.textLabel setHighlightedTextColor: [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
    }
    cell.textLabel.text = _numOfGuestsArray[indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([self.selected[indexPath.row] isEqualToNumber:@1]) {
        imageView.image = [UIImage imageNamed:@"ic_fa-check"];
        cell.textLabel.textColor = ZZGoldColor;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.accessoryView = imageView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _eventDetail.guestNumber = _numOfGuestsArray[indexPath.row];
    
    if ([_selected[indexPath.row] isEqualToNumber:@1]) {
        _selected[indexPath.row] = @0;
    } else {
        _selected[indexPath.row] = @1;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)okButtonClicked {
    NSLog(@"eventDetail in okButtonClicked interests %@", _eventDetail.interests);
    [self passValueMethod];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passValueMethod
{
    [_delegate passValueNumOfGuests:_eventDetail];
}

@end
