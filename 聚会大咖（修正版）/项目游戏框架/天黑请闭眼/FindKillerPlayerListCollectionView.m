//
//  FindKillerPlayerListCollectionView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FindKillerPlayerListCollectionView.h"
#import "FindKillerPlayerListCollectionCell.h"

@interface FindKillerPlayerListCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

/**
 *  记录当前游戏剩余杀手人数
 */
@property (nonatomic, assign)NSInteger currentKillerNum;
/**
 *  记录当前游戏剩余警察人数
 */
@property (nonatomic, assign)NSInteger currentPoliceNum;
/**
 *  记录当前游戏剩余平民人数
 */
@property (nonatomic, assign)NSInteger currentPeopleNum;
/**
 *  记录被杀的数组
 */
@property (nonatomic, strong)NSMutableArray *isKilledArray;
/**
 *  记录胜利结果，YES为杀手胜利，NO为好人胜利
 */
@property (nonatomic, assign)BOOL isKillerWin;

@end

@implementation FindKillerPlayerListCollectionView

- (instancetype)initWithFrame:(CGRect)frame playersInfo:(NSArray *)playersInfo
{
    //玩家人数
    NSInteger playerNumber = playersInfo.count;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (playerNumber < 7) {
        //两行 每行三个
        layout.itemSize = CGSizeMake(80*SIZE_RATIO, 80*SIZE_RATIO);
        layout.minimumInteritemSpacing = 20*SIZE_RATIO;
        layout.minimumLineSpacing = 120*SIZE_RATIO;
    }else if (playerNumber < 10) {
        //三行 每行三个
        layout.itemSize = CGSizeMake(80*SIZE_RATIO, 80*SIZE_RATIO);
        layout.minimumInteritemSpacing = 20*SIZE_RATIO;
        layout.minimumLineSpacing = 40*SIZE_RATIO;
    }else {
        //四行 每行四个
        layout.itemSize = CGSizeMake(55*SIZE_RATIO, 55*SIZE_RATIO);
        layout.minimumInteritemSpacing = 20*SIZE_RATIO;
        layout.minimumLineSpacing = 36*SIZE_RATIO;
    }
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.playersInfo = playersInfo;
        _isHiddenIdentity = YES;
        _isAllowLongPress = NO;
        _isVoting = NO;
        NSArray *gameScheme = @[@[@(1),@(1),@(3)],
                        @[@(1),@(1),@(4)],
                        @[@(1),@(1),@(5)],
                        @[@(2),@(2),@(4)],
                        @[@(2),@(2),@(5)],
                        @[@(2),@(2),@(6)],
                        @[@(3),@(3),@(5)],
                        @[@(3),@(3),@(6)],
                        @[@(3),@(3),@(7)],
                        @[@(3),@(3),@(8)],
                        @[@(4),@(4),@(7)],
                        @[@(4),@(4),@(8)]];
        _currentKillerNum = [gameScheme[playersInfo.count - 5][0] integerValue];
        _currentPoliceNum = [gameScheme[playersInfo.count - 5][1] integerValue];
        _currentPeopleNum = [gameScheme[playersInfo.count - 5][2] integerValue];
        _isKilledArray = [NSMutableArray array];
        for (int i = 0 ; i < playersInfo.count; i ++) {
            [_isKilledArray addObject:[NSNumber numberWithBool:NO]];
        }
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[FindKillerPlayerListCollectionCell class] forCellWithReuseIdentifier:@"FindKillerPlayerListCollectionCell"];
    }
    return self;
}

