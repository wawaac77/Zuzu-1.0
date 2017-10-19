//
//  GFSettingViewController.m
//  高仿百思不得不得姐
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
//#import "InternationalControl.h"

#import "GFTabBarController.h"
#import "ZBLocalized.h"
#import "GFSettingViewController.h"
#import "ZZUser.h"
#import "ZZTypicalInformationModel.h"
#import "CuisineTableViewController.h"
#import "SubFillTableViewController.h"

#import "AboutZZViewController.h"
#import "ZZMessageAdminViewController.h"
#import "LoginViewController.h"
#import "ImagePickerViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SDImageCache.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface GFSettingViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSString *> *reuseIDArray;
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong, nonatomic) UISwitch *allowNotificationSwitch;

@property (strong, nonatomic) UIButton *changeProfileImageButton;

@end

@implementation GFSettingViewController

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
    NSLog(@"changeLanguage viewDidLoad");
    
    self.navigationItem.title = ZBLocalized(@"Settings", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
    [self setUpReuseIDArray];
    [self toggleAuthUI];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    
    //google
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    //计算整个应用程序的缓存数据 --- > 沙盒（Cache）
    //NSFileManager
    //attributesOfItemAtPathe:指定文件路径，获取文件属性
    //把所有文件尺寸加起来    //获取缓存尺寸字符串赋值给cell的textLabel
    //[self registerCell];
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickerView)];
    
    //[self.view addGestureRecognizer:tap];
    
    
}


