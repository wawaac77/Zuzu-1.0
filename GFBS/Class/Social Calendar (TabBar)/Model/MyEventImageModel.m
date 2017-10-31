//
//  MyEventImageModel.m
//  GFBS
//
//  Created by Alice Jin on 7/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyEventImageModel.h"

@implementation MyEventImageModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"restaurantImages" : @"MyEventImageModel"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"imageFilename" : @"filename",
             @"imageOriginalName" : @"originalName",
             @"imagePath" : @"path",
             @"imageSize" : @"size",
             @"imageFileType" : @"filetype",
             @"imageID" : @"_id",
             @"imageUrl" : @"url",
             };
}


@end
