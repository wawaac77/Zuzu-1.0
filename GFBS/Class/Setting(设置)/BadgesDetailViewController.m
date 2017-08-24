//
//  BadgesDetailViewController.m
//  GFBS
//
//  Created by Alice Jin on 15/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BadgesDetailViewController.h"
#import <UIImageView+WebCache.h>

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
    NSLog(@"self.item in detail %@", self.item.name);
    
    [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:self.item.icon.imageUrl] placeholderImage:nil];
    _nameLabel.text = self.item.name.en;
    _descriptionTextView.text = self.item.badgeDescription.en;
    _priceLabel.titleLabel.text = [NSString stringWithFormat:@"HK$ %@", self.item.price];
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
