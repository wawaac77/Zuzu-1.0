//
//  RestaurantMenuViewController.m
//  GFBS
//
//  Created by Alice Jin on 24/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantMenuViewController.h"
#import "MyEventImageModel.h"
#import "ZZImageCollectionCell.h"

static NSString *const ID = @"ID";
static NSInteger const cols = 2;
static CGFloat  const margin = 1;

#define itemHW  (GFScreenWidth - (cols - 1) * margin ) / cols

@interface RestaurantMenuViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong ,nonatomic) UICollectionView *collectionView;
/*所有collectionView 的cell的内容*/
@property (strong, nonatomic) NSMutableArray <MyEventImageModel *> *imagesArray ;
@end

@implementation RestaurantMenuViewController
@synthesize menuImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesArray = [[NSMutableArray <MyEventImageModel *> alloc] initWithArray:menuImages];
   
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
    //self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:collectionView];
    //关闭滚动
    collectionView.scrollEnabled = YES;
    
    //设置数据源和代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZZImageCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

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
