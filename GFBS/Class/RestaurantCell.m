//
//  RestaurantCell.m
//  GFBS
//
//  Created by Alice Jin on 18/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "RestaurantCell.h"
#import "EventRestaurant.h"
#import "ZZTypicalInformationModel.h"

#import <AFNetworking.h>
#import "UILabel+LabelHeightAndWidth.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface  RestaurantCell()
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNoticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;

@property (strong , nonatomic) GFHTTPSessionManager *manager;
@property (strong , nonatomic) EventRestaurant *thisRestaurant;

@end

@implementation RestaurantCell

-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

-(void)setRestaurant:(EventRestaurant *)restaurant
{
    self.thisRestaurant = restaurant;
    NSLog(@"restaurant.id %@, %@", restaurant.restaurantId,restaurant.restaurantName.en);
    self.restaurantImageView.clipsToBounds = YES;
    [self.restaurantImageView sd_setImageWithURL:[NSURL URLWithString:restaurant.restaurantIcon.imageUrl] placeholderImage:nil];
    _bigTitleLabel.text = restaurant.restaurantName.en;
    
    _locationLabel.text = [NSString stringWithFormat:@"%@ - %.1fkm",restaurant.restaurantDistrict.informationName.en, [restaurant.restaurantDistance floatValue] * 1000];
    NSString *cuisines = @"";
    for (int i = 0; i < restaurant.restaurantCuisines.count; i++) {
        cuisines = [cuisines stringByAppendingString:restaurant.restaurantCuisines[i].informationName.en];
    }
    _priceLabel.text = [NSString stringWithFormat:@"$%@-%@ per person | %@", restaurant.restaurantMinPrice, restaurant.restaurantMaxPrice, cuisines];
    
    
    
    if ([restaurant.isFavourite isEqual:@true]) {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-o"] forState:UIControlStateNormal];
    } else {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-grey"] forState:UIControlStateNormal];
    }
    [_heartButton addTarget:self action:@selector(likedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)likedButtonClicked: (UIButton *) sender {
    NSLog(@"self.thisEvent.listIsLike %@", self.thisRestaurant.isFavourite);
    
    if ([self.thisRestaurant.isFavourite isEqualToNumber:@1]) {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-grey"] forState:UIControlStateNormal];
        self.thisRestaurant.isFavourite = [NSNumber numberWithBool:false];
        [self likeRestaurant:false];
        
    } else {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-o"] forState:UIControlStateNormal];
        self.thisRestaurant.isFavourite = [NSNumber numberWithBool:true];
        [self likeRestaurant:true];
    }
}


- (void)likeRestaurant: (BOOL) like {
    NSLog(@"_event %@", self.thisRestaurant);
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSNumber *likeNum = [[NSNumber alloc] initWithBool:like];
    NSLog(@"likeNum %@", likeNum);
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inData = [[NSDictionary alloc] init];
  
    NSDictionary *inSubData = @{@"restaurant" : self.thisRestaurant.restaurantId, @"isFavourite" : likeNum};
    inData = @{@"action" : @"favouriteRestaurant", @"token" : userToken, @"data" : inSubData};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"publish content parameters %@", parameters);
    
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"responseObject - data is %@", responseObject[@"data"]);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
