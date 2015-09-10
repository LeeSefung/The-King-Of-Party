//
//  FindKillerPlayerListView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/28.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FindKillerPlayerListView.h"
#import "FindKillerPlayerListCollectionView.h"
#import "FindKillerResultView.h"

@interface FindKillerPlayerListView ()<FindKillerPlayerListCollectionViewDelegate>

#pragma mark -- property
/**
 *  记录传入的玩家们的信息
 */
@property (nonatomic, strong)NSArray *playersInfo;
/**
 *  玩家列表背景视图
 */
@property (nonatomic, strong)UIView *playerListBGView;
/**
 *  玩家列表CollectionView
 */
@property (nonatomic, strong)FindKillerPlayerListCollectionView *playerListCollectionView;
/**
 *  记录平民被杀说明label，方便更新显示信息peopleKilledByVoted
 */
@property (nonatomic, strong)UILabel *peopleKilledExplainLabel;
/**
 *  记录玩家被投票致死说明label，方便更新显示信息
 */
@property (nonatomic, strong)UILabel *peopleKilledByVotedExplainLabel;
/**
 *  玩家列表下方用于显示当前游戏提示
 */
@property (nonatomic, strong)UILabel *gameTips;
/**
 *  记录当前被杀的人的信息，count为编号，identity为身份
 */
@property (nonatomic, strong)NSDictionary *currenKilledInfo;
/**
 *  用于区分是被杀手杀死，还是投票致死,YES为投票状态，默认为NO
 */
@property (nonatomic, assign)BOOL isVoting;
/**
 *  查看身份按钮
 */
@property (nonatomic, strong)QBFlatButton *check;
/**
 *  开始游戏按钮
 */
@property (nonatomic, strong)QBFlatButton *startGame;
/**
 *  警察完成验人按钮
 */
@property (nonatomic, strong)QBFlatButton *checkCompleted;
/**
 *  每一轮开始引导视图
 */
@property (nonatomic, strong)UIView *eachRoundBegainView;
/**
 *  警察验人引导视图
 */
@property (nonatomic, strong)UIView *policeCheckView;
/**
 *  警察验人结果引导视图
 */
@property (nonatomic, strong)UIView *policeCheckResultView;
/**
 *  平民被杀引导视图
 */
@property (nonatomic, strong)UIView *peopleKilledView;
/**
 *  平民被投票致死引导视图
 */
@property (nonatomic, strong)UIView *peopleKilledByVotedView;

#pragma mark -- action
/**
 *  查看玩家身份按钮按下时触发的事件
 */
- (void)checkButtonTouchDown;
/**
 *  查看玩家身份按钮按弹起时触发的事件
 */
- (void)checkButtonTouchUpInside;
/**
 *  开始游戏按钮触发的事件
 */
- (void)startGameButtonPressed;
/**
 *  传入frame和text，获得引导界面专用的法官label
 */
- (UILabel *)createGuideJudgeLabelWithFrame:(CGRect)frame;
/**
 *  传入frame和text，获得引导界面专用的label
 */
- (UILabel *)createGuideLabelWithFrame:(CGRect)frame text:(NSString *)text;
/**
 *  传入frame和text，获得引导界面专用的下一步label
 */
- (UILabel *)createGuideNextLabelWithFrame:(CGRect)frame;
/**
 *  传入frame和text，获得引导界面专用的label，不带点击事件
 */
- (QBFlatButton *)createGuideButtonWithFrame:(CGRect)frame text:(NSString *)text;

@end

@implementation FindKillerPlayerListView

- (instancetype)initWithFrame:(CGRect)frame playersInfo:(NSArray *)playersInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.playersInfo = playersInfo;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

#pragma mark -- initialize methods

- (void)initializeDataSource
{
    _isVoting = NO;
}

