//
//  GFCommentCell.h
//  GFBS
//
//  Created by apple on 2016/11/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZZComment;
@interface GFCommentCell : UITableViewCell

/*数据*/
@property (strong , nonatomic)ZZComment *comment;
@end
