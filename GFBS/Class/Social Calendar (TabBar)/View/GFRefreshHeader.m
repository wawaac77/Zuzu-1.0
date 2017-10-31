//
//  GFRefreshHeader.m
//  GFBS
//
//  Created by apple on 2016/11/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GFRefreshHeader.h"

@implementation GFRefreshHeader


/**
 初始化
 */
-(void)prepare
{
    [super prepare];
    self.automaticallyChangeAlpha = YES;
    self.stateLabel.textColor = [UIColor orangeColor];
    self.lastUpdatedTimeLabel.textColor = [UIColor orangeColor];
    
    [self setTitle:@"Zuzu!" forState:MJRefreshStateIdle];
    [self setTitle:@"Pull to refresh" forState:MJRefreshStatePulling];
    [self setTitle:@"Zuzuuuuuuu..." forState:MJRefreshStateRefreshing];
    
    
}

@end
