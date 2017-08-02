//
//  SignUpChildViewController.h
//  GFBS
//
//  Created by Alice Jin on 26/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn.h>

@interface SignUpChildViewController : UIViewController <GIDSignInDelegate>
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleSignInButton;

@end
