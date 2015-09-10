//
//  GestureAndGuessViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "GestureAndGuessViewController.h"
#import "GestureAndGuessSettingView.h"
#import "GestureAndGuessGameView.h"
#import "SelectWordTypeView.h"
#import "ScoreView.h"


@interface GestureAndGuessViewController ()

//帮助页面
@property (nonatomic, strong)HelpView *helpView;

/**
 *  创建游戏设置页面
 */
- (void)createGameSettingView;
/**
 *  通过设置数据创建游戏视图
 *
 *  @param settingData 设置数据
 */
- (void)createGameViewWithSettingData:(NSDictionary *)settingData;
/**
 *  通过玩家游戏数据创建结果视图
 *
 *  @param data 玩家游戏结束数据
 */
- (void)createScoreViewWithData:(NSArray *)data;

@end

@implementation GestureAndGuessViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"心有灵犀";
    self.view.backgroundColor = [UIColor colorWithRed:0 green:189/255.0 blue:156.0/255 alpha:1];
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods

- (void)initializeDataSource
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(punishView) name:@"GestureAndGuessPunish" object:nil];
}

- (void)initializeUserInterface
{
    [self createGameSettingView];
}

/**
 *  创建游戏设置页面
 */
- (void)createGameSettingView
{
    __weak typeof(self) weakSelf = self;
    GestureAndGuessSettingView *settingView = [[GestureAndGuessSettingView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED settingCompleted:^(NSDictionary *settingData) {
        [weakSelf createGameViewWithSettingData:settingData];
    }];
    
    [self.view addSubview:settingView];
}

/**
 *  通过设置数据创建游戏视图
 *
 *  @param settingData 设置数据
 */
- (void)createGameViewWithSettingData:(NSDictionary *)settingData
{
    __weak typeof(self) weakSelf = self;
    GestureAndGuessGameView *gameView = [[GestureAndGuessGameView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED wordType:settingData[@"wordType"] time:[settingData[@"time"] integerValue] groupNumber:[settingData[@"groupNumber"] integerValue] completed:^(NSArray *result) {
        //游戏结束
        [weakSelf createScoreViewWithData:result];
    } backToMenu:^{
        //游戏中途返回重来
        [weakSelf createGameSettingView];
    }];
    [self.view addSubview:gameView];
}

/**
 *  通过玩家游戏数据创建结果视图
 *
 *  @param data 玩家游戏结束数据
 */
- (void)createScoreViewWithData:(NSArray *)data
{
    __weak typeof(self) weakSelf = self;
    //显示分数
    ScoreView *scoreTableView = [[ScoreView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED data:data completed:^() {
        [weakSelf createGameSettingView];
    }];
    [self.view addSubview:scoreTableView];
}

#pragma mark -- action

- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"心有灵犀\n①.选择词语类型，进入词语类型选择界面，点击相应的词语类型即可，也可以点击下方的随机选择按钮随机选择。\n②.设置游戏时间，游戏时间默认每组为30s，点击可以选择其他时间。\n③.设置参与游戏的小组数目，默认为3组，可通过下面的按钮加减选择组数。\n④.以上设置完毕后，点击开始正式进入游戏界面。\n⑤.点击开始开始游戏，队友答对则按下正确按钮，答对次数+1，若打不上来，可选择跳过，倒计时为0后传给下一组猜词。\n⑥.每组都结束游戏后，显示各小组的得分，等分低得小组将接受惩罚。点击惩罚按钮接受惩罚。惩罚结束后点击返回结束游戏。";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

/**
 *  进入惩罚
 */
- (void)punishView
{
    InnerWordAndAdventureViewController *punishVC = [[InnerWordAndAdventureViewController alloc] init];
    [self.navigationController pushViewController:punishVC animated:YES];
}

@end
