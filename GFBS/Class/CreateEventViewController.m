//
//  CreateEventViewController.m
//  GFBS
//
//  Created by Alice Jin on 14/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "DateAndTimeViewController.h"
#import "BannerListTableViewController.h"
#import "CreateEventViewController.h"
#import "ZZTypicalInformationModel.h"
#import "RestaurantMultiSearchViewController.h"

#import "EventInList.h"
#import "ZZBannerModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <SVProgressHUD.h>
//static NSString*const ID = @"ID";

@interface CreateEventViewController () <ChildViewControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableViewCell *cleanCell;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) ZZBannerModel *bannerImage;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIImageView *bannerImageView;

@property (strong, nonatomic) UILabel *budgetLabel;
@property (strong, nonatomic) UITextField *eventNameField;
@property (strong, nonatomic) UITextField *guestNumField;
@property (strong, nonatomic) UITextField *dateField;
@property (strong, nonatomic) UITextField *endDateField;
@property (strong, nonatomic) UITextField *interestField;
@property (strong, nonatomic) UITextView *descripField;

@property (strong, nonatomic) NSMutableArray<ZZTypicalInformationModel *> *interestsArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *interests;

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong, nonatomic) EventInList *eventCreated;

@end

@implementation CreateEventViewController

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
    [self setUpNavBar];
    self.interests = [[NSMutableArray alloc] init];
    self.interestsArray = [[NSMutableArray alloc] init];
    [self loadInterestsData];
    self.tableView.scrollEnabled = YES;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.eventCreated = [[EventInList alloc] init];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        if (_bannerImage != nil) {
            return 120;
        } else {
            return 0;
        }

    } else if ((indexPath.section == 1) && (indexPath.row == 1)) {
        return 120;
    } else if ((indexPath.section == 1) && (indexPath.row == 2)) {
        return 70;
    } else {
        return 44;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        NSLog(@"section");
        return 5;
    } else {
        NSLog(@"section2");
        return 4;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"section%ldrow%ld", indexPath.section, indexPath.row];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, self.view.gf_width - 15 - 30, 30)];
        [textField setFont:[UIFont systemFontOfSize:15]];
        //textField.textColor = [UIColor blackColor];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                //******** banner preview imageView ******//
                if (_bannerImage != nil) {
                    UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, GFScreenWidth - 20, 115)];
                    //NSURL *URL = [NSURL URLWithString:_bannerImage.image.imageUrl];
                    //NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
                    //UIImage *image = [[UIImage alloc]initWithData:data];
                    //bannerImageView.image = image;
                    //NSLog(@"hihi~~~~~~~~~");
                    self.bannerImageView = bannerImageView;
                    bannerImageView.image = _bannerImage.image.image_UIImage;
                    bannerImageView.clipsToBounds = YES;
                    bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
                    [cell.contentView addSubview:bannerImageView];
                }
                
                
            } else if (indexPath.row == 1) {
                self.eventNameField = textField;
                textField.placeholder = @"Event Name";
                [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:textField];
                
                //*********** add image button *******//
                UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
                self.button = button;
                [button addTarget:self action:@selector(imageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = button;
                
                
            } else if (indexPath.row == 2) {
                self.guestNumField = textField;
                textField.placeholder = @"Number of guests";
                textField.keyboardType = UIKeyboardTypeNumberPad;
                [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:textField];
                
            } else {
                if (indexPath.row == 3) {
                    self.dateField = textField;
                    textField.placeholder = @"Start date and time";
                } else {
                    self.endDateField = textField;
                    textField.placeholder = @"End date and time";
                }
                //self.dateField = textField;
                
                textField.delegate = self;
                textField.tag = indexPath.row;
                [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:textField];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                self.datePicker = datePicker;
                datePicker.backgroundColor = [UIColor whiteColor];
                datePicker.frame = CGRectMake(5, 0, GFScreenWidth, 300);
                //datePicker.date = [NSData date];
                datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
                datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                NSLog(@"datepicker date %@", datePicker.date);
                //datePicker.minimumDate = [NSData date]
                textField.inputView = datePicker;
                
                UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, 44)];
                //toolBar.barStyle = UIBarStyleDefault;
                toolBar.barTintColor = [UIColor blackColor];
                UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDoneButtonClicked:)];
                //[[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
                [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
                
                [textField setInputAccessoryView: toolBar];
                //[self.view addSubview:datePicker];
                
            }
        }
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                self.interestField = textField;
                textField.placeholder = @"Select Interest";
                textField.tag = 5 + indexPath.row;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:textField];
                
                UIPickerView *picker = [[UIPickerView alloc] init];
                self.pickerView = picker;
                picker.dataSource = self;
                picker.delegate = self;
                textField.inputView = picker;
                picker.backgroundColor = [UIColor whiteColor];
                
                UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, GFScreenWidth, 44)];
                //toolBar.barStyle = UIBarStyleDefault;
                toolBar.barTintColor = [UIColor blackColor];
                UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDoneButtonClicked:)];
                //[[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
                [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
                
                [textField setInputAccessoryView: toolBar];
                
                
            } else if (indexPath.row == 1) {
                UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 30)];
                descriptionLabel.text = @"Event Description";
                descriptionLabel.font = [UIFont systemFontOfSize:15];
                descriptionLabel.textColor = [UIColor grayColor];
                [cell.contentView addSubview:descriptionLabel];
                
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, GFScreenWidth - 10, 120 - 30)];
                self.descripField = textView;
                [cell.contentView addSubview:textView];
                
            } else if (indexPath.row == 2) {
                UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
                title1.font = [UIFont systemFontOfSize:15];
                title1.textColor = [UIColor grayColor];
                title1.text = @"Budget";
                [cell.contentView addSubview:title1];
                
                UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 120, 25)];
                title2.font = [UIFont systemFontOfSize:14];
                title2.textColor = [UIColor grayColor];
                title2.text = @"(HK$ per person)";
                [cell.contentView addSubview:title2];
                
                //************** add slider
                UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(135, 0, self.view.gf_width - 200, 70)];
                sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
                sliderView.continuous = YES;
                sliderView.maximumValue = 2000;
                sliderView.minimumValue = 0;
                sliderView.value = 100; // initialize
                [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:sliderView];
                
                UILabel *budgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 60, 20, 45, 30)];
                self.budgetLabel = budgetLabel;
                budgetLabel.textAlignment = NSTextAlignmentRight;
                budgetLabel.font = [UIFont systemFontOfSize:15];
                budgetLabel.textColor = [UIColor grayColor];
                budgetLabel.text = @"100";
                [cell.contentView addSubview:budgetLabel];
            }
            
            else if (indexPath.row == 3) {
                cell.textLabel.text = @"Select restaurant";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.textColor = [UIColor grayColor];
                [cell setTintColor:[UIColor grayColor]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    } else {
        if (indexPath.section == 0 && indexPath.row == 0) {
            if (_bannerImage != nil) {
                UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, GFScreenWidth - 20, 115)];
                //NSURL *URL = [NSURL URLWithString:_bannerImage.image.imageUrl];
                //NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
                //UIImage *image = [[UIImage alloc]initWithData:data];
                //bannerImageView.image = image;
                //NSLog(@"hihi~~~~~~~~~");
                self.bannerImageView = bannerImageView;
                bannerImageView.image = _bannerImage.image.image_UIImage;
                bannerImageView.clipsToBounds = YES;
                bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
                [cell.contentView addSubview:bannerImageView];
            }
        }
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if ((indexPath.section == 0) && (indexPath.row == 3)) {
        DateAndTimeViewController *dateVC = [[DateAndTimeViewController alloc] init];
        [self.navigationController pushViewController:dateVC animated:YES];
    }
     */
    if ((indexPath.section == 1) && (indexPath.row == 3)) {
        RestaurantMultiSearchViewController *restaurantSearchVC = [[RestaurantMultiSearchViewController alloc] init];
        restaurantSearchVC.title = @"Search Restaurant";
        [self.navigationController pushViewController:restaurantSearchVC animated:YES];
        
    }
    
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *sliderControl = sender;
    //Default range should be get from backend
    NSString *priceRange = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    NSLog(@"The slider value is %@", priceRange);
    //UITableViewCell *parentCell = (UITableViewCell *) sliderControl.superview;
    //parentCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", priceRange];
    _budgetLabel.text = priceRange;
}