- (void)initializeUserInterface
{
    self.backgroundColor = COLOR_OF_BG;
    /**
     *  创建玩家列表视图
     */
    [self addSubview:self.playerListBGView];
    
    /**
     *  设置查看玩家身份button
     */
    _check = [[QBFlatButton alloc] initWithFrame:CGRectMake(100*SIZE_RATIO, 518*SIZE_RATIO, 130*SIZE_RATIO, 30*SIZE_RATIO)];
    _check.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    _check.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    _check.radius = 10.0;
    _check.margin = 4.0;
    _check.depth = 3.0;
    _check.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_check setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_check setTitle:@"查看玩家身份" forState:UIControlStateNormal];
    [_check addTarget:self action:@selector(checkButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_check addTarget:self action:@selector(checkButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_check addTarget:self action:@selector(checkButtonTouchUpInside) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:_check];
    
    /**
     *  设置重来button
     */
    QBFlatButton *again = [[QBFlatButton alloc] initWithFrame:CGRectMake(20*SIZE_RATIO, 518*SIZE_RATIO, 50*SIZE_RATIO, 30*SIZE_RATIO)];
    again.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    again.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    again.radius = 10.0;
    again.margin = 4.0;
    again.depth = 3.0;
    again.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [again setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [again setTitle:@"重来" forState:UIControlStateNormal];
    [again addTarget:self action:@selector(againButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:again];
    
    
}

/**
 *  玩家列表背景视图
 */
- (UIView *)playerListBGView
{
    if (!_playerListBGView) {
        
        _playerListBGView = [[UIView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 500)];
        _playerListBGView.backgroundColor = COLOR_OF_BG;
        [self addSubview:_playerListBGView];
        /**
         *  根据玩家总人数创建玩家列表
         */
        _playerListCollectionView = [[FindKillerPlayerListCollectionView alloc] initWithFrame:CGRectMake(0, 44, 320*SIZE_RATIO, (500 - 44 - 60)*SIZE_RATIO) playersInfo:_playersInfo];
        _playerListCollectionView.resultDelegate = self;
        [_playerListBGView addSubview:_playerListCollectionView];
        
        /**
         *  设置开始游戏button
         */
        _startGame = [[QBFlatButton alloc] initWithFrame:CGRectMake(85*SIZE_RATIO, CGRectGetMaxY(_playerListCollectionView.frame) + 20*SIZE_RATIO, 150*SIZE_RATIO, 40*SIZE_RATIO)];
        _startGame.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        _startGame.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        _startGame.radius = 10.0;
        _startGame.margin = 7.0;
        _startGame.depth = 6.0;
        _startGame.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_startGame setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
        [_startGame setTitle:@"开始游戏" forState:UIControlStateNormal];
        [_startGame addTarget:self action:@selector(startGameButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_playerListBGView addSubview:_startGame];
        
        /**
         *  设置警察完成验人button
         */
        _checkCompleted = [[QBFlatButton alloc] initWithFrame:CGRectMake(85*SIZE_RATIO, CGRectGetMaxY(_playerListCollectionView.frame), 150*SIZE_RATIO, 40*SIZE_RATIO)];
        _checkCompleted.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        _checkCompleted.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        _checkCompleted.radius = 10.0;
        _checkCompleted.margin = 7.0;
        _checkCompleted.depth = 6.0;
        _checkCompleted.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_checkCompleted setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
        [_checkCompleted setTitle:@"完成验人" forState:UIControlStateNormal];
        [_checkCompleted addTarget:self action:@selector(checkCompletedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _checkCompleted.hidden = YES;
        [_playerListBGView addSubview:_checkCompleted];
        
        _gameTips = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(_playerListCollectionView.frame) + 30*SIZE_RATIO, 200*SIZE_RATIO, 40*SIZE_RATIO)];
            label.font = [UIFont systemFontOfSize:18];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = COLOR_OF_TINTYELLOW;
            label.text = @"长按选择要杀的人";
            label.hidden = YES;
            label;
        });
        [_playerListBGView addSubview:_gameTips];
        
    }
    return _playerListBGView;
}
/**
 *  每一轮开始引导视图
 */
- (UIView *)eachRoundBegainView
{
    if (!_eachRoundBegainView) {
        _eachRoundBegainView = [[UIView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 500)];
        _eachRoundBegainView.backgroundColor = COLOR_OF_BG;
        [self addSubview:_eachRoundBegainView];
        
        CGFloat margin = 30*SIZE_RATIO;
        CGFloat labelX = 60*SIZE_RATIO;
        CGFloat labelWidth = 200*SIZE_RATIO;
        CGFloat labelHeight = 30*SIZE_RATIO;
        
        UILabel *judge = [self createGuideJudgeLabelWithFrame:CGRectMake(110*SIZE_RATIO, 100*SIZE_RATIO, 100*SIZE_RATIO, 40)];
        [_eachRoundBegainView addSubview:judge];
        
        UILabel *closeEyes = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(judge.frame) + margin, labelWidth, labelHeight) text:@"天黑请闭眼"];
        [_eachRoundBegainView addSubview:closeEyes];
        
        UILabel *nextOne = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(closeEyes.frame), 200*SIZE_RATIO, 20)];
        [_eachRoundBegainView addSubview:nextOne];
        
        UILabel *killerOpenEyes = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(closeEyes.frame) + margin, labelWidth, labelHeight) text:@"杀手请睁眼"];
        [_eachRoundBegainView addSubview:killerOpenEyes];
        
        UILabel *nextTwo = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(killerOpenEyes.frame), 200*SIZE_RATIO, 20)];
        [_eachRoundBegainView addSubview:nextTwo];
        
        UILabel *killPeople = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(killerOpenEyes.frame) + margin, labelWidth, labelHeight) text:@"请杀手指定要杀的一个人"];
        [_eachRoundBegainView addSubview:killPeople];
        
        UILabel *nextThree = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(killPeople.frame), 200*SIZE_RATIO, 20)];
        [_eachRoundBegainView addSubview:nextThree];
        
        QBFlatButton *button = [self createGuideButtonWithFrame:CGRectMake(labelX + 10*SIZE_RATIO, CGRectGetMaxY(killPeople.frame) + margin, labelWidth - 20*SIZE_RATIO, 40*SIZE_RATIO) text:@"点击杀人"];
        [button addTarget:self action:@selector(killerKillPeople) forControlEvents:UIControlEventTouchUpInside];
        [_eachRoundBegainView addSubview:button];
    }
    return _eachRoundBegainView;
}
/**
 *  警察验人引导视图
 */
