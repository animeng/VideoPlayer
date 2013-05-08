//
//  BasicModel.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//
//所有数据模型的基类
//HouseInfo::BasicModel
//例如用法：HouseInfo此类中包含name属性
//创建：HouseInfo *house = [HouseInfo createObjectWithInfo:info];
//注意：info是一个字典，
//     house中的属性(property)和字典中的key一致的情况下才能完成创建。
//     例如：字典@{name:animeng} 那么实体house必须有name这个属性才能完成赋值
//实现NScoding和NSCopy目的为了归档,可以做本地存储

#import <Foundation/Foundation.h>

@interface BasicModel : NSObject<NSCoding,NSCopying>

+ (id)createObjectWithInfo:(NSDictionary*)info;

+ (id)loadFromFile:(NSString*)path;
- (void)saveToFile:(NSString*)path;

@end
