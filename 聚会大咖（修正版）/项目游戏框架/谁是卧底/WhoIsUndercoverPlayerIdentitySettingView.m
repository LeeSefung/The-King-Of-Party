//
//  FindKillerPlayerIdentitySettingView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/28.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WhoIsUndercoverPlayerIdentitySettingView.h"

@interface WhoIsUndercoverPlayerIdentitySettingView ()

@property (nonatomic, strong)NSMutableArray *playerHeadArray;//记录玩家头像数组
@property (nonatomic, copy)void(^takePhoto)();//记录拍照片回调block
@property (nonatomic, copy)void(^settingCompleted)(NSArray *playersHead);//记录设置完成代码块
@property (nonatomic, strong)NSArray *gameScheme;//记录游戏方案数组
@property (nonatomic, strong)UILabel *playerCount;//玩家号数
@property (nonatomic, assign)NSInteger currentPlayerCount;//记录当前玩家号数
@property (nonatomic, strong)UILabel *playerIdentity;//显示玩家词条
@property (nonatomic, assign)BOOL isFirst;//记录每个玩家是否是第一次点击

@end

@implementation WhoIsUndercoverPlayerIdentitySettingView

- (instancetype)initWithFrame:(CGRect)frame gameScheme:(NSArray *)gameScheme takePhoto:(void (^)())takePhoto settingCompleted:(void (^)(NSArray *))settingCompleted
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gameScheme = gameScheme;
        self.takePhoto = takePhoto;
        self.settingCompleted = settingCompleted;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

#pragma mark -- initialize methods

- (void)initializeDataSource
{
    _isFirst = YES;
    _currentPlayerCount = 0;
    _playerHeadArray = [NSMutableArray array];
}

- (void)initializeUserInterface
{
    self.backgroundColor = COLOR_OF_BG;
    CGFloat margin = 20*SIZE_RATIO;
    /**
     *  显示当前玩家编号
     */
    _playerCount = ({
        UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(60, 100, 200, 200)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 30;
        label.backgroundColor = COLOR_OF_TINTBULE;
        label.font = [UIFont systemFontOfSize:90];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"1";
        label;
    });
    [self addSubview:_playerCount];
    
    _playerIdentity = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10*SIZE_RATIO, CGRectGetMaxY(_playerCount.frame) + margin, 300, 30)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.hidden = YES;
        label;
    });
    [self addSubview:_playerIdentity];
    
    /**
     *  下一步button
     */
    QBFlatButton *next = [[QBFlatButton alloc] initWithFrame:CGRectMake(90*SIZE_RATIO, CGRectGetMaxY(_playerIdentity.frame) + margin, 140*SIZE_RATIO, 40*SIZE_RATIO)];
    next.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
    next.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
    next.radius = 10.0;
    next.margin = 7.0;
    next.depth = 6.0;
    next.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [next setTitle:@" 点击查看词条 " forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:next];
    
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

#pragma mark -- action

/**
 *  进行下一步按钮
 */
- (void)nextButtonPressed:(QBFlatButton *)sender
{
    //防止越界处理
    if (_currentPlayerCount >= _gameScheme.count) {
        return;
    }
    if (_isFirst) {
        //首先调出照相机
        //无真机测试，暂时阉割掉这个功能
//        if (_takePhoto) {
//            _takePhoto();
//        }
        
        //当前玩家第一次点击，即显示对应号数玩家的身份并切换button的title
        NSMutableAttributedString *playerIdentityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld号 您的词条：%@",_currentPlayerCount + 1, _gameScheme[_currentPlayerCount]]];
        if (_currentPlayerCount + 1 < 10) {
            [playerIdentityString setAttributes:@{NSForegroundColorAttributeName : COLOR_OF_TINTYELLOW, NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(0, 2)];
            [playerIdentityString setAttributes:@{NSForegroundColorAttributeName : COLOR_OF_TINTYELLOW, NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(8, playerIdentityString.length - 8)];
        }else {
            [playerIdentityString setAttributes:@{NSForegroundColorAttributeName : COLOR_OF_TINTYELLOW, NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(0, 3)];
            [playerIdentityString setAttributes:@{NSForegroundColorAttributeName : COLOR_OF_TINTYELLOW, NSFontAttributeName : [UIFont boldSystemFontOfSize:22]} range:NSMakeRange(9, playerIdentityString.length - 9)];
        }
        
        _playerIdentity.attributedText = playerIdentityString;
        _playerIdentity.hidden = NO;
        if (_currentPlayerCount == _gameScheme.count - 1) {
            //最后一个玩家
            [sender setTitle:@"设置结束" forState:UIControlStateNormal];
        }else {
            [sender setTitle:@"传递给下一个人" forState:UIControlStateNormal];
        }
        _isFirst = NO;
    }else {
        //当前玩家第二次点击，隐藏对应号数玩家的身份并切换button的title,最后切换玩家编号显示
        _playerIdentity.hidden = YES;
        [sender setTitle:@" 点击查看词条 " forState:UIControlStateNormal];
        _currentPlayerCount++;
        if (_currentPlayerCount >= _gameScheme.count) {
            /**
             *  所有玩家设置完毕,传出玩家头像
             */
            self.settingCompleted(_playerHeadArray);
        }else {
            _playerCount.text = [NSString stringWithFormat:@"%ld",_currentPlayerCount + 1];
        }
        _isFirst = YES;
    }
}

- (void)againButtonPressed
{
    [ToolManager showAlertViewWithMessage:@"确认要重新开始游戏吗？" cancelTitle:@"取消" confirmTitle:@"确定" confirmBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WhoIsUndecoverOnceAgain" object:nil];
        [self removeFromSuperview];
    }];
}

- (void)addHeadForPlayerWithPhoto:(UIImage *)photo
{
    //将玩家所拍照的头像，更新到界面
    
    //将玩家头像放入头像数组
    [_playerHeadArray addObject:photo];
}

@end


















