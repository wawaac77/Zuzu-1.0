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
@property (strong , nonatomic) ZZFriendRequestModel *thisRequest;

@end

@implementation NotificationButtonsCell

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
 
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inSubData = @{@"friendRelationshipId" : self.thisRequest.friendshipID, @"status" : @"accepted"};
    NSDictionary *inData = @{@"action" : @"updateFriendRequestStatus", @"token" : userToken, @"data" :inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.label.text = [NSString stringWithFormat:@"%@ has become your friend.", self.thisRequest.memberRequest.userUserName];
        _acceptButton.hidden = YES;
        _declineButton.hidden = YES;
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)declineButtonClicked {
   
    NSString *userToken = [AppDelegate APP].user.userToken;
    
    NSDictionary *inSubData = @{@"friendRelationshipId" : self.thisRequest.friendshipID, @"status" : @"declined"};
    NSDictionary *inData = @{@"action" : @"updateFriendRequestStatus", @"token" : userToken, @"data" :inSubData};
    
    NSDictionary *parameters = @{@"data" : inData};
    
    [[GFHTTPSessionManager shareManager] POSTWithURLString:GetURL parameters:parameters success:^(id data) {
        
        self.label.text = [NSString stringWithFormat:@"You have declined %@'s friend request.", self.thisRequest.memberRequest.userUserName];
        _acceptButton.hidden = YES;
        _declineButton.hidden = YES;
        
    } failed:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [SVProgressHUD dismiss];
    }];
    
}


@end