- (void)setUpReuseIDArray {
    _reuseIDArray = [[NSMutableArray alloc] init];
    
    [_reuseIDArray insertObject:@"account" atIndex:0];
    [_reuseIDArray insertObject:@"basic" atIndex:1];
    
    for (int i = 2; i < 5; i++) {
        [_reuseIDArray insertObject:@"accessory" atIndex:i];
        NSLog(@"i = %zd", i);
    }
    
    [_reuseIDArray insertObject:@"indicator" atIndex:5];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return ZBLocalized(@"Your Account", nil);
    } else if (section == 1) {
        return ZBLocalized(@"Personal Information", nil);
    } else if (section == 2) {
        return ZBLocalized(@"Visibility", nil);
    } else if (section == 3) {
        return ZBLocalized(@"System", nil);
    }
    
    return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    NSString *cellID = _reuseIDArray[indexPath.section];
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        cellID = @"buttons";
    }
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    if (cell == nil) {
        switch (indexPath.section) {
            case 0:{
                if (indexPath.row == 3) {
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellID];
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                } else {
                    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                }
                break;
            }
                
                
            case 1:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
                break;
                
            default:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
                break;
        }
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = [AppDelegate APP].user.userUserName;
            cell.detailTextLabel.text = [ZZUser shareUser].userEmail;
            cell.imageView.image = [UIImage imageNamed:@"Ic_fa-star"];
            
            NSString *imageURL = [ZZUser shareUser].userProfileImage.imageUrl;
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 34, 34)];
            myImageView.layer.cornerRadius = myImageView.gf_width / 2;
            myImageView.clipsToBounds = YES;
            myImageView.contentMode = UIViewContentModeScaleAspectFill;
            [myImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
            [cell.contentView addSubview:myImageView];
            
            //change profile image button
            self.changeProfileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [_changeProfileImageButton addTarget:self action:@selector(changeProfileImage) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_changeProfileImageButton];
            
            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 100, 10, 90, 30)];
            accessoryLabel.textAlignment = NSTextAlignmentRight;
            accessoryLabel.font = [UIFont systemFontOfSize:15];
            accessoryLabel.text = ZBLocalized(@"Log Out >", nil);
            [cell.contentView addSubview:accessoryLabel];
            
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"Login with Facebook";
            cell.imageView.image = [UIImage imageNamed:@"Ic_fa-star"];
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 34, 34)];
            myImageView.image =[UIImage imageNamed:@"square-facebook-69x69"];
            myImageView.layer.cornerRadius = 5.0f;
            myImageView.clipsToBounds = YES;
            myImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:myImageView];
            
            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 100, 10, 90, 30)];
            accessoryLabel.textAlignment = NSTextAlignmentRight;
            accessoryLabel.font = [UIFont systemFontOfSize:15];
            
            [cell.contentView addSubview:accessoryLabel];
            
            NSLog(@"[ZZUser shareUser].userFacebookID in setting %@", [ZZUser shareUser].userFacebookID);
            
            if ([ZZUser shareUser].userFacebookID == NULL) {
                
                //accessoryLabel.text = ZBLocalized(@"Not connected", nil);
                
            } else {
                NSLog(@"facebookId in setting %@", [ZZUser shareUser].userFacebookID);
                accessoryLabel.text = ZBLocalized(@"Connected", nil);
            }
            
        }
        
        else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"Login with Goolge";
            cell.imageView.image = [UIImage imageNamed:@"Ic_fa-star"];
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 34, 34)];
            myImageView.image =[UIImage imageNamed:@"google-plus-2-512 copy.png"];
            myImageView.layer.cornerRadius = 5.0f;
            myImageView.clipsToBounds = YES;
            myImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:myImageView];
            
            UILabel *accessoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 100, 10, 90, 30)];
            accessoryLabel.textAlignment = NSTextAlignmentRight;
            accessoryLabel.font = [UIFont systemFontOfSize:15];
            
            [cell.contentView addSubview:accessoryLabel];
            
            if ([[ZZUser shareUser].userGoogleID isEqualToString:@""] || [ZZUser shareUser].userGoogleID == NULL) {
                //accessoryLabel.text = ZBLocalized(@"Not connected", nil);
            } else {
                
                NSLog(@"googleId in setting = %@", [ZZUser shareUser].userGoogleID);
                accessoryLabel.text = ZBLocalized(@"Connected", nil);
            }
            
        }
        
        else if (indexPath.row == 3) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
            [label setFont:[UIFont systemFontOfSize:15]];
            label.text = ZBLocalized(@"Language", nil);
            [cell.contentView addSubview:label];
            
            CGFloat btnWidth = (GFScreenWidth - 20 - 10) / 2;
            
            UIButton *enButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, btnWidth, 30)];
            [enButton addTarget:self action:@selector(enButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [enButton setTitle:@"English" forState:UIControlStateNormal];
            [enButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            enButton.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            enButton.layer.cornerRadius = 5.0f;
            enButton.layer.masksToBounds = YES;
            
            UIButton *twButton = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth + 20, 30, btnWidth, 30)];
            [twButton addTarget:self action:@selector(twButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [twButton setTitle:@"中文" forState:UIControlStateNormal];
            [twButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            twButton.backgroundColor = [UIColor grayColor];
            twButton.layer.cornerRadius = 5.0f;
            twButton.layer.masksToBounds = YES;
            
            [cell.contentView addSubview:enButton];
            [cell.contentView addSubview:twButton];
        }
    }
    
    else if (indexPath.section == 1) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = ZBLocalized(@"Age", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ZZUser shareUser].age] ;
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Gender", nil);
            cell.detailTextLabel.text = [ZZUser shareUser].gender;
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = ZBLocalized(@"Phone", nil) ;
            cell.detailTextLabel.text = [ZZUser shareUser].phone;
            
        } else if (indexPath.row == 3) {
            cell.textLabel.text = ZBLocalized(@"Industry", nil);
            cell.detailTextLabel.text = [ZZUser shareUser].userIndustry.informationName;
            
        } else if (indexPath.row == 4) {
            cell.textLabel.text = ZBLocalized(@"Profession", nil);
            cell.detailTextLabel.text = [ZZUser shareUser].userProfession.informationName;
            
        } else if (indexPath.row == 5) {
            cell.textLabel.text = ZBLocalized(@"Interests", nil);
            NSString *myInterests = @"";
            for (int i = 0; i < [ZZUser shareUser].userInterests.count; i++) {
                myInterests = [[NSString stringWithFormat:@"%@ ", [ZZUser shareUser].userInterests[i].informationName] stringByAppendingString: myInterests];
            }
            NSLog(@"myInterests %@", myInterests);
            cell.detailTextLabel.text = myInterests;
        }
    }
    
    else if (indexPath.section == 2) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = ZBLocalized(@"Anyone can view my profile.", nil);
            if ([[ZZUser shareUser].canSeeMyProfile isEqualToValue:@true]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Anyone can message me.", nil);
            if ([[ZZUser shareUser].canMessageMe isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else {
            cell.textLabel.text = ZBLocalized(@"Let my friends see my email address.", nil);
            if ([[ZZUser shareUser].canMyFriendSeeMyEmail isEqualToValue:@1]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        }
    }
    
    else if (indexPath.section == 3) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = ZBLocalized( @"Allow Notification", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            self.allowNotificationSwitch = switchView;
            cell.accessoryView = switchView;
            
            NSLog(@"[ZZUser shareUser].allowNotification switch %@", [ZZUser shareUser].allowNotification);
            if ([[ZZUser shareUser].allowNotification isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                NSLog(@"allowNotification switch is on");
                [switchView setOn:YES animated:NO];
            } else {
                NSLog(@"allowNotification switch is off");
                [switchView setOn:NO animated:NO];
            }
            
            switchView.tag = 0;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
        }
    }
    
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            cell.textLabel.text = ZBLocalized( @"Email Notification", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            NSLog(@"going to set switch enable ");
            if ([[ZZUser shareUser].allowNotification isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                switchView.enabled = YES;
                
            } else {
                switchView.enabled = NO;
                
            }
            
            if ([[ZZUser shareUser].emailNotification isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                [switchView setOn:YES animated:NO];
                NSLog(@"switch set to ON");
            } else {
                [switchView setOn:NO animated:NO];
                NSLog(@"switch set to off");
            }
            switchView.tag = 1;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            //[switchView release];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Sounds", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            
            if ([[ZZUser shareUser].allowNotification isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                switchView.enabled = YES;
                NSLog(@"switchView enable = YES  for sound");
            } else {
                switchView.enabled = NO;
                NSLog(@"switchView enable = NO  for sound");
            }
            
            if ([[ZZUser shareUser].sounds isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                [switchView setOn:YES animated:NO];
                NSLog(@"switch set to ON");
            } else {
                [switchView setOn:NO animated:NO];
                NSLog(@"switch set to off");
            }
            switchView.tag = 2;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
        } else if (indexPath.row == 2) {
            cell.textLabel.text = ZBLocalized(@"Show on Lock Screen", nil);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            NSLog(@"show on lock screen switch %@", [ZZUser shareUser].showOnLockScreen );            if ([[ZZUser shareUser].allowNotification isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                switchView.enabled = YES;
                NSLog(@"switchView enable = YES  for sound");
            } else {
                switchView.enabled = NO;
                NSLog(@"switchView enable = NO  for sound");
            }
            
            if ([[ZZUser shareUser].showOnLockScreen isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                [switchView setOn:YES animated:NO];
            } else {
                [switchView setOn:NO animated:NO];
            }
            switchView.tag = 3;
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    else if (indexPath.section == 5) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = ZBLocalized( @"About Zuzu", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ZBLocalized(@"Message Admin", nil) ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = ZBLocalized(@"Version 1.0", nil) ;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return 70.0f;
        } else {
            return 50.0f;
        }
    }
    return 44.0f;
}


- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    
    NSLog(@"sender.tag %zd", switchControl.tag);
    NSLog(@"This switch is %@", switchControl.on ? @"ON" : @"OFF");
    
    BOOL switchResult = switchControl.on ? @"ON" : @"OFF";
    
    //NSLog(@"swichResult %@", switchResult);
    
    if (switchControl.tag == 0) {
        [ZZUser shareUser].allowNotification = [NSNumber numberWithBool:switchResult];
        if ([switchControl.on ? @"ON" : @"OFF"  isEqual: @"OFF"]) {
            
            [ZZUser shareUser].allowNotification = @false;
            [ZZUser shareUser].emailNotification = @false;
            [ZZUser shareUser].sounds = @false;
            [ZZUser shareUser].showOnLockScreen = @false;
            
            NSLog(@"reload some sections");
            //[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 4)] withRowAnimation: UITableViewRowAnimationNone];
            
            [self.tableView reloadData];
            
        } else {
            [ZZUser shareUser].allowNotification = @true;
            
            [self.tableView reloadData];
        }
    } else if (switchControl.tag == 1) {
        [ZZUser shareUser].emailNotification = [NSNumber numberWithBool:switchResult];
    } else if (switchControl.tag == 2) {
        [ZZUser shareUser].sounds = [NSNumber numberWithBool:switchResult];
    } else if (switchControl.tag == 3) {
        [ZZUser shareUser].showOnLockScreen = [NSNumber numberWithBool:switchResult];
    }
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
 - (void)changeLanguage:(id)sender {
 /*
 NSLog(@"Change language button clicked");
 NSString *lan = [InternationalControl userLanguage];
 [InternationalControl setUserlanguage:@"zh-Hant"];
 */

/*
 if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
 
 
 
 }else{
 
 [InternationalControl setUserlanguage:@"en"];
 }
 */

//改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
//[[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
/*
 NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
 NSLog(@"切换后的语言:%@",language);
 }
 */

/*
 -(void)changeLanguageInVC{
 NSLog(@"reload VC");
 [self viewDidLoad];
 }
 */

- (void)enButtonClicked {
    NSLog(@"English button clicked");
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    
    if ([language isEqualToString:@"en"]) {
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil  message:ZBLocalized(@"Are you sure?", nil)  delegate:self cancelButtonTitle: ZBLocalized(@"Cancel", nil) otherButtonTitles:ZBLocalized(@"Yes", nil), nil];
        alertView.tag = 1;
        [alertView show];
    }
    
    NSLog(@"切换后的语言:%@",language);
}

- (void)twButtonClicked {
    NSLog(@"Chinese button clicked");
    
    NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    
    if ([language isEqualToString:@"en"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil  message:ZBLocalized(@"Are you sure to log out?", nil)  delegate:self cancelButtonTitle: ZBLocalized(@"Cancel", nil) otherButtonTitles:ZBLocalized(@"Yes", nil), nil];
        alertView.tag = 2;
        [alertView show];
        
    } else {
        
    }
    
    //NSString *language=[[ZBLocalized sharedInstance]currentLanguage];
    NSLog(@"切换后的语言:%@",language);
    
}

- (void)initRootVC{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[GFTabBarController alloc]init];
    [window makeKeyWindow];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    UIAlertView *alert = alertView;
    //log out
    if (buttonIndex == 1 && alertView.tag == 0) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [AppDelegate APP].user = nil;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:@"KEY_USER_NAME"];
        [userDefaults setObject:nil forKey:@"KEY_USER_TOKEN"];
        [userDefaults synchronize];
        
        [appDel.window makeKeyAndVisible];
        [appDel.window setRootViewController:loginVC];
        
        // change to English
    } else if (alertView.tag == 1 && buttonIndex == 1) {
        [[ZBLocalized sharedInstance]setLanguage:@"en"];
        [self initRootVC];
        
        //change to Chinese
    } else if (alertView.tag == 2 && buttonIndex == 1) {
        [[ZBLocalized sharedInstance]setLanguage:@"zh-Hant"];
        [self initRootVC];
    } else if (alertView.tag == 3 && buttonIndex == 1) { //age
        [ZZUser shareUser].age = [NSNumber numberWithInteger:[[alertView textFieldAtIndex:0].text integerValue]];
        [self.tableView reloadData];
    } else if (alertView.tag == 4 && buttonIndex == 1) { //phone
        [ZZUser shareUser].phone = [alertView textFieldAtIndex:0].text;
        [self.tableView reloadData];
    }
}

//********************* didSelectRowAtIndexPath **************************//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil  message:ZBLocalized(@"Are you sure to log out?", nil)  delegate:self cancelButtonTitle: ZBLocalized(@"Cancel", nil) otherButtonTitles:ZBLocalized(@"Yes", nil), nil];
            alertView.tag = 0;
            [alertView show];
            
        }
        else if (indexPath.row == 1) {
            [self loginFBButtonClicked];
            
        }
        
        else if (indexPath.row == 2) {
            if ([ZZUser shareUser].userGoogleID == NULL || [[ZZUser shareUser].userGoogleID isEqualToString:@""]) {
                [self loginWithGoogleClicked];
                //[self googlePlusLogoutButtonClick];
                
            } else {
                [self googlePlusLogoutButtonClick];
            }
        }
        
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            /*
             CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
             cuisineVC.tableType = @"Age";
             cuisineVC.delegate = self;
             [self.navigationController pushViewController:cuisineVC animated:YES];
             */
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:ZBLocalized(@"Please input your age", nil)  delegate:self cancelButtonTitle:ZBLocalized(@"Cancel", nil)  otherButtonTitles: ZBLocalized(@"Done", nil) , nil];
            alertView.tag = 3;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
            
        }
        
        else if (indexPath.row == 1) {
            
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Gender";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
        }
        
        else if (indexPath.row == 2) {
            /*
             SubFillTableViewController *cuisineVC = [[SubFillTableViewController alloc] init];
             cuisineVC.tableType = @"Phone";
             cuisineVC.delegate = self;
             [self.navigationController pushViewController:cuisineVC animated:YES];
             */
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:ZBLocalized(@"Please input your phone number", nil)  delegate:self cancelButtonTitle:ZBLocalized(@"Cancel", nil)  otherButtonTitles: ZBLocalized(@"Done", nil) , nil];
            alertView.tag = 4;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
        
        else if (indexPath.row == 3) {
            
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Industry";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
            
            
        }
        else if (indexPath.row == 4) {
            
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Profession";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
        }
        else if (indexPath.row == 5) {
            
            CuisineTableViewController *cuisineVC = [[CuisineTableViewController alloc] init];
            cuisineVC.tableType = @"Interests";
            cuisineVC.delegate = self;
            [self.navigationController pushViewController:cuisineVC animated:YES];
        }
    }
    else if (indexPath.section == 2) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([[ZZUser shareUser].canSeeMyProfile isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
                
                [ZZUser shareUser].canSeeMyProfile = @0;
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
                
                [ZZUser shareUser].canSeeMyProfile = @1;
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([[ZZUser shareUser].canMessageMe isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
                [ZZUser shareUser].canMessageMe = @0;
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
                [ZZUser shareUser].canMessageMe = @1;
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
        } else {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([[ZZUser shareUser].canMyFriendSeeMyEmail isEqualToNumber:[NSNumber numberWithBool:@1]]) {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-o"]];
                
                [ZZUser shareUser].canMyFriendSeeMyEmail = @0;
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
                
                [ZZUser shareUser].canMyFriendSeeMyEmail = @true;
            }
            cell.accessoryView.frame = CGRectMake(0, 0, 24, 24);
            
        }
    }
    
    else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            AboutZZViewController *aboutZZVC = [[AboutZZViewController alloc] init];
            [self.navigationController pushViewController:aboutZZVC animated:YES];
        }
        else if (indexPath.row == 1) {
            ZZMessageAdminViewController *adminVC = [[ZZMessageAdminViewController alloc] init];
            [self.navigationController pushViewController:adminVC animated:YES];
        }
    }
}

