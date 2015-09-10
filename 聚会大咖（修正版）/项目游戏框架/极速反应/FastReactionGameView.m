//
//  FastReactionGameView.m
//  聚会大咖
//
//  Created by jiaxin on 15/7/5.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FastReactionGameView.h"

@interface FastReactionGameView ()

//记录游戏重来block
@property (nonatomic, copy)void(^onceAgain)();
//记录游戏回合数
@property (nonatomic, assign)NSInteger gameRound;
//记录当前游戏的当前回合数
@property (nonatomic, assign)NSInteger currentGameRound;
//玩家1游戏提示label
@property (nonatomic, strong)UILabel *gameTipsOne;
//玩家2游戏提示label
@property (nonatomic, strong)UILabel *gameTipsTwo;
//玩家1游戏信息label
@property (nonatomic, strong)UILabel *gameInfoOne;
//玩家2游戏信息label
@property (nonatomic, strong)UILabel *gameInfoTwo;
//玩家1游戏分数
@property (nonatomic, strong)UILabel *scoreOne;
//玩家2游戏分数
@property (nonatomic, strong)UILabel *scoreTwo;
//玩家1button
@property (nonatomic, strong)UIButton *playerOne;
//玩家2button
@property (nonatomic, strong)UIButton *playerTwo;

/**
 *  倒计时到0游戏配置
 */
//记录倒计时游戏状态，YES为进行,NO为结束,默认为YES
@property (nonatomic, assign)BOOL isCountdownGaming;
//玩家1倒计时结果label
@property (nonatomic, strong)UILabel *countdownResultOne;
//玩家2倒计时结果label
@property (nonatomic, strong)UILabel *countdownResultTwo;
//倒计时到0游戏timer
@property (nonatomic, strong)NSTimer *countdownTimer;
//倒计时到0游戏起始值
@property (nonatomic, assign)float countdownStartNum;
//倒计时到0游戏隐藏值
@property (nonatomic, assign)float countdownHiddenNum;
/**
 *  进入倒计时到0游戏视图
 */
- (void)countdownGameView;
/**
 *  更新倒计时状态
 */
- (void)countdownGameUpdate;
/**
 *  开始倒计时到0游戏
 */
- (void)startCountdownGame;


/**
 *  颜色字游戏配置
 */
//记录倒计时游戏状态，YES为进行,NO为结束,默认为NO
@property (nonatomic, assign)BOOL isColorWordGaming;
//颜色字游戏timer
@property (nonatomic, strong)NSTimer *colorWordTimer;
//记录颜色数组
@property (nonatomic, strong)NSArray *colorArray;
//记录颜色名字
@property (nonatomic, strong)NSArray *colorNameArray;
/**
 *  进入颜色字游戏视图
 */
- (void)colorWordGameView;
/**
 *  开始颜色字游戏
 */
- (void)startColorWordGame;
/**
 *  颜色字游戏时间到了，自动进入下一局
 */
- (void)colorWordNext;


/**
 *  恢复游戏主要控件的初始值
 */
- (void)recoverGame;
/**
 *  停止定时器
 */
- (void)stopTimer;
/**
 *  暂停button点击
 */
- (void)pauseButtonPressed;
/**
 *  再来一局
 */
- (void)onceAgainButtonPressed;
/**
 *  玩家button点击
 */
- (void)playerButtonPressed:(UIButton *)sender;
/**
 *  进入游戏结果视图
 */
- (void)createResultView;

@end

