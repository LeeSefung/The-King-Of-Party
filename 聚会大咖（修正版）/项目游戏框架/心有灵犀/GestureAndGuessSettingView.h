//
//  GestureAndGuessSettingView.h
//  聚会大咖
//
//  Created by jiaxin on 15/7/5.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureAndGuessSettingView : UIView

- (instancetype)initWithFrame:(CGRect)frame settingCompleted:(void(^)(NSDictionary *settingData))settingCompleted;

@end
