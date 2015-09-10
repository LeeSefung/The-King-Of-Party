//
//  NumberLandmineSettingView.h
//  聚会大咖
//
//  Created by jiaxin on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberLandmineSettingView : UIView

/**
 *  初始化方法
 *
 *  @param frame            适配后的frame
 *  @param settingCompleted 设置完成后返回字典
 *
 *  @return @"max"为最大值，@"mine"为地雷值
 */
- (instancetype)initWithFrame:(CGRect)frame settingCompleted:(void(^)(NSDictionary *gameScheme))settingCompleted;

@end
