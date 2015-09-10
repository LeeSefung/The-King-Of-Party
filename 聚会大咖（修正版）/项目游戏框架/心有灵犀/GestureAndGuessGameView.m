//
//  TimeView.m
//  聚会大咖
//
//  Created by rimi on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "GestureAndGuessGameView.h"

@interface GestureAndGuessGameView () {
    
    UILabel *_wordLabel;
    NSInteger _currentGroup;
    UILabel *_allGroupNumberLabel;
    UILabel *_currentGroupNumberLabel;
    UILabel *_timeLabel;
    UILabel *_correctNumberLabel;
    NSTimer *_timer;
    NSInteger _currentTime;
    NSInteger _currentCorrectNumber;
    NSMutableSet *_set;
    NSMutableArray *_userData;
}



@end


@implementation GestureAndGuessGameView

- (void)dealloc
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame wordType:(NSString *)wordType time:(NSInteger)time groupNumber:(NSInteger)groupNumber completed:(void (^)(NSArray *))completed backToMenu:(void (^)())backToMenu{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.completed = completed;
        self.backToMenu = backToMenu;
        self.groupNumber = groupNumber;
        self.time = time;
        self.wordType = wordType;
        [self initWithInterface];
    }
    return self;
}

- (void)initWithInterface {
    self.backgroundColor = COLOR_OF_BG;

    
    //词语
    _wordLabel = ({
        
        UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*RATIO, 150*RATIO, (320-30)*RATIO, 80)];
        wordLabel.text = @"准备";
        wordLabel.font = [UIFont boldSystemFontOfSize:40];
        wordLabel.textAlignment = NSTextAlignmentCenter;
        wordLabel;
    });
    [self addSubview:_wordLabel];
    
    //总共有%ld个小组
    _allGroupNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45*RATIO, (30 + 20)*RATIO, 150*RATIO, 35*RATIO)];
    _allGroupNumberLabel.text = [NSString stringWithFormat:@"总共有%ld个小组",(long)_groupNumber];

    [self addSubview:_allGroupNumberLabel];
    
    //当前为第%ld个小组
    _currentGroupNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45*RATIO, (60 + 20)*RATIO, 150*RATIO, 35*RATIO)];
    _currentGroup = 1;
    _currentGroupNumberLabel.text = [NSString stringWithFormat:@"当前为第%ld个小组",(long)_currentGroup];
    [self addSubview:_currentGroupNumberLabel];
    
    //限制时间
    UILabel *timeLimit = [[UILabel alloc] initWithFrame:CGRectMake((320-70)*RATIO, (30 + 20)*RATIO, 80*RATIO, 50*RATIO)];
    timeLimit.text = [NSString stringWithFormat:@"%lds",(long)_time];
    timeLimit.font = [UIFont boldSystemFontOfSize:30];
    timeLimit.textColor = [UIColor orangeColor];
    [self addSubview:timeLimit];
    
    //时间倒计时label
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40*RATIO, 240*RATIO, 240*RATIO, 40*RATIO)];
    _timeLabel.text = @"00:00";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont boldSystemFontOfSize:32];
    [self addSubview:_timeLabel];
    
    //已猜中%ld个
    _correctNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*RATIO, 290*RATIO, 240*RATIO, 30)];
    _currentCorrectNumber = 0;
    _correctNumberLabel.text = [NSString stringWithFormat:@"已猜中%ld个!",(long)_currentCorrectNumber];
    _correctNumberLabel.textAlignment = 1;
    [self addSubview:_correctNumberLabel];
    
    //开始游戏
    QBFlatButton *startButton = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((175)*RATIO, (345)*RATIO, 100*RATIO, 35*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 50;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"点击开始" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:startButton];
    
    //回答正确
    QBFlatButton *correctButton = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((160+15)*RATIO, (345+50)*RATIO, 100*RATIO, 35*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 100;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        [btn setTitle:@"正确" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:correctButton];
    
    //跳过当前词语
    QBFlatButton *passButton = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((160-115)*RATIO, (345+50)*RATIO, 100*RATIO, 35*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 101;
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"跳过" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:passButton];
    
    //返回游戏设置目录
    QBFlatButton *returnButton = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((160-115)*RATIO, (345)*RATIO, 100*RATIO, 35*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 200;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"重新开始" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:returnButton];
    _userData = [[NSMutableArray alloc] init];
}

