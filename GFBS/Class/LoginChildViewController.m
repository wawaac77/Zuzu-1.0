//
//  LoginChildViewController.m
//  GFBS
//
//  Created by Alice Jin on 26/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginChildViewController.h"
#import "GFHomeViewController.h"
#import "GFEventDetailViewController.h"
#import "GFTabBarController.h"
#import "GFNavigationController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <FirebaseAuth/FirebaseAuth.h>

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
}

-(void)dismissKeyboard {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)setupLayout {
    _loginWithFacebookButton.layer.cornerRadius = 5.0f;
    _loginWithGoogleButton.layer.masksToBounds = YES;
    
    _loginWithGoogleButton.layer.cornerRadius = 5.0f;
    [_loginWithGoogleButton setClipsToBounds:YES];
    
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
            
            NSLog(@"user token = %@", thisUser.userToken);
            
            /*
             
            NSString *imageURL = thisUser.userProfileImage.imageUrl;
            NSURL  *url = [NSURL URLWithString:imageURL];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
             
            if ( urlData )
             
            {
             
            NSLog(@"Downloading started...");
             
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
             
            NSString *documentsDirectory = [paths objectAtIndex:0];
             
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"dwnld_image.png"];
             
            NSLog(@"FILE : %@",filePath);
             
            [urlData writeToFile:filePath atomically:YES];
             
            UIImage *image1=[UIImage imageWithContentsOfFile:filePath];
             
            thisUser.userProfileImage_UIImage = image1;
             
            NSLog(@"Completed...");
             
            }
             */
            
            //*************** defualt user set even app is turned off *********//
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:thisUser.userUserName forKey:@"KEY_USER_NAME"];
            [userDefaults setObject:thisUser.userToken forKey:@"KEY_USER_TOKEN"];
            [userDefaults synchronize];
            
            NSLog(@"this user %@", thisUser);
            NSLog(@"this user. userName %@", thisUser.usertName);
            NSLog(@"this user. memberId %@", thisUser.userID);

            
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
    
    NSLog(@"forget password > button clicked");
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *email = _emailTextField.text;
    NSDictionary *emailDic = @ {@"email" : email};
    NSDictionary *inData = @{
                             @"action" : @"forgetPassword",
                             @"data" : emailDic};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"upcoming events parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        NSNumber *responseStatus = [[NSNumber alloc] init];
        responseStatus = responseObject[@"status"];
       
        NSLog(@"responseStatus %@", responseStatus);
        if ([responseStatus isEqualToNumber:@1]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ZUZU" message:@"You could check your email and set new password now ^^" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"The account does not exist." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alertView show];

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    

}
- (IBAction)loginUsingFirebaseClicked:(id)sender {
    
}

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

@end
