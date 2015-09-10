//
//  CollectPointView.h
//  聚会大咖
//
//  Created by rimi on 15/7/6.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectPointView : UIView

@property (nonatomic,copy)void(^completed)(NSInteger number);

- (instancetype)initWithFrame:(CGRect)frame completed:(void(^)(NSInteger number))completed;

@end
