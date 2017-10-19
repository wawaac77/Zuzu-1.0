//
//  AppDelegate.m
//  GFBS
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import <SDImageCache.h>
#import "GFTabBarController.h"
#import "GFAdViewController.h"
#import "LoginViewController.h"
#import "DHGuidePageHUD.h"
#import "ZBLocalized.h"
@import Firebase;
#import <Fabric/Fabric.h>
#import "Crashlytics/Crashlytics.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>


@interface AppDelegate ()

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation AppDelegate

@synthesize user;

+ (AppDelegate *) APP {
    return  (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefault objectForKey:@"KEY_USER_NAME"];
    NSString *userToken = [userDefault objectForKey:@"KEY_USER_TOKEN"];
    NSNumber *socialLevel = [userDefault objectForKey:@"KEY_USER_SOCIAL_LEVEL"];
    NSNumber *organizeLevel = [userDefault objectForKey:@"KEY_USER_ORGANIZE_LEVEL"];
    NSString *profilePicUrl = [userDefault objectForKey:@"KEY_USER_PROFILE_PICURL"];
    NSString *userlang = [userDefault objectForKey:@"KEY_USER_PROFILE_LANG"];
    NSString *googleUserID = [userDefault objectForKey:@"googlePlusUserID"];
    NSString *facebookUserID = [userDefault objectForKey:@"facebookUserID"];
    
    if (userToken != nil) {
        
        ///UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //window.rootViewController = [[GFTabBarController alloc]init];
        
        user = [[ZZUser alloc] init];
        user.userToken = userToken;
        user.userUserName = username;
        user.socialLevel = socialLevel;
        user.userOrganizingLevel = organizeLevel;
        user.userProfileImage.imageUrl = profilePicUrl;
        user.preferredLanguage = userlang;
        
        NSLog(@"user default profile imageUrl at appDelegate %@", user.userProfileImage.imageUrl);
        
        //user instance
        [ZZUser shareUser].userToken = userToken;
        [ZZUser shareUser].userUserName = username;
        [ZZUser shareUser].preferredLanguage = userlang;
        [ZZUser shareUser].userGoogleID = googleUserID;
        [ZZUser shareUser].userFacebookID = facebookUserID;
        
        //初始化语言
        if ([userlang isEqualToString:@"en"]) {
            [[ZBLocalized sharedInstance]setLanguage:@"en"];
        } else if ([userlang isEqualToString:@"tw"]) {
            [[ZBLocalized sharedInstance]setLanguage:@"zh-Hant"];
        } else {
            [[ZBLocalized sharedInstance]initLanguage];
        }
        
        
        GFTabBarController *tabVC = [[GFTabBarController alloc] init];
        self.window.rootViewController = tabVC;
        
        [self.window makeKeyAndVisible];
        NSLog(@"userToken in default user %@", userToken);
        
        return YES;
    }
    
    //广告控制器
//    GFAdViewController *adVC = [[GFAdViewController alloc]init];
    
    //GFTabBarController *tabVc = [[GFTabBarController alloc] init];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;

    
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
    }
    
    NSArray *imageNameArray = @[@"tutorial-1242x2208-1.jpg",@"tutorial-1242x2208-2.jpg",@"tutorial-1242x2208-3.jpg"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.window.frame imageNameArray:imageNameArray buttonIsHidden:YES];
    [self.window addSubview:guidePage];
    
    //清除过期缓存
    [[SDImageCache sharedImageCache] cleanDisk];
    
    [GFTopWindow gf_show];
    [FIRApp configure];
    
    /******** Google+ signin *********/
    //NSError* configureError;
    //[[GGLContext sharedInstance] configureWithError: &configureError];
    //NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].clientID = @"YOUR_CLIENT_ID";
    [GIDSignIn sharedInstance].delegate = self;
    
    /******** Facebook signin *********/
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

/************************* Facebook ************************/

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    [FBSDKAppEvents activateApp];
}

// [START openurl]
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    /************************* Facebook ************************/
    NSLog(@"application openURL");
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
    /************************* Google+ ************************/
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}
// [END openurl]

/************************* Google+ ************************/

// [START signin_handler]
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
    // [START_EXCLUDE]
    NSDictionary *statusText = @{@"statusText":
                                     [NSString stringWithFormat:@"Signed in user: %@",
                                      fullName]};
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    // [END_EXCLUDE]
}
// [END signin_handler]

// This callback is triggered after the disconnect call that revokes data
// access to the user's resources has completed.
// [START disconnect_handler]
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // [START_EXCLUDE]
    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    // [END_EXCLUDE]
}
// [END disconnect_handler]

- (void)googleLogin {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSDictionary *inSubData = @ {@"googleId" : [ZZUser shareUser].userGoogleID};
    NSDictionary *inData = @{
                             @"action" : @"googleLogin",
                             @"data" : inSubData};
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
            
            
            //*************** defualt user set even app is turned off *********//
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:thisUser.userUserName forKey:@"KEY_USER_NAME"];
            [userDefaults setObject:thisUser.userToken forKey:@"KEY_USER_TOKEN"];
            
            thisUser.preferredLanguage = @"en"; //should add this parameter in google login API
            [userDefaults setObject:thisUser.preferredLanguage forKey:@"KEY_USER_LANG"];
            [userDefaults synchronize];
            
            NSLog(@"this user %@", thisUser);
            NSLog(@"this user. userName %@", thisUser.usertName);
            NSLog(@"this user. memberId %@", thisUser.userID);
            NSLog(@"this user. preferredLanguage %@", thisUser.preferredLanguage);
            
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
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
