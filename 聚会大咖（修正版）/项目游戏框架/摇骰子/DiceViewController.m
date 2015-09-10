//
//  DiceViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "DiceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CollectPointView.h"

@interface DiceViewController ()
{
    int whichAnimatiom;
    int zeng;
    NSMutableSet *_pointSet;
    NSMutableSet *_locationSet;
    UIImageView *_background;
    NSMutableSet *_finallySet;
    CollectPointView *_collectView;
    NSInteger _allNumber;
}

//帮助页面
@property (nonatomic, strong)HelpView *helpView;

//初始化数据
- (void)initializeDataSource;
//初始化界面
- (void)initializeUserInterface;
//选择点数
- (void)collectPointButtonPress:(UIButton *)sender;
//点击开始
- (void)startPress:(UIButton *)sender;
//开始动画
- (void)animationGo;
//结束动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
//取绝对值absolute value
- (NSInteger)getAbsoluteValue:(NSInteger)number;
//获取随机数组
- (NSArray *)getRandomArrayWithArray:(NSArray *)array;
//帮助
- (void)questionPressed:(UIBarButtonItem *)sender;

@end

@implementation DiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"摇骰子";
    self.view.backgroundColor = [UIColor colorWithRed:0 green:189/255.0 blue:156.0/255 alpha:1];
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods

- (void)initializeDataSource
{
    _allNumber = 0;
    _pointSet = [[NSMutableSet alloc] initWithArray:[NSArray arrayWithObjects:
                         @{@"x":@"100",@"y":@"25"},@{@"x":@"145",@"y":@"25"},
                         @{@"x":@"55",@"y":@"70"},@{@"x":@"100",@"y":@"70"},@{@"x":@"145",@"y":@"70"},@{@"x":@"190",@"y":@"70"},
                         @{@"x":@"30",@"y":@"115"},@{@"x":@"75",@"y":@"115"},@{@"x":@"120",@"y":@"115"},@{@"x":@"165",@"y":@"115"},@{@"x":@"210",@"y":@"115"},
                         @{@"x":@"45",@"y":@"160"},@{@"x":@"135",@"y":@"160"},@{@"x":@"90",@"y":@"160"},@{@"x":@"185",@"y":@"160"},
                         @{@"x":@"90",@"y":@"205"},@{@"x":@"135",@"y":@"205"},
                                                     nil]];
    _locationSet = [[NSMutableSet alloc] initWithArray:[NSArray arrayWithObjects:
                                                        @{@"x":@"122.5",@"y":@"47.5"},@{@"x":@"167.5",@"y":@"47.5"},
                                                        @{@"x":@"77.5",@"y":@"92.5"},@{@"x":@"212.5",@"y":@"92.5"},
                                                        @{@"x":@"52.5",@"y":@"137.5"},@{@"x":@"232.5",@"y":@"137.5"},
                                                        @{@"x":@"67.5",@"y":@"187.5"},@{@"x":@"207.5",@"y":@"182.5"},
                                                        @{@"x":@"112.5",@"y":@"227.5"},@{@"x":@"157.5",@"y":@"227.5"},
                                                        nil]];
    _finallySet = [[NSMutableSet alloc] initWithArray:[NSArray arrayWithObjects:
                                                       @{@"x":@"122.5",@"y":@"47.5"},@{@"x":@"167.5",@"y":@"47.5"},
                                                       @{@"x":@"77.5",@"y":@"92.5"},@{@"x":@"212.5",@"y":@"92.5"},@{@"x":@"122.5",@"y":@"92.5"},@{@"x":@"167.5",@"y":@"92.5"},
                                                       @{@"x":@"52.5",@"y":@"137.5"},@{@"x":@"232.5",@"y":@"137.5"},@{@"x":@"97.5",@"y":@"137.5"},@{@"x":@"142.5",@"y":@"137.5"},@{@"x":@"187.5",@"y":@"137.5"},
                                                       @{@"x":@"67.5",@"y":@"187.5"},@{@"x":@"207.5",@"y":@"182.5"},@{@"x":@"157.5",@"y":@"182.5"},@{@"x":@"112.5",@"y":@"182.5"},
                                                       @{@"x":@"112.5",@"y":@"227.5"},@{@"x":@"157.5",@"y":@"227.5"},
                                                       nil]];
}

