//
//  ZZChatViewController.h
//  GFBS
//
//  Created by Alice Jin on 14/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import "NSUserDefaults+DemoSettings.h"
#import "ZZMessageModel.h"

@class ZZChatViewController;

@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(ZZChatViewController *)vc;

@end


@interface ZZChatViewController : JSQMessagesViewController<UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) ZZMessageModel *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
