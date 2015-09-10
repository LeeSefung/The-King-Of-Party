//
//  HelpView.h
//  聚会大咖
//
//  Created by jiaxin on 15/7/1.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpView : UIView

- (instancetype)initWithText:(NSString *)text understand:(void(^)())understand;

@end
