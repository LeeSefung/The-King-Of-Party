//
//  GameCell.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/26.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "GameCell.h"

@implementation GameCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = COLOR_WITH_RGBA(52, 152, 219, 1);
        
        _gameName = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(0, 140, 130, 40)];
        _gameName.textAlignment = NSTextAlignmentCenter;
        _gameName.textColor = [UIColor whiteColor];
        _gameName.font = [UIFont fontWithName:@"Georgia-Bold" size:19];
        [self.contentView addSubview:_gameName];
        
        _headImageView = [[UIImageView alloc] initWithIPhone5Frame:CGRectMake(15, 20, 100, 100)];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headImageView];
        
    }
    return self;
}

@end
