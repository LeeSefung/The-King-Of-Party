//
//  NumberLandmineView.m
//  聚会大咖
//
//  Created by rimi on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "DrinkWheelView.h"

@interface DrinkWheelView () {
    
    UIImageView *_backImageView;//转盘
    UIImageView *_pointImageView;//指针
    UIImageView *_moveImageView;//旋转转盘
    float random;
    float orign;
}

- (void)numberLandmineView;

@property (strong, nonatomic) QBFlatButton *btn_start;

@end

@implementation DrinkWheelView

- (instancetype)initWithIPhone5Frame:(CGRect)frame {
    self = [super initWithIPhone5Frame:frame];
    if (self) {
        [self numberLandmineView];
    }
    return self;
}

- (void)numberLandmineView {
    
    self.backgroundColor = COLOR_WITH_RGBA(43, 132, 210, 1);
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11 * SIZE_RATIO, 100 * SIZE_RATIO, 300 * SIZE_RATIO, 300 * SIZE_RATIO)];
    _backImageView.image = IMAGE_WITH_NAME(@"转盘图片2.png");
    [self addSubview:_backImageView];
    
    _moveImageView = ({
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.5 * SIZE_RATIO, 96 * SIZE_RATIO, 305 * SIZE_RATIO, 305 * SIZE_RATIO)];
        _backImageView.image = IMAGE_WITH_NAME(@"转盘图片4.png");
        _backImageView;
    });
    [self addSubview:_moveImageView];
    
    
    _pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(101.5 * SIZE_RATIO, (144 + 20 + 5) * SIZE_RATIO, 120 * SIZE_RATIO, 210 * SIZE_RATIO)];
    _pointImageView.image = IMAGE_WITH_NAME(@"start副本副本副本.png");
    [self addSubview:_pointImageView];
    
    self.btn_start = [QBFlatButton buttonWithType:UIButtonTypeRoundedRect];
    self.btn_start.frame = CGRectMake(94.0 * SIZE_RATIO, 440.0 * SIZE_RATIO, 142.0 * SIZE_RATIO, 47.0 * SIZE_RATIO);
    [self.btn_start addTarget:self action:@selector(luckyDraw:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_start.radius = 8.0;
    self.btn_start.margin = 4.0;
    self.btn_start.depth = 3.0;
    self.btn_start.faceColor = [UIColor colorWithRed:254.0/255.0 green:159.0/255.0 blue:0 alpha:1.0];
    self.btn_start.sideColor = [UIColor colorWithRed:170.0/255.0 green:105.0/255.0 blue:0 alpha:1.0];
    
    self.btn_start.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btn_start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_start setTitle:@"开始" forState:UIControlStateNormal];
    
    [self addSubview:self.btn_start];

}

#pragma mark -- action

- (void)luckyDraw:(UIButton *)sender {
    
    self.btn_start.enabled = NO;
    //******************旋转动画******************
    //产生随机角度
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    random = (rand() % 20) / 10.0;
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:M_PI * (0.0+orign)]];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * (10.0+random+orign)]];
    [spin setDuration:3];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //    //添加动画
    [[_moveImageView layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    _moveImageView.transform = CGAffineTransformMakeRotation(M_PI * (10.0+random+orign));
    //锁定fromValue的位置
    orign = 10.0+random+orign;
    orign = fmodf(orign, 2.0);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.btn_start.enabled = YES;
    //    判断抽奖结果
        if (orign >= 0.0 && orign < (0.5/3.0)) {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"请自罚一杯" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
        }
        else if (orign >= (0.5/3.0) && orign < ((0.5/3.0)*2))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"请自罚三杯" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
        }else if (orign >= ((0.5/3.0)*2) && orign < ((0.5/3.0)*3))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"吹一瓶" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= (0.0+0.5) && orign < ((0.5/3.0)+0.5))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"请自罚三杯" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= ((0.5/3.0)+0.5) && orign < (((0.5/3.0)*2)+0.5))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"请自罚一杯" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= (((0.5/3.0)*2)+0.5) && orign < (((0.5/3.0)*3)+0.5))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"请自罚三杯" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= (0.0+1.0) && orign < ((0.5/3.0)+1.0))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"PASS！" message:@"安全卡 本回合安全" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= ((0.5/3.0)+1.0) && orign < (((0.5/3.0)*2)+1.0))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"请自罚三杯" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= (((0.5/3.0)*2)+1.0) && orign < (((0.5/3.0)*3)+1.0))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"吹一瓶" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= (0.0+1.5) && orign < ((0.5/3.0)+1.5))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"请自罚一杯" message:@"如不胜酒力 喝水也可以哦！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= ((0.5/3.0)+1.5) && orign < (((0.5/3.0)*2)+1.5))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"PASS" message:@"安全卡 本回合安全" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
    
        }else if (orign >= (((0.5/3.0)*2)+1.5) && orign < (((0.5/3.0)*3)+1.5))
        {
            UIAlertView *result = [[UIAlertView alloc] initWithTitle:@"唱首歌" message:@"唱首歌来打动大家吧 ！" delegate:self cancelButtonTitle:@"继续玩！" otherButtonTitles: nil];
            [result show];
        }
}

@end