- (void)updateProfile {
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableArray<NSString *> *interestIDArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [ZZUser shareUser].userInterests.count; i++) {
        [interestIDArray addObject:[ZZUser shareUser].userInterests[i].informationID];
    }
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inSubData2 = @{
                                 @"username" : [ZZUser shareUser].userUserName,
                                 //@"googleId" : [ZZUser shareUser].userGoogleID,
                                 //@"facebookId" : [ZZUser shareUser].userFacebookID,
                                 
                                 @"age" : [ZZUser shareUser].age,
                                 @"gender" :[ZZUser shareUser].gender,
                                 @"phone" : [ZZUser shareUser].phone,
                                 @"industry" : [ZZUser shareUser].userIndustry.informationID,
                                 @"profession" : [ZZUser shareUser].userProfession.informationID,
                                 @"interests" : interestIDArray,
                                 
                                 @"allowNotification" : [ZZUser shareUser].allowNotification,
                                 @"emailNotification" : [ZZUser shareUser].emailNotification,
                                 @"showOnLockScreen" : [ZZUser shareUser].allowNotification,
                                 @"sounds" : [ZZUser shareUser].sounds,
                                 
                                 @"canSeeMyProfile" : [ZZUser shareUser].canSeeMyProfile,
                                 @"canMessageMe" : [ZZUser shareUser].canMessageMe,
                                 @"canMyFriendSeeMyEmail" : [ZZUser shareUser].canMyFriendSeeMyEmail
                                 };
    
    NSLog(@"[ZZUser shareUser].canSeeMyProfile %@", [ZZUser shareUser].canSeeMyProfile);
    NSLog(@"[ZZUser shareUser].canMessageMe %@", [ZZUser shareUser].canMessageMe);
    NSLog(@"[ZZUser shareUser].canFriendSeeMyEmail %@", [ZZUser shareUser].canMyFriendSeeMyEmail);
    
    NSDictionary *inData2 = @{@"action" : @"updateProfile", @"token" : userToken, @"data" : inSubData2,
                              };
    NSDictionary *parameters2 = @{@"data" : inData2};
    
    [_manager POST:GetURL parameters:parameters2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network for profession, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 NSLog(@"updated profile");
 [self updateProfile];
 }
 */

