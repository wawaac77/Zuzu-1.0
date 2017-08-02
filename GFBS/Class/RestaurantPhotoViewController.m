//
//  RestaurantPhotoViewController.m
//  GFBS
//
//  Created by Alice Jin on 24/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantPhotoViewController.h"
#import "MyEventImageModel.h"
#import "ZZImageCollectionCell.h"

static NSString *const ID = @"ID";
static NSInteger const cols = 2;
static CGFloat  const margin = 1;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols


@interface RestaurantPhotoViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong ,nonatomic) UICollectionView *collectionView;
/*所有collectionView 的cell的内容*/
@property (strong, nonatomic) NSMutableArray <MyEventImageModel *> *imagesArray ;

@end

@implementation RestaurantPhotoViewController

@synthesize restaurantImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArray = [[NSMutableArray <MyEventImageModel *> alloc] initWithArray:restaurantImages];
    NSLog(@"restuarntImages in RestaurantPhotoVC %@", restaurantImages);
    NSLog(@"self.imagesArray in RestaurantPhotoVC %@", self.imagesArray);
    [self setUpCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, GFScreenWidth, GFScreenHeight - 235 - GFTabBarH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
 
    collectionView.scrollEnabled = YES;
    
    [self.view addSubview:collectionView];
    
    
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