@implementation FastReactionGameView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame gameRound:(NSInteger)gameRound onceAgain:(void (^)())onceAgain
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gameRound = gameRound;
        self.onceAgain = onceAgain;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeDataSource
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FastReactionHiddenNavBar" object:nil];
    _colorArray = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor orangeColor],[UIColor whiteColor],[UIColor yellowColor]];
    _colorNameArray = @[@"红",@"绿",@"蓝",@"橘",@"白",@"黄"];
}
- (void)initializeUserInterface
{
    self.backgroundColor = COLOR_OF_BG;
    
    UIButton *pauseOne = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, (568/2 + 1) * SIZE_RATIO, 50*SIZE_RATIO, 40*SIZE_RATIO);
        button.layer.cornerRadius = 10;
        button.backgroundColor = COLOR_OF_TINTBULE;
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pauseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:pauseOne];
    
    UIButton *pauseTwo = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, (568/2 - 40 - 1)*SIZE_RATIO, 50*SIZE_RATIO, 40*SIZE_RATIO);
        button.layer.cornerRadius = 10;
        button.backgroundColor = COLOR_OF_TINTBULE;
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pauseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        button.transform = CGAffineTransformMakeRotation(M_PI);
        button;
    });
    [self addSubview:pauseTwo];
    
    _gameTipsOne = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(50, 568/2 + 1, 220, 40)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = [UIColor colorWithWhite:0.312 alpha:0.610];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label;
    });
    [self addSubview:_gameTipsOne];
    
    _gameTipsTwo = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(50, 568/2 - 40 - 1, 220, 40)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = [UIColor colorWithWhite:0.312 alpha:0.610];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.transform = CGAffineTransformMakeRotation(M_PI);
        label;
    });
    [self addSubview:_gameTipsTwo];
    
    _gameInfoOne = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(50, 568/2 + 50, 220, 80)];
        label.font = [UIFont boldSystemFontOfSize:50];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label;
    });
    [self addSubview:_gameInfoOne];
    
    _gameInfoTwo = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(50, 160, 220, 80)];
        label.font = [UIFont boldSystemFontOfSize:50];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.transform = CGAffineTransformMakeRotation(M_PI);
        label;
    });
    [self addSubview:_gameInfoTwo];
    
    UIButton *onceAgainOne = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((320 - 50)*SIZE_RATIO, (568/2 + 1) * SIZE_RATIO, 50*SIZE_RATIO, 40*SIZE_RATIO);
        button.layer.cornerRadius = 10;
        button.backgroundColor = COLOR_OF_TINTBULE;
        [button setTitle:@"重来" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onceAgainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:onceAgainOne];
    
    UIButton *onceAgainTwo = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((320 - 50)*SIZE_RATIO, (568/2 - 40 - 1)*SIZE_RATIO, 50*SIZE_RATIO, 40*SIZE_RATIO);
        button.layer.cornerRadius = 10;
        button.backgroundColor = COLOR_OF_TINTBULE;
        [button setTitle:@"重来" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onceAgainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        button.transform = CGAffineTransformMakeRotation(M_PI);
        button;
    });
    [self addSubview:onceAgainTwo];
    
    UIView *dividingLine = [[UIView alloc] initWithIPhone5Frame:CGRectMake(0, 568/2, 320, 1)];
    dividingLine.backgroundColor = COLOR_OF_TINTRED;
    [self addSubview:dividingLine];
    
    _playerOne = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, (568 - 120) * SIZE_RATIO, 320*SIZE_RATIO, 120*SIZE_RATIO);
        button.layer.cornerRadius = 30;
        button.backgroundColor = COLOR_OF_TINTBULE;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:60];
        [button setTitle:@"玩家1" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:_playerOne];
    
    _playerTwo = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 320*SIZE_RATIO, 120*SIZE_RATIO);
        button.layer.cornerRadius = 30;
        button.backgroundColor = COLOR_OF_TINTBULE;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:60];
        [button setTitle:@"玩家2" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.transform = CGAffineTransformMakeRotation(M_PI);
        button;
    });
    [self addSubview:_playerTwo];
    
    _scoreOne = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(320 - 60, 568 - 120 - 40, 60, 40)];
        label.font = [UIFont systemFontOfSize:40];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = @"0";
        label;
    });
    [self addSubview:_scoreOne];
    
    _scoreTwo = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(0, 120, 60, 40)];
        label.font = [UIFont systemFontOfSize:40];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = @"0";
        label.transform = CGAffineTransformMakeRotation(M_PI);
        label;
    });
    [self addSubview:_scoreTwo];
    
    /**
     *  进入倒计时到0游戏视图
     */
    [self countdownGameView];
    
    
}

