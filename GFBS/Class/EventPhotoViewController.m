//
//  EventPhotoViewController.m
//  GFBS
//
//  Created by Alice Jin on 22/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "EventPhotoViewController.h"
#import "ZZEventImages.h"
#import "MyEventImageModel.h"
#import "ZZImageCollectionCell.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const ID = @"ID";
static NSInteger const cols = 2;
static CGFloat  const margin = 1;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols


@interface EventPhotoViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

/*所有collectionView 的cell的内容*/
@property (strong, nonatomic) NSArray <MyEventImageModel *> *imagesArray ;

@property (strong ,nonatomic) UICollectionView *collectionView;

@end

@implementation EventPhotoViewController
//@synthesize thisEventID;

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
    self.view.frame = [UIScreen mainScreen].bounds;
    self.imagesArray = [[NSArray <MyEventImageModel *> alloc] init];
    [self loadNeweData];


    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNeweData {
    
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSString *eventID = self.thisEventID;
    NSLog(@"photo thisEventID %@", eventID);
    NSDictionary *forEventID = @ {@"eventId" : eventID};
    NSDictionary *inData = @{
                             @"action" : @"getEventDetail",
                             @"data" : forEventID};
    NSDictionary *parameters = @{@"data" : inData};
    
    
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        ZZEventImages *images = responseObject[@"data"];
        ZZEventImages *array = [ZZEventImages mj_objectWithKeyValues:images];
        NSLog(@"arrayCollection zzEventImages %@", array.eventImages);
        
        self.imagesArray = array.eventImages;
       
        NSLog(@"imagesArray %@", self.imagesArray);
        
        [self setUpCollectionView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        //[self.tableView.mj_footer endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
}

#pragma mark - collectionView
-(void)setUpCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置尺寸
    layout.itemSize = CGSizeMake(itemHW, itemHW);
    NSLog(@"itemHW %f", itemHW);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, GFScreenWidth, GFScreenHeight - 200) collectionViewLayout:layout];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:collectionView];
    //关闭滚动
    collectionView.scrollEnabled = YES;
    
    //设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZZImageCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

/*
#pragma mark - Setup UICollectionView Data
-(void)setUpCollectionItemsData {
    
    for (int i = 0; i < _imagesArray.count; i++) {
        ZZImageCollectionCell *squareItem = [[ZZImageCollectionCell alloc]init];
        MyEventImageModel *thisImageInformation = [_imagesArray objectAtIndex:i];
        squareItem.imageURL = thisImageInformation.imageUrl;
        [_buttonItems addObject:squareItem];
    }
    NSLog(@"buttonItems:%@", _buttonItems);
}
 */

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"imageArray.count %lu", _imagesArray.count);
    NSLog(@"imageArrayCollectionNumberofSection %@", _imagesArray);
    return self.imagesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    MyEventImageModel *thisImageInformation = [_imagesArray objectAtIndex:indexPath.row];
    cell.imageURL = thisImageInformation.imageUrl;
    NSLog(@"thisImageInformation.imageUrl %@", thisImageInformation.imageUrl);
    NSLog(@"indexPath in eventImage.item%ld", indexPath.item);
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"this image is selleceted");
}




@end
