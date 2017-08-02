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
@import Firebase;
#import <Fabric/Fabric.h>
#import "Crashlytics/Crashlytics.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize user;

+ (AppDelegate *) APP {
    return  (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefault objectForKey:@"KEY_USER_NAME"];
    NSString *userToken = [userDefault objectForKey:@"KEY_USER_TOKEN"];
    
    if (userToken != nil) {
        
        ///UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //window.rootViewController = [[GFTabBarController alloc]init];
        
        user = [[ZZUser alloc] init];
        user.userToken = userToken;
        user.userUserName = username;
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
    
    NSArray *imageNameArray = @[@"guide-1.jpg",@"guide-2.jpg",@"guide-3"];
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
    
    return YES;
}

// [START openurl]
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}
// [END openurl]

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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
