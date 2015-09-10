//
//  CollectPointView.m
//  聚会大咖
//
//  Created by rimi on 15/7/6.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "CollectPointView.h"

@implementation CollectPointView {
    
    UIVisualEffectView *_visualEfView;
}

- (instancetype)initWithFrame:(CGRect)frame completed:(void (^)(NSInteger))completed{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.completed = completed;
        [self initWithInterface];
    }
    return self;
}

//初始化界面
- (void)initWithInterface {
    
    // blur效果
    _visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _visualEfView.frame = self.bounds;
    _visualEfView.alpha = 1;
    [self addSubview:_visualEfView];
    
    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74*RATIO, 320*RATIO, 40)];
    selectLabel.text = @"请选择点数";
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:selectLabel];
    
    //设置点数
    for (int i = 6; i <= 30; i ++) {
        
        QBFlatButton *numberButton = ({
            
            [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
            [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
            
            QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((12.5+60*((i-6)%5))*RATIO, (140 + 60*((i-6)/5))*RATIO, 55*RATIO, 55*RATIO);
            btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
            btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
            btn.radius = 8.0;
            btn.margin = 4.0;
            btn.depth = 3.0;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:numberButton];
    }
}

//点击返回点数
- (void)buttonPress:(UIButton *)sender {
    
    _completed([sender.titleLabel.text integerValue]);
}

@end
