//
//  ZZBadgeModel.h
//  GFBS
//
//  Created by Alice Jin on 9/8/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFImage.h"
#import "TwEn.h"

@interface ZZBadgeModel : NSObject


@property (strong , nonatomic)NSString *_id;
@property (strong , nonatomic)GFImage *icon;

@property (strong , nonatomic)TwEn *name;
@property (strong , nonatomic)TwEn *badgeDescription;

@property (strong, nonatomic)NSNumber *price;

@end
