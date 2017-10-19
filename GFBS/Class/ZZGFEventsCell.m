//
//  GFEventsCell.m
//  GFBS
//
//  Created by Alice Jin on 17/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZGFEventsCell.h"

#import "ZZContentModel.h"
#import "GFImage.h"

#import <AFNetworking.h>
#import "UILabel+LabelHeightAndWidth.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface ZZGFEventsCell()

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UILabel *textField;
//@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;

@property (strong, nonatomic) ZZContentModel *thisEvent;
@property (strong , nonatomic) GFHTTPSessionManager *manager;

/*图片View*/
//@property (weak ,nonatomic) GFTopicPictureView *pictureView;
/*声音View*/
//@property (weak ,nonatomic) GFTopicVoiceView *voiceView;
/*视频View*/
//@property (weak ,nonatomic) GFTopicVideoView *videoView;


@end

@implementation ZZGFEventsCell

/*
#pragma mark - 懒加载
-(GFTopicPictureView *)pictureView
{
    if (!_pictureView) {
        _pictureView = [GFTopicPictureView gf_viewFromXib];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}

-(GFTopicVideoView *)videoView
{
    if (!_videoView) {
        _videoView = [GFTopicVideoView gf_viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}

-(GFTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        _voiceView = [GFTopicVoiceView gf_viewFromXib];
        [self.contentView addSubview:_voiceView];
    }
    return _voiceView;
}
*/

-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}

-(void)setEvent:(ZZContentModel *)event
{
    
    ZZContentModel *thisEvent = event;
    self.thisEvent = thisEvent;
    if ([thisEvent.listIsLike isEqualToNumber:@1]) {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-o"] forState:UIControlStateNormal];
    } else {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-grey"] forState:UIControlStateNormal];
    }
    
    [_heartButton addTarget:self action:@selector(likedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    if image.width > image.height {
        imageView.contentMode = UIViewContentModeScaleAspectFit
        //since the width > height we may fit it and we'll have bands on top/bottom
    } else {
        imageView.contentMode = UIViewContentModeScaleAspectFill
        //width < height we fill it until width is taken up and clipped on top/bottom
    }
     */

    /*
    NSURL *URL = [NSURL URLWithString:thisEvent.listImage.imageUrl];
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    UIImage *image = [[UIImage alloc]initWithData:data];
    */
    
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bigImageView.clipsToBounds = YES;
    _bigImageView.image = thisEvent.listImage_UIImage;
    //[self.bigImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listImage.imageUrl] placeholderImage:nil];


    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:thisEvent.listPublishUser.userProfileImage.imageUrl] placeholderImage:nil];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    
    self.bigTitleLabel.text = thisEvent.listEventRestaurant.restaurantName;
    
    self.placeLabel.text = thisEvent.listEventRestaurant.restaurantDistrict.informationName;
    
    self.smallTitleLabel.text = thisEvent.listPublishUser.userUserName;
    
    /*
    
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.numberOfLines = 0;
    CGFloat height = [UILabel getHeightByWidth:_textField.frame.size.width title:_textField.text font:_textField.font];
    
    if (height > 50.0f) {
        height = 50.0f;
    }
     */
    CGFloat height;
    height = thisEvent.cellHeight - 337 - GFMargin;
    NSLog(@"cell not comment textField height %f", height);
    /*
    if (thisEvent.type == CommentContent) {
        height = thisEvent.cellHeightForComment - 337 - GFMargin;
        NSLog(@"cell comment textField height %f", height);
    } else {
        height = thisEvent.cellHeight - 337 - GFMargin;
        NSLog(@"cell not comment textField height %f", height);
    }
    */
    _textField.frame = CGRectMake(GFMargin, 337, GFScreenWidth - 2 * GFMargin, height);
    _textField.clipsToBounds = YES;
    _textField.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textField.text = thisEvent.listMessage;
    
    self.timeLabel.text = thisEvent.listEventUpdatedAt;
    
    //[self.profileImageButton addTarget:self action:@selector(profileImageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //[self layoutSubviews];
}

- (void)profileImageButtonClicked {
    
}

/*
- (void)layoutSubviews {
    
    CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.textField.gf_height + 350);
    CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textField.gf_height + 350);
    
    self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
    self.frame = newCellViewFrame;
    
    [super layoutSubviews];
}
 */

- (void)likedButtonClicked: (UIButton *) sender {
    NSLog(@"self.thisEvent.listIsLike %@", self.thisEvent.listIsLike);
   
    if ([self.thisEvent.listIsLike isEqualToNumber:@1]) {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-grey"] forState:UIControlStateNormal];
        self.thisEvent.listIsLike = [NSNumber numberWithBool:false];
        [self likeCheckin:false];
        
    } else {
        [_heartButton setImage:[UIImage imageNamed:@"ic_heart-o"] forState:UIControlStateNormal];
        self.thisEvent.listIsLike = [NSNumber numberWithBool:true];
        [self likeCheckin:true];
    }
}

- (void)setType:(NSString *)type {
    if ([type isEqualToString:@"comment"]) {
        _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
        /*
        //图片
        CGFloat imageViewH = _thisEvent.listImage_UIImage.size.height / _thisEvent.listImage_UIImage.size.width * GFScreenWidth;
        NSLog(@"imageViewH %f", imageViewH);
        _bigImageView.frame = CGRectMake(
                   _bigImageView.frame.origin.x,
                   _bigImageView.frame.origin.y, GFScreenWidth, imageViewH);
        */
    }
}

- (void)likeCheckin: (BOOL) like {
    NSLog(@"_event %@", self.thisEvent);
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSNumber *likeNum = [[NSNumber alloc] initWithBool:like];
    NSLog(@"likeNum %@", likeNum);
    
    NSString *userToken = [[NSString alloc] init];
    userToken = [AppDelegate APP].user.userToken;
    //NSLog(@"user token %@", userToken);
    
    NSDictionary *inData = [[NSDictionary alloc] init];
    NSString *checkinId = [[NSString alloc] initWithFormat:@"%@", self.thisEvent.listEventID];
    //NSString *checkinId = _event.listEventID;
    NSLog(@"checkinId %@", checkinId);
    NSDictionary *inSubData = @{@"checkinId" : checkinId, @"isLike" : likeNum};
    inData = @{@"action" : @"likeCheckin", @"token" : userToken, @"data" : inSubData};
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