/*
 - (void)changeLanguage {
 NSLog(@"changeLanguage");
 
 //[[InternationalControl sharedInstance]
 //[self viewDidLoad];
 [self.tableView reloadData];
 }
 */

//************************* pass value delegate ****************************//
- (void)passValueCuisine:(ZZUser *)theValue {
    
    /*
     if (theValue.userIndustry != NULL) {
     [ZZUser shareUser].userIndustry = theValue.userIndustry;
     }
     */
    
    [self.tableView reloadData];
}

- (void)passValue:(NSNumber *)theValue {
    
    [self.tableView reloadData];
}

- (void)passSingleImage:(NSString *)theURL {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

#pragma mark - Facebook
//************************login with Facebook *******************************//
- (void)loginFBButtonClicked {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             NSLog(@"facebookToken %@", result.token);
             
             if ([FBSDKAccessToken currentAccessToken])
             {
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=id,name,age_range,birthday,devices,email,gender,last_name,family,friends,location,picture" parameters:nil]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          
                          NSString * accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                          NSLog(@"fetched user:%@ ,%@", result,accessToken);
                          
                          //fbResultData =[[NSMutableDictionary alloc]init];
                          
                          if ([result objectForKey:@"email"]) {
                              [ZZUser shareUser].facebookEmail = [result objectForKey:@"email"];
                          }
                          if ([result objectForKey:@"gender"]) {
                              [ZZUser shareUser].gender = [result objectForKey:@"gender"];
                          }
                          if ([result objectForKey:@"name"]) {
                              
                          }
                          if ([result objectForKey:@"last_name"]) {
                          }
                          if ([result objectForKey:@"id"]) {
                              
                              [ZZUser shareUser].userFacebookID = [result objectForKey:@"id"];
                              NSLog(@"[ZZUser shareUser].userFacebookID %@", [ZZUser shareUser].userFacebookID);
                              [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"id"] forKey:@"facebookUserID"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              
                          }
                          
                          FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                        initWithGraphPath:[NSString stringWithFormat:@"me/picture?type=large&redirect=false"]
                                                        parameters:nil
                                                        HTTPMethod:@"GET"];
                          [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                id result,
                                                                NSError *error) {
                              if (!error){
                                  
                                  /*
                                   if ([[result objectForKey:@"data"] objectForKey:@"url"]) {
                                   [fbResultData setObject:[[result objectForKey:@"data"] objectForKey:@"url"] forKey:@"picture"];
                                   }
                                   
                                   //You get all detail here in fbResultData
                                   NSLog(@"Final data of FB login********%@",fbResultData);
                                   [_userDefaults setObject:[NSString stringWithFormat:@"%@ %@",[fbResultData objectForKey:@"name"],[fbResultData objectForKey:@"last_name"]] forKey:@"facebookLogin"];
                                   [_userDefaults synchronize];
                                   [self showAlertForLoggedIn:[NSString stringWithFormat:@"%@ %@",[fbResultData objectForKey:@"name"],[fbResultData objectForKey:@"last_name"]]];
                                   
                                   */
                              } }];
                      }
                      else {
                          NSLog(@"result: %@",[error description]);
                          //                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error description] delegate:nil cancelButtonTitle:NSLocalizedString(@"DISMISS", nil) otherButtonTitle:nil];
                          // [alert showInView:self.view.window];
                          //[self showAlertForLoggedIn:[error description]];
                      }
                  }];
             }
             else{
                 [[FBSDKLoginManager new] logOut];
                 //                     [_customFaceBookButton setImage:[UIImage imageNamed:@"fb_connected"] forState:UIControlStateNormal];
             }
             
         }
     }];
    
    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
}

