//
//  DateAndTimeViewController.m
//  GFBS
//
//  Created by Alice Jin on 7/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "DateAndTimeViewController.h"

@interface DateAndTimeViewController ()

@end

@implementation DateAndTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDatePicker];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(5, 0, GFScreenWidth, 300);
    //datePicker.date = [NSData date];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //datePicker.minimumDate = [NSData date]
    
    [self.view addSubview:datePicker];
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
