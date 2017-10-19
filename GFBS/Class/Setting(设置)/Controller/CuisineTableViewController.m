//
//  CuisineTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 10/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "CuisineTableViewController.h"
#import "ZBLocalized.h"
#import "ZZUser.h"
#import "ZZTypicalInformationModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";

@interface CuisineTableViewController ()

@property(nonatomic ,strong) NSMutableArray<ZZTypicalInformationModel *> *cuisineArray;

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation CuisineTableViewController


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
    
    self.navigationItem.title = ZBLocalized(self.tableType, nil) ;
    self.thisUser = [[ZZUser alloc] init];
    
    
    [self setUpNavBar];
    
    if ([self.tableType isEqualToString: @"Gender"]) {
        self.cuisineArray = [[NSMutableArray alloc] init];
        
        ZZTypicalInformationModel *female = [[ZZTypicalInformationModel alloc] init];
        female.informationName = ZBLocalized(@"Female", nil);
                [_cuisineArray addObject:female];
        
        ZZTypicalInformationModel *male = [[ZZTypicalInformationModel alloc] init];
        male.informationName = ZBLocalized(@"Male", nil);
        [_cuisineArray addObject:male];
        
        if ([[ZZUser shareUser].gender isEqualToString:female.informationName]) {
            _cuisineArray[0].selected = @1;
        } else {
            _cuisineArray[1].selected = @1;
        }

        
    }
    
    else if ([self.tableType isEqualToString: @"Age"]) {
        self.cuisineArray = [[NSMutableArray alloc] initWithCapacity:120];
        
        for (int i = 0; i < 120; i++) {

            ZZTypicalInformationModel *age = [[ZZTypicalInformationModel alloc] init];
            age.informationName = [NSString stringWithFormat:@"%zd", i];
            [_cuisineArray addObject:age];
            
            //self.cuisineArray[i].informationName = [NSString stringWithFormat:@"%zd", i];
            
            if (i == [[ZZUser shareUser].age intValue]) {
                self.cuisineArray[i].selected = @1;
            }
        }
    }
    
    else {
        [self setUpArray];
    }
   
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpArray {
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USER_LANG"];
    if ([userLang isEqualToString:@"zh-Hant"]) {
        userLang = @"tw";
    }
    
    NSDictionary *inData = [[NSDictionary alloc] init];
    if ([self.tableType isEqualToString: @"Industry"]) {
        inData = @{@"action" : @"getIndustryList", @"lang" : userLang};
    }

    else if ([self.tableType isEqualToString: @"Profession"]) {
        inData = @{@"action" : @"getProfessionList", @"lang" : userLang};
    }
    else if ([self.tableType isEqualToString: @"Interests"]) {
        inData = @{@"action" : @"getInterestList", @"lang" : userLang};
    }
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        NSLog(@"response %@", responseObject[@"data"]);
        
        self.cuisineArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if ([self.tableType isEqualToString: @"Industry"]) {
            for (int i = 0; i < _cuisineArray.count; i ++) {
                if ([_cuisineArray[i].informationName isEqualToString:[ZZUser shareUser].userIndustry.informationName]) {
                    _cuisineArray[i].selected = @1;
                    NSLog(@"_cuisineArray selected %@", _cuisineArray[i].informationName);
                } else {
                    _cuisineArray[i].selected = @0;
                    
                }
            }
            
        }
        
        else if ([self.tableType isEqualToString: @"Profession"]) {
            for (int i = 0; i < _cuisineArray.count; i ++) {
                if ([_cuisineArray[i].informationName isEqualToString:[ZZUser shareUser].userProfession.informationName]) {
                    _cuisineArray[i].selected = @1;
                    NSLog(@"_cuisineArray selected %@", _cuisineArray[i].informationName);
                } else {
                    _cuisineArray[i].selected = @0;

                }
            }
            
        }
        
        else if ([self.tableType isEqualToString: @"Interests"]) {
            for (int i = 0; i < _cuisineArray.count; i ++) {
                for (int j = 0; j < [ZZUser shareUser].userInterests.count; j++) {
                    if ([_cuisineArray[i].informationName isEqualToString:[ZZUser shareUser].userInterests[j].informationName]) {
                        _cuisineArray[i].selected = @1;
                        NSLog(@"_cuisineArray selected %@", _cuisineArray[i].informationName);
                    } else {
                        _cuisineArray[i].selected = @0;
                        
                    }
                }
            }
            
        }
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cuisineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        //cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_fa_check"]];
        //[cell.textLabel setHighlightedTextColor:ZZGoldColor];
    }
    cell.textLabel.text = _cuisineArray[indexPath.row].informationName;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([_cuisineArray[indexPath.row].selected isEqual:@1]) {
        imageView.image = [UIImage imageNamed:@"ic_fa-check"];
        cell.textLabel.textColor = ZZGoldColor;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.accessoryView = imageView;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //General select change
    if ([self.tableType isEqualToString:@"Interests"]) { //multiphe selection
        if ([_cuisineArray[indexPath.row].selected isEqual:@1]) {
            _cuisineArray[indexPath.row].selected = 0;
        } else {
            _cuisineArray[indexPath.row].selected = @1;
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if ([self.tableType isEqualToString:@"Industry"] || [self.tableType isEqualToString:@"Profession"] || [self.tableType isEqualToString:@"Gender"] || [self.tableType isEqualToString:@"Age"] ) { // can only select one
        _cuisineArray[indexPath.row].selected = @1;
        for (int i = 0; i < _cuisineArray.count; i++) {
            if (!(i == indexPath.row)) {
                _cuisineArray[i].selected = @0;
            }
        }
        
        [self.tableView reloadData];
    }
    
}

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)okButtonClicked {
    
    if ([self.tableType isEqualToString: @"Interests"]) {
        _thisUser.userInterests = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _cuisineArray.count; i++) {
            if ([_cuisineArray[i].selected isEqual:@1]) {
                
                [_thisUser.userInterests addObject:_cuisineArray[i]];
                NSLog(@"_cuisine array %@", _cuisineArray[i]);
                
            }
        }
        
        [ZZUser shareUser].userInterests = _thisUser.userInterests;
        
    }
    
    else if ([self.tableType isEqualToString: @"Industry"]) {
        
        for (int i = 0; i < _cuisineArray.count; i++) {
            if ([_cuisineArray[i].selected isEqual:@1]) {
                _thisUser.userIndustry = _cuisineArray[i];
                break;
            }
        }
        
        [ZZUser shareUser].userIndustry = _thisUser.userIndustry;
    }
    
    else if ([self.tableType isEqualToString: @"Profession"]) {
        
        for (int i = 0; i < _cuisineArray.count; i++) {
            if ([_cuisineArray[i].selected isEqual:@1]) {
                _thisUser.userProfession = _cuisineArray[i];
                break;
            }
        }
        
        [ZZUser shareUser].userProfession = _thisUser.userProfession;
    }
    
    else if ([self.tableType isEqualToString: @"Gender"]) {
        
        for (int i = 0; i < _cuisineArray.count; i++) {
            if ([_cuisineArray[i].selected isEqual:@1]) {
                _thisUser.gender = _cuisineArray[i].informationName;
                break;
            }
        }
        
        [ZZUser shareUser].gender = _thisUser.gender;
    }
    
    else if ([self.tableType isEqualToString: @"Age"]) {
        
        for (int i = 0; i < _cuisineArray.count; i++) {
            if ([_cuisineArray[i].selected isEqual:@1]) {
                _thisUser.age = [NSNumber numberWithInteger:[_cuisineArray[i].informationName integerValue]];
                break;
            }
        }
        
        [ZZUser shareUser].age = _thisUser.age;
    }
    
    [self passValueMethod];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passValueMethod
{
    [_delegate passValueCuisine:_thisUser];
}

@end
