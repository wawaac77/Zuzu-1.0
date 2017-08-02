//
//  BadgesSquareCell.m
//  GFBS
//
//  Created by Alice Jin on 15/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BadgesSquareCell.h"
#import "GFSquareItem.h"
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

-(void)setItem:(GFSquareItem *)item
{
    _item = item;
    
    
    self.titleLabel.text = item.name;
    self.priceLabel.text = item.price;
    self.imageView.image = [UIImage imageNamed:item.icon];
    //设置图片
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:nil];
    
}



@end
