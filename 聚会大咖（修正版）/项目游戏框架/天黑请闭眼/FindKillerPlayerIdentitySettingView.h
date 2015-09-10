//
//  FindKillerPlayerIdentitySettingView.h
//  聚会大咖
//
//  Created by jiaxin on 15/6/28.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindKillerPlayerIdentitySettingView : UIView

- (instancetype)initWithFrame:(CGRect)frame gameScheme:(NSArray *)gameScheme settingCompleted:(void(^)(NSArray *playersInfo))settingCompleted;

@end
