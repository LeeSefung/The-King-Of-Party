//
//  NumberLandmineGameView.m
//  聚会大咖
//
//  Created by jiaxin on 15/7/2.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "NumberLandmineGameView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface NumberLandmineGameView () <UITextFieldDelegate>

//记录游戏方案信息
@property (nonatomic, strong)NSDictionary *gameScheme;
//记录再来一局代码块
@property (nonatomic, copy)void(^onceAgainBlock)();
//记录游戏惩罚代码块
@property (nonatomic, copy)void(^punishBlock)();
//游戏提示
@property (nonatomic, strong)UILabel *gameTips;
//记录炸弹视图
@property (nonatomic, strong)UIImageView *bomb;
//当前数字范围最小值
@property (nonatomic, strong)UILabel *currentMin;
//当前数字范围最大值
@property (nonatomic, strong)UILabel *currentMax;
//用户输入的排雷数字
@property (nonatomic, strong)UITextField *inputTextField;
//再来一局button
@property (nonatomic, strong)QBFlatButton *onceAgain;
//进入惩罚button
@property (nonatomic, strong)QBFlatButton *punish;
//用于倒计时隐藏gametips
@property (nonatomic, strong)NSTimer *dismissTimer;

/**
 *  确认按钮被点击
 */
- (void)confirmButtonPressed;
/**
 *  再来一局
 */
- (void)onceAgainButtonPressed;
/**
 *  进入惩罚
 */
- (void)punishButtonPressed;
/**
 *  动画显示gametips
 */
- (void)showGameTipsWithAnimation;
/**
 *  动画隐藏gametips
 */
- (void)dismissGameTipsWithAnimation;

@end

@implementation NumberLandmineGameView