- (UIView *)policeCheckView
{
    if (!_policeCheckView) {
        _policeCheckView = [[UIView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 500)];
        _policeCheckView.backgroundColor = COLOR_OF_BG;
        [self addSubview:_policeCheckView];
        
        CGFloat margin = 30*SIZE_RATIO;
        CGFloat labelX = 60*SIZE_RATIO;
        CGFloat labelWidth = 200*SIZE_RATIO;
        CGFloat labelHeight = 30*SIZE_RATIO;
        
        UILabel *judge = [self createGuideJudgeLabelWithFrame:CGRectMake(110*SIZE_RATIO, 100*SIZE_RATIO, 100*SIZE_RATIO, 40)];
        [_policeCheckView addSubview:judge];
        
        UILabel *closeEyes = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(judge.frame) + margin, labelWidth, labelHeight) text:@"杀手请闭眼，警察请睁眼"];
        [_policeCheckView addSubview:closeEyes];
        
        UILabel *nextOne = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(closeEyes.frame), 200*SIZE_RATIO, 20)];
        [_policeCheckView addSubview:nextOne];
        
        UILabel *policeCheck = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(closeEyes.frame) + margin, labelWidth, labelHeight) text:@"警察请验人"];
        [_policeCheckView addSubview:policeCheck];
        
        UILabel *nextTwo = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(policeCheck.frame), 200*SIZE_RATIO, 20)];
        [_policeCheckView addSubview:nextTwo];
        
        QBFlatButton *button = [self createGuideButtonWithFrame:CGRectMake(labelX + 10*SIZE_RATIO, CGRectGetMaxY(policeCheck.frame) + margin, labelWidth - 20*SIZE_RATIO, 40*SIZE_RATIO) text:@"点击验人"];
        [button addTarget:self action:@selector(checkPeople) forControlEvents:UIControlEventTouchUpInside];
        [_policeCheckView addSubview:button];
        
    }
    return _policeCheckView;
}
/**
 *  警察验人结果引导视图
 */
