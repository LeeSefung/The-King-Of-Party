//
//  FindKillerPlayerListCollectionView.h
//  聚会大咖
//
//  Created by jiaxin on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WhoIsUndercoverPlayerListCollectionViewDelegate <NSObject>

@required
- (void)eliminatePlayerWithCount:(NSInteger)count identity:(NSString *)identity;

@end

@interface WhoIsUndercoverPlayerListCollectionView : UICollectionView
//是否允许显示玩家词条,默认为NO
@property (nonatomic, assign)BOOL isAllowShowWord;
//是否允许进行长按投票，在点击忘词之后，确定之前，不能长按投票，默认为YES
@property (nonatomic, assign)BOOL isAllowVote;
//代理
@property (nonatomic, assign)id<WhoIsUndercoverPlayerListCollectionViewDelegate>actionDelegate;

- (instancetype)initWithFrame:(CGRect)frame playersInfo:(NSDictionary *)playersInfo;

@end
