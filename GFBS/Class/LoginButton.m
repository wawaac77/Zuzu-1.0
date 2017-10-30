//
//  LoginButton.m
//  GFBS
//
//  Created by Alice Jin on 26/5/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton

-(void)setHighlighted:(BOOL)highlighted{}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1] forState:UIControlStateSelected];
    }
    return self;
}

@end
