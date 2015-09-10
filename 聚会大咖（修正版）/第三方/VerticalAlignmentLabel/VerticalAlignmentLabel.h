//
//  VerticalAlignmentLabel.h
//  ECB商学营
//
//  Created by rimi on 15/6/10.
//  Copyright (c) 2015年 吕玉梅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalAlignmentLabel.h"

typedef NS_ENUM(NSInteger, VerticalAlignment) {
    VerticalAlignmentTop = 0, // 默认顶部对齐
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};

@interface VerticalAlignmentLabel : UILabel
@property (assign, nonatomic) VerticalAlignment verticalAlignment;//设置垂直对齐方式
@end
