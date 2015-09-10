//
//  NumberLandmineViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "NumberLandmineViewController.h"
#import "NumberLandmineSettingView.h"
#import "NumberLandmineGameView.h"

@interface NumberLandmineViewController ()
//帮助视图
@property (nonatomic, strong)HelpView *helpView;
//游戏设置视图
@property (nonatomic, strong)NumberLandmineSettingView *settingView;

/**
 *  初始化游戏场景
 */
- (void)createGameScene;
/**
 *  初始化游戏进行视图
 */
- (void)createGameViewWithGameScheme:(NSDictionary *)gameScheme;


@end

@implementation NumberLandmineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods

- (void)initializeDataSource
{
    
}

- (void)initializeUserInterface
{
    self.view.backgroundColor = COLOR_OF_BG;
    self.navigationItem.title = @"数字地雷";
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
    _settingView = [[NumberLandmineSettingView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED settingCompleted:^(NSDictionary *gameScheme) {
        [self createGameViewWithGameScheme:gameScheme];
    }];
    [self.view addSubview:_settingView];
}

/**
 *  初始化游戏进行视图
 */
- (void)createGameViewWithGameScheme:(NSDictionary *)gameScheme
{
    __weak typeof(self) weakSelf = self;
    NumberLandmineGameView *gameView = [[NumberLandmineGameView alloc] initWithFrame:CGRectMake(0, -568*SIZE_RATIO, 320*SIZE_RATIO, 568*SIZE_RATIO) gameScheme:gameScheme onceAgain:^{
        //再来一局
        [weakSelf createGameScene];
        [weakSelf.view sendSubviewToBack:_settingView];
    } punish:^{
        //进入惩罚
        InnerWordAndAdventureViewController *punishVC = [[InnerWordAndAdventureViewController alloc] init];
        [weakSelf.navigationController pushViewController:punishVC animated:YES];
    }];
    [self.view addSubview:gameView];
    
    [UIView animateWithDuration:0.5 animations:^{
        gameView.frame = FRAME_OF_IPHONE5_PROCESSED;
    }completion:^(BOOL finished) {
        if (_settingView) {
            [_settingView removeFromSuperview];
        }
    }];
    
}
#pragma mark -- action

- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"数字地雷\n既简单又刺激的好游戏\n游戏流程:\n①在100~1000之间设置数字最大的范围;②在1~设置的最大数之间选择一个数字作为地雷;③点击开始游戏，进入游戏画面；④由玩家依次输入排雷数字进行验证，排雷成功换下一位;⑤重复第四步直到有人踩雷，就可以进入惩罚环节";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
    [self.view endEditing:YES];
}

@end





















