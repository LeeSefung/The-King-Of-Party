//
//  FindKillerPlayerListCollectionView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WhoIsUndercoverPlayerListCollectionView.h"
#import "WhoIsUndercoverPlayerListCollectionCell.h"
#import "WhoIsUndercoverResultView.h"

@interface WhoIsUndercoverPlayerListCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>
/**
 *  所有玩家信息
 */
@property (nonatomic, strong)NSDictionary *playersInfo;
/**
 *  玩家词条数组
 */
@property (nonatomic, strong)NSArray *playersArray;
/**
 *  记录当前游戏剩余卧底人数
 */
@property (nonatomic, assign)NSInteger currentUndercoverNum;
/**
 *  记录当前游戏剩余平民人数
 */
@property (nonatomic, assign)NSInteger currentPeopleNum;
/**
 *  记录被淘汰的数组
 */
@property (nonatomic, strong)NSMutableArray *isOverArray;
/**
 *  记录胜利结果，YES为卧底胜利，NO为平民胜利
 */
@property (nonatomic, assign)BOOL isUndercoverWin;

@end

@implementation WhoIsUndercoverPlayerListCollectionView

- (instancetype)initWithFrame:(CGRect)frame playersInfo:(NSDictionary *)playersInfo
{
    //玩家人数
    NSInteger playerNumber = [playersInfo[@"array"] count];
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
        self.playersArray = playersInfo[@"array"];
        _isAllowShowWord = NO;
        _isAllowVote = YES;
        _isOverArray = [NSMutableArray array];
        for (int i = 0 ; i < [playersInfo[@"array"] count]; i ++) {
            [_isOverArray addObject:[NSNumber numberWithBool:NO]];
        }
        NSArray *gameScheme = @[@[@(2),@(1)],
                                 @[@(3),@(1)],
                                 @[@(4),@(1),],
                                 @[@(5),@(1),],
                                 @[@(6),@(1),],
                                 @[@(6),@(2),],
                                 @[@(7),@(2),],
                                 @[@(8),@(2),],
                                 @[@(9),@(2),],
                                 @[@(9),@(3),],
                                 @[@(10),@(3),],
                                 @[@(11),@(3),],
                                 @[@(12),@(3),],
                                 @[@(12),@(4),]];
        _currentUndercoverNum = [gameScheme[[playersInfo[@"array"] count] - 3][1] integerValue];
        _currentPeopleNum = [gameScheme[[playersInfo[@"array"] count] - 3][0] integerValue];
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[WhoIsUndercoverPlayerListCollectionCell class] forCellWithReuseIdentifier:@"WhoIsUndercoverPlayerListCollectionCell"];
    }
    return self;
}

#pragma mark -- <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _playersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WhoIsUndercoverPlayerListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WhoIsUndercoverPlayerListCollectionCell" forIndexPath:indexPath];
    if (![_isOverArray[indexPath.row] boolValue]) {
        //未被淘汰
        cell.playerCount.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    }else {
        //被淘汰了
        if ([_playersArray[indexPath.row] isEqualToString:_playersInfo[@"undercover"]]) {
            cell.playerCount.text = @"卧底";
        }else {
            cell.playerCount.text = @"平民";
        }
    }
    
    cell.playerIdentity.text = _playersArray[indexPath.row];
    if (!_isAllowShowWord) {
        cell.playerIdentity.hidden = YES;
    }

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 1.5;
    [cell addGestureRecognizer:longPress];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (_playersArray.count < 7) {
        //两行 每行三个
        return UIEdgeInsetsMake(60*SIZE_RATIO, 20*SIZE_RATIO, 10*SIZE_RATIO, 20*SIZE_RATIO);
    }else if (_playersArray.count < 10) {
        //三行 每行三个
        return UIEdgeInsetsMake(40*SIZE_RATIO, 20*SIZE_RATIO, 10*SIZE_RATIO, 20*SIZE_RATIO);
    }else {
        //四行 每行四个
        return UIEdgeInsetsMake(36*SIZE_RATIO, 20*SIZE_RATIO, 10*SIZE_RATIO, 20*SIZE_RATIO);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isAllowShowWord) {
        //允许显示
        WhoIsUndercoverPlayerListCollectionCell *cell = (WhoIsUndercoverPlayerListCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.playerIdentity.hidden = NO;
        _isAllowShowWord = NO;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (!_isAllowVote) {
            return;
        }
        
        WhoIsUndercoverPlayerListCollectionCell *cell = (WhoIsUndercoverPlayerListCollectionCell *)longPress.view;
        //如果长按的人已经被投票淘汰了，直接返回
        if ([cell.playerCount.text isEqualToString:@"卧底"] || [cell.playerCount.text isEqualToString:@"平民"]) {
            return;
        }
        
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        NSString *identity = _playersArray[indexPath.row];
        if ([identity isEqualToString:_playersInfo[@"undercover"]]) {
            cell.playerCount.text = @"卧底";
        }else {
            cell.playerCount.text = @"平民";
        }
        
        if ([identity isEqualToString:_playersInfo[@"undercover"]]) {
            
            if (--_currentUndercoverNum == 0) {
                //全部卧底被投票，平民胜利
                _isUndercoverWin = NO;
                [self createResultView];
            }else {
                [_isOverArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
                if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(eliminatePlayerWithCount:identity:)]) {
                    [_actionDelegate eliminatePlayerWithCount:indexPath.row identity:@"卧底"];
                }
            }
            
        }else {
            if (--_currentPeopleNum == 0) {
                //全部平民被偷票，卧底胜利
                _isUndercoverWin = YES;
                [self createResultView];
            }else {
                [_isOverArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
                if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(eliminatePlayerWithCount:identity:)]) {
                    [_actionDelegate eliminatePlayerWithCount:indexPath.row identity:@"平民"];
                }
            }
            
        }
    }
}

- (void)createResultView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhoIsUndercoverResult" object:nil userInfo:@{@"result" : [NSNumber numberWithBool:_isUndercoverWin], @"info" : _playersInfo}];

    [self.superview removeFromSuperview];
}

@end













