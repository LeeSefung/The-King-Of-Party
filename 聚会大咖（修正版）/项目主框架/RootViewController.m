//
//  ViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.


#import "RootViewController.h"
#import "GameCell.h"
#import "FindKillerViewController.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)NSArray *gameNameArray;
@property (nonatomic, strong)NSArray *gameVCNameArray;
@property (nonatomic, strong)NSArray *imageNameArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods

- (void)initializeDataSource {
    //注册分享通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(share) name:@"shareGame" object:nil];
    
    /**
     *  初始化游戏名字数组
     */
    _gameNameArray = [NSArray arrayWithObjects:@"谁是卧底", @"天黑请闭眼", @"心有灵犀", @"真心话/大冒险", @"极速反应", @"摇骰子", @"数字地雷", @"文字地雷", @"罚酒转盘", @"互动游戏集合",nil];
    
    /**
     *  初始化游戏视图控制器名字数组
     */
//    @"谁是卧底WhoIsUndercover", @"天黑请闭眼FindKiller", @"心有灵犀GestureAndGuess", @"真心话/大冒险InnerWordAndAdventure", @"极速反应FastReaction", @"摇骰子Dice", @"数字地雷NumberLandmine", @"文字地雷WordLandmine", @"变音识人InflexionMan", @"互动游戏集合InteractiveGame"
    _gameVCNameArray = [NSArray arrayWithObjects:@"WhoIsUndercoverViewController",
                        @"FindKillerViewController",
                        @"GestureAndGuessViewController",
                        @"InnerWordAndAdventureViewController",
                        @"FastReactionViewController",
                        @"DiceViewController",
                        @"NumberLandmineViewController",
                        @"WordLandmineViewController",
                        @"DrinkWheelViewController",
                        @"InteractiveGameViewController", nil];
    /**
     *  初始化游戏logo名字数组
     */
    NSMutableArray *tempImageNameArray = [NSMutableArray array];
    for (int i = 0 ; i < 10; i ++) {
        NSString *string = [NSString stringWithFormat:@"smiley_00%d.png",i];
        [tempImageNameArray addObject:string];
    }
    _imageNameArray = [NSArray arrayWithArray:tempImageNameArray];
}

- (void)initializeUserInterface {
    self.view.backgroundColor = COLOR_OF_BG;
    self.navigationItem.title = @"聚会大咖";
    
    /**
     *  初始化主界面collectionview
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(130*SIZE_RATIO, 200*SIZE_RATIO);
    layout.minimumInteritemSpacing = 15*SIZE_RATIO;
    UICollectionView *collectioinView = [[UICollectionView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED collectionViewLayout:layout];
    [collectioinView registerClass:[GameCell class] forCellWithReuseIdentifier:@"GameCell"];
    collectioinView.showsVerticalScrollIndicator = NO;
    collectioinView.backgroundColor = [UIColor clearColor];
    collectioinView.dataSource = self;
    collectioinView.delegate = self;
    [self.view addSubview:collectioinView];
}

#pragma mark -- <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GameCell" forIndexPath:indexPath];
    cell.gameName.text = _gameNameArray[indexPath.row];
    cell.headImageView.image = IMAGE_WITH_NAME(_imageNameArray[indexPath.row]);
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20*SIZE_RATIO, 20*SIZE_RATIO, 20*SIZE_RATIO, 20*SIZE_RATIO);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *vc = [[NSClassFromString(_gameVCNameArray[indexPath.row]) alloc] init];
    NSString *backstring = [NSString stringWithFormat:@"返回"];
    UIBarButtonItem *backLeftItem = [[UIBarButtonItem alloc]
                                      initWithTitle:backstring
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(backButtonPress)];
    [self.navigationItem setBackBarButtonItem:backLeftItem];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- action

- (void)backButtonPress {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/**
 *  分享
 */
- (void)share
{

}

@end


