- (UIView *)policeCheckResultView
{
    if (!_policeCheckResultView) {
        _policeCheckResultView = [[UIView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 500)];
        _policeCheckResultView.backgroundColor = COLOR_OF_BG;
        [self addSubview:_policeCheckResultView];
        
        CGFloat margin = 30*SIZE_RATIO;
        CGFloat labelX = 60*SIZE_RATIO;
        CGFloat labelWidth = 200*SIZE_RATIO;
        CGFloat labelHeight = 30*SIZE_RATIO;
        
        UILabel *judge = [self createGuideJudgeLabelWithFrame:CGRectMake(110*SIZE_RATIO, 100*SIZE_RATIO, 100*SIZE_RATIO, 40)];
        [_policeCheckResultView addSubview:judge];
        
        UILabel *tips = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(judge.frame) + margin, labelWidth, labelHeight) text:@"拇指向上是杀手，向下是好人"];
        [_policeCheckResultView addSubview:tips];
        
        UILabel *nextOne = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(tips.frame), 200*SIZE_RATIO, 20)];
        [_policeCheckResultView addSubview:nextOne];
        
        UILabel *policeCloseEyes = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(tips.frame) + margin, labelWidth, labelHeight) text:@"警察请闭眼"];
        [_policeCheckResultView addSubview:policeCloseEyes];
        
        UILabel *nextTwo = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(policeCloseEyes.frame), 200*SIZE_RATIO, 20)];
        [_policeCheckResultView addSubview:nextTwo];
        
        UILabel *allOpenEyes = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(policeCloseEyes.frame) + margin, labelWidth, labelHeight) text:@"天亮了，所有人请睁眼"];
        [_policeCheckResultView addSubview:allOpenEyes];
        
        UILabel *nextThree = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(allOpenEyes.frame), 200*SIZE_RATIO, 20)];
        [_policeCheckResultView addSubview:nextThree];
        
        QBFlatButton *button = [self createGuideButtonWithFrame:CGRectMake(labelX + 10*SIZE_RATIO, CGRectGetMaxY(allOpenEyes.frame) + margin, labelWidth - 20*SIZE_RATIO, 40*SIZE_RATIO) text:@"点击继续"];
        [button addTarget:self action:@selector(checkPeopleCompleted) forControlEvents:UIControlEventTouchUpInside];
        [_policeCheckResultView addSubview:button];
    }
    return _policeCheckResultView;
}
/**
 *  平民被杀引导视图
 */
