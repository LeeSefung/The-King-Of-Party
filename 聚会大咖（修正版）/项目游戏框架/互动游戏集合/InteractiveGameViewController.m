//
//  InteractiveGameViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "InteractiveGameViewController.h"
#import "InteractiveGameCollectionViewCell.h"

@interface InteractiveGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

//帮助视图
@property (nonatomic, strong)HelpView *helpView;
@property (nonatomic, strong)NSArray *gameNameArray;
@property (nonatomic, strong)NSArray *gameArray;

@end

@implementation InteractiveGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"互动游戏集合";
    self.view.backgroundColor = COLOR_OF_BG;

    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods

- (void)initializeDataSource
{
    _gameNameArray = [NSArray arrayWithObjects:@"酒杯游戏", @"脸色游戏", @"当然了", @"黑匣子", @"时间记忆", @"黑手党游戏", @"开火车", @"交换名字", @"萝卜蹲", @"拍七令",nil];
    
    _gameArray = @[@"每人先选一个数字，再由裁判选随机选出一个数字，选出的数字对应的人选取自己想要对决的人。这时裁判选取另一个数字，不要告诉别人，两个人在数字中要避开这个数字，每人一次且数字不能重复，没有避开的人失败，并喝酒，进入下一回合。失败的人选取下一个随机数字，胜利的人选出自己想要对决的人，依次循环，最后成功的人胜利。",
                  @"按照顺序，依次说出数字1、2、3、。。。，如果同时说出同一数字，或最后一个人说出数字的接受惩罚。",
                   @"适合于团队游戏，先后顺序由随机获得，向对方说一些对方难以忍受的话，对方只能回答当然了，如果对方不能回答则对方失败，接受惩罚。当然这种游戏偶尔玩玩也是很不错的。",
                   @"每人一个盒子，盒子里是随机不相同的数字，自己也有对应的数字，不要告诉别人自己的数字或者盒子里的数字。游戏开始后，每两个人每次互看对方盒子里的数字，如果是自己的数字，则成功，再把自己的盒子交给对方，继续找数字，最后的两个人将接受惩罚。",
                   @"可以是单人或者团队之间的竞赛，比赛先后顺序可通过剪刀石头布或者掷筛子等方式决定。每组做出一个有一定难度的动作，保持5s，下一组进行进行模仿，模仿成功的小组，做自己的动作，再由下一组模仿，下一组要从第一组的动作开始模仿，一次下去。如果动作无法模仿则失败，本轮游戏结束，开始下一轮游戏，重复之前的过程，最终留下来的队伍胜利。（有时并不一定是顺序靠前越有利）",
                   @"这是一个团队游戏，一个团队中又几人是黑手党，通过一些小的游戏，游戏前几名有指认黑手党的权利，得票最多者淘汰，所以无论你是市民还是黑手党都要努力的争取机会。当黑手党没被全部找出，或者达到游戏次数线则黑手党获得胜利，市民死亡。",
                   @"在开始之前，每个人说出一个地名，代表自己。但是地点不能重复。游戏开始后，假设你来自北京，而另一个人来自上海，你就要说：“开呀开呀开火车，北京的火车就要开。”大家一起问：“往哪开？”你说：“上海开”。那代表上海的那个人就要马上反应接着说：“上海的火车就要开。”然后大家一起问：“往哪开？”再由这个人选择另外的游戏对象，说：“往某某地方开。”如果对方稍有迟疑，没有反应过来就输了。",
                   @"参赛者围坐一圈，自己随即更换成右邻者的名字，以猜拳的方式来决定顺序，然后按顺序来提出问题。当主持人问及“张三先生，你今天早上几点起床？”时，真正的张三不可以回答，而必须由更换成张三的名字的人来回答，当自己该回答时却不回答，不是自己该回答的人就要被淘汰。最后剩下的一个人就是胜利者。",
                   @"萝卜蹲游戏,每个人头上带着一种蔬菜头饰，如叫到白菜，带着白菜头饰的人就说白菜蹲啊白菜蹲，白菜 蹲完茄子蹲，依次类推",
                   @"多人参加，从1-99报数，但有人数到含有“7”的数字或“7”的倍数时，不许报数，要拍下一个人的后脑勺，下一个人继续报数。如果有人报错数或拍错人则表演节目。"];
}

- (void)initializeUserInterface
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(130*SIZE_RATIO, 130*SIZE_RATIO);
    layout.minimumInteritemSpacing = 15*SIZE_RATIO;
    UICollectionView *collectioinView = [[UICollectionView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED collectionViewLayout:layout];
    [collectioinView registerClass:[InteractiveGameCollectionViewCell class] forCellWithReuseIdentifier:@"GameCell"];
    collectioinView.backgroundColor = [UIColor clearColor];
    collectioinView.dataSource = self;
    collectioinView.delegate = self;
    collectioinView.showsHorizontalScrollIndicator = NO;
    collectioinView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectioinView];

}

#pragma mark -- action

- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"互动游戏集合\n这里罗列了当下非常流行的小游戏，与你的朋友通过游戏一起互动，获得欢乐的时候，也增进了感情。所以赶紧嗨起来吧~~~";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

#pragma mark -- <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InteractiveGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GameCell" forIndexPath:indexPath];
    cell.gameName.text = _gameNameArray[indexPath.row];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(20*SIZE_RATIO, 20*SIZE_RATIO, 20*SIZE_RATIO, 20*SIZE_RATIO);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = COLOR_OF_BG;
    
    UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(15, 0, 290, 568)];
    label.numberOfLines = 0;
    label.text = _gameArray[indexPath.row];
    label.textColor = [UIColor whiteColor];
    [vc.view addSubview:label];
    vc.navigationItem.title = _gameNameArray[indexPath.row];
    
    NSString *backstring = [NSString stringWithFormat:@"返回"];
    UIBarButtonItem *backLeftItem = [[UIBarButtonItem alloc]
                                         initWithTitle:backstring
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                        action:@selector(backButtonPress)];
    [self.navigationItem setBackBarButtonItem:backLeftItem];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)backButtonPress {
    [self.navigationController popViewControllerAnimated:YES];
}

@end



























