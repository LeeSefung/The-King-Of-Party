//
//  UIView+Flexible.m
//  屏幕适配
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "UIView+Flexible.h"

@implementation UIView (Flexible)

- (instancetype)initWithIPhone5Frame:(CGRect)frame
{
    self = [self initWithFrame:[FlexibleFrame frameWithIPhone5Frame:frame]];
    return self;
}

- (void)setBoundsAfterProcess:(CGRect)bounds
{
    CGFloat x = bounds.origin.x*SIZE_RATIO;
    CGFloat y = bounds.origin.y*SIZE_RATIO;
    CGFloat width = bounds.size.width*SIZE_RATIO;
    CGFloat height = bounds.size.height*SIZE_RATIO;
    self.bounds = CGRectMake(x, y, width, height);
}

- (void)setCenterAfterProcess:(CGPoint)center
{
    CGFloat x = center.x*SIZE_RATIO;
    CGFloat y = center.y*SIZE_RATIO;
    self.center = CGPointMake(x, y);
}


@end