- (UIView *)peopleKilledView
{
    if (!_peopleKilledView) {
        _peopleKilledView = [[UIView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 500)];
        _peopleKilledView.backgroundColor = COLOR_OF_BG;
        [self addSubview:_peopleKilledView];
        
        CGFloat margin = 30*SIZE_RATIO;
        CGFloat labelX = 60*SIZE_RATIO;
        CGFloat labelWidth = 200*SIZE_RATIO;
        CGFloat labelHeight = 30*SIZE_RATIO;
        
        UILabel *judge = [self createGuideJudgeLabelWithFrame:CGRectMake(110*SIZE_RATIO, 100*SIZE_RATIO, 100*SIZE_RATIO, 40)];
        [_peopleKilledView addSubview:judge];
        
        UILabel *explain = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(judge.frame) + margin, labelWidth, labelHeight) text:[NSString stringWithFormat:@"%@号被杀,有遗言",_currenKilledInfo[@"count"]]];

        [_peopleKilledView addSubview:explain];
        self.peopleKilledExplainLabel = explain;
        
        UILabel *nextOne = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(explain.frame), 200*SIZE_RATIO, 20)];
        [_peopleKilledView addSubview:nextOne];
        
        UILabel *speak = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(explain.frame) + margin, labelWidth, labelHeight) text:@"从死者左边第一个人开始发言"];
        [_peopleKilledView addSubview:speak];
        
        UILabel *nextTwo = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(speak.frame), 200*SIZE_RATIO, 20)];
        [_peopleKilledView addSubview:nextTwo];
        
        
        QBFlatButton *button = [self createGuideButtonWithFrame:CGRectMake(labelX + 10*SIZE_RATIO, CGRectGetMaxY(speak.frame) + margin, labelWidth - 20*SIZE_RATIO, 40*SIZE_RATIO) text:@"点击投票"];
        [button addTarget:self action:@selector(startVoting) forControlEvents:UIControlEventTouchUpInside];
        [_peopleKilledView addSubview:button];
        
        QBFlatButton *same = [self createGuideButtonWithFrame:CGRectMake(labelX + 10*SIZE_RATIO, CGRectGetMaxY(button.frame) + margin, labelWidth - 20*SIZE_RATIO, 40*SIZE_RATIO) text:@"票数相同"];
        [same addTarget:self action:@selector(sameVote) forControlEvents:UIControlEventTouchUpInside];
        [_peopleKilledView addSubview:same];
        
    }
    if (_peopleKilledExplainLabel) {
        _peopleKilledExplainLabel.text = [NSString stringWithFormat:@"%@号被杀,有遗言",_currenKilledInfo[@"count"]];
//        ,_currenKilledInfo[@"identity"]
    }
    return _peopleKilledView;
}
/**
 *  被投票致死且游戏未结束引导视图
 */
- (UIView *)peopleKilledByVotedView
{
    if (!_peopleKilledByVotedView) {
        _peopleKilledByVotedView = [[UIView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 500)];
        _peopleKilledByVotedView.backgroundColor = COLOR_OF_BG;
        [self addSubview:_peopleKilledByVotedView];
        
        CGFloat margin = 30*SIZE_RATIO;
        CGFloat labelX = 60*SIZE_RATIO;
        CGFloat labelWidth = 200*SIZE_RATIO;
        CGFloat labelHeight = 30*SIZE_RATIO;
        
        UILabel *judge = [self createGuideJudgeLabelWithFrame:CGRectMake(110*SIZE_RATIO, 100*SIZE_RATIO, 100*SIZE_RATIO, 40)];
        [_peopleKilledByVotedView addSubview:judge];
        
        UILabel *explain = [self createGuideLabelWithFrame:CGRectMake(labelX, CGRectGetMaxY(judge.frame) + margin, labelWidth, labelHeight) text:[NSString stringWithFormat:@"%@号被票死,有遗言",_currenKilledInfo[@"count"]]];
//        ,_currenKilledInfo[@"identity"]
        [_peopleKilledByVotedView addSubview:explain];
        self.peopleKilledByVotedExplainLabel = explain;
        
        UILabel *nextOne = [self createGuideNextLabelWithFrame:CGRectMake(60*SIZE_RATIO, CGRectGetMaxY(explain.frame), 200*SIZE_RATIO, 20)];
        [_peopleKilledByVotedView addSubview:nextOne];
        
        QBFlatButton *button = [self createGuideButtonWithFrame:CGRectMake(labelX + 10*SIZE_RATIO, CGRectGetMaxY(explain.frame) + margin, labelWidth - 20*SIZE_RATIO, 40*SIZE_RATIO) text:@"下一轮"];
        [button addTarget:self action:@selector(nextRound) forControlEvents:UIControlEventTouchUpInside];
        [_peopleKilledByVotedView addSubview:button];
        
    }
    if (_peopleKilledByVotedExplainLabel) {
        _peopleKilledByVotedExplainLabel.text = [NSString stringWithFormat:@"%@号被票死,有遗言",_currenKilledInfo[@"count"]];
//        ,_currenKilledInfo[@"identity"]
    }
    return _peopleKilledByVotedView;
}

