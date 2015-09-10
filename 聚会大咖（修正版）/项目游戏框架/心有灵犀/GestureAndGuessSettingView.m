//
//  GestureAndGuessSettingView.m
//  聚会大咖
//
//  Created by jiaxin on 15/7/5.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "GestureAndGuessSettingView.h"
#import "SelectWordTypeView.h"

@interface GestureAndGuessSettingView (){
    NSInteger _currentTimeIndex;
    SelectWordTypeView *_selectWordTypeView;
}
@property (nonatomic, strong)NSArray *timesArray;

@property (nonatomic, copy)void(^settingCompleted)(NSDictionary *settingData);

@end

@implementation GestureAndGuessSettingView

- (instancetype)initWithFrame:(CGRect)frame settingCompleted:(void (^)(NSDictionary *))settingCompleted
{
    self = [super initWithFrame:frame];
    if (self) {
        self.settingCompleted = settingCompleted;
        [self initializeDataSource];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeDataSource
{
    _timesArray = @[@"60",@"120",@"180",@"300"];
}

- (void)initializeUserInterface
{    
    //Label-词语
    ColorButton *wordTypeButton = ({
        
        NSMutableArray *colorArray = [@[[UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1], [UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1]] mutableCopy];
        
        ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake(45*RATIO, (120)*RATIO, 115*RATIO, 35*RATIO) FromColorArray:colorArray ByGradientType:upleftTolowRight];
        [button setTitle:@"词语类型" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.userInteractionEnabled = NO;
        button;
    });
    [self addSubview:wordTypeButton];
    //词语类型选择
    ColorButton *wordTypeLabelButton = ({
        
        NSMutableArray *colorArray1 = [@[[UIColor colorWithRed:246/256.0 green:167/256.0 blue:7/256.0 alpha:1], [UIColor colorWithRed:238/256.0 green:94/256.0 blue:0 alpha:1]] mutableCopy];
        
        ColorButton *button1 = [[ColorButton alloc] initWithFrame:CGRectMake(160*RATIO, (120)*RATIO, 115*RATIO, 35*RATIO) FromColorArray:colorArray1 ByGradientType:upleftTolowRight];
        //设置部分圆角
        button1.tag = 200;
        [button1 setRatio:UIRectCornerBottomRight | UIRectCornerTopRight];
        [button1 setTitle:@"点击选择" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button1 addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button1;
    });
    [self addSubview:wordTypeLabelButton];
    
    //Label-时间
    ColorButton *timeButton = ({
        
        NSMutableArray *colorArray = [@[[UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1], [UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1]] mutableCopy];
        
        ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake((110)*RATIO, (180)*RATIO, 100*RATIO, 35*RATIO) FromColorArray:colorArray ByGradientType:leftToRight];
        [button setTitle:@"游戏时间" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.userInteractionEnabled = NO;
        button;
    });
    [self addSubview:timeButton];
    //时间选择
    UISegmentedControl *timeSegmentedControl = ({
        
        NSArray *segmentedArray = @[@"60s",@"120s",@"180s",@"300s"];
        //初始化UISegmentedControl
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        segmentedControl.frame = CGRectMake(45*RATIO, 235*RATIO, 230*RATIO, 30*RATIO);
        segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        segmentedControl.tintColor = [UIColor colorWithRed:238/256.0 green:94/256.0 blue:0 alpha:1];
        segmentedControl.tag = 300;
        [segmentedControl addTarget:self action:@selector(segmentedcontrolValueChanged:) forControlEvents:UIControlEventValueChanged];
        segmentedControl;
    });
    [self addSubview:timeSegmentedControl];
    _currentTimeIndex = 0;
    
    //Label-小组数目
    ColorButton *numberButton = ({
        
        NSMutableArray *colorArray = [@[[UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1], [UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1]] mutableCopy];
        
        ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake((110)*RATIO, (290)*RATIO, 100*RATIO, 35*RATIO) FromColorArray:colorArray ByGradientType:leftToRight];
        [button setTitle:@"小组数目" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.userInteractionEnabled = NO;
        button;
    });
    [self addSubview:numberButton];
    //添加小组
    ColorButton *addButton = ({
        
        NSMutableArray *colorArray = [@[[UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1], [UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1]] mutableCopy];
        
        ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake((45+40)*RATIO, (345)*RATIO, 35*RATIO, 35*RATIO) FromColorArray:colorArray ByGradientType:leftToRight];
        [button setTitle:@"+" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 101;
        button;
    });
    [self addSubview:addButton];
    //减少小组
    ColorButton *subButton = ({
        
        NSMutableArray *colorArray = [@[[UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1], [UIColor colorWithRed:44/256.0 green:151/256.0 blue:222/256.0 alpha:1]] mutableCopy];
        
        ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake((45+115+40)*RATIO, (345)*RATIO, 35*RATIO, 35*RATIO) FromColorArray:colorArray ByGradientType:leftToRight];
        [button setTitle:@"-" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 102;
        button;
    });
    [self addSubview:subButton];
    //小组数目
    ColorButton *numberLabelButton = ({
        
        NSMutableArray *colorArray = [@[[UIColor colorWithRed:238/256.0 green:94/256.0 blue:0 alpha:1], [UIColor colorWithRed:238/256.0 green:94/256.0 blue:0 alpha:1]] mutableCopy];
        
        ColorButton *button = [[ColorButton alloc] initWithFrame:CGRectMake((45+35+40)*RATIO, (345)*RATIO, 80*RATIO, 35*RATIO) FromColorArray:colorArray ByGradientType:leftToRight];
        [button setTitle:@"2组" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.userInteractionEnabled = NO;
        button.tag = 104;
        button;
    });
    [self addSubview:numberLabelButton];
    
    //开始游戏
    QBFlatButton *okButton = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((160-115/2.0)*RATIO, (345+80)*RATIO, 115*RATIO, 35*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 103;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self addSubview:okButton];
    
}

- (void)buttonPress:(UIButton *)sender {
    
    //词语类型选择
    if (sender.tag == 200) {
        
        _selectWordTypeView = [[SelectWordTypeView alloc] initWithFrame:FRAME_OF_IPHONE5_PROCESSED completed:^(NSString *returnString) {
            
            ColorButton *title = (ColorButton *)[self viewWithTag:200];
            [title setTitle:returnString forState:UIControlStateNormal];
        }];
        [self addSubview:_selectWordTypeView];
        return;
    }
    //添加小组数目
    if (sender.tag == 101) {
        
        ColorButton *title = (ColorButton *)[self viewWithTag:104];
        NSInteger number = [[title.titleLabel.text substringToIndex:1] integerValue];
        number ++;
        if (number > 5) {
            number --;
        }
        NSString *str = [NSString stringWithFormat:@"%ld组", (long)number];
        [title setTitle:str forState:UIControlStateNormal];
        return;
    }
    //减少小组数目
    if (sender.tag == 102) {
        
        ColorButton *title = (ColorButton *)[self viewWithTag:104];
        NSInteger number = [[title.titleLabel.text substringToIndex:1] integerValue];
        number --;
        if (number < 2) {
            number ++;
        }
        NSString *str = [NSString stringWithFormat:@"%ld组", (long)number];
        [title setTitle:str forState:UIControlStateNormal];
        return;
    }
    //开始游戏
    if (sender.tag == 103) {
        
        ColorButton *wordTypeButton = (ColorButton *)[self viewWithTag:200];
        ColorButton *groupNumber = (ColorButton *)[self viewWithTag:104];
        if ([wordTypeButton.titleLabel.text isEqualToString:@"点击选择"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有选取词语类型!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        //进入游戏
        NSDictionary *dataDict = @{@"wordType" : wordTypeButton.titleLabel.text, @"time" : _timesArray[_currentTimeIndex], @"groupNumber" : [groupNumber.titleLabel.text substringToIndex:1]};
        _settingCompleted(dataDict);
        [self removeFromSuperview];
        return;
    }
}

#pragma mark -- segmentedControl

- (void)segmentedcontrolValueChanged:(UISegmentedControl *)sender {
    
    _currentTimeIndex = sender.selectedSegmentIndex;
}


@end