- (void)initializeUserInterface
{
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shangpingwan@2x.png"]];
    _background.frame = CGRectMake(15.0*RATIO, 44+10*RATIO, 290.0*RATIO, 290*RATIO);
    [self.view addSubview:_background];
    
    NSArray *pointArray = [_pointSet allObjects];
    //逐个添加骰子
    UIImageView *_image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1@2x.png"]];
    int i = arc4random()%pointArray.count;
    [_pointSet removeObject:pointArray[i]];
    _image1.frame = CGRectMake([pointArray[i][@"x"] integerValue]*RATIO, [pointArray[i][@"y"] integerValue]*RATIO, 45.0*RATIO, 45.0*RATIO);
    image1 = _image1;
    [_background addSubview:_image1];

    UIImageView *_image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2@2x.png"]];
    NSArray *pointArray2 = [_pointSet allObjects];
    int i2 = arc4random()%pointArray2.count;
    [_pointSet removeObject:pointArray2[i2]];
    _image2.frame = CGRectMake([pointArray2[i2][@"x"] integerValue]*RATIO, [pointArray2[i2][@"y"] integerValue]*RATIO, 45.0*RATIO, 45.0*RATIO);
    image2 = _image2;
    [_background addSubview:_image2];
    
    UIImageView *_image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3@2x.png"]];
    NSArray *pointArray3 = [_pointSet allObjects];
    int i3 = arc4random()%pointArray3.count;
    [_pointSet removeObject:pointArray3[i3]];
    _image3.frame = CGRectMake([pointArray3[i3][@"x"] integerValue]*RATIO, [pointArray3[i3][@"y"] integerValue]*RATIO, 45.0*RATIO, 45.0*RATIO);
    image3 = _image3;
    [_background addSubview:_image3];
    UIImageView *_image4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4@2x.png"]];
    NSArray *pointArray4 = [_pointSet allObjects];
    int i4 = arc4random()%pointArray4.count;
    [_pointSet removeObject:pointArray4[i4]];
    _image4.frame = CGRectMake([pointArray4[i4][@"x"] integerValue]*RATIO, [pointArray4[i4][@"y"] integerValue]*RATIO, 45.0*RATIO, 45.0*RATIO);
    image4 = _image4;
    [_background addSubview:_image4];

    UIImageView *_image6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6@2x.png"]];
    NSArray *pointArray6 = [_pointSet allObjects];
    int i6 = arc4random()%pointArray6.count;
    [_pointSet removeObject:pointArray6[i6]];
    _image6.frame = CGRectMake([pointArray6[i6][@"x"] integerValue]*RATIO, [pointArray6[i6][@"y"] integerValue]*RATIO, 45.0*RATIO, 45.0*RATIO);
    image6 = _image6;
    [_background addSubview:_image6];
    //添加按钮
    //开始游戏
    QBFlatButton *okButton = ({
        
        [[QBFlatButton appearance] setFaceColor:[UIColor colorWithWhite:0.75 alpha:1.0] forState:UIControlStateDisabled];
        [[QBFlatButton appearance] setSideColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateDisabled];
        
        QBFlatButton *btn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(235*RATIO, (445)*RATIO, 60*RATIO, 60*RATIO);
        btn.faceColor = [UIColor colorWithRed:86.0/255.0 green:161.0/255.0 blue:217.0/255.0 alpha:1.0];
        btn.sideColor = [UIColor colorWithRed:79.0/255.0 green:127.0/255.0 blue:179.0/255.0 alpha:1.0];
        btn.radius = 8.0;
        btn.margin = 4.0;
        btn.depth = 3.0;
        btn.tag = 500;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [btn addTarget:self action:@selector(startPress:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:okButton];
    
    //游戏说明：
    UILabel *gameExplanation = [[UILabel alloc] initWithFrame:CGRectMake(15*RATIO, 355*RATIO, 290*RATIO, 50*RATIO)];
    gameExplanation.text = @"游戏规则：玩家首先选择点数，玩家间点数不能相同，然后再摇色子，点数越靠近的玩家预设点数的获得胜利!";
    gameExplanation.font = [UIFont systemFontOfSize:16];
    gameExplanation.numberOfLines = 0;
    [gameExplanation sizeToFit];
    [self.view addSubview:gameExplanation];
    
    //设置点数
    for (int i = 0; i < 2; i ++) {
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*RATIO, (440+60*i)*RATIO, 80*RATIO, 30*RATIO)];
        nameLabel.text = [NSString stringWithFormat:@"玩家%ld：",(long)(i + 1)];
        [self.view addSubview:nameLabel];
        
        UIButton *collectPointButton = [[UIButton alloc] initWithFrame:CGRectMake(90*RATIO, (438+60*i)*RATIO, 120*RATIO, 35*RATIO)];
        collectPointButton.backgroundColor = [UIColor colorWithRed:82/255.0 green:160/255.0 blue:219/255.0 alpha:1];
        collectPointButton.layer.cornerRadius = 5;
        [collectPointButton setTitle:@"选择点数" forState:UIControlStateNormal];
        collectPointButton.tag = 300+i;
        [collectPointButton addTarget:self action:@selector(collectPointButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:collectPointButton];
    }

}

//选择点数
- (void)collectPointButtonPress:(UIButton *)sender {
    
    _collectView = [[CollectPointView alloc] initWithFrame:CGRectMake(0, 0, 320*RATIO, 568*RATIO) completed:^(NSInteger number) {
        
        [sender setTitle:[NSString stringWithFormat:@"%ld点",(long)number] forState:UIControlStateNormal];
        [_collectView removeFromSuperview];
    }];
    [self.view addSubview:_collectView];
}

//点击开始
- (void)startPress:(UIButton *)sender {
    
    UIButton *number1 = (UIButton *)[self.view viewWithTag:300];
    NSInteger numberO = [[number1.titleLabel.text substringWithRange:NSMakeRange(0, number1.titleLabel.text.length-1)] integerValue];
    UIButton *number2 = (UIButton *)[self.view viewWithTag:301];
    NSInteger numberT = [[number2.titleLabel.text substringWithRange:NSMakeRange(0, number2.titleLabel.text.length-1)] integerValue];
    
    if (number2.titleLabel.text.length != 4 && number2.titleLabel.text.length != 4) {
        
        if (numberO != numberT) {
            
            [self animationGo];
            sender.userInteractionEnabled = NO;
            number1.userInteractionEnabled = NO;
            number2.userInteractionEnabled = NO;
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"玩家点数不能相同，请重新设置点数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置点数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

//开始动画
- (void)animationGo
{
    static SystemSoundID soundIDTest = 0;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"yao" ofType:@"wav"];
    
    if (path) {
        
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
        
    }
    
    AudioServicesPlaySystemSound( soundIDTest );
    [self initializeDataSource];
    //隐藏初始位置的骰子
    image1.hidden = YES;
    image2.hidden = YES;
    image3.hidden = YES;
    image4.hidden = YES;
//    image5.hidden = YES;
    image6.hidden = YES;
    dong1.hidden = YES;
    dong2.hidden = YES;
    dong3.hidden = YES;
    dong4.hidden = YES;
//    dong5.hidden = YES;
    dong6.hidden = YES;
    //******************旋转动画的初始化******************
    //转动骰子的载入
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"dong1@2x.png"],
                         [UIImage imageNamed:@"dong2@2x.png"],
                         [UIImage imageNamed:@"dong3@2x.png"],nil];
    //骰子1的转动图片切换
    UIImageView *dong11 = [[UIImageView alloc]initWithFrame:image1.frame];
    dong11.animationImages = [self getRandomArrayWithArray:myImages];
    dong11.animationDuration = 0.5;
    [dong11 startAnimating];
    [_background addSubview:dong11];
    dong1 = dong11;
    //骰子2的转动图片切换
    UIImageView *dong12 = [[UIImageView alloc] initWithFrame:image2.frame];
    dong12.animationImages = [self getRandomArrayWithArray:myImages];
    dong12.animationDuration = 0.5;
    [dong12 startAnimating];
    [_background addSubview:dong12];
    dong2 = dong12;
    //骰子3的转动图片切换
    UIImageView *dong13 = [[UIImageView alloc] initWithFrame:image3.frame];
    dong13.animationImages = [self getRandomArrayWithArray:myImages];
    dong13.animationDuration = 0.5;
    [dong13 startAnimating];
    [_background addSubview:dong13];
    dong3 = dong13;
    //骰子4的转动图片切换
    UIImageView *dong14 = [[UIImageView alloc] initWithFrame:image4.frame];
    dong14.animationImages = [self getRandomArrayWithArray:myImages];
    dong14.animationDuration = 0.5;
    [dong14 startAnimating];
    [_background addSubview:dong14];
    dong4 = dong14;

    //    骰子6的转动图片切换
    UIImageView *dong16 = [[UIImageView alloc]initWithFrame:image6.frame];
    dong16.animationImages = [self getRandomArrayWithArray:myImages];
    dong16.animationDuration = 0.5;
    [dong16 startAnimating];
    [_background addSubview:dong16];
    dong6 = dong16;
    
    //******************旋转动画******************
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 16]];
    [spin setDuration:4];
    //******************位置变化******************
    //骰子1的位置变化
    CGPoint p1 = image1.center;
    int p101 = arc4random()%[_locationSet allObjects].count;
    int p102 = arc4random()%[_locationSet allObjects].count;
    int p103 = arc4random()%[_locationSet allObjects].count;
    int p104 = arc4random()%[_locationSet allObjects].count;
    int p105 = arc4random()%[_locationSet allObjects].count;
    int p106 = arc4random()%[_locationSet allObjects].count;
    int p107 = arc4random()%[_locationSet allObjects].count;
    CGPoint p2 = CGPointMake([[_locationSet allObjects][p101][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p101][@"y"] integerValue]*RATIO);
    CGPoint p3 = CGPointMake([[_locationSet allObjects][p102][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p102][@"y"] integerValue]*RATIO);
    CGPoint p4 = CGPointMake([[_locationSet allObjects][p103][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p103][@"y"] integerValue]*RATIO);
    CGPoint p5 = CGPointMake([[_locationSet allObjects][p104][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p104][@"y"] integerValue]*RATIO);
    CGPoint p6 = CGPointMake([[_locationSet allObjects][p105][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p105][@"y"] integerValue]*RATIO);
    CGPoint p7 = CGPointMake([[_locationSet allObjects][p106][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p106][@"y"] integerValue]*RATIO);
    CGPoint p8 = CGPointMake([[_locationSet allObjects][p107][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p107][@"y"] integerValue]*RATIO);
    NSArray *keypoint = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4],[NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p7], nil];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setValues:keypoint];
    [animation setDuration:4.0];
    [animation setDelegate:self];
    [dong11.layer setPosition:CGPointMake([[_locationSet allObjects][p106][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p106][@"y"] integerValue]*RATIO)];
    image1.center = CGPointMake([[_locationSet allObjects][p106][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p106][@"y"] integerValue]*RATIO);
    [_finallySet removeObject:[_locationSet allObjects][p106]];
    
