//
//  WhoIsUndercoverPlayerListView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/30.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WhoIsUndercoverPlayerListView.h"
#import "WhoIsUndercoverPlayerListCollectionView.h"

@interface WhoIsUndercoverPlayerListView () <WhoIsUndercoverPlayerListCollectionViewDelegate>
//玩家列表视图
@property (nonatomic, strong)WhoIsUndercoverPlayerListCollectionView *playerListView;
//记录玩家信息
@property (nonatomic, strong)NSDictionary *playersInfo;
//用于显示随机抽取一名活着的玩家开始陈述的label
@property (nonatomic, strong)UILabel *order;
//说明忘词操作
@property (nonatomic, strong)UILabel *explain;
//记录活着的玩家
@property (nonatomic, strong)NSMutableArray *isAliveArray;
@end

@implementation WhoIsUndercoverPlayerListView

- (instancetype)initWithFrame:(CGRect)frame playersInfo:(NSDictionary *)playersInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.playersInfo = playersInfo;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeDataSource
{
    _isAliveArray = [NSMutableArray array];
    for (NSInteger i = 0 ; i < [_playersInfo[@"array"] count]; i ++) {
        [_isAliveArray addObject:[NSNumber numberWithInteger:i]];
    }

}

- (void)initializeUserInterface
{
    _order = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(10, 50, 300, 30)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = [UIColor colorWithWhite:0.312 alpha:0.610];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_OF_TINTYELLOW;
        NSInteger randomIndex = arc4random()%_isAliveArray.count;
        label.text = [NSString stringWithFormat:@"%ld号玩家先发言，都发言后长按投票",[_isAliveArray[randomIndex] integerValue] + 1];
        label;
    });
    [self addSubview:_order];
    
    _playerListView = [[WhoIsUndercoverPlayerListCollectionView alloc] initWithFrame:CGRectMake(0, 80*SIZE_RATIO, 320*SIZE_RATIO, 420*SIZE_RATIO) playersInfo:_playersInfo];
    _playerListView.actionDelegate = self;
    [self addSubview:_playerListView];
    
    _explain = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(45, 480, 230, 25)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = [UIColor colorWithWhite:0.312 alpha:0.610];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"点击自己的头像查看词语，不准作弊哟";
        label.alpha = 0;
        label;
    });
    [self addSubview:_explain];
    
    /**
     *  设置查看button
     */
    QBFlatButton *check = [[QBFlatButton alloc] initWithFrame:CGRectMake(110*SIZE_RATIO, 518*SIZE_RATIO, 100*SIZE_RATIO, 30*SIZE_RATIO)];
    check.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    check.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    check.radius = 10.0;
    check.margin = 4.0;
    check.depth = 3.0;
    check.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [check setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [check setTitle:@"忘词" forState:UIControlStateNormal];
    [check addTarget:self action:@selector(checkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:check];
    
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

- (void)againButtonPressed
{
    [ToolManager showAlertViewWithMessage:@"确认要重新开始游戏吗？" cancelTitle:@"取消" confirmTitle:@"确定" confirmBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WhoIsUndecoverOnceAgain" object:nil];
        [self removeFromSuperview];
    }];
}

- (void)checkButtonPressed:(QBFlatButton *)sender
{
    
    if ([[sender currentTitle] isEqualToString:@"忘词"]) {
        [UIView animateWithDuration:0.5 animations:^{
            _explain.alpha = 1;
        }];
        [sender setTitle:@"确定" forState:UIControlStateNormal];
        _playerListView.isAllowShowWord = YES;
        _playerListView.isAllowVote = NO;
        [_playerListView reloadData];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            _explain.alpha = 0;
        }];
       [sender setTitle:@"忘词" forState:UIControlStateNormal];
        _playerListView.isAllowShowWord = NO;
        _playerListView.isAllowVote = YES;
        [_playerListView reloadData];
    }
}

#pragma mark -- <WhoIsUndercoverPlayerListCollectionViewDelegate>

- (void)eliminatePlayerWithCount:(NSInteger)count identity:(NSString *)identity
{
    [_isAliveArray removeObject:[NSNumber numberWithInteger:count]];
    NSInteger randomIndex = arc4random()%_isAliveArray.count;
    _order.text = [NSString stringWithFormat:@"%ld号是%@,%ld号玩家继续新一轮发言",count + 1,identity,[_isAliveArray[randomIndex] integerValue] + 1];
}

@end

















