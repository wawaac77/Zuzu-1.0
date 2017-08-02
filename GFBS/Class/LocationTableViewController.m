//
//  LocationTableViewController.m
//  GFBS
//
//  Created by Alice Jin on 27/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "LocationTableViewController.h"
#import "FilterTableViewController.h"
#import "SearchEventDetail.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import "PassValueDelegate.h"

//@class FilterTableViewController;

#define DEFAULT_COLOR_GOLD [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
static NSString*const ID = @"ID";

@interface LocationTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *cleanCell;
@property(nonatomic ,strong) NSMutableArray *markArray;//要显示mark的数组
@property(nonatomic ,strong) NSMutableArray *cities;//要显示mark的数组
//@property(nonatomic ,strong) SearchEventDetail *eventDetail;

@end

@implementation LocationTableViewController

@synthesize eventDetail;
@synthesize filterVC;
//@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Location";
    [self setUpNavBar];
    [self setUpArray];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpArray {
    NSMutableArray *cities = [[NSMutableArray alloc] initWithObjects:@"Hong Kong", @"Singapore", nil];
    self.cities = cities;
    NSMutableArray *markArray = [[NSMutableArray alloc] init];
    self.markArray = markArray;
    [markArray addObject:@1];
    for (int i = 1; i < cities.count; i++) {
        [markArray addObject:@0];
    }
    NSLog(@"cities %@", cities);
    NSLog(@"markArray %@", markArray);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Distance";
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //cell.textLabel.textColor = DEFAULT_COLOR_GOLD;
        //cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.tintColor = DEFAULT_COLOR_GOLD;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Change Country";
        //cell.accessoryType = NO;
    } else {
        for (int i = 2; i < _cities.count + 2; i++) {
            NSLog(@"start for loop");
            if (indexPath.row == i) {
                cell.textLabel.text = [NSString stringWithFormat:@"  %@", [_cities objectAtIndex:i - 2]];
                //NSLog(@"cell text %@", cell.textLabel.text);
                if ([[_markArray objectAtIndex:i - 2] isEqual: @1]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.textLabel.textColor = DEFAULT_COLOR_GOLD;
                    cell.tintColor = DEFAULT_COLOR_GOLD;
                    NSLog(@"_markArray i-2 %@" , [_markArray objectAtIndex:i - 2]);
                    
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.textColor = [UIColor darkGrayColor];
                }

                
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 2; i < _cities.count + 2; i++) {
        if (indexPath.row == i) {
            [_markArray replaceObjectAtIndex:i - 2 withObject:@1];
            NSString *city = [_cities objectAtIndex:i - 2];
            //SearchEventDetail *detail = [[SearchEventDetail alloc] init];
            eventDetail.district = city;
            //[self.delegate passValue:detail];
            [tableView reloadData];
        } else {
            [_markArray replaceObjectAtIndex:i - 2 withObject:@0];
            [tableView reloadData];
        }
    }
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.gf_width, 50)];
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinButton.frame = CGRectMake(5, 10, self.view.gf_width - 10, 35);
    joinButton.layer.cornerRadius = 5.0f;
    joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [joinButton setClipsToBounds:YES];
    [joinButton setTitle:@"Ok" forState:UIControlStateNormal];
    [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinButton setBackgroundColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1]];
    [joinButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:joinButton];
    return footerView;
}
*/

- (void)setUpNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okButtonClicked)];
    
}

- (void)okButtonClicked {
    //FilterTableViewController *filterVC = [[UIStoryboard storyboardWithName:@"LocationTableViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"FilterTableViewController"];
    //SearchEventDetail *eventDetail = [[SearchEventDetail alloc] init];
    
    for (int i = 0; i < _markArray.count; i++) {
        if ([[_markArray objectAtIndex:i] isEqual:@1]) {
            eventDetail.district = [_cities objectAtIndex:i];
            break;
        }
    }
    NSLog(@"eventDetail in okButtonClicked %@", eventDetail.district);
    //[self.delegate passValue:eventDetail];
    
    FilterTableViewController *filterVC = [[FilterTableViewController alloc] init];
    //self.filterVC = filterVC;
    filterVC.delegate = self;
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (SearchEventDetail *)passValue {
    return eventDetail;
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    
    SearchEventDetail *eventDetail = [[SearchEventDetail alloc] init];
    
    for (int i = 0; i < _markArray.count; i++) {
        if ([[_markArray objectAtIndex:i] isEqual:@1]) {
            eventDetail.district = [_cities objectAtIndex:i];
            break;
        }
    }
    [self.delegate passValue:eventDetail];
    
    [super viewWillDisappear:animated];
        
    NSLog(@"%s", __func__);
}
 */

- (IBAction)rowSelected:(id)sender {
}
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
