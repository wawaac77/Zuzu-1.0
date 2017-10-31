//
//  GFImage.h
//  GFBS
//
//  Created by Alice Jin on 5/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFImage : NSObject

@property (nonatomic, copy) NSString *imageFilename;
@property (nonatomic, assign) NSString *imageSize;
@property (nonatomic, copy) NSString *imageMimetype;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *imageOriginalname;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *imageFiletype;
@property (nonatomic, copy) NSString *imageID;

@property (nonatomic, strong) UIImage *image_UIImage;

@end
