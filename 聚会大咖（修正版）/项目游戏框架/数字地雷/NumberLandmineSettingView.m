//
//  NumberLandmineSettingView.m
//  聚会大咖
//
//  Created by jiaxin on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "NumberLandmineSettingView.h"

@interface NumberLandmineSettingView () <UITextFieldDelegate>

@property (nonatomic, copy)void(^settingCompleted)(NSDictionary *gameScheme);//记录游戏方案设置完成回调的block
//数字最大值
@property (nonatomic, strong)UITextField *numberRange;
//数字地雷
@property (nonatomic, strong)UITextField *numberLandmine;
//游戏提示
@property (nonatomic, strong)UILabel *gameTips;
//用于倒计时隐藏gametips
@property (nonatomic, strong)NSTimer *dismissTimer;


/**
 *  动画显示gametips
 */
- (void)showGameTipsWithAnimation;
/**
 *  动画隐藏gametips
 */
- (void)dismissGameTipsWithAnimation;

/**
 *  显示数字地雷
 */
- (void)showMineButtonTouchDown;
/**
 *  隐藏数字地雷
 */
- (void)showMineButtonTouchUpInside;
/**
 *  开始游戏
 */
- (void)startGameButtonPressed;



@end

@implementation NumberLandmineSettingView

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
    
    UILabel *numberRangeLabel = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(10, 100, 220, 30)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = COLOR_OF_TINTBULE;
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"输入数字最大值：100~1000之间";
        label;
    });
    [self addSubview:numberRangeLabel];
    
    _numberRange = [[UITextField alloc] initWithIPhone5Frame:CGRectMake(240, 100, 70, 30)];
    _numberRange.layer.cornerRadius = 10;
    _numberRange.backgroundColor = COLOR_OF_TINTBULE;
    _numberRange.placeholder = @"请输入";
    _numberRange.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _numberRange.autocorrectionType = UITextAutocorrectionTypeNo;
    _numberRange.keyboardType = UIKeyboardTypeNumberPad;
    _numberRange.delegate = self;
    [_numberRange becomeFirstResponder];
    [self addSubview:_numberRange];
    
    UILabel *numberLandmineLabel = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(10, 150, 220, 30)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = COLOR_OF_TINTBULE;
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"输入数字地雷：1~设定的最大值之间";
        label;
    });
    [self addSubview:numberLandmineLabel];
    
    _numberLandmine = [[UITextField alloc] initWithIPhone5Frame:CGRectMake(240, 150, 70, 30)];
    _numberLandmine.layer.cornerRadius = 10;
    _numberLandmine.backgroundColor = COLOR_OF_TINTBULE;
    _numberLandmine.placeholder = @"请输入";
    _numberLandmine.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _numberLandmine.autocorrectionType = UITextAutocorrectionTypeNo;
    _numberLandmine.keyboardType = UIKeyboardTypeNumberPad;
    _numberLandmine.secureTextEntry = YES;
    _numberLandmine.delegate = self;
    [self addSubview:_numberLandmine];
    
    /**
     *  显示数字地雷button
     */
    QBFlatButton *showMine = [[QBFlatButton alloc] initWithFrame:CGRectMake(100*SIZE_RATIO, CGRectGetMaxY(_numberLandmine.frame) + 30*SIZE_RATIO, 120*SIZE_RATIO, 40*SIZE_RATIO)];
    showMine.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    showMine.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    showMine.radius = 15.0;
    showMine.margin = 7.0;
    showMine.depth = 6.0;
    showMine.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [showMine setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [showMine setTitle:@"显示地雷" forState:UIControlStateNormal];
    [showMine addTarget:self action:@selector(showMineButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [showMine addTarget:self action:@selector(showMineButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [showMine addTarget:self action:@selector(showMineButtonTouchUpInside) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:showMine];
    
    /**
     *  开始游戏button
     */
    QBFlatButton *startGame = [[QBFlatButton alloc] initWithFrame:CGRectMake(80*SIZE_RATIO, CGRectGetMaxY(showMine.frame) + 20*SIZE_RATIO, 160*SIZE_RATIO, 40*SIZE_RATIO)];
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

#pragma mark -- <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"\ntext--%@  range--%@ replace--%@",textField.text,NSStringFromRange(range),string);
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
    if (textField == _numberRange) {
        //当前为数字最大值设置textfield
        if ([insertedString intValue] > 1000) {
            _gameTips.text = @"数字最大值不能大于1000,请重新输入";
            [self showGameTipsWithAnimation];
            return NO;
        }
        return YES;
        
    }else {
        //当前为数字地雷设置textfield
        if ([insertedString intValue] > [_numberRange.text intValue]) {
            _gameTips.text = @"数字地雷不能大于最大值,请重新输入";
            [self showGameTipsWithAnimation];
            return NO;
        }
        return YES;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _numberRange) {
        //当前为数字最大值设置textfield
        if ([_numberRange.text intValue] < 100 ) {
            _gameTips.text = @"数字最大值不能小于100,请重新输入";
            [self showGameTipsWithAnimation];
        }
    }else {
        //当前为数字地雷设置textfield
        if ([_numberLandmine.text intValue] == 1 || [_numberLandmine.text intValue] == [_numberRange.text intValue] || _numberLandmine.text.length == 0) {
            if (_numberRange.text.length == 0) {
                _gameTips.text = [NSString stringWithFormat:@"请先输入数字最大值，再来输入数字地雷"];
                [self showGameTipsWithAnimation];
            }else {
                _gameTips.text = [NSString stringWithFormat:@"数字地雷应在1~%@之间,请重新输入",_numberRange.text];
                [self showGameTipsWithAnimation];
            }
        }
    }
}

#pragma mark -- action

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

/**
 *  显示数字地雷
 */
- (void)showMineButtonTouchDown
{
    _numberLandmine.secureTextEntry = NO;
}

/**
 *  隐藏数字地雷
 */
- (void)showMineButtonTouchUpInside
{
    _numberLandmine.secureTextEntry = YES;
}

/**
 *  开始游戏
 */
- (void)startGameButtonPressed
{
    if ([_numberRange.text intValue] < 100 ) {
        _gameTips.text = @"数字最大值不能小于100,请重新输入";
        [self showGameTipsWithAnimation];
    }else if ([_numberLandmine.text intValue] == 1 || [_numberLandmine.text intValue] == [_numberRange.text intValue] || _numberLandmine.text.length == 0 ) {
        _gameTips.text = [NSString stringWithFormat:@"数字地雷应在1~%@之间,请重新输入",_numberRange.text];
        [self showGameTipsWithAnimation];
    }else {
        //所有配置都没有问题了，可以进入游戏画面
        NSDictionary *dataDict = @{@"max" : _numberRange.text, @"mine" : _numberLandmine.text};
        self.settingCompleted(dataDict);
    }
    
    //电脑随机埋雷，自己玩
//    NSInteger random = arc4random()%[_numberRange.text integerValue];
//    NSDictionary *dataDict = @{@"max" : _numberRange.text, @"mine" : [NSString stringWithFormat:@"%ld",random]};
//    self.settingCompleted(dataDict);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_numberRange resignFirstResponder];
    [_numberLandmine resignFirstResponder];
}

@end












