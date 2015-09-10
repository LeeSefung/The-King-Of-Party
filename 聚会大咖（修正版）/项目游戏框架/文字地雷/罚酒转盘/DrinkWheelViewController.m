//
//  NumberLandmineViewController.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "DrinkWheelViewController.h"

@interface DrinkWheelViewController ()

@property (strong, nonatomic) DrinkWheelView *numLandView;

@property (nonatomic, strong) HelpView *helpView;

@end

@implementation DrinkWheelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"罚酒转盘";

    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *question = [[UIBarButtonItem alloc] initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(questionPressed:)];
    self.navigationItem.rightBarButtonItem = question;
    [self.view addSubview:self.numLandView];
    [self initializeUserInterface];
}

#pragma mark -- initialize methods

- (DrinkWheelView *)numLandView {
    
    if (!_numLandView) {
        _numLandView = [[DrinkWheelView alloc] initWithIPhone5Frame:CGRectMake(0, 0, 320, 568)];
    }
    return _numLandView;
}

- (void)initializeDataSource
{
    
}

- (void)initializeUserInterface
{
    
}


- (void)questionPressed:(UIBarButtonItem *)sender
{
    //    ㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩①②③④⑤⑥⑦⑧⑨⑩
    NSString *helpString = @"罚酒转盘\n点击开始即可接受惩罚，请输的人依次接受惩罚！   ";
    if (!_helpView) {
        _helpView = [[HelpView alloc] initWithText:helpString understand:^{
            _helpView = nil;
        }];
        [self.view addSubview:_helpView];
    }
}

@end





















