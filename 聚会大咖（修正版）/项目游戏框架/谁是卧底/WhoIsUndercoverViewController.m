//
//  WhoIsUndercoverViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WhoIsUndercoverViewController.h"
#import "WhoIsUndercoverPlayerNumSettingView.h"
#import "WhoIsUndercoverPlayerIdentitySettingView.h"
#import "WhoIsUndercoverPlayerListView.h"
#import "WhoIsUndercoverResultView.h"

@interface WhoIsUndercoverViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//帮助页面
@property (nonatomic, strong)HelpView *helpView;
//记录游戏设置数据@"array"是随机之后的词条数组 @"undercover"是卧底词汇 @"people"是平民词汇 @"headArray"预留给玩家头像
@property (nonatomic, strong)NSMutableDictionary *dataDict;
//玩家数量设置页面
@property (nonatomic, strong)WhoIsUndercoverPlayerNumSettingView *playerNumSettingView;
//玩家身份设置页面
@property (nonatomic, strong)WhoIsUndercoverPlayerIdentitySettingView *playerIdentitySettingView;
//玩家列表视图
@property (nonatomic, strong)WhoIsUndercoverPlayerListView *playerListView;


/**
 *  初始化游戏人数设置页面
 */
- (void)createGameScene;
/**
 *  初始化玩家身份设置页面
 */
- (void)createPlayerIdentitySettingViewWithgameScheme:(NSDictionary *)gameScheme;
/**
 *  初始化玩家列表视图
 */
- (void)createPlayerListView;
/**
 *  初始化游戏结果视图
 */
- (void)createResultView:(NSNotification *)info;
/**
 *  调用相机进行拍照
 */
- (void)takePhoto;

@end

@implementation WhoIsUndercoverViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onceAgain) name:@"WhoIsUndecoverOnceAgain" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(punish) name:@"WhoIsUndecoverPunish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createResultView:) name:@"WhoIsUndercoverResult" object:nil];
}

- (void)initializeUserInterface
{
    self.navigationItem.title = @"谁是卧底";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    self.view.backgroundColor = COLOR_OF_BG;
    
    [self createGameScene];
    
}

/**
 *  初始化游戏人数设置页面
 */
- (void)createGameScene
{
    WeakSelf(self);
    _playerNumSettingView = [[WhoIsUndercoverPlayerNumSettingView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED settingCompleted:^(NSDictionary *gameScheme) {
        [weakSelf createPlayerIdentitySettingViewWithgameScheme:gameScheme];
    }];
    [self.view addSubview:_playerNumSettingView];
}

/**
 *  初始化玩家身份设置页面
 */
- (void)createPlayerIdentitySettingViewWithgameScheme:(NSDictionary *)gameScheme
{
    WeakSelf(self);
    _dataDict = [gameScheme mutableCopy];
    _playerIdentitySettingView = [[WhoIsUndercoverPlayerIdentitySettingView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED gameScheme:gameScheme[@"array"] takePhoto:^{
        //调用照相机拍照片
        [weakSelf takePhoto];
        
    } settingCompleted:^(NSArray *playersHead) {
        //预留给把头像数组加入 _dataDict
        [_dataDict setObject:playersHead forKey:@"headArray"];
        [weakSelf createPlayerListView];
    }];
    [self.view addSubview:_playerIdentitySettingView];
    if (_playerNumSettingView) {
        [_playerNumSettingView removeFromSuperview];
    }
}
/**
 *  初始化玩家列表视图
 */
- (void)createPlayerListView
{
    _playerListView = [[WhoIsUndercoverPlayerListView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED playersInfo:_dataDict];
    [self.view addSubview:_playerListView];
    if (_playerIdentitySettingView) {
        [_playerIdentitySettingView removeFromSuperview];
    }
}

/**
 *  初始化游戏结果视图
 */
- (void)createResultView:(NSNotification *)info
{
    NSDictionary *dict = info.userInfo;
    WhoIsUndercoverResultView *resultView = [[WhoIsUndercoverResultView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED isUndercoverWin:[dict[@"result"] boolValue] playersInfo:dict[@"info"]];
    [self.view addSubview:resultView];
}

/**
 *  惩罚
 */
- (void)punish
{
    InnerWordAndAdventureViewController *punishVC = [[InnerWordAndAdventureViewController alloc] init];
    [self.navigationController pushViewController:punishVC animated:YES];
}

/**
 *  再来一局
 */
- (void)onceAgain {
    [self createGameScene];
}

#pragma mark -- action

- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"谁是卧底\n游戏流程：以8人游戏为例，其他人数依次类推\n①在场8人中6人拿到同一词语，剩下2人拿到与之相关的另一词语。这时平民与卧底都不知道互相的身份，卧底也不知道自己是卧底。\n②每人用一句话描述自己拿到的词语，最好不要太过明显，既不能让卧底察觉，也要给同伴以暗示。\n③每轮描述完毕，所有在场的人投票选出怀疑的卧底人选，得票最多的人出局。若所有卧底出局，则游戏结束。若有卧底未出局，游戏继续。如有两人得票相同，则进入PK，大家再从两人中间投出一个。\n④若卧底淘汰了所有平民，则卧底获胜，反之，则平民胜利。\n注意：卧底和平民都要描述自己手上的牌，卧底如果猜到了平民的词汇，接下来如果卧底的描述和平民词有共性那么OK；不可以为了掩饰自己的身份说出跟卧底词不搭边的话。例如：卧底词是福尔摩斯，平民词是工藤新一。如果卧底猜到了平民词，为了混淆视听而说“他长期使用着另一个名字”这样与福尔摩斯完全没有关系的描述，是不可以的。这就是考验卧底掩饰能力的地方。";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

/**
 *  调用相机进行拍照
 */
- (void)takePhoto
{
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    camera.sourceType = sourceType;
    camera.delegate = self;
    [self presentViewController:camera animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_playerIdentitySettingView addHeadForPlayerWithPhoto:photo];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
