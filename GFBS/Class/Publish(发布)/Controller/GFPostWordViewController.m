//
//  GFPostWordViewController.m
//  GFBS
//
//  Created by apple on 2016/12/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "GFPostWordViewController.h"

#import "GFPlaceholderTextView.h"
#import "GFAddToolBar.h"

@interface GFPostWordViewController ()<UITextViewDelegate>

/** 文本输入控件 */
@property (nonatomic, weak) GFPlaceholderTextView *textView;
@property (nonatomic, weak) GFAddToolBar *toolBar;
@end

@implementation GFPostWordViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpBase];
    
    [self setUpTextView];
    
    [self setUpToolBar];
}

- (void)setUpToolBar
{
    GFAddToolBar *toolBar = [GFAddToolBar gf_toolbar];
    self.toolBar = toolBar;
    [self.view addSubview:toolBar];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChageFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 监听键盘的弹出和隐藏
- (void)keyBoardWillChageFrame:(NSNotification *)note
{
    NSLog(@"keyboard changed");
    
    //键盘最终的Frame
    CGRect keyBoadrFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //动画
    CGFloat animKey = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:animKey animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0,keyBoadrFrame.origin.y - GFScreenHeight);
    }];

}

#pragma mark - 准确布局
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _toolBar.gf_width = self.view.gf_width;
    _toolBar.gf_y = self.view.gf_height - _toolBar.gf_height;
    
}

- (void)setUpTextView
{
    NSString *username = @"Alice Jin";
    GFPlaceholderTextView *textView = [[GFPlaceholderTextView alloc] init];
    textView.placeholder = [NSString stringWithFormat:@"What's in your mind %@",username];
    textView.frame = self.view.bounds;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setUpBase
{
    self.view.backgroundColor = [UIColor whiteColor];
    //self.title = @"发表文字";
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    //self.navigationItem.rightBarButtonItem.enabled = NO; //默认不能点击
    //[self.navigationController.navigationBar layoutIfNeeded]; //强制刷新
}


/**
 退出当前界面
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 点击发表
 */
- (void)post
{
    GFBSLog(@"点击发表");
}

#pragma mark - 监听文字改变
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    //发表点击判断
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

#pragma mark - 键盘弹出和退出
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 先退出之前的键盘
    [self.view endEditing:YES];
    // 再叫出键盘
    [self.textView becomeFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

@end
