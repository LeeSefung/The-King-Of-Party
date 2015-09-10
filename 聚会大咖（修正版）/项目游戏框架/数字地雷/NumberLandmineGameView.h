//
//  NumberLandmineGameView.h
//  聚会大咖
//
//  Created by jiaxin on 15/7/2.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberLandmineGameView : UIView

- (instancetype)initWithFrame:(CGRect)frame gameScheme:(NSDictionary *)gameScheme onceAgain:(void(^)())onceAgain punish:(void(^)())punish;

@end
