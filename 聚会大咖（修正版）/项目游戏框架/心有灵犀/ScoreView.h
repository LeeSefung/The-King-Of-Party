//
//  ScoreTableView.h
//  聚会大咖
//
//  Created by rimi on 15/6/30.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreView : UIView

@property (nonatomic,copy)void(^completed)();

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data completed:(void(^)())completed;

@end
