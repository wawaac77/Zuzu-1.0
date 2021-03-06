//
//  BadgesSquareCell.m
//  GFBS
//
//  Created by Alice Jin on 15/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BadgesSquareCell.h"
//#import "GFSquareItem.h"
#import "ZZBadgeModel.h"
#import <UIImageView+WebCache.h>

@interface BadgesSquareCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation BadgesSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItem:(ZZBadgeModel *)item
{
    _item = item;
    
    self.titleLabel.text = item.name;
    self.priceLabel.text = [NSString stringWithFormat:@"HK$ %@", item.price];
    //self.imageView.image = [UIImage imageNamed:item.icon];
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.icon.imageUrl] placeholderImage:nil];
    
}



@end
