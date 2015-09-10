//
//  FindKillerPlayerListCollectionView.h
//  聚会大咖
//
//  Created by jiaxin on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindKillerPlayerListCollectionViewDelegate <NSObject>

@required
/**
 *  游戏结束
 *
 *  @param isKillerWin YES为杀手胜利，NO为好人胜利
 *  @param playerInfo  所有玩家的信息
 */
- (void)gameOverWithIsKillerWin:(BOOL)isKillerWin playerInfo:(NSArray *)playerInfo;
/**
 *  进入警察开始验人视图
 *
 *  @param info 被杀的人的信息
 */
- (void)policeStartCheckPeopleWithKilledInfo:(NSDictionary *)info;
//杀手杀人阶段，提示杀手不能杀杀手
- (void)killerCantKillKillerTips;
@end

@interface FindKillerPlayerListCollectionView : UICollectionView
@property (nonatomic, assign)id<FindKillerPlayerListCollectionViewDelegate> resultDelegate;

/**
 *  玩家信息
 */
@property (nonatomic, strong)NSArray *playersInfo;
/**
 *  是否隐藏玩家身份，默认为YES
 */
@property (nonatomic, assign)BOOL isHiddenIdentity;
/**
 *  是否加入长按手势，默认为NO
 */
@property (nonatomic, assign)BOOL isAllowLongPress;
/**
 *  是否为投票状态，默认为NO
 */
@property (nonatomic, assign)BOOL isVoting;

- (instancetype)initWithFrame:(CGRect)frame playersInfo:(NSArray *)playersInfo;

@end