#pragma mark -- <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _playersInfo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FindKillerPlayerListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FindKillerPlayerListCollectionCell" forIndexPath:indexPath];
    if (![_isKilledArray[indexPath.row] boolValue]) {
        //未被杀
       cell.playerCount.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }else {
        //被杀了
        cell.playerCount.text = _playersInfo[indexPath.row][@"name"];
    }
    cell.playerIdentity.text = _playersInfo[indexPath.row][@"name"];
    if (_isHiddenIdentity) {
        cell.playerIdentity.hidden = YES;
    }else {
        cell.playerIdentity.hidden = NO;
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1.5;
    [cell addGestureRecognizer:longPress];
    if (_isAllowLongPress) {
        cell.userInteractionEnabled = YES;
    }else {
        cell.userInteractionEnabled = NO;
    }
    if ([_isKilledArray[indexPath.row] boolValue]) {
        cell.userInteractionEnabled = NO;
    }
    
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (_playersInfo.count < 7) {
        //两行 每行三个
        return UIEdgeInsetsMake(60*SIZE_RATIO, 20*SIZE_RATIO, 10*SIZE_RATIO, 20*SIZE_RATIO);
    }else if (_playersInfo.count < 10) {
        //三行 每行三个
        return UIEdgeInsetsMake(40*SIZE_RATIO, 20*SIZE_RATIO, 10*SIZE_RATIO, 20*SIZE_RATIO);
    }else {
        //四行 每行四个
        return UIEdgeInsetsMake(36*SIZE_RATIO, 20*SIZE_RATIO, 10*SIZE_RATIO, 20*SIZE_RATIO);
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        FindKillerPlayerListCollectionCell *cell = (FindKillerPlayerListCollectionCell *)longPress.view;
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        NSString *identity = _playersInfo[indexPath.row][@"name"];
        
        if ([identity isEqualToString:@"杀手"]) {
            if (!_isVoting) {
                //不为投票状态，那么杀手就不能杀杀手
                if (_resultDelegate && [_resultDelegate respondsToSelector:@selector(killerCantKillKillerTips)]) {
                    [_resultDelegate killerCantKillKillerTips];
                }
                return;
            }
        }
        
        cell.playerCount.text = identity;
        
        //更新被杀数组
        [_isKilledArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
        if ([identity isEqualToString:@"杀手"]) {
            
            if (--_currentKillerNum == 0) {
                //全部杀手被投票，好人胜利
                _isKillerWin = NO;
                if (_resultDelegate && [_resultDelegate respondsToSelector:@selector(gameOverWithIsKillerWin:playerInfo:)]) {
                    [_resultDelegate gameOverWithIsKillerWin:_isKillerWin playerInfo:_playersInfo];
                }
            }else {
                if (_resultDelegate && [_resultDelegate respondsToSelector:@selector(policeStartCheckPeopleWithKilledInfo:)]) {
                    [_resultDelegate policeStartCheckPeopleWithKilledInfo:@{@"count" : [NSNumber numberWithInteger:indexPath.row + 1 ], @"identity" : identity}];
                }
            }
            
        }else if ([identity isEqualToString:@"警察"]) {
            if (--_currentPoliceNum == 0) {
                //全部警察被投票或被杀，杀手胜利
                _isKillerWin = YES;
                if (_resultDelegate && [_resultDelegate respondsToSelector:@selector(gameOverWithIsKillerWin:playerInfo:)]) {
                    [_resultDelegate gameOverWithIsKillerWin:_isKillerWin playerInfo:_playersInfo];
                }
            }else {
                if (_resultDelegate && [_resultDelegate respondsToSelector:@selector(policeStartCheckPeopleWithKilledInfo:)]) {
                    [_resultDelegate policeStartCheckPeopleWithKilledInfo:@{@"count" : [NSNumber numberWithInteger:indexPath.row + 1], @"identity" : identity}];
                }
            }
            
        }else {
            if (--_currentPeopleNum == 0) {
                //全部平民被偷票或被杀，杀手胜利
                _isKillerWin = YES;
                if (_resultDelegate && [_resultDelegate respondsToSelector:@selector(gameOverWithIsKillerWin:playerInfo:)]) {
                    [_resultDelegate gameOverWithIsKillerWin:_isKillerWin playerInfo:_playersInfo];
                }
            }else {
                if (_resultDelegate && [_resultDelegate respondsToSelector:@selector(policeStartCheckPeopleWithKilledInfo:)]) {
                    [_resultDelegate policeStartCheckPeopleWithKilledInfo:@{@"count" : [NSNumber numberWithInteger:indexPath.row + 1], @"identity" : identity}];
                }
            }
            
        }
    }
}


@end













