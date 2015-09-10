//
//  UIView+Flexible.h
//  屏幕适配
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Flexible)

- (instancetype)initWithIPhone5Frame:(CGRect)frame;
- (void)setBoundsAfterProcess:(CGRect)bounds;
- (void)setCenterAfterProcess:(CGPoint)center;

@end
