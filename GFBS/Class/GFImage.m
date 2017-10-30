//
//  GFImage.m
//  GFBS
//
//  Created by Alice Jin on 5/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "GFImage.h"
#import <MJExtension.h>

@implementation GFImage

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"imageFilename" : @"filename",
             @"imageSize" : @"size",
             @"imageMimetype" : @"mimetype",
             @"imageUrl" : @"url",
             
             @"imageOriginalname": @"originalname",
             @"imagePath": @"path",
             @"imageFiletype": @"filetype",
             @"imageID": @"_id",
             };
}

@end
