//
//  FindKillerPlayerListCollectionCell.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "FindKillerPlayerListCollectionCell.h"

@implementation FindKillerPlayerListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        _playerCount = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 10;
            label.backgroundColor = COLOR_OF_TINTBULE;
            label.font = [UIFont systemFontOfSize:20];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self.contentView addSubview:_playerCount];

        _playerIdentity = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height*2/3, width, height*1/3)];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 10;
            label.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
            label.font = [UIFont systemFontOfSize:18];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor redColor];
            label;
        });
        [self.contentView addSubview:_playerIdentity];
        
    }
    return self;
}




@end