- (void)setUpNavBar
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    
    //Title
    self.navigationItem.title = @"New Event";
    
}

- (void)saveButtonClicked {
    NSLog(@"Save button clicked");
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSLog(@"_eventNameField.text %@", _eventNameField.text);
    NSLog(@"_bannerImage._id %@", _bannerImage._id);
    NSLog(@"_budgetLabel.text %@",  _budgetLabel.text);
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    //----------------get profession array-----------------//
    
    
    NSDictionary *inSubData2 = @{
                                 @"name" : _eventNameField.text,
                                 //@"banner" : _bannerImage._id,
                                 //@"guestNumber" : _guestNumField.text,
                                 //@"startDate" : _dateField.text,
                                 //@"endDate" : _endDateField.text,
                                 //@"interests" : @"",
                                 //@"isPrivate" : @true,
                                 //@"descriotion" : _descripField.text,
                                 //@"budget" : _budgetLabel.text,
                                 //@"restaurant" : _thisUser.userIndustry.informationID,
                                 //@"status" : @"incomplete",
                                
                                 };
    NSDictionary *inData2 = @{@"action" : @"createEvent", @"token" : userToken, @"data" : inSubData2};
    NSDictionary *parameters2 = @{@"data" : inData2};
    
    [_manager POST:GetURL parameters:parameters2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObjectCreateEvent %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

- (void)imageButtonClicked {
    BannerListTableViewController *bannerVC = [[BannerListTableViewController alloc] init];
    bannerVC.delegate = self;
    [self.navigationController pushViewController:bannerVC animated:YES];
}

- (void) passValue:(ZZBannerModel *)theValue {
    self.bannerImage = theValue;
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSLog(@"self.bannerImage theValue %@", theValue.image.imageUrl);
    self.bannerImageView.image = theValue.image.image_UIImage;
    [self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)pickerDoneButtonClicked:(id)sender {
    //[self.dateField resignFirstResponder];
    [self.dateField resignFirstResponder];
    [self.endDateField resignFirstResponder];
    [self.interestField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY HH:mm"];
    
    if (textField.tag == 3) {
        textField.text=[NSString stringWithFormat:@"Starts at %@",[formatter stringFromDate:_datePicker.date]];
    } else if (textField.tag == 4) {
        textField.text=[NSString stringWithFormat:@"Ends at %@",[formatter stringFromDate:_datePicker.date]];
    }
    
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma  -loadInterestsArray
- (void)loadInterestsData {
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    //NSString *userToken = [AppDelegate APP].user.userToken;
    
    //----------------get interests array-----------------//
    NSDictionary *inData2 = @{@"action" : @"getInterestList"};
    
    NSDictionary *parameters2 = @{@"data" : inData2};
    
    [_manager POST:GetURL parameters:parameters2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        self.interestsArray = [ZZTypicalInformationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //self.interests = [[NSMutableArray alloc] init];
        for (int i = 0; i < _interestsArray.count; i++) {
            [self.interests addObject:_interestsArray[i].informationName];
            NSLog(@"_interestsArray[i].informationName %@", _interestsArray[i].informationName);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network for interest, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

#pragma -picke view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [_interests count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [_interests objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //_selectedItem = [_interests objectAtIndex:row];
    
    _interestField.text = [_interests objectAtIndex:row];
   
    [_interestField resignFirstResponder];
    
}




@end
