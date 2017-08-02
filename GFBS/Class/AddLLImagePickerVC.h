//
//  AddLLImagePickerVC.h
//  LLImagePickerDemo
//
//  Created by liushaohua on 2017/6/1.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLImagePickerView.h"

@interface AddLLImagePickerVC : UITableViewController

@property (strong, nonatomic) NSArray<LLImagePickerModel *> *pickedImageArray;

@end
