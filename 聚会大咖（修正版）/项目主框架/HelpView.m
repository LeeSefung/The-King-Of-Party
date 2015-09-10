//
//  HelpView.m
//  聚会大咖
//
//  Created by jiaxin on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "HelpView.h"

@interface HelpView ()

@property (nonatomic, copy)void(^understand)();
@property (nonatomic, strong)NSString *text;

@end

@implementation HelpView

- (instancetype)initWithText:(NSString *)text understand:(void (^)())understand
{
    self = [super initWithFrame:FRAME_OF_IPHONE5_PROCESSED];
    if (self) {
        self.text = text;
        self.understand = understand;
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface
{
    self.backgroundColor = [UIColor colorWithWhite:0.407 alpha:0.9];
    
    UITextView *text = [[UITextView alloc] initWithIPhone5Frame:CGRectMake(10, 60, 300, 440)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:18];
    text.textColor = [UIColor whiteColor];
    text.selectable = NO;
    text.editable = NO;
    text.showsVerticalScrollIndicator = NO;
    NSMutableParagraphStyle *paragraphStytle = [[NSMutableParagraphStyle alloc] init];
    paragraphStytle.lineSpacing = 5*SIZE_RATIO;
    paragraphStytle.paragraphSpacing = 10*SIZE_RATIO;
    //    paragraphStytle.firstLineHeadIndent = 10*SIZE_RATIO;
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStytle,};
    text.attributedText = [[NSAttributedString alloc] initWithString:_text attributes:attributes];
    [self addSubview:text];
    
    UIButton *understand = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(110*SIZE_RATIO, 510*SIZE_RATIO, 100*SIZE_RATIO, 30*SIZE_RATIO);
        button.layer.masksToBounds = NO;
        button.layer.cornerRadius = 10;
        button.backgroundColor = COLOR_OF_TINTYELLOW;
        [button setTitle:@"了解" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.679 green:0.270 blue:0.058 alpha:1.000] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(understandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:understand];
    
}

- (void)understandButtonPressed:(UIButton *)sender
{
    _understand();
    [UIView animateWithDuration:0.6 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.center = CGPointMake(300*SIZE_RATIO, 44*SIZE_RATIO);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didMoveToSuperview
{
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.center = CGPointMake(300*SIZE_RATIO, 44*SIZE_RATIO);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = CGPointMake(320/2 * SIZE_RATIO, 568/2 *SIZE_RATIO);
    }];
}



@end









