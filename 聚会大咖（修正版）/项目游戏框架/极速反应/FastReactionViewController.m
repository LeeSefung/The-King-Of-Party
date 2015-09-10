//
//  FastReactionViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FastReactionViewController.h"
#import "FastReactionSettingView.h"
#import "FastReactionGameView.h"

@interface FastReactionViewController ()
//帮助视图
@property (nonatomic, strong)HelpView *helpView;
/**
 *  初始化游戏场景
 */
- (void)createGameScene;
/**
 *  通过游戏回合数创建游戏视图
 *
 *  @param gameRound 游戏回合数
 */
- (void)createGameViewWithGameRound:(NSInteger)gameRound;


@end

@implementation FastReactionViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods

- (void)initializeDataSource
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenNavigationBar) name:@"FastReactionHiddenNavBar" object:nil];
}

- (void)initializeUserInterface
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"极速反应";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    [self createGameScene];
}
/**
 *  初始化游戏场景
 */
- (void)createGameScene
{
    __weak typeof(self) weakSelf = self;
    FastReactionSettingView *settingView = [[FastReactionSettingView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED settingCompleted:^(NSInteger gameRound) {
        //回合设置结束
        [weakSelf createGameViewWithGameRound:gameRound];
    }];
    [self.view addSubview:settingView];
}

/**
 *  通过游戏回合数创建游戏视图
 *
 *  @param gameRound 游戏回合数
 */
- (void)createGameViewWithGameRound:(NSInteger)gameRound
{
    __weak typeof(self) weakSelf = self;
    FastReactionGameView *gameView = [[FastReactionGameView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED gameRound:gameRound onceAgain:^{
        weakSelf.navigationController.navigationBarHidden = NO;
        [weakSelf createGameScene];
    }];
    [self.view addSubview:gameView];
    
}

#pragma mark -- action

- (void)hiddenNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"极速反应\n㈠分秒倒计时：游戏中的倒计时数字会不断减小，最后几秒的时候，数字会用《？》号代替,玩家在心中默念倒计时，当玩家觉得数字已经减小到0以后，就可以点击按钮；如果时间确实在0以后，加分，在0之前则减分。\n㈡疯狂颜色字:当出现的文字含义和它本身的颜色能对应上，玩家就可以点击按钮确认，如果正确加分，反之减分。";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

@end















