//
//  ZZEventImages.h
//  GFBS
//
//  Created by Alice Jin on 9/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEventImageModel.h"

@class MyEventImageModel;
@interface ZZEventImages : NSObject

@property (nonatomic, strong) NSArray<MyEventImageModel *> *eventImages;

@end
