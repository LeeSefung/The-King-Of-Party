//
//  InnerWordAndAdventureView.m
//  聚会大咖
//
//  Created by rimi on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "InnerWordAndAdventureView.h"
#import "VerticalAlignmentLabel.h"


#define BTN_TAG_BASE 500
#define BTN_CONTENT_BASE 600
@interface InnerWordAndAdventureView () {
    
    QBFlatButton *_currentButton;
    UIButton *_currentButtonBottom;
    int _btnTag;
    UIButton *_button;
    NSDictionary *_dicWord;
    NSDictionary *_dicAdventure;
    NSArray *_arrayNameWord;
    NSArray *_arrayAdventure;
    NSInteger flag;
}

@property (strong, nonatomic) QBFlatButton *btnTrueSpeak;

@property (strong, nonatomic) QBFlatButton *btnBigAdventure;


- (void)InnerWordAndAdventureView;

@end

@implementation InnerWordAndAdventureView

- (instancetype)initWithIPhone5Frame:(CGRect)frame {
    
    self = [super initWithIPhone5Frame:frame];
    
    if (self) {
        
        flag = 1;
        [self InnerWordAndAdventureView];
        
    }
    
    return self;
}

- (void)InnerWordAndAdventureView {
    self.backgroundColor = COLOR_WITH_RGBA(43, 132, 210, 1);
    _currentButton = [[QBFlatButton alloc] init];
    _currentButtonBottom = [[UIButton alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(30, 123, 270, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"摇一摇或者再次点击内容可以更换问题哦!";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    [self addSubview:label];
    
    _btnTrueSpeak = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    _btnTrueSpeak.frame = CGRectMake(28.0 * SIZE_RATIO, (20.0 + 64) * SIZE_RATIO, 120.0 * SIZE_RATIO, 36.0 * SIZE_RATIO);
    _btnTrueSpeak.radius = 8.0;
    _btnTrueSpeak.margin = 4.0;
    _btnTrueSpeak.depth = 3.0;
    
    _btnTrueSpeak.tag = BTN_TAG_BASE;
    _btnTrueSpeak.sideColor = COLOR_WITH_RGBA(170, 105, 0, 1);
    _btnTrueSpeak.faceColor = COLOR_WITH_RGBA(254, 159, 0, 1);
    [_btnTrueSpeak setTitle:@"真心话" forState:UIControlStateNormal];
    
    [_btnTrueSpeak addTarget:self action:@selector(btnTrueSpeakPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (_btnTrueSpeak.tag == BTN_TAG_BASE) {
        
        _btnTrueSpeak.selected = YES;
        _currentButton = _btnTrueSpeak;
    }
    [self addSubview:_btnTrueSpeak];
    
    _btnBigAdventure = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    _btnBigAdventure.frame = CGRectMake((28.0 + 120.0 + 20) * SIZE_RATIO, (20.0 + 64) * SIZE_RATIO, 120.0 * SIZE_RATIO, 36.0 * SIZE_RATIO);
    //        _btnTrueSpeak.sideColor = COLOR_WITH_RGBA(233, 83, 131, 1);
    //        _btnTrueSpeak.faceColor = COLOR_WITH_RGBA(236, 110, 116, 1);
    _btnBigAdventure.sideColor = COLOR_WITH_RGBA(170, 105, 0, 1);
    _btnBigAdventure.faceColor = COLOR_WITH_RGBA(254, 159, 0, 1);
    [_btnBigAdventure addTarget:self action:@selector(btnTrueSpeakPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBigAdventure setTitle:@"大冒险" forState:UIControlStateNormal];
    _btnBigAdventure.tag = BTN_TAG_BASE + 1;
    _btnBigAdventure.radius = 8.0;
    _btnBigAdventure.margin = 4.0;
    _btnBigAdventure.depth = 3.0;
    [self addSubview:_btnBigAdventure];
    
    
    //获取plist数据
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"TrueSpeak.plist"]];
    _dicWord = dictionary[@"Word"];
    _dicAdventure = dictionary[@"Adventure"];
    _arrayNameWord = @[@"小清新", @"日常", @"重口味", @"感情类", @"人生阅历", @"综合"];
    _arrayAdventure = @[@"疯狂类", @"男女搭配", @"个性类", @"戏虐人生", @"男生请进", @"惊喜/惊悚类"];

    for (int i = 0; i < 3; i++) {
        
        for (int j = 0; j < 2; j++) {
            
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = CGRectMake((28.0 + j * (120 + 20)) * SIZE_RATIO, (160 + i * (120 + 10))* SIZE_RATIO, 120 * SIZE_RATIO, 110 * SIZE_RATIO);
            [_button setBackgroundImage:IMAGE_WITH_NAME(@"button2.png") forState:UIControlStateNormal];
            _button.layer.cornerRadius = 8.0;
            _button.layer.borderWidth = 2;
            _button.tag = BTN_CONTENT_BASE + _btnTag;
            [_button setBackgroundImage:IMAGE_WITH_NAME(@"button3.png") forState:UIControlStateSelected];
            [_button setBackgroundImage:IMAGE_WITH_NAME(@"button3.png") forState:UIControlStateSelected | UIControlStateHighlighted];
            _button.clipsToBounds = YES;
            [_button setTitle:_arrayNameWord[_btnTag] forState:UIControlStateNormal];
            [_button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            _button.layer.borderColor = [UIColor whiteColor].CGColor;
            [_button addTarget:self action:@selector(buttonContentPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_button];
            _btnTag++;
        }
    }
}

- (void)btnTrueSpeakPressed:(QBFlatButton *)sender {
    
    NSInteger index = sender.tag - BTN_TAG_BASE;
    if (sender != _currentButton) {
        
        _currentButton.selected = NO;
        _currentButton = sender;
    }
    
    _currentButton.selected = YES;
    
    if (index == 0) {
        
        [self trueSpeak];
    } else if (index == 1) {
        _btnBigAdventure.selected = YES;
        [self adventure];
    }
}

#pragma mark - 真心话 大冒险方法

- (void)trueSpeak {
    
    flag = 1;
    for (int i = 0; i < 6; i ++) {
        _button.selected = NO;
        _button = (UIButton *)[self viewWithTag:BTN_CONTENT_BASE + i];
        [_button setTitle:_arrayNameWord[i] forState:UIControlStateNormal];
    }
}

- (void)adventure {
    
    flag = 2;
    for (int i = 0; i < 6; i ++) {
        
        _button.selected = NO;
        _button = (UIButton *)[self viewWithTag:BTN_CONTENT_BASE + i];
        [_button setTitle:_arrayAdventure[i] forState:UIControlStateNormal];
    }
}

- (void)buttonContentPressed:(UIButton *)sender {
    
    NSInteger index = sender.tag - BTN_CONTENT_BASE;
    if (sender != _currentButtonBottom) {
        
        _currentButtonBottom.selected = NO;
        _currentButtonBottom = sender;
    }
    _currentButtonBottom.selected = YES;
    
    sender.titleLabel.lineBreakMode = 0;
    sender.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [sender.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    int x = arc4random() % 15;
    
    if (flag == 1) {
        
        if (index == 0) {
            
            [sender setTitle:_dicWord[@"小清新"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicWord[@"小清新"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 1) {
         
            [sender setTitle:_dicWord[@"日常"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicWord[@"日常"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 2) {
            
            [sender setTitle:_dicWord[@"重口味"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicWord[@"重口味"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 3) {
            
            [sender setTitle:_dicWord[@"感情类"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicWord[@"感情类"][x] forState:UIControlStateSelected | UIControlStateHighlighted];

        }
        
        if (index == 4) {
            
            [sender setTitle:_dicWord[@"人生阅历"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicWord[@"人生阅历"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 5) {
            
            [sender setTitle:_dicWord[@"综合"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicWord[@"综合"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }

    }
    
    if (flag == 2) {
        
        if (index == 0) {
            
            [sender setTitle:_dicAdventure[@"疯狂类"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicAdventure[@"疯狂类"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 1) {
            
            [sender setTitle:_dicAdventure[@"男女搭配"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicAdventure[@"男女搭配"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 2) {
            
            [sender setTitle:_dicAdventure[@"个性类"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicAdventure[@"个性类"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 3) {
            
            [sender setTitle:_dicAdventure[@"戏虐人生"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicAdventure[@"戏虐人生"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 4) {
            
            [sender setTitle:_dicAdventure[@"男生请进"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicAdventure[@"男生请进"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
        if (index == 5) {
            
            [sender setTitle:_dicAdventure[@"惊喜类"][x] forState:UIControlStateSelected];
//            [sender setTitle:_dicAdventure[@"惊喜类"][x] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
    }
}

/**
 *  摇一摇更新真心话或者大冒险内容
 */
- (void)changeContentByShakeEnded
{
    //改变真心话或者大冒险惩罚内容
    if (flag == 1) {
        //真心话
        for (int i = 0; i < 6; i ++) {
            NSInteger randomIndex = arc4random()%15;
            UIButton *button = (UIButton *)[self viewWithTag:BTN_CONTENT_BASE + i];
            [button setTitle:_dicWord[_arrayNameWord[i]][randomIndex] forState:UIControlStateSelected];
        }
    }else {
        //大冒险
        for (int i = 0; i < 6; i ++) {
            NSInteger randomIndex = arc4random()%15;
            UIButton *button = (UIButton *)[self viewWithTag:BTN_CONTENT_BASE + i];
            [button setTitle:_dicAdventure[_arrayAdventure[i]][randomIndex] forState:UIControlStateSelected];
        }
    }
}


@end
