//
//  FlexibleFrame.m
//  屏幕适配
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FlexibleFrame.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define IPHONE5_SIZE CGSizeMake(320,568)

@implementation FlexibleFrame

+ (CGFloat)ratio {
    return SCREEN_SIZE.height/IPHONE5_SIZE.height;
}

+ (CGRect)frameWithIPhone5Frame:(CGRect)iPhone5Frame {

    CGFloat x = iPhone5Frame.origin.x*[self ratio];
    CGFloat y = iPhone5Frame.origin.y*[self ratio];
    CGFloat width = iPhone5Frame.size.width*[self ratio];
    CGFloat height = iPhone5Frame.size.height*[self ratio];
    return CGRectMake(x, y, width, height);
}

@end









