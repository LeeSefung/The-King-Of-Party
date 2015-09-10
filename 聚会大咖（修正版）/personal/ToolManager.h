//
//  ToolManager.h
//  聚会大咖
//
//  Created by jiaxin on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolManager : NSObject

/**
 *  用rootviewcontroller弹出警告框
 *
 *  @param message      message
 *  @param cancelTitle  cancelTitle 如果是nil就不创建
 *  @param confirmTitle confirmTitle 如果是nil就不创建
 *  @param confirmBlock 如果有confirm，点击之后调用的代码块
 *
 *  @return 返回创建的UIAlertController
 */
+ (UIAlertController *)showAlertViewWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle confirmBlock:(void(^)())confirmBlock;

@end
