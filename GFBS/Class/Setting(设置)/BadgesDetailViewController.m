//
//  BadgesDetailViewController.m
//  GFBS
//
//  Created by Alice Jin on 15/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BadgesDetailViewController.h"

@interface BadgesDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation BadgesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"self.item in detail %@", self.item.name);
    _badgeImageView.image = [UIImage imageNamed:self.item.icon];
    _nameLabel.text = self.item.name;
    _descriptionTextView.text = self.item.description;
    _priceLabel.titleLabel.text = [NSString stringWithFormat:@"%@", self.item.price];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