//按钮点击事件
- (void)buttonPress:(UIButton *)sender {
    
    //答对+1
    if (sender.tag == 100) {
        
        _currentCorrectNumber ++;
        _correctNumberLabel.text = [NSString stringWithFormat:@"已猜中%ld个!",(long)_currentCorrectNumber];
        [self updateWord];
        return;
    }
    //跳过
    if (sender.tag == 101) {
        [self updateWord];
        return;
    }
    //游戏开始
    if (sender.tag == 50) {
        [sender setTitle:@"游戏中..." forState:UIControlStateNormal];
        sender.userInteractionEnabled = NO;
        sender.selected = YES;
        
        UIButton *pass = (UIButton *)[self viewWithTag:100];
        pass.userInteractionEnabled = YES;
        UIButton *go = (UIButton *)[self viewWithTag:101];
        go.userInteractionEnabled = YES;
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"Property List.plist"]];

        _set = [[NSMutableSet alloc] initWithArray:dictionary[@"wordType"][_wordType]];//_wordType
        [self updateWord];
        _currentTime = _time;
        _currentCorrectNumber = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    //点击返回
    if (sender.tag == 200) {
        [ToolManager showAlertViewWithMessage:@"确定要重新开始，退出本次游戏？" cancelTitle:@"取消" confirmTitle:@"确定" confirmBlock:^{
            if (_backToMenu) {
                _backToMenu();
            }
            [self removeFromSuperview];
        }];
        return;
    }
}

//更新答对次数
- (void)updateWord {
    
    NSArray *array = [_set allObjects];
    _wordLabel.text = array[arc4random()%array.count];
    if (_set.count == 1) {
        return;
    }
    [_set removeObject:_wordLabel.text];
}

//刷新倒计时时间
- (void)updateTime {
    
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)_currentTime/60, (long)_currentTime%60];
    if (_currentTime == 0) {
        
        [_timer invalidate];
        _timer = nil;
        UIButton *pass = (UIButton *)[self viewWithTag:100];
        pass.userInteractionEnabled = NO;
        UIButton *go = (UIButton *)[self viewWithTag:101];
        go.userInteractionEnabled = NO;
        UIButton *start = (UIButton *)[self viewWithTag:50];
        start.userInteractionEnabled = YES;
        [start setTitle:@"点击开始" forState:UIControlStateNormal];
        start.selected = NO;
        _wordLabel.text = @"准备";
        _currentGroup ++;
        if (_currentGroup > _groupNumber) {
            //提交数据
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)_currentGroup-1] forKey:@"groupIndex"],
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)_currentCorrectNumber] forKey:@"correctNumber"];
            [_userData addObject:dic];
            _currentCorrectNumber = 0;
            _correctNumberLabel.text = [NSString stringWithFormat:@"已猜中%ld个!",(long)_currentCorrectNumber];
            //游戏结束
            _completed([_userData mutableCopy]);
            [self removeFromSuperview];
            return;
        }else {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)_currentGroup-1] forKey:@"groupIndex"],
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)_currentCorrectNumber] forKey:@"correctNumber"];
            [_userData addObject:dic];
            _currentGroupNumberLabel.text = [NSString stringWithFormat:@"当前为第%ld个小组",(long)_currentGroup];
            _currentCorrectNumber = 0;
            _correctNumberLabel.text = [NSString stringWithFormat:@"已猜中%ld个!",(long)_currentCorrectNumber];
            return;
        }
    }
    _currentTime --;
}

@end
