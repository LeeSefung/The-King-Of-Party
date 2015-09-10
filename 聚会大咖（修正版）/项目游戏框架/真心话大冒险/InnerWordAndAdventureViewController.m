//
//  InnerWordAndAdventureViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "InnerWordAndAdventureViewController.h"
#import "InnerWordAndAdventureView.h"

@interface InnerWordAndAdventureViewController ()

@property (strong, nonatomic) InnerWordAndAdventureView *innerView;

@property (nonatomic, strong) HelpView *helpView;

@end

@implementation InnerWordAndAdventureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"真心话大冒险";
    self.view.backgroundColor = COLOR_WITH_RGBA(43, 132, 210, 1);
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    [self.view addSubview:self.innerView];
}

- (InnerWordAndAdventureView *)innerView {
    if (!_innerView) {
        _innerView = [[InnerWordAndAdventureView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 568)];
    }
    return _innerView;
}

#pragma mark -- action

- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"真心话大冒险\n       真心话大冒险是一种娱乐活动，具体规则一般为2人时，可利用猜拳决定；3人时，可利用手心手背决定；如果有很多人，可以抽牌，通常来说抽中大鬼的那位就要选择真心话还是大冒险。由选定的一方选择“真心话”还是“大冒险”，选择真心话，则由胜方随意问输者问题，输者必须全部如实回答；选择大冒险，则胜方随意出任何行为问题由输方尝试完成。";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }

}

/**
 *  摇一摇开始
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}
/**
 *  摇一摇结束
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [_innerView changeContentByShakeEnded];
}
/**
 *  摇一摇取消
 */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

@end















