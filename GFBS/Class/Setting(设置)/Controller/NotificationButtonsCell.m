//
//  NotificationButtonsCell.m
//  GFBS
//
//  Created by Alice Jin on 26/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationButtonsCell.h"
#import "ZZFriendRequestModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface NotificationButtonsCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (strong , nonatomic) GFHTTPSessionManager *manager;
@property (strong , nonatomic) ZZFriendRequestModel *thisRequest;

@end

@implementation NotificationButtonsCell

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequest:(ZZFriendRequestModel *)request {
    self.thisRequest = request;
    NSString *friendName = request.memberRequest.userUserName;
    _label.text = [NSString stringWithFormat:@"%@ sent you a friend request.", friendName];
    
    
    _acceptButton.layer.cornerRadius = 5.0f;
    _acceptButton.clipsToBounds = YES;
    [_acceptButton addTarget:self action:@selector(acceptButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _declineButton.layer.cornerRadius = 5.0f;
    _declineButton.clipsToBounds = YES;
    [_declineButton addTarget:self action:@selector(declineButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)acceptButtonClicked {
    NSLog(@"accept button clicked");
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数

    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inSubData = @{@"friendRelationshipId" : self.thisRequest.friendshipID, @"status" : @"accepted"};
    NSDictionary *inData = @{@"action" : @"updateFriendRequestStatus", @"token" : userToken, @"data" :inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        self.label.text = [NSString stringWithFormat:@"%@ has become your friend.", self.thisRequest.memberRequest.userUserName];
        _acceptButton.hidden = YES;
        _declineButton.hidden = YES;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    }];
    
    
    
}

- (void)declineButtonClicked {
    NSLog(@"declineButtonClicked");
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inSubData = @{@"friendRelationshipId" : self.thisRequest.friendshipID, @"status" : @"declined"};
    NSDictionary *inData = @{@"action" : @"updateFriendRequestStatus", @"token" : userToken, @"data" :inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        self.label.text = [NSString stringWithFormat:@"You have declined %@'s friend request.", self.thisRequest.memberRequest.userUserName];
        _acceptButton.hidden = YES;
        _declineButton.hidden = YES;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
        });
        
    }];
    
}


@end
