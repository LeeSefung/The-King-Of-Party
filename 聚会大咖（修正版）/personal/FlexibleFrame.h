//
//  FlexibleFrame.h
//  屏幕适配
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FlexibleFrame : NSObject

+ (CGFloat)ratio;
+ (CGRect)frameWithIPhone5Frame:(CGRect)iPhone5Frame;


@end
