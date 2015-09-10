//
//  FindKillerPlayerIdentitySettingView.h
//  聚会大咖
//
//  Created by jiaxin on 15/6/28.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhoIsUndercoverPlayerIdentitySettingView : UIView

/**
 *  通过拍照添加玩家的头像
 *
 *  @param photo 玩家拍照的头像
 */
- (void)addHeadForPlayerWithPhoto:(UIImage *)photo;

- (instancetype)initWithFrame:(CGRect)frame gameScheme:(NSArray *)gameScheme  takePhoto:(void(^)())takePhoto settingCompleted:(void(^)(NSArray *playersHead))settingCompleted;

@end
