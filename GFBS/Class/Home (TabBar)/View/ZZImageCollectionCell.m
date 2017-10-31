//
//  ZZImageCollectionCell.m
//  GFBS
//
//  Created by Alice Jin on 9/7/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "ZZImageCollectionCell.h"
#import <UIImageView+WebCache.h>

@interface ZZImageCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ZZImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
}


/*
-(void)downloadImageFromURL :(NSString *)imageUrl{
    
    NSURL  *url = [NSURL URLWithString:imageUrl];
    NSLog(@"imageURL %@", url);
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSLog(@"Downloading started...");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"dwnld_image.png"];
        NSLog(@"FILE : %@",filePath);
        [urlData writeToFile:filePath atomically:YES];
        UIImage *image1=[UIImage imageWithContentsOfFile:filePath];
        self.imageView.image = image1;
        NSLog(@"Completed...");
    }
}
*/

@end