#pragma mark -- guide

- (UILabel *)createGuideJudgeLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5;
    label.backgroundColor = COLOR_OF_TINTYELLOW;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.679 green:0.270 blue:0.058 alpha:1.000];
    label.text = @"法官台词";
    return label;
}

- (UILabel *)createGuideLabelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5;
    label.backgroundColor = COLOR_OF_TINTBULE;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = text;
    return label;
}

- (UILabel *)createGuideNextLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.832 alpha:1.000];
    label.text = @"|下一步|";
    return label;
}

- (QBFlatButton *)createGuideButtonWithFrame:(CGRect)frame text:(NSString *)text
{
    QBFlatButton *button = [[QBFlatButton alloc] initWithFrame:frame];
    button.faceColor = [UIColor colorWithRed:0.892 green:0.790 blue:0.160 alpha:1.000];
    button.sideColor = [UIColor colorWithRed:0.679 green:0.560 blue:0.111 alpha:1.000];
    button.radius = 10.0;
    button.margin = 7.0;
    button.depth = 6.0;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button setTitleColor:[UIColor colorWithRed:0.679 green:0.270 blue:0.058 alpha:1.000] forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}

#pragma mark -- <FindKillerPlayerListCollectionViewDelegate>
/**
 *  游戏结束，显示游戏结果视图
 */
- (void)gameOverWithIsKillerWin:(BOOL)isKillerWin playerInfo:(NSArray *)playerInfo
{
    FindKillerResultView *resultView = [[FindKillerResultView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED isKillerWin:isKillerWin  playerInfo:playerInfo];
    [self addSubview:resultView];
}
/**
 *  警察开始验人
 */
- (void)policeStartCheckPeopleWithKilledInfo:(NSDictionary *)info
{
    //用属性记录被杀人的信息
    _currenKilledInfo = nil;
    _currenKilledInfo = [NSDictionary dictionaryWithDictionary:info];

    if (!_isVoting) {
        //不是投票状态
        [self addSubview:self.policeCheckView];
        [self sendSubviewToBack:_policeCheckView];
        [UIView animateWithDuration:0.5 animations:^{
            _playerListBGView.transform = CGAffineTransformMakeTranslation(0, -568*SIZE_RATIO);
            _check.alpha = 0;
        }];
        _isVoting = YES;
    }else {
        //投票状态
        [self addSubview:self.peopleKilledByVotedView];
        _isVoting = NO;
    }
    
}

/**
 *  杀手杀人阶段，提示杀手不能杀杀手
 */
- (void)killerCantKillKillerTips
{
    _gameTips.hidden = NO;
    _gameTips.text = @"杀手不能杀杀手(┯_┯) ";
}
#pragma mark -- action

- (void)againButtonPressed
{
    [ToolManager showAlertViewWithMessage:@"确认要重新开始游戏吗？" cancelTitle:@"取消" confirmTitle:@"确定" confirmBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FindKilleronceAgin" object:nil];
        [self removeFromSuperview];
    }];
}

- (void)checkButtonTouchDown
{
    _playerListCollectionView.isHiddenIdentity = NO;
    [_playerListCollectionView reloadData];
}

- (void)checkButtonTouchUpInside
{
    _playerListCollectionView.isHiddenIdentity = YES;
    [_playerListCollectionView reloadData];
}

