//
//  SubFillTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 14/9/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "SubFillTableViewController.h"
#import "EventRestaurant.h"
#import "ZZUser.h"
#import "ZBLocalized.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>

static NSString*const ID = @"ID";

@interface SubFillTableViewController ()

@property(nonatomic ,strong) NSMutableArray<NSString *> *infoArray;//

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong, nonatomic) UITextField *phoneField1;
@property (strong, nonatomic) UITextField *phoneField2;


@end

@implementation SubFillTableViewController

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
    
    self.navigationItem.title = ZBLocalized(self.tableType, nil);
    self.infoArray = [[NSMutableArray alloc] init];
    [self setUpNavBar];
    [self setUpArray];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)setUpArray {
    if ([self.tableType isEqualToString:@"Phone"]) {
        [self.infoArray addObject:@"First contact"];
        [self.infoArray addObject:@"Second contact"];
    }
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        //cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_fa_check"]];
        //[cell.textLabel setHighlightedTextColor:ZZGoldColor];
    }
    cell.textLabel.text = _infoArray[indexPath.row];
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(GFScreenWidth - 200, 9, 190, 25)];
    
    if (indexPath.row == 0) {
        self.phoneField1 = textfield;
        self.phoneField1.text = [ZZUser shareUser].phone;
    } else if (indexPath.row == 1) {
        self.phoneField2 = textfield;
    }
    textfield.borderStyle = UITextBorderStyleLine;
    [cell.contentView addSubview:textfield];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)okButtonClicked {
    if (_phoneField1.text != NULL) {
        [ZZUser shareUser].phone = _phoneField1.text;
    }
    
    /*
    if (_phoneField2.text != NULL) {
        [_thisRestaurant.phone addObject:_phoneField2.text];
    }
    */
    [self passValueMethod];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passValueMethod
{
    [_delegate passValue:[NSNumber numberWithInt:@2]];
}



@end
