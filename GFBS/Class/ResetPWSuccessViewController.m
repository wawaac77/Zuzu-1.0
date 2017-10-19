//
//  ResetPWSuccessViewController.m
//  GFBS
//
//  Created by Alice Jin on 4/9/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ResetPWSuccessViewController.h"
#import "LoginViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface ResetPWSuccessViewController ()
- (IBAction)resentButtonClicked:(id)sender;
- (IBAction)loginButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *resetPWLabel;

@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation ResetPWSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_login_page"]];
    backgroundImageView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    self.resetPWLabel.textColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
    
}

- (IBAction)resentButtonClicked:(id)sender {
    NSLog(@"submit button clicked");
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *email = self.email;
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

- (IBAction)loginButtonClicked:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[LoginViewController alloc]init];
    [window makeKeyWindow];
}
@end
