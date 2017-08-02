//
//  BadgesCollectionViewController.m
//  GFBS
//
//  Created by Alice Jin on 14/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BadgesCollectionViewController.h"
#import "GFWebViewController.h"

#import "GFSquareItem.h"
#import "BadgesSquareCell.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>

static NSString *const ID = @"ID";
static NSInteger const cols = 3;
static CGFloat  const margin = 0;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols
#define itemHH  itemHW + 50

@interface BadgesCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *badgesCollectionView;

/*所有button内容*/
@property (strong , nonatomic)NSMutableArray<GFSquareItem *> *buttonItems;

@end

@implementation BadgesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    [self setUpFunctionsCollectionView];
    [self setUpNavBar];
    //self.view.frame = [UIScreen mainScreen].bounds;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpFunctionsCollectionView
{
    [self setUpCollectionItemsData];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置尺寸
    layout.itemSize = CGSizeMake(itemHW, itemHH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    UICollectionView *badgesCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, self.view.gf_height) collectionViewLayout:layout];
    self.view.backgroundColor = [UIColor whiteColor];
    self.badgesCollectionView = badgesCollectionView;
    
    [self.view addSubview:badgesCollectionView];
    //关闭滚动
    badgesCollectionView.scrollEnabled = NO;
    
    //设置数据源和代理
    badgesCollectionView.dataSource = self;
    badgesCollectionView.delegate = self;
    
    //注册
    [badgesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BadgesSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - Setup UICollectionView Data
-(void)setUpCollectionItemsData {
    NSArray *buttonIcons = [NSArray arrayWithObjects:@"ic_badges_338x338-01.png", @"ic_badges_338x338-02.png", @"ic_badges_338x338-03.png", @"ic_badges_338x338-04.png", @"ic_badges_338x338-05.png", @"ic_badges_338x338-06.png",@"ic_badges_338x338-07.png", @"ic_badges_338x338-08.png",  nil];
    NSArray *buttonTitles = [NSArray arrayWithObjects:@"Early Bird", @"Lounge Cat", @"Heavyweight", @"Wallflower", @"Eclectic", @"Socialite",@"Researcher", @"Insomniac",  nil];
    NSArray *buttonPrice = [NSArray arrayWithObjects:@"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00", @"HK$ 5.00",@"HK$ 5.00", @"HK$ 5.00",  nil];

    //NSMutableArray<GFSquareItem *> *buttonItems =[[NSMutableArray<GFSquareItem *> alloc]init];
    //self.buttonItems = buttonItems;
    self.buttonItems = [[NSMutableArray<GFSquareItem *> alloc]init];
    for (int i = 0; i < buttonIcons.count; i++) {
        GFSquareItem *squareItem = [[GFSquareItem alloc]init];
        squareItem.icon = buttonIcons[i];
        squareItem.name = buttonTitles[i];
        squareItem.price = buttonPrice[i];
        [_buttonItems addObject:squareItem];
    }
    NSLog(@"buttonItems:%@", _buttonItems);
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"_buttonItems.count = %ld", _buttonItems.count);
    return _buttonItems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BadgesSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSLog(@"indexPath.item%ld", indexPath.item);
    NSLog(@"buttonItems indexPath.item%@", self.buttonItems[indexPath.item].name);
    
    cell.item = self.buttonItems[indexPath.item];
    
    return cell;
}

- (void)setUpNavBar
{
    UIBarButtonItem *settingBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_settings"] WithHighlighted:[UIImage imageNamed:@"ic_settings"] Target:self action:@selector(settingClicked)];
    UIBarButtonItem *notificationBtn = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-bell-o"] WithHighlighted:[UIImage imageNamed:@"ic_fa-bell-o"] Target:self action:@selector(notificationClicked)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: settingBtn, notificationBtn, nil]];
    
    
    //Title
    self.navigationItem.title = @"Badges Collection";
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GFSquareItem *item = _buttonItems[indexPath.item];
    //判断
    if (![item.url containsString:@"http"]) return;
    
    NSURL *url = [NSURL URLWithString:item.url];
    GFWebViewController *webVc = [[GFWebViewController alloc]init];
    [self.navigationController pushViewController:webVc animated:YES];
    
    //给Url赋值
    webVc.url = url;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
