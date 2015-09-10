//
//  TimeView.h
//  聚会大咖
//
//  Created by rimi on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureAndGuessGameView : UIView

@property (nonatomic, strong) NSString *wordType;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger groupNumber;

@property (nonatomic,copy)void(^completed)(NSArray *result);
@property (nonatomic, copy)void(^backToMenu)();

- (instancetype)initWithFrame:(CGRect)frame wordType:(NSString *)wordType time:(NSInteger)time groupNumber:(NSInteger)groupNumber completed:(void(^)(NSArray *result))completed backToMenu:(void(^)())backToMenu;

@end