//************************ End of login with Facebook *******************************//

#pragma mark - Google
//************************* Google signin **************************//

- (void)loginWithGoogleClicked {
    [[GIDSignIn sharedInstance] signIn];
    [self.tableView reloadData];
    //self.googlePlusLogoutButtonInstance.enabled=YES;
    
}


- (void)googlePlusLogoutButtonClick {
    
    [[GIDSignIn sharedInstance] signOut];
    //[[GPPSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] disconnect];
    
    NSLog(@"google plus sign out");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"googlePlusLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"googlePlusUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ZZUser shareUser].userGoogleID = NULL;
    
    [self.tableView reloadData];
    
}



- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    // ...
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //[myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleAuthUI {
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
        // Not signed in
        //self.statusText.text = @"Google Sign in\niOS Demo";
        //self.signInButton.hidden = NO;
        //self.signOutButton.hidden = YES;
        //self.disconnectButton.hidden = YES;
    } else {
        // Signed in
        //self.signInButton.hidden = YES;
        //self.signOutButton.hidden = NO;
        //self.disconnectButton.hidden = NO;
    }
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

//************************* end of Google signin part **************************//


- (void)okButtonClicked {
    [self updateProfile];
}

- (void)changeProfileImage {
    /*
     ImagePickerViewController *imagePickerVC = [[ImagePickerViewController alloc] init];
     [self.navigationController pushViewController:imagePickerVC animated:YES];
     */
    
    PickSingleImageViewController *pickVC = [[PickSingleImageViewController alloc] init];
    [self.navigationController pushViewController:pickVC animated:YES];
    
}


/*
 -(void)viewWillAppear:(BOOL)animated{
 NSLog(@"indexPathForSlectedRow in viewWillAppear %@", [self.tableView indexPathForSelectedRow]);
 NSLog(@"indexPathForSlectedRow in viewWillAppear.row %ld", [self.tableView indexPathForSelectedRow].row);
 
 if ([self.tableView indexPathForSelectedRow].section == 0 && [self.tableView indexPathForSelectedRow].row == 0) {
 [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
 
 }
 
 }
 */

@end