- (instancetype)initWithFrame:(CGRect)frame gameScheme:(NSDictionary *)gameScheme
 onceAgain:(void (^)())onceAgain punish:(void (^)())punish{
    self = [super initWithFrame:frame];
    if (self) {
        self.gameScheme = gameScheme;
        self.onceAgainBlock = onceAgain;
        self.punishBlock = punish;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)dealloc
{
    if ([_dismissTimer isValid]) {
        [_dismissTimer invalidate];
        _dismissTimer = nil;
    }
}

- (void)initializeDataSource
{
    
}

- (void)initializeUserInterface
{
    self.backgroundColor = COLOR_OF_BG;
    
    CGFloat margin = 20*SIZE_RATIO;
    
    _gameTips = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(20, 50, 280, 30)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = [UIColor colorWithWhite:0.312 alpha:0.610];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.alpha = 0;
        label;
    });
    [self addSubview:_gameTips];
    
    UIImageView *bomb = [[UIImageView alloc] initWithFrame:CGRectMake(110*SIZE_RATIO, CGRectGetMaxY(_gameTips.frame) + margin, 100*SIZE_RATIO, 100*SIZE_RATIO)];
    bomb.image = IMAGE_WITH_NAME(@"bomb.png");
    bomb.contentMode = UIViewContentModeScaleAspectFit;
    bomb.clipsToBounds = YES;
    [self addSubview:bomb];
    self.bomb = bomb;
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        bomb.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        
    }];
    
    UILabel *currentRange = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20*SIZE_RATIO, CGRectGetMaxY(bomb.frame) + margin, 280*SIZE_RATIO, 40*SIZE_RATIO)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = COLOR_OF_TINTBULE;
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = @"当前数字范围：              ~       ";
        label;
    });
    [self addSubview:currentRange];
    
    _currentMin = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130*SIZE_RATIO, CGRectGetMinY(currentRange.frame), 60*SIZE_RATIO, 40*SIZE_RATIO)];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_OF_TINTYELLOW;
        label.text = @"1";
        label;
    });
    [self addSubview:_currentMin];
    
    _currentMax = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(230*SIZE_RATIO, CGRectGetMinY(currentRange.frame), 60*SIZE_RATIO, 40*SIZE_RATIO)];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_OF_TINTYELLOW;
        label.text = _gameScheme[@"max"];
        label;
    });
    [self addSubview:_currentMax];
    
    UILabel *inputNumberLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20*SIZE_RATIO, CGRectGetMaxY(currentRange.frame) + margin, 200*SIZE_RATIO, 40*SIZE_RATIO)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = COLOR_OF_TINTBULE;
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = @"请输入排雷数字：";
        label;
    });
    [self addSubview:inputNumberLabel];
    
    _inputTextField = ({
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(165*SIZE_RATIO, CGRectGetMinY(inputNumberLabel.frame), 50*SIZE_RATIO, 40*SIZE_RATIO)];
        textfield.placeholder = @"输入";
        textfield.textColor = COLOR_OF_TINTYELLOW;
        textfield.font = [UIFont systemFontOfSize:20];
        textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textfield.autocorrectionType = UITextAutocorrectionTypeNo;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.delegate = self;
        [textfield becomeFirstResponder];
        textfield;
    });
    [self addSubview:_inputTextField];
    
    /**
     *  确定button
     */
    QBFlatButton *confirm = [[QBFlatButton alloc] initWithFrame:CGRectMake(225*SIZE_RATIO, CGRectGetMinY(inputNumberLabel.frame), 75*SIZE_RATIO, 40*SIZE_RATIO)];
    confirm.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    confirm.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    confirm.radius = 15.0;
    confirm.margin = 7.0;
    confirm.depth = 6.0;
    confirm.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirm setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm];
    
    /**
     *  再来一局button
     */
    _onceAgain = [[QBFlatButton alloc] initWithFrame:CGRectMake(20*SIZE_RATIO, CGRectGetMaxY(inputNumberLabel.frame) + margin, 120*SIZE_RATIO, 40*SIZE_RATIO)];
    _onceAgain.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _onceAgain.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _onceAgain.radius = 15.0;
    _onceAgain.margin = 7.0;
    _onceAgain.depth = 6.0;
    _onceAgain.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_onceAgain setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [_onceAgain setTitle:@"再来一局" forState:UIControlStateNormal];
    [_onceAgain addTarget:self action:@selector(onceAgainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _onceAgain.hidden = YES;
    [self addSubview:_onceAgain];
    
    /**
     *  进入惩罚button
     */
    _punish = [[QBFlatButton alloc] initWithFrame:CGRectMake(180*SIZE_RATIO, CGRectGetMaxY(inputNumberLabel.frame) + margin, 120*SIZE_RATIO, 40*SIZE_RATIO)];
    _punish.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _punish.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _punish.radius = 15.0;
    _punish.margin = 7.0;
    _punish.depth = 6.0;
    _punish.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_punish setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [_punish setTitle:@"进入惩罚" forState:UIControlStateNormal];
    [_punish addTarget:self action:@selector(punishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _punish.hidden = YES;
    [self addSubview:_punish];
    
}

#pragma mark -- <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //不允许第一个数字为0
    if (textField.text.length == 0 && [string intValue] == 0) {
        _gameTips.text = @"第一个数字不能为0,请重新输入";
        [self showGameTipsWithAnimation];
        return NO;
    }
    //允许删除
    if (string.length == 0) {
        return YES;
    }
    //下面用于过滤输入的不是数字
    NSCharacterSet * cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
        _gameTips.text = @"只能输入阿拉伯数字,请重新输入";
        [self showGameTipsWithAnimation];
        return NO;
    }
    
    NSString *insertedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    int max = [_currentMax.text intValue];
    if ([insertedString intValue] >= max) {
        _gameTips.text = [NSString stringWithFormat:@"数字不能大于等于%d,请重新输入",max];
        [self showGameTipsWithAnimation];
        return NO;
    }
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark -- action

/**
 *  确认按钮被点击
 */
- (void)confirmButtonPressed
{
    int inputNumber = [_inputTextField.text intValue];
    int mineNumber = [_gameScheme[@"mine"] intValue];
    int min = [_currentMin.text intValue];
    
    //首先判断用户输入的排雷数字是否就是地雷数字
    if (inputNumber == mineNumber) {
        //相同游戏结束
        //隐藏键盘
        [_inputTextField resignFirstResponder];
        //显示再来一局和进入惩罚
        _onceAgain.hidden = NO;
        _punish.hidden = NO;
        //让手机震动一下
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //替换炸弹视图为爆炸视图
        _bomb.image = IMAGE_WITH_NAME(@"bang.png");
        //关闭输入框的交互
        _inputTextField.userInteractionEnabled = NO;
        //显示地雷数字tips
        if ([_dismissTimer isValid]) {
            [_dismissTimer invalidate];
            _dismissTimer = nil;
        }
        _gameTips.alpha = 1;
        _gameTips.text = [NSString stringWithFormat:@"数字地雷为%d,脚气不错，买彩票吧",mineNumber];
    }else {
        
        if ([_inputTextField.text intValue] <= min) {
            _gameTips.text = [NSString stringWithFormat:@"数字不能小于等于%d,请重新输入",min];
            [self showGameTipsWithAnimation];
            return;
        }
        
        //不相同，更新数字范围label，再进行下一轮
        if (inputNumber < mineNumber) {
            //如果输入的排雷数字小于地雷数字，则更新最小值为输入值
            _currentMin.text = [NSString stringWithFormat:@"%d",inputNumber];
        }else {
            //如果输入的排雷数字大于地雷数字，则更新最大值为输入值
            _currentMax.text = [NSString stringWithFormat:@"%d",inputNumber];
        }
        //把输入清零
        _inputTextField.text = @"";
        //提示下一个玩家排雷
        _gameTips.text = @"恭喜您成功排雷，请下一位玩家排雷";
        [self showGameTipsWithAnimation];
    }
    
    
    
}

/**
 *  再来一局
 */
- (void)onceAgainButtonPressed
{
    if(_onceAgainBlock){
        _onceAgainBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, -568*SIZE_RATIO, 320*SIZE_RATIO, 568*SIZE_RATIO);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 *  进入惩罚
 */
- (void)punishButtonPressed
{
    if (_punishBlock) {
        _punishBlock();
    }
}

/**
 *  动画显示gametips
 */
- (void)showGameTipsWithAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        _gameTips.alpha = 1;
    } completion:^(BOOL finished) {
        if ([_dismissTimer isValid]) {
            [_dismissTimer invalidate];
            _dismissTimer = nil;
        }
        _dismissTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismissGameTipsWithAnimation) userInfo:nil repeats:NO];
    }];
}

/**
 *  动画隐藏gametips
 */
- (void)dismissGameTipsWithAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        _gameTips.alpha = 0;
    } completion:^(BOOL finished) {
        if ([_dismissTimer isValid]) {
            [_dismissTimer invalidate];
            _dismissTimer = nil;
        }
    }];
}

@end














