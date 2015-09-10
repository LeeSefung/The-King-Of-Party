//
//  WordLandmineViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WordLandmineViewController.h"
#import "WordLandmineGameView.h"

@interface WordLandmineViewController ()
//帮助视图
@property (nonatomic, strong)HelpView *helpView;

/**
 *  初始化游戏场景
 */
- (void)createGameScene;

@end

@implementation WordLandmineViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createGameScene) name:@"WordLandmineOnceAgain" object:nil];
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = COLOR_OF_BG;
    self.navigationItem.title = @"文字地雷";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    //初始化游戏场景
    [self createGameScene];
}
/**
 *  初始化游戏场景
 */
- (void)createGameScene
{
    __weak typeof(self) weakSelf = self;
    WordLandmineGameView *gameView = [[WordLandmineGameView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED punish:^{
        
        InnerWordAndAdventureViewController *punishVC = [[InnerWordAndAdventureViewController alloc] init];
        [weakSelf.navigationController pushViewController:punishVC animated:YES];
    }];
    [self.view addSubview:gameView];
}

#pragma mark -- action

- (void)questionPressed:(UIBarButtonItem *)sender
{
//    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"文字地雷\n游戏流程：\n㈠首先由对手进行埋雷设置：\n①、点击<随机字眼>选择将要进行游戏的字眼；\n②、点击<点击埋雷>，从字眼方阵中选择一个字眼作为地雷；\n③、点击<确认埋雷>完成埋雷操作；\n④、可以点击<修改埋雷>和<确认修改>完成修改地雷的操作;\n⑤、点击<开始游戏>将手机交给我方。\n㈡然后由我方进行游戏操作：\n①、由我方每个玩家依次从字眼方阵中，随意选择两个没有被使用的字眼；\n②、用这两个字眼造句，造句结束之后，在字眼方阵中点击对应的字眼；\n③、如果没有踩雷，可继续游戏；\n④、成功使用了八个字眼造句并且没有踩雷则游戏胜利，否则游戏失败，可以进入惩罚环节，惩罚对方。\n请尽情享受放雷带来的快感和害怕踩雷带来的刺激吧O(∩_∩)O~";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

@end



















