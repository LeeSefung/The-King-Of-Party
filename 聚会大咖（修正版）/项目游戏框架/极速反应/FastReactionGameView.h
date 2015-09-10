//
//  FastReactionGameView.h
//  聚会大咖
//
//  Created by jiaxin on 15/7/5.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastReactionGameView : UIView

- (instancetype)initWithFrame:(CGRect)frame gameRound:(NSInteger)gameRound onceAgain:(void(^)())onceAgain;


@end
