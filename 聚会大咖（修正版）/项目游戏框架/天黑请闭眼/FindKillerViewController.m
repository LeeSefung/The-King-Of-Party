//
//  FindKillerViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FindKillerViewController.h"
#import "FindKillerSettingView.h"
#import "FindKillerPlayerIdentitySettingView.h"
#import "FindKillerPlayerListView.h"
#import "FindKillerResultView.h"

@interface FindKillerViewController ()
//帮助页面
@property (nonatomic, strong)HelpView *helpView;
/**
 *  游戏人数设置画面
 */
@property (nonatomic, strong)FindKillerSettingView *playerNumberSettingView;
/**
 *  游戏玩家身份设置画面
 */
@property (nonatomic, strong)FindKillerPlayerIdentitySettingView *playerIdentitySettingView;


/**
 *  初始化游戏人数设置页面
 */
- (void)createGameScene;
/**
 *  帮助
 */
- (void)questionPressed:(UIBarButtonItem *)sender;
/**
 *  初始化玩家身份设置页面
 */
- (void)createPlayerIdentitySettingViewWithData:(NSArray *)data;
/**
 *  初始化玩家列表页面
 */
- (void)createPlayerListViewWithData:(NSArray *)data;

@end

@implementation FindKillerViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onceAgain) name:@"FindKilleronceAgin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(punish) name:@"FindKillerPunish" object:nil];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"天黑请闭眼";
    self.view.backgroundColor = COLOR_OF_BG;
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;

    /**
     *  初始化游戏人数设置页面
     */
    [self createGameScene];
}

/**
 *  初始化游戏人数设置页面
 */
- (void)createGameScene
{
    WeakSelf(self);
    _playerNumberSettingView = [[FindKillerSettingView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED startSetting:^(NSArray *numbers) {
        [weakSelf createPlayerIdentitySettingViewWithData:numbers];
    }];
    [self.view addSubview:_playerNumberSettingView];
}

/**
 *  初始化玩家身份设置页面
 */
- (void)createPlayerIdentitySettingViewWithData:(NSArray *)data
{
    //动画消失玩家人数设置
    if (_playerNumberSettingView) {
        [UIView animateWithDuration:0.3 animations:^{
            _playerNumberSettingView.alpha = 0;
        } completion:^(BOOL finished) {
            [_playerNumberSettingView removeFromSuperview];
        }];
    }
    WeakSelf(self);
    _playerIdentitySettingView = [[FindKillerPlayerIdentitySettingView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED gameScheme:data settingCompleted:^(NSArray *playersInfo) {
        /**
         *  所有玩家身份设置完成,进入玩家列表视图
         */
        [weakSelf createPlayerListViewWithData:playersInfo];
    }];
    _playerIdentitySettingView.alpha = 0;
    [self.view addSubview:_playerIdentitySettingView];
    [UIView animateWithDuration:0.3 animations:^{
        _playerIdentitySettingView.alpha = 1;
    }];
}

/**
 *  初始化玩家列表页面
 */
- (void)createPlayerListViewWithData:(NSArray *)data
{
    FindKillerPlayerListView *playerListView = [[FindKillerPlayerListView alloc] initWithFrame:CGRectMake(0, -568*SIZE_RATIO, 320*SIZE_RATIO, 568*SIZE_RATIO) playersInfo:data];
    [self.view addSubview:playerListView];
    [UIView animateWithDuration:0.5 animations:^{
        playerListView.frame = FRAME_OF_IPHONE5_PROCESSED;
    } completion:^(BOOL finished) {
        //消失玩家身份设置
        if (_playerIdentitySettingView) {
            [_playerIdentitySettingView removeFromSuperview];
        }
    }];
}

#pragma mark -- action

/**
 *  帮助
 */
- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"天黑请闭眼\n游戏中有四种角色:\n1.法官（掌控全局的一名重要角色，所有的角色都听从他的口头指挥）;\n2.警察（在每轮的闭眼中，拥有一个权力就是可以辨别出谁是凶手）;\n3.杀手（在每轮的闭眼中，拥有一个权力就是可以杀掉一名除法官外的任何角色）;\n4.平民（在每轮的闭眼结束的睁眼阶段，轮到你发言的时候，便可拿出你的相关证据，用你的话语去说服其他人）。\n游戏流程:\n①法官：“天黑请闭眼。”\n所有闭上眼睛\n法官：“杀手请睁眼。”\n杀手睁开眼睛\n法官：“杀手请杀人。”\n睁开眼睛的杀手们 必须通过眼神或者手势的商量后 统一意见指向想杀的那名角色。\n法官要确认完毕后 说：“杀手请闭眼”.\n②法官：“警察请睁眼”\n警察们睁开眼睛\n睁开眼睛的警察们，必须通过眼神或者手势的商量，统一意见指向怀疑的那名角色。\n法官要用大拇指朝上（是暗示这是名杀手的提示），大拇指朝下（是暗示这是名平民的提示）\n然后暗示完。法官要说：“警察请闭眼”.\n③法官：“天亮请睁眼”\n大家都睁开眼睛\n法官要先把那名被杀手杀掉的人名（切记不是游戏身份）说出来\n然后那名被杀的角色不可以亮出身份.\n④再来由那名被杀的角色说句话（话很重要，要清楚自己的角色，然后说些话去鼓舞或者煽动的话，来迷惑大家或者提醒大家的话）然后按顺时针的顺序依次说下去。\n⑤说完后开始重要环节。就是投票出局环节。\n从被杀的那名角色开始顺时针投票\n投票最多的那名角色便出局，然后说句话。\n⑥接下来 就是重复刚才的环节了。\n直到平民或者警察被杀或被票死光，或者杀手都被票死光，游戏才能结束。\nPS:平民或者警察被杀光，杀手获胜。杀手被票死光，平民和警察获胜。";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

/**
 *  再来一局
 */
- (void)onceAgain {
    [self createGameScene];
}
/**
 *  惩罚
 */
- (void)punish
{
    InnerWordAndAdventureViewController *punishVC = [[InnerWordAndAdventureViewController alloc] init];
    [self.navigationController pushViewController:punishVC animated:YES];
}




@end




