#pragma mark -- 倒计时游戏
/**
 *  进入倒计时到0游戏视图
 */
- (void)countdownGameView
{
    _isCountdownGaming = YES;
    _currentGameRound = _gameRound;
    
    _gameTipsOne.text = @"倒计时到0之后点击";
    _gameTipsTwo.text = @"倒计时到0之后点击";
    
    _countdownResultOne = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(100, 568 - 120 - 30, 120, 30)];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:_countdownResultOne];
    
    _countdownResultTwo = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(100, 120, 120, 30)];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.transform = CGAffineTransformMakeRotation(M_PI);
        label;
    });
    [self addSubview:_countdownResultTwo];
    
    [self startCountdownGame];
}

/**
 *  开始倒计时到0游戏
 */
- (void)startCountdownGame
{
    [self recoverGame];
    _countdownResultOne.text = @"";
    _countdownResultTwo.text = @"";
    //随机[4,2]之间的数作为隐藏值
    _countdownHiddenNum = (arc4random()%3) + 2;
    //随机[6,9]之间的数作为起始数
    _countdownStartNum = (arc4random()%3) + 6;
    _gameInfoOne.text = [NSString stringWithFormat:@"%d",(int)_countdownStartNum];
    _gameInfoTwo.text = [NSString stringWithFormat:@"%d",(int)_countdownStartNum];
    if (!_countdownTimer) {
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(countdownGameUpdate) userInfo:nil repeats:YES];
    }else {
        [_countdownTimer setFireDate:[NSDate date]];
    }
    
}

/**
 *  更新倒计时状态
 */
- (void)countdownGameUpdate
{
    _countdownStartNum -= 0.01;
    
    if (_countdownStartNum <= _countdownHiddenNum) {
        //如果小于等于隐藏值，则为 ？ 号
        _gameInfoOne.text = @"?";
        _gameInfoTwo.text = @"?";
    }else {
        //如果倒计时到整数
        NSString *numberString = [NSString stringWithFormat:@"%f",_countdownStartNum];
        if ([[numberString substringToIndex:4] floatValue] == floorf(_countdownStartNum)) {
            _gameInfoOne.text = [NSString stringWithFormat:@"%d",(int)floorf(_countdownStartNum)];
            _gameInfoTwo.text = [NSString stringWithFormat:@"%d",(int)floorf(_countdownStartNum)];
        }
    }
    
}

#pragma mark -- 颜色字游戏

/**
 *  进入颜色字游戏视图
 */
- (void)colorWordGameView
{
    //恢复状态
    [self recoverGame];
    [_countdownResultOne removeFromSuperview];
    [_countdownResultTwo removeFromSuperview];
    //初始化状态
    _isColorWordGaming = YES;
    _currentGameRound = _gameRound;
    
    _gameTipsOne.text = @"当字与颜色相同时点击";
    _gameTipsTwo.text = @"当字与颜色相同时点击";
    [self startColorWordGame];
}

/**
 *  开始颜色字游戏
 */
- (void)startColorWordGame
{
    [self recoverGame];

    NSInteger randomColor = arc4random()%_colorArray.count;
    NSInteger randomColorName = arc4random()%_colorNameArray.count;
    NSMutableArray *tempColorNameArray = [NSMutableArray arrayWithArray:_colorNameArray];
    for (int i = 0; i < _colorNameArray.count/2; i ++) {
        [tempColorNameArray addObject:_colorNameArray[randomColorName]];
    }
    NSInteger lastRandomColorName = arc4random()%tempColorNameArray.count;
    
    _gameInfoOne.textColor = _colorArray[randomColor];
    _gameInfoOne.text = tempColorNameArray[lastRandomColorName];
    _gameInfoTwo.textColor = _colorArray[randomColor];
    _gameInfoTwo.text = tempColorNameArray[lastRandomColorName];
    if (_colorWordTimer) {
        [self stopTimer];
    }
    _colorWordTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(colorWordNext) userInfo:nil repeats:YES];
}

