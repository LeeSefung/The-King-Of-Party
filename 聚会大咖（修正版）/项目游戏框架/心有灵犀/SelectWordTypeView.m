//
//  SelectWordTypeView.m
//  PartyGame
//
//  Created by rimi on 15/6/26.
//  Copyright (c) 2015年 LeeSefung. All rights reserved.
//

#import "SelectWordTypeView.h"

@implementation SelectWordTypeView {
    
    UIVisualEffectView *_visualEfView;
}

- (instancetype)initWithFrame:(CGRect)frame completed:(void (^)(NSString *))completed{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.completed = completed;
        [self initWithInterface];
    }
    return self;
}

- (void)initWithInterface {
    self.backgroundColor = COLOR_OF_BG;
    
    //获取plist数据
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"Property List.plist"]];
    NSDictionary *dic = dictionary[@"wordType"];
    NSMutableArray *wordTypeArray = [dic.allKeys mutableCopy];
    
    //初始化分类标题
    for (int i = 0; i < 6; i ++) {
        
        if (i%2 == 0) {
            
            NSMutableArray *colorArray = [@[[UIColor colorWithRed:238/256.0 green:94/256.0 blue:0 alpha:1],[UIColor colorWithRed:246/256.0 green:167/256.0 blue:7/256.0 alpha:1]] mutableCopy];
            
            ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake(40*RATIO, (140+75*(i/2))*RATIO, 110*RATIO, 40*RATIO) FromColorArray:colorArray ByGradientType:upleftTolowRight];
            //设置部分圆角
            [button setRatio:UIRectCornerTopLeft | UIRectCornerBottomRight];
            [button setTitle:wordTypeArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }else {
            
            NSMutableArray *colorArray = [@[[UIColor colorWithRed:238/256.0 green:94/256.0 blue:0 alpha:1],[UIColor colorWithRed:246/256.0 green:167/256.0 blue:7/256.0 alpha:1]] mutableCopy];
            
            ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake((45+115)*RATIO, (140+75*(i/2))*RATIO, 110*RATIO, 40*RATIO) FromColorArray:colorArray ByGradientType:upleftTolowRight];
            //设置部分圆角
            [button setRatio:UIRectCornerTopLeft | UIRectCornerBottomRight];
            [button setTitle:wordTypeArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    
    //初始化随机选择按钮
    ColorButton *button = ({
        
        NSMutableArray *colorArray = [@[[UIColor colorWithRed:238/256.0 green:94/256.0 blue:0 alpha:1],[UIColor colorWithRed:246/256.0 green:167/256.0 blue:7/256.0 alpha:1]] mutableCopy];
        ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake((45+115-55)*RATIO, (50+75*5-50)*RATIO, 110*RATIO, 40*RATIO) FromColorArray:colorArray ByGradientType:upleftTolowRight];
        //设置部分圆角
        [button setRatio:UIRectCornerAllCorners];
        [button setTitle:@"随机选择" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.tag = 120;
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:button];
}

//随机选择标题类别
- (void)buttonPress:(UIButton *)sender {
    
    if (sender.tag == 120) {

        ColorButton *title = (ColorButton *)[self viewWithTag:100 + arc4random() % 6];
        _completed(title.titleLabel.text);
        [self removeFromSuperview];
        return;
    }
    ColorButton *title = (ColorButton *)[self viewWithTag:sender.tag];
    _completed(title.titleLabel.text);
    [self removeFromSuperview];
    return;

}

@end
