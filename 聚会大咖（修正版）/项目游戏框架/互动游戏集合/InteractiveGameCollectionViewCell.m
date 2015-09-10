//
//  InteractiveGameCollectionViewCell.m
//  聚会大咖
//
//  Created by rimi on 15/7/6.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "InteractiveGameCollectionViewCell.h"

@implementation InteractiveGameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = COLOR_WITH_RGBA(52, 152, 219, 1);
        
        _gameName = [[UILabel alloc] initWithIPhone5Frame:CGRectMake(0, 50, 130, 30)];
        _gameName.textAlignment = NSTextAlignmentCenter;
        _gameName.textColor = [UIColor whiteColor];
        _gameName.font = [UIFont fontWithName:@"Georgia-Bold" size:19];
        [self.contentView addSubview:_gameName];
    
    }
    return self;
}


@end