/**
 *  颜色字游戏时间到了，自动进入下一局
 */
- (void)colorWordNext
{
    [self startColorWordGame];
}

#pragma mark -- gameResult

/**
 *  进入游戏结果视图
 */
- (void)createResultView
{
    NSInteger playOneScore = [_scoreOne.text integerValue];
    NSInteger playTwoScore = [_scoreTwo.text integerValue];
    if (playOneScore > playTwoScore) {
        //玩家1获胜
        _gameInfoOne.text = @"胜利";
        _gameInfoTwo.text = @"失败";
    }else if (playOneScore < playTwoScore) {
        //玩家2获胜
        _gameInfoOne.text = @"失败";
        _gameInfoTwo.text = @"胜利";
    }else {
        //平局
        _gameInfoOne.text = @"平局";
        _gameInfoTwo.text = @"平局";
    }
    
}

#pragma mark -- action

/**
 *  恢复游戏主要控件的初始值
 */
- (void)recoverGame
{
    _playerOne.userInteractionEnabled = YES;
    _playerTwo.userInteractionEnabled = YES;
    _playerOne.backgroundColor = COLOR_OF_TINTBULE;
    _playerTwo.backgroundColor = COLOR_OF_TINTBULE;
}
/**
 *  停止定时器
 */
- (void)stopTimer
{
    if ([_countdownTimer isValid]) {
        [_countdownTimer invalidate];
        _countdownTimer = nil;
    }
    if ([_colorWordTimer isValid]) {
        [_colorWordTimer invalidate];
        _colorWordTimer = nil;
    }
}
/**
 *  玩家button点击
 */
