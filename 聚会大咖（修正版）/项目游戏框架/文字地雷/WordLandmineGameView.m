//
//  WordLandmineGameView.m
//  聚会大咖
//
//  Created by jiaxin on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WordLandmineGameView.h"

@interface WordLandmineGameView ()
//记录进入惩罚代码块
@property (nonatomic, copy)void(^punishBlock)();
//再来一局button
@property (nonatomic, strong)QBFlatButton *onceAgain;
//进入惩罚button
@property (nonatomic, strong)QBFlatButton *punish;
//游戏开始后，游戏过程提示label
@property (nonatomic, strong)UILabel *gameProcess;
//游戏操作提示label
@property (nonatomic, strong)UILabel *gameTips;
//开始游戏button
@property (nonatomic, strong)QBFlatButton *startGame;
//修改文字地雷button
@property (nonatomic, strong)QBFlatButton *modify;
//随机字眼button
@property (nonatomic, strong)QBFlatButton *randomWord;
//存放原始字眼数组
@property (nonatomic, strong)NSMutableArray *originalArray;
//存放字眼数组
@property (nonatomic, strong)NSArray *dataArray;
//存放字眼button
@property (nonatomic, strong)NSMutableArray *buttonArray;
//记录地雷的位置
@property (nonatomic, assign)NSInteger minePosition;
//记录地雷对应的button
@property (nonatomic, strong)UIButton *mineButton;
//记录已造句字眼的数量，达到8个的时候为游戏胜利,默认为0
@property (nonatomic, assign)NSInteger usedWordNum;

#pragma mark -- BOOL值，用于记录游戏的各种状态值

//记录是否埋过雷,默认为NO
@property (nonatomic, assign)BOOL hasmined;
//记录是否点击选择了地雷,默认为NO
@property (nonatomic, assign)BOOL ismined;
//记录是否完成了埋雷,默认为NO
@property (nonatomic, assign)BOOL isCompleteMine;
//记录是否允许埋雷，默认为NO
@property (nonatomic, assign)BOOL isAllowMine;
//记录是否开始了游戏，默认为NO
@property (nonatomic, assign)BOOL isGaming;
//记录是否结束了游戏，默认为NO
@property (nonatomic, assign)BOOL isGameOver;

/**
 *  刷新字眼界面
 */
- (void)refreshUserInterface;
/**
 *  开始游戏
 */
- (void)startGameButtonPressed:(QBFlatButton *)sender;
/**
 *  修改文字地雷
 *
 *  @param sender 传入修改用的button，方面修改它的title
 */
- (void)modifyButtonPressed:(QBFlatButton *)sender;
/**
 *  随机字眼button点击
 *
 *  @param sender 随机字眼button
 */
- (void)randomWordButtonPressed:(QBFlatButton *)sender;
/**
 *  再玩一局
 */
- (void)onceAgainButtonPressed:(QBFlatButton *)sender;
/**
 *  进入惩罚
 */
- (void)punishButtonPressed:(QBFlatButton *)sender;

@end

@implementation WordLandmineGameView

- (instancetype)initWithFrame:(CGRect)frame punish:(void (^)())punish
{
    self = [super initWithFrame:frame];
    if (self) {
        self.punishBlock = punish;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeDataSource
{
    _isGaming = NO;
    _isGameOver = NO;
    _hasmined = NO;
    _ismined = NO;
    _isCompleteMine = NO;
    _isAllowMine = NO;
    _buttonArray = [NSMutableArray array];
    _usedWordNum = 0;
    _originalArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"WordLandmine.plist"]];
}

