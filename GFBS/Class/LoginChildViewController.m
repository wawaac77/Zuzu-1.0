//
//  LoginChildViewController.m
//  GFBS
//
//  Created by Alice Jin on 26/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginChildViewController.h"
//#import "GFHomeViewController.h"
#import "GFEventDetailViewController.h"
#import "GFTabBarController.h"
#import "GFNavigationController.h"
#import "ForgetPasswordViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginChildViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginWithFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *loginWithGoogleButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonClicked:(id)sender;
- (IBAction)forgetPasswordClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginUsingFirebaseButton;
- (IBAction)loginUsingFirebaseClicked:(id)sender;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation LoginChildViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    [self setupLayout];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSString *nameOfLoginUser = [result valueForKey:@"name"];
                NSString *idOfLoginUser = [result valueForKey:@"id"];
                
                 NSLog(@"facebook public_profile nameOfLoginUser %@", nameOfLoginUser);
                NSLog(@"facebook id nameOfLoginUser %@", idOfLoginUser);
                
                NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                //NSURL *url = [[NSURL alloc] initWithURL: imageStringOfLoginUser];
                //[self.imageView setImageWithURL:url placeholderImage: nil];
            }
        }];
        
    }
}

-(void)dismissKeyboard {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)setupLayout {

    _loginWithFacebookButton.layer.cornerRadius = 5.0f;
    _loginWithFacebookButton.layer.masksToBounds = YES;
    _loginWithFacebookButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1];
    [_loginWithFacebookButton addTarget:self action:@selector(loginFBButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _loginWithGoogleButton.layer.cornerRadius = 5.0f;
    [_loginWithGoogleButton setClipsToBounds:YES];
    _loginWithGoogleButton.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:72.0/255.0 blue:54.0/255.0 alpha:1];
    
    _passwordTextField.secureTextEntry = YES;
    /*
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
     */
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextButtonClicked:(id)sender {
    
    NSLog(@"next > button clicked");
    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //window.rootViewController = [[GFTabBarController alloc]init];
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *email = _emailTextField.text;
    NSString *password = _passwordTextField.text;
    if (email.length == 0) {
        _emailTextField.text = @"alicej@gmail.com";
        _passwordTextField.text =@"123456";

    }
    
    NSDictionary *emailAndPassword = @ {@"email" : email, @"password" : password};
    NSDictionary *inData = @{
                             @"action" : @"login",
                             @"data" : emailAndPassword};
    NSDictionary *parameters = @{@"data" : inData};

    NSLog(@"upcoming events parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        ZZUser *thisUser = [[ZZUser alloc] init];
        thisUser = [ZZUser mj_objectWithKeyValues:responseObject[@"data"]];
        
        
        if (thisUser == nil) {
            
            [SVProgressHUD showWithStatus:@"Incorrect Email or password ><"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        } else {
            
            [AppDelegate APP].user = [[ZZUser alloc] init];
            [AppDelegate APP].user = thisUser;
            
            NSURL *URL = [NSURL URLWithString:thisUser.userProfileImage.imageUrl];
            NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
            UIImage *image = [[UIImage alloc]initWithData:data];
            [AppDelegate APP].user.userProfileImage_UIImage = image;
            
            //*************** defualt user set even app is turned off *********//
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:thisUser.userUserName forKey:@"KEY_USER_NAME"];
            [userDefaults setObject:thisUser.userToken forKey:@"KEY_USER_TOKEN"];
            [userDefaults setObject:thisUser.socialLevel forKey:@"KEY_USER_SOCIAL_LEVEL"];
            [userDefaults setObject:thisUser.userOrganizingLevel forKey:@"KEY_USER_ORGANIZE_LEVEL"];
            [userDefaults setObject:thisUser.userProfileImage.imageUrl forKey:@"KEY_USER_PROFILE_PICURL"];
            if (thisUser.preferredLanguage == NULL) {
                thisUser.preferredLanguage = @"en";
            }
            [userDefaults setObject:thisUser.preferredLanguage forKey:@"KEY_USER_LANG"];
            [userDefaults synchronize];

            NSLog(@"this user %@", thisUser);
            NSLog(@"this user. userName %@", thisUser.usertName);
            NSLog(@"this user. memberId %@", thisUser.userID);

            //*************** user instance *********//
            [ZZUser shareUser].userID = thisUser.userID;
            [ZZUser shareUser].userUpdatedAt = thisUser.userUpdatedAt;
            [ZZUser shareUser].userCreatedAt = thisUser.userCreatedAt;
            [ZZUser shareUser].usertName = thisUser.usertName;
            [ZZUser shareUser].userEmail = thisUser.userEmail;
            //[ZZUser shareUser].usertPassword = thisUser.usertPassword;
            [ZZUser shareUser].userUserName = thisUser.userUserName;
            [ZZUser shareUser].userStatus = thisUser.userStatus;
            [ZZUser shareUser].userToken = thisUser.userToken;
            //[ZZUser shareUser].userFacebookID = thisUser.userFacebookID;
            //[ZZUser shareUser].userGoogleID = thisUser.userGoogleID;
            [ZZUser shareUser].userOrganizingExp = thisUser.userOrganizingExp;
            [ZZUser shareUser].userOrganizingLevel = thisUser.userOrganizingLevel;
            [ZZUser shareUser].socialExp = thisUser.socialExp;
            [ZZUser shareUser].socialLevel = thisUser.socialLevel;
            [ZZUser shareUser].checkinPoint = thisUser.checkinPoint;
            [ZZUser shareUser].userInterests = [[NSMutableArray alloc] init];
            [ZZUser shareUser].userInterests = thisUser.userInterests;
            [ZZUser shareUser].userLastCheckIn = thisUser.userLastCheckIn;
            [ZZUser shareUser].age = thisUser.age;
            [ZZUser shareUser].gender = thisUser.gender;
            [ZZUser shareUser].userIndustry = thisUser.userIndustry;
            [ZZUser shareUser].userProfession = thisUser.userProfession;
            [ZZUser shareUser].maxPrice = thisUser.maxPrice;
            [ZZUser shareUser].minPrice = thisUser.minPrice;
            [ZZUser shareUser].preferredLanguage = thisUser.preferredLanguage;
            [ZZUser shareUser].numOfFollower = thisUser.numOfFollower;
            [ZZUser shareUser].showOnLockScreen = thisUser.showOnLockScreen;
            [ZZUser shareUser].sounds = thisUser.sounds;
            [ZZUser shareUser].emailNotification = thisUser.emailNotification;
            [ZZUser shareUser].allowNotification = thisUser.allowNotification;
            [ZZUser shareUser].canSeeMyProfile = thisUser.canSeeMyProfile;
            [ZZUser shareUser].canMessageMe = thisUser.canMessageMe;
            [ZZUser shareUser].canMyFriendSeeMyEmail = thisUser.canMyFriendSeeMyEmail;
            [ZZUser shareUser].notificationNum = thisUser.notificationNum;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[GFTabBarController alloc]init];
            [window makeKeyWindow];
            /*
            [[FIRAuth auth]signInWithEmail:self.emailTextField.text
                                  password:self.passwordTextField.text
                                completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                    if (error) {
                                        NSLog(@"%@", [error localizedDescription]);
                                        
                                        [SVProgressHUD showWithStatus:@"Busy network, please try later"];
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [SVProgressHUD dismiss];
                                        });
                                        
                                        
                                    }
                                    else{
             
                                        [AppDelegate APP].user = [[ZZUser alloc] init];
                                        [AppDelegate APP].user = thisUser;
                                        
                                        NSLog(@"user token = %@", thisUser.userToken);
                                        
                                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                        window.rootViewController = [[GFTabBarController alloc]init];
                                    }
                                }];
             */
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];

}

- (IBAction)forgetPasswordClicked:(id)sender {
    
    ForgetPasswordViewController *forgetVC = [[ForgetPasswordViewController alloc] init];
    forgetVC.view.frame = [UIScreen mainScreen].bounds;
    [self presentViewController:forgetVC animated:YES completion:nil];

}

- (IBAction)loginUsingFirebaseClicked:(id)sender {
    
}


//************************login with Facebook *******************************//
/*
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
             
             /*
             NSString *nameOfLoginUser = [result valueForKey:@"name"];
             NSLog(@"facebook public_profile nameOfLoginUser %@", nameOfLoginUser);
             
             NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
             //NSURL *url = [[NSURL alloc] initWithURL: imageStringOfLoginUser];
             //[self.imageView setImageWithURL:url placeholderImage: nil];
             
             //NSLog(@"facebookId %@", result.);
             */
/*
         }
     }];
}
*/

#pragma mark - 监听键盘的弹出和隐藏
/*
- (void)keyBoardWillChageFrame:(NSNotification *)note
{
    //键盘最终的Frame
    CGRect keyBoadrFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //动画
    CGFloat animKey = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animKey animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0,keyBoadrFrame.origin.y - GFScreenHeight);
    }];
    NSLog(@"KeyboardFrame.origin.y %f", keyBoadrFrame.origin.y);
    
}
 */

- (void)keyBoardWillHide:(NSNotification *)note
{
    //键盘最终的Frame
    CGRect keyBoadrFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //动画
    CGFloat animKey = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animKey animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, - keyBoadrFrame.origin.y + GFScreenHeight);
    }];
    NSLog(@"KeyboardFrame.origin.y %f", keyBoadrFrame.origin.y);
}

- (void)keyBoardWillShow: (NSNotification *)note
{
    //键盘最终的Frame
    CGRect keyBoadrFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //动画
    CGFloat animKey = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animKey animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0,keyBoadrFrame.origin.y - GFScreenHeight + 50);
    }];
    NSLog(@"KeyboardFrame.origin.y %f", keyBoadrFrame.origin.y);
    
}

/*
#pragma mark - 键盘弹出和退出
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 先退出之前的键盘
    [self.view endEditing:YES];
    // 再叫出键盘
    [self.emailTextField becomeFirstResponder];
}
 */

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
    
    
}
//************************* End of Facebook signin part **************************//

@end
