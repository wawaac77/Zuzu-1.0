//
//  SearchPageViewController.m
//  GFBS
//
//  Created by Alice Jin on 3/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "SearchPageViewController.h"

@interface SearchPageViewController ()

@property (weak ,nonatomic) UISearchBar *searchBar;

@end

@implementation SearchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, GFScreenWidth, 90)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpNavBar
{
    //add search bar
    //self.navigationController.navigationBar.barStyle =
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.searchBar = searchBar;
    //searchBar.tintColor = [UIColor darkGrayColor];
    //searchBar.frame = CGRectMake(5, 0, GFScreenWidth - 50, 20);
    //searchBar1.backgroundColor = [UIColor whiteColor];
    searchBar.placeholder = @"Event name, interest, restaurant";
    self.navigationItem.titleView = searchBar;
    
    //[self.navigationController.navigationBar addSubview:searchBar1];
    
    //左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_logo"] WithHighlighted:[UIImage imageNamed:@"ic_logo"] Target:self action:@selector(logo)];
    
    //右边
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"ic_fa-filter"] WithHighlighted:[UIImage imageNamed:@"ic_fa-filter"] Target:self action:@selector(filterButton)];
    
    //TitieView
    //self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    //self.navigationItem.title = @"Search Bar should be here!";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
