//
//  WhoIsUndecoverResultView.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/30.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "WhoIsUndercoverResultView.h"

@implementation WhoIsUndercoverResultView


- (instancetype)initWithFrame:(CGRect)frame isUndercoverWin:(BOOL)isUndercoverWin playersInfo:(NSDictionary *)playersInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *win = [[UIImageView alloc] initWithIPhone5Frame:CGRectMake(60, 100, 200, 200)];
        win.image = IMAGE_WITH_NAME(@"win.png");
        [self addSubview:win];
        
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotation.duration = 5.f;
        rotation.repeatCount = HUGE_VALF;
        rotation.toValue = [NSNumber numberWithFloat:M_PI];
        [win.layer addAnimation:rotation forKey:@"rotation"];

        UILabel *resultLabel = ({
            UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(85, 180, 150, 40)];
            label.font = [UIFont systemFontOfSize:25];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text = isUndercoverWin ? @"卧底胜利" : @"平民胜利";
            label;
        });
        [self addSubview:resultLabel];
        
        UILabel *identity = ({
            UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(35, 300, 250, 80)];
            label.font = [UIFont systemFontOfSize:20];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text = [NSString stringWithFormat:@"卧底词语：%@\n平民词语：%@",playersInfo[@"undercover"],playersInfo[@"people"]];
            label;
        });
        [self addSubview:identity];
        
        /**
         *  进入惩罚button
         */
        QBFlatButton *punish = [[QBFlatButton alloc] initWithFrame:CGRectMake(100*SIZE_RATIO,510*SIZE_RATIO, 120*SIZE_RATIO, 40*SIZE_RATIO)];
        punish.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        punish.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        punish.radius = 15.0;
        punish.margin = 7.0;
        punish.depth = 6.0;
        punish.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [punish setTitleColor:COLOR_OF_TINTYELLOW forState:UIControlStateNormal];
        [punish setTitle:@"进入惩罚" forState:UIControlStateNormal];
        [punish addTarget:self action:@selector(punishButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:punish];
        
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
        
        /**
         *  设置分享button
         */
        QBFlatButton *share = [[QBFlatButton alloc] initWithFrame:CGRectMake(250*SIZE_RATIO, 518*SIZE_RATIO, 50*SIZE_RATIO, 30*SIZE_RATIO)];
        share.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        share.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        share.radius = 10.0;
        share.margin = 4.0;
        share.depth = 3.0;
        share.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [share setTitle:@"分享" forState:UIControlStateNormal];
        [share addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:share];
        
    }
    return self;
}

/**
 *  再来一局
 */
- (void)againButtonPressed
{
    [ToolManager showAlertViewWithMessage:@"确认要重新开始游戏吗？" cancelTitle:@"取消" confirmTitle:@"确定" confirmBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WhoIsUndecoverOnceAgain" object:nil];
        [self removeFromSuperview];
    }];
}
/**
 *  进入分享
 */
- (void)shareButtonPressed
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareGame" object:nil];
}

/**
 *  进入惩罚
 */
- (void)punishButtonPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhoIsUndecoverPunish" object:nil];
}


@end















