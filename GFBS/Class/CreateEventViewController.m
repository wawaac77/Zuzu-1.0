//
//  CreateEventViewController.m
//  GFBS
//
//  Created by Alice Jin on 14/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "CreateEventViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
static NSString*const ID = @"ID";

@interface CreateEventViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *cleanCell;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, self.view.gf_width - 15, 50)];
    textField.textColor = [UIColor blackColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            textField.placeholder = @"Event Name";
            //UIButton *button = [[UIButton alloc] init];
            //[button setImage:[UIImage imageNamed:@"ic_fa-image"] forState:UIControlStateNormal];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
            
            [button addTarget:self action:@selector(imageButtomClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = button;
            
        } else if (indexPath.row == 1) {
            textField.placeholder = @"Guests";
        } else {
            textField.placeholder = @"Date and Time";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            textField.placeholder = @"Select Interest";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            textField.placeholder = @"Event Description";
        } else if (indexPath.row == 2) {
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            //}
            cell.textLabel.text = @"Budget(HK$ per person)";
            cell.detailTextLabel.text = @"100"; //initialize
            //add slider
            UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(120, 0, self.view.gf_width - 200, 70)];
            sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            sliderView.value = 200; // initialize
            sliderView.maximumValue = 2000;
            [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:sliderView];

        }
    }
    [textField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.contentView addSubview:textField];

    
    return cell;
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *sliderControl = sender;
    //Default range should be get from backend
    NSString *priceRange = [NSString stringWithFormat:@"%d",(int)sliderControl.value];
    NSLog(@"The slider value is %@", priceRange);
    UITableViewCell *parentCell = (UITableViewCell *) sliderControl.superview;
    parentCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", priceRange];
}

- (void)setUpNavBar
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClicked)];
    
    //Title
    self.navigationItem.title = @"New Event";
    
}

- (void)saveButtonClicked {
    NSLog(@"Save button clicked");
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