- (void)initializeUserInterface
{
    self.backgroundColor = COLOR_OF_BG;
    
    _gameProcess = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(45, 45, 230, 40)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = COLOR_OF_TINTYELLOW;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0.679 green:0.270 blue:0.058 alpha:1.000];
        label.text = @"点击帮助按钮，获取游戏信息";
        label;
    });
    [self addSubview:_gameProcess];
    
    for (NSInteger i = 0; i < 9; i ++) {
        NSInteger row = i / 3;//行数
        NSInteger list = i % 3;//列数
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((20 + list*100)*SIZE_RATIO, (100 + row*100)*SIZE_RATIO, 80*SIZE_RATIO, 80*SIZE_RATIO);
        button.backgroundColor = COLOR_OF_TINTBULE;
        button.layer.masksToBounds = NO;
        button.layer.cornerRadius = 10;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:33];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonArray addObject:button];
    }
    
    _gameTips = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(30, 400, 260, 25)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = [UIColor colorWithWhite:0.312 alpha:0.610];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"请先点击埋雷，然后开始游戏";
        label.hidden = YES;
        label;
    });
    [self addSubview:_gameTips];
    
    /**
     *  再来一局button
     */
    _onceAgain = [[QBFlatButton alloc] initWithFrame:CGRectMake(20*SIZE_RATIO, 440*SIZE_RATIO, 120*SIZE_RATIO, 40*SIZE_RATIO)];
    _onceAgain.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _onceAgain.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _onceAgain.radius = 15.0;
    _onceAgain.margin = 7.0;
    _onceAgain.depth = 6.0;
    _onceAgain.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_onceAgain setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [_onceAgain setTitle:@"再来一局" forState:UIControlStateNormal];
    [_onceAgain addTarget:self action:@selector(onceAgainButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _onceAgain.hidden = YES;
    [self addSubview:_onceAgain];
    
    /**
     *  进入惩罚button
     */
    _punish = [[QBFlatButton alloc] initWithFrame:CGRectMake(180*SIZE_RATIO, 440*SIZE_RATIO, 120*SIZE_RATIO, 40*SIZE_RATIO)];
    _punish.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _punish.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _punish.radius = 15.0;
    _punish.margin = 7.0;
    _punish.depth = 6.0;
    _punish.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_punish setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [_punish setTitle:@"进入惩罚" forState:UIControlStateNormal];
    [_punish addTarget:self action:@selector(punishButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _punish.hidden = YES;
    [self addSubview:_punish];
    
    /**
     *  开始游戏button
     */
    _startGame = [[QBFlatButton alloc] initWithFrame:CGRectMake(80*SIZE_RATIO, 440*SIZE_RATIO, 160*SIZE_RATIO, 40*SIZE_RATIO)];
    _startGame.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _startGame.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _startGame.radius = 15.0;
    _startGame.margin = 7.0;
    _startGame.depth = 6.0;
    _startGame.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [_startGame setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [_startGame setTitle:@"开始游戏" forState:UIControlStateNormal];
    [_startGame addTarget:self action:@selector(startGameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_startGame];
    
    /**
     *  修改文字地雷button
     */
    _modify = [[QBFlatButton alloc] initWithFrame:CGRectMake(50*SIZE_RATIO, 500*SIZE_RATIO, 100*SIZE_RATIO, 40*SIZE_RATIO)];
    _modify.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _modify.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _modify.radius = 15.0;
    _modify.margin = 7.0;
    _modify.depth = 6.0;
    _modify.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_modify setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [_modify setTitle:@"点击埋雷" forState:UIControlStateNormal];
    [_modify addTarget:self action:@selector(modifyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_modify];
    
    /**
     *  随机字眼button
     */
    _randomWord = [[QBFlatButton alloc] initWithFrame:CGRectMake(170*SIZE_RATIO, 500*SIZE_RATIO, 100*SIZE_RATIO, 40*SIZE_RATIO)];
    _randomWord.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _randomWord.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _randomWord.radius = 15.0;
    _randomWord.margin = 7.0;
    _randomWord.depth = 6.0;
    _randomWord.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_randomWord setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
    [_randomWord setTitle:@"随机字眼" forState:UIControlStateNormal];
    [_randomWord addTarget:self action:@selector(randomWordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_randomWord];
    
    [self refreshUserInterface];
}


#pragma mark -- action

- (void)refreshUserInterface
{
    NSInteger randomIndex = arc4random()%_originalArray.count;
//    _dataArray = [NSArray arrayWithArray:_originalArray[randomIndex]];
    _dataArray = [DataManager getRandomArrayWithArray:_originalArray[randomIndex]];
    for (NSInteger i = 0; i < _dataArray.count; i ++) {
        UIButton *button = (UIButton *)_buttonArray[i];
        [button setTitle:_dataArray[i] forState:UIControlStateNormal];
    }
}

/**
 *  button点击事件
 */
- (void)buttonPressed:(UIButton *)sender
{
    if (_isAllowMine) {
        //允许埋雷
        
//        if (!_ismined) {
//            //还没有埋雷
//            [sender setImage:IMAGE_WITH_NAME(@"bomb.png") forState:UIControlStateNormal];
//            sender.backgroundColor = [UIColor clearColor];
//            [sender setTitle:@"" forState:UIControlStateNormal];
//            _minePosition = [_buttonArray indexOfObject:sender];
//            _ismined = YES;
//            _hasmined = YES;
//            _mineButton = sender;
//        }else {
//            //已经埋雷
////            _gameTips.hidden = YES;
////            _gameTips.text = @"若想换雷，请先确定再修改";
//            if (_mineButton) {
//                [_mineButton setImage:nil forState:UIControlStateNormal];
//                _mineButton.backgroundColor = COLOR_OF_TINTBULE;
//                [_mineButton setTitle:_dataArray[_minePosition] forState:UIControlStateNormal];
//            }
//            
//        }
        
        if (_mineButton) {
            //已选了雷，但是没埋，正想修改
            [_mineButton setImage:nil forState:UIControlStateNormal];
            _mineButton.backgroundColor = COLOR_OF_TINTBULE;
            [_mineButton setTitle:_dataArray[_minePosition] forState:UIControlStateNormal];
        }
        [sender setImage:IMAGE_WITH_NAME(@"bomb.png") forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor clearColor];
        [sender setTitle:@"" forState:UIControlStateNormal];
        _minePosition = [_buttonArray indexOfObject:sender];
        _ismined = YES;
        _hasmined = YES;
        _mineButton = sender;
        
    }
    
    if (_isGaming) {
        //游戏开始了
        if (sender == _mineButton) {
            //如果点击了地雷
            sender.userInteractionEnabled = NO;
            [sender setImage:IMAGE_WITH_NAME(@"bomb.png") forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor clearColor];
            [sender setTitle:@"" forState:UIControlStateNormal];
            //游戏结束
            [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse animations:^{
                sender.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:^(BOOL finished) {
                
            }];
            if (!_isGameOver) {
                _gameProcess.text = @"爆炸!!!GameOver!!!";
                _isGameOver = YES;
            }
            _startGame.hidden = YES;
            _onceAgain.hidden = NO;
            _punish.hidden = NO;
        }else {
            //如果没有点击地雷
            sender.backgroundColor = COLOR_OF_TINTGREEN;
            sender.userInteractionEnabled = NO;
            if (++_usedWordNum == 8) {
                //游戏胜利，对方接受惩罚
                if (!_isGameOver) {
                    _gameProcess.text = @"胜利!!!让对方接受惩罚吧!!!";
                    _isGameOver = YES;
                }
                _startGame.hidden = YES;
                _onceAgain.hidden = NO;
                _punish.hidden = NO;
            }
        }
    }
}
/**
 *  开始游戏
 */
- (void)startGameButtonPressed:(QBFlatButton *)sender
{
    if (_isCompleteMine) {
        //已经埋好雷了
        _gameTips.hidden = NO;
        _gameTips.text = @"正在游戏中......";
        _randomWord.userInteractionEnabled = NO;
        _modify.userInteractionEnabled = NO;
        //进入游戏环节
        _gameProcess.hidden = NO;
        _gameProcess.text = @"请每个玩家随意用两个字眼造句";
        _isGaming = YES;
    }else {
        //还没有埋好雷
        _gameTips.hidden = NO;
        _gameTips.text = @"正在埋雷或修改埋雷，请确认后再开始游戏";
    }
}
/**
 *  修改文字地雷
 *
 *  @param sender 传入修改用的button，方面修改它的title
 */
- (void)modifyButtonPressed:(QBFlatButton *)sender
{
    _gameTips.hidden = YES;
    
    if ([[sender currentTitle] isEqualToString:@"点击埋雷"]) {
        //当前为『点击埋雷』
        [sender setTitle:@"确认埋雷" forState:UIControlStateNormal];
        _isAllowMine = YES;
        _gameTips.hidden = NO;
        _gameTips.text = @"请点击一个字眼设置为地雷";
        
    }else if ([[sender currentTitle] isEqualToString:@"确认埋雷"]) {
        //当前为『确认埋雷』
        if (!_ismined) {
            //如果还没有埋好雷
            _gameTips.hidden = NO;
            _gameTips.text = @"请先点击一个字眼作为地雷，再确认";
            return;
        }
        [sender setTitle:@"修改埋雷" forState:UIControlStateNormal];
        _isAllowMine = NO;
        _isCompleteMine = YES;
        [_mineButton setImage:nil forState:UIControlStateNormal];
        _mineButton.backgroundColor = COLOR_OF_TINTBULE;
        [_mineButton setTitle:_dataArray[_minePosition] forState:UIControlStateNormal];
        
    }else if ([[sender currentTitle] isEqualToString:@"修改埋雷"]) {
        //当前为『修改埋雷』
        [sender setTitle:@"确认修改" forState:UIControlStateNormal];
        _isAllowMine = YES;
        _ismined = NO;
        _isCompleteMine = NO;
        _gameTips.hidden = NO;
        _gameTips.text = @"请点击一个字眼设置为地雷";
        
    }else if ([[sender currentTitle] isEqualToString:@"确认修改"]) {
        //当前为『确认修改』
        if (!_ismined) {
            //如果选择要修改的地雷
            _gameTips.hidden = NO;
            _gameTips.text = @"请先点击一个字眼作为地雷，再确认";
            return;
        }
        [sender setTitle:@"修改埋雷" forState:UIControlStateNormal];
        _isAllowMine = NO;
        _isCompleteMine = YES;
        [_mineButton setImage:nil forState:UIControlStateNormal];
        _mineButton.backgroundColor = COLOR_OF_TINTBULE;
        [_mineButton setTitle:_dataArray[_minePosition] forState:UIControlStateNormal];
    }
}
/**
 *  随机字眼button点击
 *
 *  @param sender 随机字眼button
 */
- (void)randomWordButtonPressed:(QBFlatButton *)sender
{
    if (!_hasmined) {
        [self refreshUserInterface];
    }else {
        _gameTips.hidden = NO;
        _gameTips.text = @"正在埋雷或已经埋过雷，不能随机字眼了";
    }
}

/**
 *  再玩一局
 */
- (void)onceAgainButtonPressed:(QBFlatButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WordLandmineOnceAgain" object:nil];
    [self removeFromSuperview];
}
/**
 *  进入惩罚
 */
- (void)punishButtonPressed:(QBFlatButton *)sender
{
    if (_punishBlock) {
        _punishBlock();
    }
}


@end







