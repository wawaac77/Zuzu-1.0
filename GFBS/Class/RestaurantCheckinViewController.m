//
//  RestaurantCheckinViewController.m
//  GFBS
//
//  Created by Alice Jin on 31/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "RestaurantCheckinViewController.h"
#import "GFEventsCell.h"
#import "ZZContentModel.h"
//#import "ZZCommentsViewController.h"
#import "GFCommentViewController.h"
#import "RestaurantDetailViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const ID = @"ID";

@interface RestaurantCheckinViewController ()

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@end

@implementation RestaurantCheckinViewController
//@synthesize contents;

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
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self setUpTable];
    //[self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTable
{
    //self.tableView.contentInset = UIEdgeInsetsMake(33, 0, GFTabBarH, 0);
    //[self.tableView setFrame:self.view.bounds];
    //NSLog(@"table width %f",self.view.gf_width);
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 400;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GFEventsCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    //[self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZContentModel *content = _contents[indexPath.row];
    NSLog(@"contentCellHeightInPostVC %f", content.cellHeight);
    return content.cellHeight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventsCell *cell = (GFEventsCell *)[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    //**** set up restaurant button **//
    UIButton *restaurantButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 16, 264, 30)];
    restaurantButton.backgroundColor = [UIColor clearColor];
    [restaurantButton addTarget:self action:@selector(restaurantButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    restaurantButton.tag = indexPath.row;
    [cell.contentView addSubview:restaurantButton];
    
    ZZContentModel *thisContent = self.contents[indexPath.row];
    if (_contents[indexPath.row].listImage_UIImage == nil) {
        NSURL *URL = [NSURL URLWithString:_contents[indexPath.row].listImage.imageUrl];
        NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
        UIImage *image = [[UIImage alloc]initWithData:data];
        _contents[indexPath.row].listImage_UIImage = image;
    }
    cell.event = thisContent;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSIndexPath *recordIndexPath = [[NSIndexPath alloc] init];
    //self.recordIndexPath = recordIndexPath;
    //recordIndexPath = indexPath;
    
    GFCommentViewController *commentsVC = [[GFCommentViewController alloc] init];
    commentsVC.topic = [_contents objectAtIndex:indexPath.row];
    commentsVC.view.frame = CGRectMake(0, ZZNewNavH, self.view.gf_width, self.view.gf_height - ZZNewNavH - GFTabBarH);
    commentsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:commentsVC animated:YES];
    
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}


- (void) restaurantButtonClicked: (UIButton *) sender {
    ZZContentModel *thisContent = _contents[sender.tag];
    RestaurantDetailViewController *restaurantVC = [[RestaurantDetailViewController alloc] init];
    restaurantVC.thisRestaurant = thisContent.listEventRestaurant;
    [self.navigationController pushViewController:restaurantVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //清理缓存 放在这个个方法中调用频率过快
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


//************************* update cell which is hearted in commentVC ******************************//
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"indexPathForSlectedRow in viewWillAppear %@", [self.tableView indexPathForSelectedRow]);
    NSLog(@"indexPathForSlectedRow in viewWillAppear.row %ld", [self.tableView indexPathForSelectedRow].row);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow],nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
