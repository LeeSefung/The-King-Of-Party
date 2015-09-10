//
//  FindKillerSettingView.h
//  聚会大咖
//
//  Created by jiaxin on 15/6/27.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindKillerSettingView : UIView

- (instancetype)initWithFrame:(CGRect)frame startSetting:(void(^)(NSArray *numbers))startSetting;

@end