//    //骰子2的位置变化
    CGPoint p21 = image2.center;
    int p201 = arc4random()%[_locationSet allObjects].count;
    int p202 = arc4random()%[_locationSet allObjects].count;
    int p203 = arc4random()%[_locationSet allObjects].count;
    int p204 = arc4random()%[_locationSet allObjects].count;
    int p207 = arc4random()%[_locationSet allObjects].count;
    int p208 = arc4random()%[_locationSet allObjects].count;
    int p205 = arc4random()%[_locationSet allObjects].count;
    int p206 = arc4random()%[_finallySet allObjects].count;
    CGPoint p22 = CGPointMake([[_locationSet allObjects][p201][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p201][@"y"] integerValue]*RATIO);
    CGPoint p32 = CGPointMake([[_locationSet allObjects][p202][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p202][@"y"] integerValue]*RATIO);
    CGPoint p42 = CGPointMake([[_locationSet allObjects][p203][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p203][@"y"] integerValue]*RATIO);
    CGPoint p52 = CGPointMake([[_locationSet allObjects][p204][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p204][@"y"] integerValue]*RATIO);
    CGPoint p62 = CGPointMake([[_locationSet allObjects][p205][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p205][@"y"] integerValue]*RATIO);
    CGPoint p82 = CGPointMake([[_locationSet allObjects][p207][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p207][@"y"] integerValue]*RATIO);
    CGPoint p92 = CGPointMake([[_locationSet allObjects][p208][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p208][@"y"] integerValue]*RATIO);
    CGPoint p72 = CGPointMake([[_finallySet allObjects][p206][@"x"] integerValue]*RATIO, [[_finallySet allObjects][p206][@"y"] integerValue]*RATIO);
    NSArray *keypoint2 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p21],[NSValue valueWithCGPoint:p22],[NSValue valueWithCGPoint:p32],[NSValue valueWithCGPoint:p42],[NSValue valueWithCGPoint:p52],[NSValue valueWithCGPoint:p62],[NSValue valueWithCGPoint:p92],[NSValue valueWithCGPoint:p82],[NSValue valueWithCGPoint:p72], nil];
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation2 setValues:keypoint2];
    [animation2 setDuration:4.0];
    [animation2 setDelegate:self];
    [dong12.layer setPosition:p72];
    image2.center = p72;
    [_finallySet removeObject:[_finallySet allObjects][p206]];

    //骰子3的位置变化
    CGPoint p31 = image3.center;
    int p301 = arc4random()%[_locationSet allObjects].count;
    int p302 = arc4random()%[_locationSet allObjects].count;
    int p303 = arc4random()%[_locationSet allObjects].count;
    int p304 = arc4random()%[_locationSet allObjects].count;
    int p305 = arc4random()%[_locationSet allObjects].count;
    int p306 = arc4random()%[_finallySet allObjects].count;
    CGPoint p23 = CGPointMake([[_locationSet allObjects][p301][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p301][@"y"] integerValue]*RATIO);
    CGPoint p33 = CGPointMake([[_locationSet allObjects][p302][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p302][@"y"] integerValue]*RATIO);
    CGPoint p43 = CGPointMake([[_locationSet allObjects][p303][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p303][@"y"] integerValue]*RATIO);
    CGPoint p53 = CGPointMake([[_locationSet allObjects][p304][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p304][@"y"] integerValue]*RATIO);
    CGPoint p63 = CGPointMake([[_locationSet allObjects][p305][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p305][@"y"] integerValue]*RATIO);
    CGPoint p73 = CGPointMake([[_finallySet allObjects][p306][@"x"] integerValue]*RATIO, [[_finallySet allObjects][p306][@"y"] integerValue]*RATIO);
    NSArray *keypoint3 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p31],[NSValue valueWithCGPoint:p23],[NSValue valueWithCGPoint:p33],[NSValue valueWithCGPoint:p43],[NSValue valueWithCGPoint:p53],[NSValue valueWithCGPoint:p63],[NSValue valueWithCGPoint:p73],nil];
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation3 setValues:keypoint3];
    [animation3 setDuration:4.0];
    [animation3 setDelegate:self];
    [dong13.layer setPosition:p73];
    image3.center = p73;
    [_finallySet removeObject:[_finallySet allObjects][p306]];
    
    //骰子4的位置变化
    CGPoint p41 = image4.center;
    int p401 = arc4random()%[_locationSet allObjects].count;
    int p402 = arc4random()%[_locationSet allObjects].count;
    int p403 = arc4random()%[_locationSet allObjects].count;
    int p404 = arc4random()%[_locationSet allObjects].count;
    int p405 = arc4random()%[_locationSet allObjects].count;
    int p406 = arc4random()%[_finallySet allObjects].count;
    CGPoint p24 = CGPointMake([[_locationSet allObjects][p401][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p401][@"y"] integerValue]*RATIO);
    CGPoint p34 = CGPointMake([[_locationSet allObjects][p402][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p402][@"y"] integerValue]*RATIO);
    CGPoint p44 = CGPointMake([[_locationSet allObjects][p403][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p403][@"y"] integerValue]*RATIO);
    CGPoint p54 = CGPointMake([[_locationSet allObjects][p404][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p404][@"y"] integerValue]*RATIO);
    CGPoint p64 = CGPointMake([[_locationSet allObjects][p405][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p405][@"y"] integerValue]*RATIO);
    CGPoint p74 = CGPointMake([[_finallySet allObjects][p406][@"x"] integerValue]*RATIO, [[_finallySet allObjects][p406][@"y"] integerValue]*RATIO);
    NSArray *keypoint4 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p41],[NSValue valueWithCGPoint:p24],[NSValue valueWithCGPoint:p34],[NSValue valueWithCGPoint:p44],[NSValue valueWithCGPoint:p54],[NSValue valueWithCGPoint:p64],[NSValue valueWithCGPoint:p74], nil];
    CAKeyframeAnimation *animation4 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation4 setValues:keypoint4];
    [animation4 setDuration:4.0];
    [animation4 setDelegate:self];
    [dong14.layer setPosition:p74];
    image4.center = p74;
    [_finallySet removeObject:[_finallySet allObjects][p406]];
    
    //    骰子6的位置变化
    CGPoint p61 = image6.center;
    int p601 = arc4random()%[_locationSet allObjects].count;
    int p602 = arc4random()%[_locationSet allObjects].count;
    int p603 = arc4random()%[_locationSet allObjects].count;
    int p604 = arc4random()%[_locationSet allObjects].count;
    int p607 = arc4random()%[_locationSet allObjects].count;
    int p605 = arc4random()%[_locationSet allObjects].count;
    int p606 = arc4random()%[_finallySet allObjects].count;
    CGPoint p26 = CGPointMake([[_locationSet allObjects][p601][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p601][@"y"] integerValue]*RATIO);
    CGPoint p36 = CGPointMake([[_locationSet allObjects][p602][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p602][@"y"] integerValue]*RATIO);
    CGPoint p46 = CGPointMake([[_locationSet allObjects][p603][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p603][@"y"] integerValue]*RATIO);
    CGPoint p56 = CGPointMake([[_locationSet allObjects][p604][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p604][@"y"] integerValue]*RATIO);
    CGPoint p66 = CGPointMake([[_locationSet allObjects][p605][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p605][@"y"] integerValue]*RATIO);
    CGPoint p86 = CGPointMake([[_locationSet allObjects][p607][@"x"] integerValue]*RATIO, [[_locationSet allObjects][p607][@"y"] integerValue]*RATIO);
    CGPoint p76 = CGPointMake([[_finallySet allObjects][p606][@"x"] integerValue]*RATIO, [[_finallySet allObjects][p606][@"y"] integerValue]*RATIO);
    NSArray *keypoint6 = [[NSArray alloc] initWithObjects:[NSValue valueWithCGPoint:p61],[NSValue valueWithCGPoint:p26],[NSValue valueWithCGPoint:p36],[NSValue valueWithCGPoint:p46],[NSValue valueWithCGPoint:p56],[NSValue valueWithCGPoint:p86],[NSValue valueWithCGPoint:p66],[NSValue valueWithCGPoint:p76], nil];
    CAKeyframeAnimation *animation6 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation6 setValues:keypoint6];
    [animation6 setDuration:4.0];
    [animation6 setDelegate:self];
    [dong16.layer setPosition:p76];
    image6.center = p76;
    
    //******************动画组合******************
    //骰子1的动画组合
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects: animation, spin,nil];
    animGroup.duration = 4;
    [animGroup setDelegate:self];
    [[dong11 layer] addAnimation:animGroup forKey:@"position"];
    //骰子2的动画组合
    CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
    animGroup2.animations = [NSArray arrayWithObjects: animation2, spin,nil];
    animGroup2.duration = 4;
    [animGroup2 setDelegate:self];
    [[dong12 layer] addAnimation:animGroup2 forKey:@"position"];
    //骰子3的动画组合
    CAAnimationGroup *animGroup3 = [CAAnimationGroup animation];
    animGroup3.animations = [NSArray arrayWithObjects: animation3, spin,nil];
    animGroup3.duration = 4;
    [animGroup3 setDelegate:self];
    [[dong13 layer] addAnimation:animGroup3 forKey:@"position"];
    //骰子4的动画组合
    CAAnimationGroup *animGroup4 = [CAAnimationGroup animation];
    animGroup4.animations = [NSArray arrayWithObjects: animation4, spin,nil];
    animGroup4.duration = 4;
    [animGroup4 setDelegate:self];
    [[dong14 layer] addAnimation:animGroup4 forKey:@"position"];
    //骰子6的动画组合
    CAAnimationGroup *animGroup6 = [CAAnimationGroup animation];
    animGroup6.animations = [NSArray arrayWithObjects: animation6, spin,nil];
    animGroup6.duration = 4;
    [animGroup6 setDelegate:self];
    [[dong16 layer] addAnimation:animGroup6 forKey:@"position"];
}