- (void)startGameButtonPressed
{
    [self addSubview:self.eachRoundBegainView];
    [self sendSubviewToBack:_eachRoundBegainView];
    [UIView animateWithDuration:0.5 animations:^{
        _playerListBGView.transform = CGAffineTransformMakeTranslation(0, -568*SIZE_RATIO);
        _check.alpha = 0;
    }];
}

/**
 *  杀手开始杀人
 */
- (void)killerKillPeople
{
    _startGame.hidden = YES;
    _checkCompleted.hidden = YES;
    _gameTips.hidden = NO;
    _gameTips.text = @"长按选择要杀的人";
    [self bringSubviewToFront:_playerListBGView];
    [UIView animateWithDuration:0.5 animations:^{
        _playerListBGView.transform = CGAffineTransformIdentity;
        _check.alpha = 1;
    } completion:^(BOOL finished) {
        _playerListCollectionView.isAllowLongPress = YES;
        _playerListCollectionView.isVoting = NO;
        [_playerListCollectionView reloadData];
        if (_eachRoundBegainView) {
            [_eachRoundBegainView removeFromSuperview];
        }
    }];
}
/**
 *  警察开始验人
 */
- (void)checkPeople
{
    _startGame.hidden = YES;
    _checkCompleted.hidden = NO;
    _gameTips.hidden = NO;
    _gameTips.text = @"点击下方查看身份按钮";
    [self bringSubviewToFront:_playerListBGView];
    [UIView animateWithDuration:0.5 animations:^{
        _playerListBGView.transform = CGAffineTransformIdentity;
        _check.alpha = 1;
    } completion:^(BOOL finished) {
        _playerListCollectionView.isAllowLongPress = NO;
        _playerListCollectionView.isVoting = NO;
        [_playerListCollectionView reloadData];
        if (_policeCheckView) {
            [_policeCheckView removeFromSuperview];
        }
    }];
}

/**
 *  警察完成验人按钮
 */
- (void)checkCompletedButtonPressed
{
    [self addSubview:self.policeCheckResultView];
    [self sendSubviewToBack:_policeCheckResultView];
    [UIView animateWithDuration:0.5 animations:^{
        _playerListBGView.transform = CGAffineTransformMakeTranslation(0, -568*SIZE_RATIO);
        _check.alpha = 0;
    }];
}
/**
 *  给警察验人指示完毕之后，点击继续按钮
 */
- (void)checkPeopleCompleted
{
    [self addSubview:self.peopleKilledView];
    if (_policeCheckResultView) {
        [_policeCheckResultView removeFromSuperview];
    }
}
/**
 *  开始投票
 */
- (void)startVoting
{
    _startGame.hidden = YES;
    _checkCompleted.hidden = YES;
    _gameTips.hidden = NO;
    _gameTips.text = @"长按选择要票的人";
    [self bringSubviewToFront:_playerListBGView];
    [UIView animateWithDuration:0.5 animations:^{
        _playerListBGView.transform = CGAffineTransformIdentity;
        _check.alpha = 1;
    } completion:^(BOOL finished) {
        _playerListCollectionView.isAllowLongPress = YES;
        _playerListCollectionView.isVoting = YES;
        [_playerListCollectionView reloadData];
        if (_peopleKilledView) {
            [_peopleKilledView removeFromSuperview];
        }
    }];
}
/**
 *  票数相同
 */
- (void)sameVote
{
    _isVoting = NO;
    [self addSubview:self.eachRoundBegainView];
    if (_peopleKilledView) {
        [_peopleKilledView removeFromSuperview];
    }
}
/**
 *  进入下一轮游戏
 */
- (void)nextRound
{
    [self addSubview:self.eachRoundBegainView];
    if (_peopleKilledByVotedView) {
        [_peopleKilledByVotedView removeFromSuperview];
    }
}
@end















