//
//  RestaurantMultiSearchViewController.m
//  GFBS
//
//  Created by Alice Jin on 21/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantMultiSearchViewController.h"

@interface RestaurantMultiSearchViewController () <UITextViewDelegate>

@property (strong, nonatomic) UITextField *interestField;
@property (strong, nonatomic) UILabel *budgetLabel;

@end

@implementation RestaurantMultiSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = [NSString stringWithFormat:@"section%ldrow%ld", indexPath.section, indexPath.row];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, self.view.gf_width - 15 - 30, 30)];
                [textField setFont:[UIFont systemFontOfSize:15]];
                
                textField.delegate = self;
                textField.tag = indexPath.row;
                self.interestField = textField;
                textField.placeholder = @"Restaurant, Cuisine, Dish";
                [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                [cell.contentView addSubview:textField];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
        }
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
                title1.font = [UIFont systemFontOfSize:15];
                title1.textColor = [UIColor grayColor];
                title1.text = @"Budget";
                [cell.contentView addSubview:title1];
                
                UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 120, 25)];
                title2.font = [UIFont systemFontOfSize:14];
                title2.textColor = [UIColor grayColor];
                title2.text = @"(HK$ per person)";
                [cell.contentView addSubview:title2];
                
                //************** add slider
                UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(135, 0, self.view.gf_width - 200, 70)];
                sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
                sliderView.continuous = YES;
                sliderView.maximumValue = 2000;
                sliderView.minimumValue = 0;
                sliderView.value = 100; // initialize
                [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:sliderView];
                
                UILabel *budgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 60, 20, 45, 30)];
                self.budgetLabel = budgetLabel;
                budgetLabel.textAlignment = NSTextAlignmentRight;
                budgetLabel.font = [UIFont systemFontOfSize:15];
                budgetLabel.textColor = [UIColor grayColor];
                budgetLabel.text = @"100";
                [cell.contentView addSubview:budgetLabel];
            }
            
            else if (indexPath.row == 1) {
                UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
                title1.font = [UIFont systemFontOfSize:15];
                title1.textColor = [UIColor grayColor];
                title1.text = @"Budget";
                [cell.contentView addSubview:title1];
                
                UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 120, 25)];
                title2.font = [UIFont systemFontOfSize:14];
                title2.textColor = [UIColor grayColor];
                title2.text = @"(HK$ per person)";
                [cell.contentView addSubview:title2];
                
                //************** add slider
                UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(135, 0, self.view.gf_width - 200, 70)];
                sliderView.minimumTrackTintColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
                sliderView.continuous = YES;
                sliderView.maximumValue = 2000;
                sliderView.minimumValue = 0;
                sliderView.value = 100; // initialize
                [sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:sliderView];
                
                UILabel *budgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(GFScreenWidth - 60, 20, 45, 30)];
                self.budgetLabel = budgetLabel;
                budgetLabel.textAlignment = NSTextAlignmentRight;
                budgetLabel.font = [UIFont systemFontOfSize:15];
                budgetLabel.textColor = [UIColor grayColor];
                budgetLabel.text = @"100";
                [cell.contentView addSubview:budgetLabel];

            }
            else if (indexPath.row == 3) {
                cell.textLabel.text = @"Cuisine";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.textColor = [UIColor grayColor];
                [cell setTintColor:[UIColor grayColor]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

        }
    }
    
    return cell;
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
