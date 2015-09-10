//
//  FindKillerSettingView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/27.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FindKillerSettingView.h"
#import "SQRiskCursor.h"

@interface FindKillerSettingView ()

@property (nonatomic, copy)void(^startSetting)(NSArray *numbers);//记录开始设置回调block
@property (nonatomic, strong)NSArray *gameScheme;//游戏方案数组
@property (nonatomic, strong)SQRiskCursor *slider;//人数设置slider
@property (nonatomic, strong)UILabel *totalNumber;//游戏总人数
@property (nonatomic, strong)UILabel *eachPlayerNumbers;//杀手人数 警察人数 平民人数
/**
 *  统一更新玩家人数设定label
 */
- (void)updateLabel;
@end

@implementation FindKillerSettingView

- (instancetype)initWithFrame:(CGRect)frame startSetting:(void (^)(NSArray *))startSetting
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.startSetting = startSetting;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeDataSource
{
    //不同的人数对应不同的游戏方案，方案依次为总人数5~16，方案内容依次为杀手人数、警察人数、平民人数
    _gameScheme = @[@[@(1),@(1),@(3)],
                    @[@(1),@(1),@(4)],
                    @[@(1),@(1),@(5)],
                    @[@(2),@(2),@(4)],
                    @[@(2),@(2),@(5)],
                    @[@(2),@(2),@(6)],
                    @[@(3),@(3),@(5)],
                    @[@(3),@(3),@(6)],
                    @[@(3),@(3),@(7)],
                    @[@(3),@(3),@(8)],
                    @[@(4),@(4),@(7)],
                    @[@(4),@(4),@(8)]];
}

- (void)initializeUserInterface
{
    self.backgroundColor = COLOR_OF_BG;
    CGFloat margin = 20*SIZE_RATIO;
    
    /**
     *  人数设置
     */
    UILabel *peopleNumberSetting = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(60, 100, 200, 40)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 20;
        label.backgroundColor = COLOR_OF_TINTBULE;
        label.font = [UIFont systemFontOfSize:25];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_OF_TINTYELLOW;
        label.text = @"人数设置";
        label;
    });
    [self addSubview:peopleNumberSetting];
    
    /**
     *  设置游戏总人数
     */
    _totalNumber = ({

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(peopleNumberSetting.frame), CGRectGetMaxY(peopleNumberSetting.frame) + margin, CGRectGetWidth(peopleNumberSetting.bounds), 25*SIZE_RATIO)];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = COLOR_OF_TINTYELLOW;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"     游戏总人数: 5"];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(12, 1)];
        label.attributedText = string;
        label;
    });
    [self addSubview:_totalNumber];
    
    /**
     *  设置slider
     */
    _slider = [[SQRiskCursor alloc] initWithFrame:CGRectMake(50*SIZE_RATIO, CGRectGetMaxY(_totalNumber.frame) + margin, 220*SIZE_RATIO, 40*SIZE_RATIO)];
    _slider.maxValue = 11;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    
    /**
     *  设置减少人数button
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
     *  设置增加人数button
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
     *  设置不同玩家人数
     */
    _eachPlayerNumbers = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10*SIZE_RATIO, CGRectGetMaxY(_slider.frame) + margin, 300*SIZE_RATIO, 25*SIZE_RATIO)];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = COLOR_OF_TINTYELLOW;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"杀手人数：1  警察人数：1  平民人数：3 "];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(5, 1)];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(13, 1)];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(21, 1)];
        label.attributedText = string;
        label;
    });
    [self addSubview:_eachPlayerNumbers];

    /**
     *  开始游戏button
     */
    QBFlatButton *startGame = [[QBFlatButton alloc] initWithFrame:CGRectMake(80*SIZE_RATIO, CGRectGetMaxY(_eachPlayerNumbers.frame) + margin, 160*SIZE_RATIO, 40*SIZE_RATIO)];
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
 *  slider拖动结束后，更新游戏总人数和玩家人数
 */
- (void)sliderValueChanged:(SQRiskCursor *)sender
{
    [self updateLabel];
}

/**
 *  增加button点击之后，slider、更新游戏总人数、玩家人数
 */
- (void)addButtonPressed
{
    if (_slider.value >= 11) {
        return;
    }
    _slider.value++;
    
    [self updateLabel];
}

/**
 *  减少button点击之后，更新游戏总人数、slider、玩家人数
 */
- (void)deleteButtonPressed
{
    if (_slider.value <= 0) {
        return;
    }
    _slider.value--;
    
    [self updateLabel];
}

/**
 *  统一更新玩家人数设定label
 */
- (void)updateLabel
{
    //更新游戏总人数
    NSMutableAttributedString *totalNumberString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"     游戏总人数: %lu ",_slider.value + 5]];
    [totalNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(12, 2)];
    _totalNumber.attributedText = totalNumberString;
    
    //更新玩家人数
    NSMutableAttributedString *eachPlayerNumberString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"杀手人数：%@  警察人数：%@  平民人数：%@ ",_gameScheme[_slider.value][0],_gameScheme[_slider.value][1],_gameScheme[_slider.value][2]]];
    [eachPlayerNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(5, 1)];
    [eachPlayerNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(13, 1)];
    [eachPlayerNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(21, 1)];
    _eachPlayerNumbers.attributedText = eachPlayerNumberString;
}

/**
 *  开始游戏
 */
- (void)startGameButtonPressed
{
    //进入游戏界面，传入游戏方案数组
    self.startSetting([DataManager getRandomFindKillerArrayWithArray:_gameScheme[_slider.value]]);
}



@end
