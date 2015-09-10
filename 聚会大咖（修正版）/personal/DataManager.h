//
//  DataManager.h
//  聚会大咖
//
//  Created by jiaxin on 15/6/28.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

/**
 *  根据传入的数组获得一个数组元素顺序随机之后的数组
 *
 *  @param array 原数组
 *
 *  @return 数组元素随机之后的数组
 */
+ (NSArray *)getRandomArrayWithArray:(NSArray *)array;
/**
 *  根据传入的FindKiller游戏方案获得一个随机之后的数组
 *
 *  @param array 原方案数组
 *
 *  @return 随机之后的数组
 */
+ (NSArray *)getRandomFindKillerArrayWithArray:(NSArray *)array;
/**
 *  根据传入的WhoIsUndecover游戏方案获得游戏数据
 *
 *  @param array 原方案数组
 *
 *  @return 游戏需要的数据
 */
+ (NSDictionary *)getWhoIsUndecoverInfoWithArray:(NSArray *)array;


@end
