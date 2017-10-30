//
//  AddLLImagePickerVC.m
//  LLImagePickerDemo
//
//  Created by liushaohua on 2017/6/1.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "AddLLImagePickerVC.h"
#import "LLImagePickerView.h"

@interface AddLLImagePickerVC ()

@end

@implementation AddLLImagePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.view.frame = CGRectMake(0, 100, GFScreenWidth, 100);
    //self.tableView.frame = CGRectMake(0, 100, GFScreenWidth, 100);
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    CGFloat height = [LLImagePickerView defaultViewHeight];
    LLImagePickerView *pickerV = [[LLImagePickerView alloc]initWithFrame:CGRectMake(0, 200, GFScreenWidth, height)];
    
    //GFScreenHeight - GFTabBarH - height - 10 - 80
    pickerV.type = LLImageTypePhoto;
    pickerV.maxImageSelected = 5;
    pickerV.allowMultipleSelection = NO;
    pickerV.allowPickingVideo = YES;
    //self.tableView.tableHeaderView = pickerV;
    [self.tableView addSubview:pickerV];
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        _pickedImageArray = list;
        NSLog(@"%@",list);
    }];    
}


@end
