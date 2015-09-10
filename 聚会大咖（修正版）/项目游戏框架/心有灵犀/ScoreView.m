//
//  ScoreTableView.m
//  聚会大咖
//
//  Created by rimi on 15/6/30.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "ScoreView.h"

@interface ScoreView () {
    
    NSArray *_dataSource;
    NSInteger _mustScore;
}

@end

@implementation ScoreView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data completed:(void (^)())completed {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.completed = completed;
        _dataSource = [data mutableCopy];

        //获得最大正确个数
        for (int i = 0; i < _dataSource.count; i ++) {
            
            if (_mustScore < [_dataSource[i][@"correctNumber"] integerValue]) {
                
                _mustScore = [_dataSource[i][@"correctNumber"] integerValue];
            }
        }
        
        if (_mustScore == 0) {
            _mustScore = 1;
        }
        
        [self initWithInterface];
    }
    return self;
}

- (void)initWithInterface {
    self.backgroundColor = COLOR_OF_BG;
    
    //页面视图--用于页面自适应
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*RATIO, (50+45*_dataSource.count+45+20)*RATIO)];
    view.center = CGPointMake(self.center.x, (568*RATIO)/2-10);
    [self addSubview:view];
    
    //分数界面
    for (int i = 0; i < _dataSource.count; i ++) {
        
        UIButton *buttton = [[UIButton alloc] initWithFrame:CGRectMake(47.5-20*RATIO, (45+45*i)*RATIO, 110*RATIO, 40*RATIO)];
//        buttton.backgroundColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        [buttton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttton setTitle:[NSString stringWithFormat:@"第%@小组%@个:", _dataSource[i][@"groupIndex"], _dataSource[i][@"correctNumber"]] forState:UIControlStateNormal];
        [view addSubview:buttton];
        
        
        UIButton *buttton1 = [[UIButton alloc] initWithFrame:CGRectMake(132.5*RATIO, (45+45*i+17.5)*RATIO, 150.0*[_dataSource[i][@"correctNumber"] integerValue]/(_mustScore)*RATIO, 10*RATIO)];
        buttton1.backgroundColor = [UIColor orangeColor];
        [buttton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:buttton1];
    }
    
    //返回按钮
    QBFlatButton *button = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(47.5*RATIO, (70+45*_dataSource.count)*RATIO, 110*RATIO, 40*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 500;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"再来一局" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [view addSubview:button];
    
    //惩罚按钮
    QBFlatButton *button1 = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(162.5*RATIO, (70+45*_dataSource.count)*RATIO, 110*RATIO, 40*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 501;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"开始惩罚" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [view addSubview:button1];
}

//按钮点击事件
- (void)buttonPress:(UIButton *)sender {
    
    //再来一局
    if (sender.tag == 500) {
        _completed();
        [self removeFromSuperview];
    }
    //惩罚
    if (sender.tag == 501) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureAndGuessPunish" object:nil];
    }
}

@end
