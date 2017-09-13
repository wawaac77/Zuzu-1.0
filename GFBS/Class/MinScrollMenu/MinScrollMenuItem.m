//
//  MinScrollMenuItem.m
//  SimpleDemo
//
//  Created by songmin.zhu on 16/4/14.
//  Copyright © 2016年 zhusongmin. All rights reserved.
//

#import "MinScrollMenuItem.h"

@interface MinScrollMenuItem ()
@property (nonatomic, strong) CALayer *selectedMaskLayer;
@property (nonatomic, assign) MinScrollMenuItemType type;
@end

@implementation MinScrollMenuItem

- (instancetype)initWithType:(MinScrollMenuItemType)type reuseIdentifier:(NSString *)reuseIdentifier {
    //self = [super initWithFrame:CGRectMake(0.0, 0.0, 60.0, 60.0)];
    self = [super init];
    if (self) {
        self.type = type;
        self.reuseIdentifer = reuseIdentifier;
        [self basePropertySetup];
    }
    
    return self;
}

- (void)basePropertySetup {
    self.userInteractionEnabled = YES;
    self.contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    self.selectedMaskLayer.hidden = YES;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.selectedMaskLayer.hidden = !isSelected;
}

- (void)setType:(MinScrollMenuItemType)type {
    if (_type != type) {
        _type = type;
        
        switch (_type) {
            case BaseType:
                [_textLabel removeFromSuperview];
                _textLabel = nil;
                [_imageView removeFromSuperview];
                _imageView = nil;
                break;
            case TextType:
                [self addSubview:self.textLabel];
                break;
            case ImageType:
                [self addSubview:self.imageView];
                [self addSubview:self.textLabel];
                [self addSubview:self.timeLabel];
                break;
            default:
                break;
        }
    }
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.alpha = 1;
        //_imageView.backgroundColor = [UIColor blackColor];
        //_contentView.backgroundColor = [UIColor blackColor];
    }
    return _imageView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.contentView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
    self.selectedMaskLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
    switch (self.type) {
        case TextType:
            self.textLabel.frame = CGRectMake(1.0, 1.0, frame.size.width-2, frame.size.height-2);
            break;
        case ImageType:
            /**set imageView*/
            self.imageView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);;
            
            /**set textLabel*/
            self.textLabel.frame = CGRectMake(10.0, frame.size.height - 100.0, frame.size.width - 10, 60);
            self.textLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            self.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            self.textLabel.numberOfLines = 0;
            self.textLabel.textColor = [UIColor whiteColor];
            [self.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
            
            /**set timeLabel*/
            self.timeLabel.frame = CGRectMake(10.0, frame.size.height - 40.0, 110, 30);
            self.timeLabel.layer.cornerRadius = 8.0f;
            self.timeLabel.layer.masksToBounds = YES;
            self.timeLabel.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:167.0/255.0 blue:78.0/255.0 alpha:1];
            self.timeLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            self.timeLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            
            self.timeLabel.textColor = [UIColor whiteColor];
            [self.timeLabel setFont:[UIFont boldSystemFontOfSize:13]];
            break;
            
        default:
            break;
    }
}

- (CALayer *)selectedMaskLayer {
    if (_selectedMaskLayer == nil) {
        _selectedMaskLayer = [CALayer layer];
        _selectedMaskLayer.frame = self.layer.frame;
        _selectedMaskLayer.backgroundColor = [UIColor colorWithRed:217.00/255.00 green:217.00/255.00 blue:217.00/255.00 alpha:1.0].CGColor;
        _selectedMaskLayer.hidden = YES;
        [self.layer insertSublayer:_selectedMaskLayer atIndex:0];
    }
    
    return _selectedMaskLayer;
}


@end
