//
//  ToolManager.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/29.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "ToolManager.h"

@implementation ToolManager

+ (UIAlertController *)showAlertViewWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle confirmBlock:(void (^)())confirmBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle != nil) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
    }
    
    if (confirmTitle != nil) {
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            confirmBlock();
        }];
        [alert addAction:confirm];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

@end