- (void)playerButtonPressed:(UIButton *)sender
{
    //首先关闭button交互和暂定定时器
    _playerOne.userInteractionEnabled = NO;
    _playerTwo.userInteractionEnabled = NO;
    
    //倒计时游戏
    if (_isCountdownGaming) {
        [_countdownTimer setFireDate:[NSDate distantFuture]];
        //倒计时游戏状态
        if (_countdownStartNum < 0) {
            //小于0,正确
            sender.backgroundColor = COLOR_OF_TINTGREEN;
            if (sender == _playerOne) {
                //是玩家1
                _gameInfoOne.text = @"完美";
                _gameInfoTwo.text = @"可惜了";
                _scoreOne.text = [NSString stringWithFormat:@"%d",[_scoreOne.text intValue] + 1];
                _countdownResultOne.textColor = COLOR_OF_TINTGREEN;
                _countdownResultOne.text = [NSString stringWithFormat:@"%.2f",_countdownStartNum];
            }else {
                //是玩家2
                _gameInfoOne.text = @"可惜了";
                _gameInfoTwo.text = @"完美";
                _scoreTwo.text = [NSString stringWithFormat:@"%d",[_scoreTwo.text intValue] + 1];
                _countdownResultTwo.textColor = COLOR_OF_TINTGREEN;
                _countdownResultTwo.text = [NSString stringWithFormat:@"%.2f",_countdownStartNum];
            }
            //正确则减少一次游戏局数
            _currentGameRound--;
            if (_currentGameRound == 0) {
                _isCountdownGaming = NO;
                [self stopTimer];
                //进入下一个颜色字游戏
                [self performSelector:@selector(colorWordGameView) withObject:nil afterDelay:2];
                return;
            }
        }else {
            //大于0，错误
            sender.backgroundColor = COLOR_OF_TINTRED;
            if (sender == _playerOne) {
                //是玩家1
                _gameInfoOne.text = @"按早了";
                _gameInfoTwo.text = @"真幸运";
                _scoreOne.text = [NSString stringWithFormat:@"%d",[_scoreOne.text intValue] - 1];
                _countdownResultOne.textColor = COLOR_OF_TINTRED;
                _countdownResultOne.text = [NSString stringWithFormat:@"%.2f",_countdownStartNum];
            }else {
                //是玩家2
                _gameInfoOne.text = @"真幸运";
                _gameInfoTwo.text = @"按早了";
                _scoreTwo.text = [NSString stringWithFormat:@"%d",[_scoreTwo.text intValue] - 1];
                _countdownResultTwo.textColor = COLOR_OF_TINTRED;
                _countdownResultTwo.text = [NSString stringWithFormat:@"%.2f",_countdownStartNum];
            }
            
        }
        //判断结束，且还有游戏回合数，再次更新游戏
        [self performSelector:@selector(startCountdownGame) withObject:nil afterDelay:2];
    }
    
    //颜色字游戏
    if (_isColorWordGaming) {
        [self stopTimer];
        
        if ([_colorArray indexOfObject:_gameInfoOne.textColor] == [_colorNameArray indexOfObject:_gameInfoOne.text]) {
            //颜色与字能对应上，正确
            _playerOne.backgroundColor = COLOR_OF_TINTGREEN;
            if (sender == _playerOne) {
                //1号玩家
                _gameInfoOne.text = @"完美";
                _gameInfoTwo.text = @"可惜了";
                _scoreOne.text = [NSString stringWithFormat:@"%d",[_scoreOne.text intValue] + 1];
            }else {
                //2号玩家
                _gameInfoOne.text = @"可惜了";
                _gameInfoTwo.text = @"完美";
                _scoreTwo.text = [NSString stringWithFormat:@"%d",[_scoreTwo.text intValue] + 1];
            }
            //正确则减少一次游戏局数
            _currentGameRound--;
            if (_currentGameRound <= 0) {
                _isColorWordGaming = NO;
                //全部游戏结束
                [self createResultView];
                return;
            }
            
        }else {
            //错误
            sender.backgroundColor = COLOR_OF_TINTRED;
            if (sender == _playerOne) {
                //是玩家1
                _gameInfoOne.text = @"搞错了";
                _gameInfoTwo.text = @"真幸运";
                _scoreOne.text = [NSString stringWithFormat:@"%d",[_scoreOne.text intValue] - 1];
            }else {
                //是玩家2
                _gameInfoOne.text = @"真幸运";
                _gameInfoTwo.text = @"搞错了";
                _scoreTwo.text = [NSString stringWithFormat:@"%d",[_scoreTwo.text intValue] - 1];
            }
            
        }
        
        //判断结束，且还有游戏回合数，再次更新游戏
        [self performSelector:@selector(startColorWordGame) withObject:nil afterDelay:2];
    }
    
}


/**
 *  暂停button点击
 */
- (void)pauseButtonPressed
{
    if (_isCountdownGaming) {
        [_countdownTimer setFireDate:[NSDate distantFuture]];
        [ToolManager showAlertViewWithMessage:@"正在暂停中......" cancelTitle:nil confirmTitle:@"恢复" confirmBlock:^{
            [_countdownTimer setFireDate:[NSDate date]];
        }];
    }
    if (_isColorWordGaming) {
        [_colorWordTimer setFireDate:[NSDate distantFuture]];
        [ToolManager showAlertViewWithMessage:@"正在暂停中......" cancelTitle:nil confirmTitle:@"恢复" confirmBlock:^{
            [_colorWordTimer setFireDate:[NSDate date]];
        }];
    }
}

/**
 *  再来一局
 */
- (void)onceAgainButtonPressed
{
    [ToolManager showAlertViewWithMessage:@"确定要重来游戏吗?" cancelTitle:@"取消" confirmTitle:@"确定" confirmBlock:^{
        if (_onceAgain) {
            _onceAgain();
        }
        [self removeFromSuperview];
    }];
}

@end

















