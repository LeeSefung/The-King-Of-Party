//
//  FastReactionSettingView.m
//  聚会大咖
//
//  Created by jiaxin on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FastReactionSettingView.h"
#import "SQRiskCursor.h"

@interface FastReactionSettingView ()

@property (nonatomic, copy)void(^settingCompleted)(NSInteger gameRound);//记录游戏回合设置完成回调的block
@property (nonatomic, strong)UILabel *gameRoundSetting;//游戏回合显示label
@property (nonatomic, strong)SQRiskCursor *slider;//游戏回合设置slider
@property (nonatomic, strong)UILabel *gameRoundLabel;//游戏回合数

@end

@implementation FastReactionSettingView

- (instancetype)initWithFrame:(CGRect)frame settingCompleted:(void (^)(NSInteger))settingCompleted
{
    self = [super initWithFrame:frame];
    if (self) {
        self.settingCompleted = settingCompleted;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeDataSource
{
    
    
}

- (void)initializeUserInterface
{
    self.backgroundColor = COLOR_OF_BG;
    CGFloat margin = 20*SIZE_RATIO;
    
    /**
     *  游戏回合设置
     */
    _gameRoundSetting = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(60, 100, 200, 40)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 20;
        label.backgroundColor = COLOR_OF_TINTBULE;
        label.font = [UIFont systemFontOfSize:22];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_OF_TINTYELLOW;
        label.text = @"游戏回合设置";
        label;
    });
    [self addSubview:_gameRoundSetting];
    
    /**
     *  显示设置的游戏回合
     */
    _gameRoundLabel = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_gameRoundSetting.frame), CGRectGetMaxY(_gameRoundSetting.frame) + margin, CGRectGetWidth(_gameRoundSetting.bounds), 25*SIZE_RATIO)];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = COLOR_OF_TINTYELLOW;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"     每类游戏回合数: 3"];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(14, 1)];
        label.attributedText = string;
        label;
    });
    [self addSubview:_gameRoundLabel];
    
    /**
     *  设置slider
     */
    _slider = [[SQRiskCursor alloc] initWithFrame:CGRectMake(50*SIZE_RATIO, CGRectGetMaxY(_gameRoundLabel.frame) + margin, 220*SIZE_RATIO, 40*SIZE_RATIO)];
    _slider.maxValue = 6;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    
    /**
     *  设置减少游戏回合数button
     */
    QBFlatButton *delete = [[QBFlatButton alloc] initWithFrame:CGRectMake(15*SIZE_RATIO, CGRectGetMinY(_slider.frame) + 5*SIZE_RATIO, 30*SIZE_RATIO, 30*SIZE_RATIO)];
    delete.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    delete.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    delete.radius = 10.0;
    delete.margin = 4.0;
    delete.depth = 3.0;
    delete.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delete setTitle:@"-" forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delete];
    
    /**
     *  设置增加游戏回合数button
     */
    QBFlatButton *add = [[QBFlatButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_slider.frame) + 5*SIZE_RATIO, CGRectGetMinY(_slider.frame) + 5*SIZE_RATIO, 30*SIZE_RATIO, 30*SIZE_RATIO)];
    add.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    add.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    add.radius = 10.0;
    add.margin = 4.0;
    add.depth = 3.0;
    add.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add setTitle:@"+" forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:add];
    
    /**
     *  开始游戏button
     */
    QBFlatButton *startGame = [[QBFlatButton alloc] initWithFrame:CGRectMake(80*SIZE_RATIO, CGRectGetMaxY(_slider.frame) + margin, 160*SIZE_RATIO, 40*SIZE_RATIO)];
    startGame.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    startGame.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    startGame.radius = 15.0;
    startGame.margin = 7.0;
    startGame.depth = 6.0;
    startGame.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [startGame setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [startGame setTitle:@"开始游戏" forState:UIControlStateNormal];
    [startGame addTarget:self action:@selector(startGameButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startGame];

    
}

#pragma mark -- action

/**
 *  slider拖动结束后，更新游戏回合数
 */
- (void)sliderValueChanged:(SQRiskCursor *)sender
{
    [self updateGameRoundLabel];
}

/**
 *  增加button点击之后，slider、更新游戏回合数
 */
- (void)addButtonPressed
{
    if (_slider.value >= 13) {
        return;
    }
    _slider.value++;
    
    [self updateGameRoundLabel];
}

/**
 *  减少button点击之后，更新游戏回合数、slider
 */
- (void)deleteButtonPressed
{
    if (_slider.value <= 0) {
        return;
    }
    _slider.value--;
    
    [self updateGameRoundLabel];
}

/**
 *  更新游戏回合label
 */
- (void)updateGameRoundLabel
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"     每类游戏回合数: %ld",_slider.value + 3]];
    [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(14, 1)];
    _gameRoundLabel.attributedText = string;
}

/**
 *  开始游戏
 */
- (void)startGameButtonPressed
{
    //进入游戏界面，传入游戏回合数
    self.settingCompleted(_slider.value + 3);
    [self removeFromSuperview];
}

@end








