//
//  DataManager.m
//  聚会大咖
//
//  Created by jiaxin on 15/6/28.
//  Copyright (c) 2015年 jiaxin. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (NSArray *)getRandomArrayWithArray:(NSArray *)array
{
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray *randomArray = [NSMutableArray array];
    
    for (NSInteger i = array.count; i > 0; i --) {
        NSInteger randomIndex = arc4random()%i;
        [randomArray addObject:dataArray[randomIndex]];
        [dataArray removeObjectAtIndex:randomIndex];
    }
    return [randomArray copy];
}

+ (NSArray *)getRandomFindKillerArrayWithArray:(NSArray *)array
{
    int killerNum = [array[0] intValue], policeNum = [array[1] intValue], peopleNum = [array[2] intValue];
    int total = killerNum + policeNum + peopleNum + 1;
    NSArray *title = @[@"杀手", @"警察", @"平民"];
    NSMutableArray *randomArray = [NSMutableArray array];
    for (int i = 1; i < total ; i ++) {
        int temp = killerNum > 0 ? 0 :(policeNum > 0 ? 1 : 2);
        temp == 0 ? killerNum-- : (temp == 1 ? policeNum -- : peopleNum --);
        int index = arc4random() % i;
        [randomArray insertObject:title[temp] atIndex:index];
    }
    return randomArray;
}

+ (NSDictionary *)getWhoIsUndecoverInfoWithArray:(NSArray *)array
{
    int undecoverNum = [array[1] intValue], peopleNum = [array[0] intValue];
    int total = undecoverNum + peopleNum + 1;
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"whoIsUndercover.plist"]];
    int randomIndex = arc4random()%dataArray.count;
    NSArray *title = dataArray[randomIndex];
    if (arc4random()%2 == 1) {
        title = [NSArray arrayWithObjects:title[1],title[0], nil];
    }
    NSMutableArray *randomArray = [NSMutableArray array];
    for (int i = 1; i < total ; i ++) {
        int temp = undecoverNum > 0 ? 0 : 1;
        temp == 0 ? undecoverNum-- : peopleNum --;
        int index = arc4random() % i;
        [randomArray insertObject:title[temp] atIndex:index];
    }
    NSDictionary *dict = @{@"array" : randomArray, @"undercover" : title[0], @"people" : title[1]};
    return dict;
}



@end
