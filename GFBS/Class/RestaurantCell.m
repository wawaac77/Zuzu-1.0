//
//  RestaurantCell.m
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RestaurantCell.h"
#import "EventRestaurant.h"
#import "ZZTypicalInformationModel.h"
#import <UIImageView+WebCache.h>

@interface  RestaurantCell()
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNoticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;

@end

@implementation RestaurantCell


-(void)setRestaurant:(EventRestaurant *)restaurant
{
    EventRestaurant *thisRestaurant = restaurant;
    self.restaurantImageView.clipsToBounds = YES;
    [self.restaurantImageView sd_setImageWithURL:[NSURL URLWithString:thisRestaurant.restaurantIcon.imageUrl] placeholderImage:nil];
    _bigTitleLabel.text = restaurant.restaurantName.en;
    //restaurant.restaurantDistance
    float distance = [thisRestaurant.restaurantDistance floatValue];
    distance = distance * 1000;
    _locationLabel.text = [NSString stringWithFormat:@"%@ - %.1fkm",thisRestaurant.restaurantDistrict.informationName.en, distance];
    NSString *cuisines = @"";
    for (int i = 0; i < thisRestaurant.restaurantCuisines.count; i++) {
        cuisines = [cuisines stringByAppendingString:thisRestaurant.restaurantCuisines[i].informationName.en];
    }
    _priceLabel.text = [NSString stringWithFormat:@"$%@-%@ per person | %@", thisRestaurant.restaurantMinPrice, thisRestaurant.restaurantMaxPrice, cuisines];
}

/*
-(void) downloadImageFromURL :(NSString *)imageUrl{
    
    NSURL  *url = [NSURL URLWithString:imageUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSLog(@"Downloading started...");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"dwnld_image.png"];
        NSLog(@"FILE : %@",filePath);
        [urlData writeToFile:filePath atomically:YES];
        UIImage *image1=[UIImage imageWithContentsOfFile:filePath];
        self.restaurantImageView.image=image1;
        NSLog(@"Completed...");
    }
    
}
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
