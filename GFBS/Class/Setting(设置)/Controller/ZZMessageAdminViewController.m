//
//  ZZMessageAdminViewController.m
//  GFBS
//
//  Created by Alice Jin on 26/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZMessageAdminViewController.h"
#import "GFPlaceholderTextView.h"

@interface ZZMessageAdminViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
//@property (nonatomic, weak) GFPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *tittleView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClicked:(id)sender;

@end

@implementation ZZMessageAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

-(void)dismissKeyboard {
    [_textView resignFirstResponder];
    [_tittleView resignFirstResponder];
}


- (void)setUpView {
    //GFPlaceholderTextView *textView = [[GFPlaceholderTextView alloc] initWithFrame:CGRectMake(16, 87, GFScreenWidth - 32, 252)];
    //textView.placeholder = @"Message";
    //textView.placeholderColor = [UIColor colorWithRed: 199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.masksToBounds = YES;
    [self.view addSubview:_textView];
    
    _sendButton.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
    _sendButton.layer.cornerRadius = 5.0f;
    _sendButton.layer.masksToBounds = YES;
                                
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonClicked:(id)sender {
    NSLog(@"sendButtonClicked");
}
@end
