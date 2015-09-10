//
//  SelectWordTypeView.h
//  PartyGame
//
//  Created by rimi on 15/6/26.
//  Copyright (c) 2015年 LeeSefung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectWordTypeView : UIView

@property (nonatomic,copy)void(^completed)(NSString *returnString);

- (instancetype)initWithFrame:(CGRect)frame completed:(void(^)(NSString *returnString))completed;

@end
