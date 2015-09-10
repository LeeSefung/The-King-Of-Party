//
//  WhoIsUndercoverPlayerNumSettingView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/30.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WhoIsUndercoverPlayerNumSettingView.h"
#import "SQRiskCursor.h"

@interface WhoIsUndercoverPlayerNumSettingView ()

@property (nonatomic, copy)void(^settingCompleted)(NSDictionary *gameScheme);//记录玩家人数设置完成回调的block
@property (nonatomic, strong)NSArray *gameScheme;//游戏方案数组
@property (nonatomic, strong)SQRiskCursor *slider;//人数设置slider
@property (nonatomic, strong)UILabel *totalNumber;//游戏总人数
@property (nonatomic, strong)UILabel *eachPlayerNumbers;//平民人数 卧底人数
/**
 *  统一更新玩家人数设定label
 */
- (void)updateLabel;
@end

@implementation WhoIsUndercoverPlayerNumSettingView

- (instancetype)initWithFrame:(CGRect)frame settingCompleted:(void (^)(NSDictionary *))settingCompleted
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
    //不同的人数对应不同的游戏方案，方案依次为总人数3~16，方案内容依次为平民人数、卧底人数
    _gameScheme = @[@[@(2),@(1)],
                    @[@(3),@(1)],
                    @[@(4),@(1),],
                    @[@(5),@(1),],
                    @[@(6),@(1),],
                    @[@(6),@(2),],
                    @[@(7),@(2),],
                    @[@(8),@(2),],
                    @[@(9),@(2),],
                    @[@(9),@(3),],
                    @[@(10),@(3),],
                    @[@(11),@(3),],
                    @[@(12),@(3),],
                    @[@(12),@(4),]];
    
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
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"     游戏总人数: 3"];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(12, 1)];
        label.attributedText = string;
        label;
    });
    [self addSubview:_totalNumber];
    
    /**
     *  设置slider
     */
    _slider = [[SQRiskCursor alloc] initWithFrame:CGRectMake(50*SIZE_RATIO, CGRectGetMaxY(_totalNumber.frame) + margin, 220*SIZE_RATIO, 40*SIZE_RATIO)];
    _slider.maxValue = 13;
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20*SIZE_RATIO, CGRectGetMaxY(_slider.frame) + margin, 280*SIZE_RATIO, 25*SIZE_RATIO)];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = COLOR_OF_TINTYELLOW;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"平民人数：2  卧底人数：1 "];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(5, 1)];
        [string setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(13, 1)];
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
    if (_slider.value >= 13) {
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
    NSMutableAttributedString *totalNumberString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"     游戏总人数: %lu ",_slider.value + 3]];
    [totalNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(12, 2)];
    _totalNumber.attributedText = totalNumberString;
    
    //更新玩家人数
    NSMutableAttributedString *eachPlayerNumberString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"平民人数：%@  卧底人数：%@ ",_gameScheme[_slider.value][0],_gameScheme[_slider.value][1]]];
    [eachPlayerNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(5, 2)];
    if ([_gameScheme[_slider.value][0] intValue]> 9) {
        [eachPlayerNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(14, 1)];
    }else {
        [eachPlayerNumberString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:20]} range:NSMakeRange(13, 1)];
    }
    _eachPlayerNumbers.attributedText = eachPlayerNumberString;
}

/**
 *  开始游戏
 */
- (void)startGameButtonPressed
{
    //进入游戏界面，传入游戏方案数组
    self.settingCompleted([DataManager getWhoIsUndecoverInfoWithArray:_gameScheme[_slider.value]]);
}

@end




