//结束动画后的操作
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //停止骰子自身的转动
    [dong1 stopAnimating];
    [dong2 stopAnimating];
    [dong3 stopAnimating];
    [dong4 stopAnimating];
    [dong6 stopAnimating];
    
    //骰子1的结果
    int result1 = arc4random()%6+1;
    switch (result1) {
        case 1:dong1.image = [UIImage imageNamed:@"1@2x.png"];break;
        case 2:dong1.image = [UIImage imageNamed:@"2@2x.png"];break;
        case 3:dong1.image = [UIImage imageNamed:@"3@2x.png"];break;
        case 4:dong1.image = [UIImage imageNamed:@"4@2x.png"];break;
        case 5:dong1.image = [UIImage imageNamed:@"5@2x.png"];break;
        case 6:dong1.image = [UIImage imageNamed:@"6@2x.png"];break;
    }
    //骰子2的结果
    int result2 = arc4random()%6+1;
    switch (result2) {
        case 1:dong2.image = [UIImage imageNamed:@"1@2x.png"];break;
        case 2:dong2.image = [UIImage imageNamed:@"2@2x.png"];break;
        case 3:dong2.image = [UIImage imageNamed:@"3@2x.png"];break;
        case 4:dong2.image = [UIImage imageNamed:@"4@2x.png"];break;
        case 5:dong2.image = [UIImage imageNamed:@"5@2x.png"];break;
        case 6:dong2.image = [UIImage imageNamed:@"6@2x.png"];break;
    }
    //骰子3的结果
    int result3 = arc4random()%6+1;
    switch (result3) {
        case 1:dong3.image = [UIImage imageNamed:@"1@2x.png"];break;
        case 2:dong3.image = [UIImage imageNamed:@"2@2x.png"];break;
        case 3:dong3.image = [UIImage imageNamed:@"3@2x.png"];break;
        case 4:dong3.image = [UIImage imageNamed:@"4@2x.png"];break;
        case 5:dong3.image = [UIImage imageNamed:@"5@2x.png"];break;
        case 6:dong3.image = [UIImage imageNamed:@"6@2x.png"];break;
    }
    //骰子4的结果
    int result4 = arc4random()%6+1;
    switch (result4) {
        case 1:dong4.image = [UIImage imageNamed:@"1@2x.png"];break;
        case 2:dong4.image = [UIImage imageNamed:@"2@2x.png"];break;
        case 3:dong4.image = [UIImage imageNamed:@"3@2x.png"];break;
        case 4:dong4.image = [UIImage imageNamed:@"4@2x.png"];break;
        case 5:dong4.image = [UIImage imageNamed:@"5@2x.png"];break;
        case 6:dong4.image = [UIImage imageNamed:@"6@2x.png"];break;
    }
    //骰子6的结果
    int result6 = arc4random()%6+1;
    switch (result6) {
        case 1:dong6.image = [UIImage imageNamed:@"1@2x.png"];break;
        case 2:dong6.image = [UIImage imageNamed:@"2@2x.png"];break;
        case 3:dong6.image = [UIImage imageNamed:@"3@2x.png"];break;
        case 4:dong6.image = [UIImage imageNamed:@"4@2x.png"];break;
        case 5:dong6.image = [UIImage imageNamed:@"5@2x.png"];break;
        case 6:dong6.image = [UIImage imageNamed:@"6@2x.png"];break;
    }
    
    static int i = 0;
    i++;
    if (i != 5) {
        return;
    }
    UIButton *startButton = (UIButton *)[self.view viewWithTag:500];
    startButton.userInteractionEnabled = YES;
    _allNumber = result1 + result2 + result3 + result4 + result6;
    UIButton *number1 = (UIButton *)[self.view viewWithTag:300];
    NSInteger numberO = [[number1.titleLabel.text substringWithRange:NSMakeRange(0, number1.titleLabel.text.length-1)] integerValue];
    UIButton *number2 = (UIButton *)[self.view viewWithTag:301];
    NSInteger numberT = [[number2.titleLabel.text substringWithRange:NSMakeRange(0, number2.titleLabel.text.length-1)] integerValue];
    number1.userInteractionEnabled = YES;
    number2.userInteractionEnabled = YES;
    if ([self getAbsoluteValue:_allNumber - numberO] < [self getAbsoluteValue:_allNumber - numberT]) {
        
        NSString *message = [NSString stringWithFormat:@"总点数为%ld，玩家1获胜",(long)_allNumber];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        i = 0;
        return;
    }else if ([self getAbsoluteValue:_allNumber - numberO] == [self getAbsoluteValue:_allNumber - numberT]) {
        
        NSString *message = [NSString stringWithFormat:@"总点数为%ld，没有决出胜负",(long)_allNumber];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        i = 0;
        return;
    }else {
        
        NSString *message = [NSString stringWithFormat:@"总点数为%ld，玩家2获胜",(long)_allNumber];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        i = 0;
        return;
    }
}

//取绝对值absolute value
- (NSInteger)getAbsoluteValue:(NSInteger)number {
    
    if (number < 0) {
        return 0 - number;
    }else {
        return number;
    }
}

//获取随机数组
- (NSArray *)getRandomArrayWithArray:(NSArray *)array
{
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray *randomArray = [NSMutableArray array];
    
    for (NSInteger i = array.count; i > 0; i --) {
        NSInteger randomIndex = arc4random()%i;
        [randomArray addObject:dataArray[randomIndex]];
        [dataArray removeObjectAtIndex:randomIndex];
    }
    return [randomArray copy];
}

#pragma mark -- action

- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"摇骰子\n①.玩家1与玩家2选择骰子的总点数。\n②.进入选择点数界面后，点击相应点数选择，且玩家间点数不能相同。\n③.设置完毕后点击开始按钮开始游戏，若选择的点数不符合要求则会弹出警告，要求重新选择点数。\n④.一切正常后，摇骰子开始，结束后显示结果。";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
