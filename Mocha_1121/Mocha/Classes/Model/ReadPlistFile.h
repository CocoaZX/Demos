//
//  ReadPlistFile.h
//  Mocha
//
//  Created by renningning on 14-12-16.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadPlistFile : NSObject

@property (nonatomic,strong) NSArray *dataArray;

+ (void)getUserAttrlist;

//地区
+ (NSArray *)readAreaArray;

//性别
+ (NSDictionary *)readSex;

//工作标签
+ (NSDictionary *)readWorkTags;

//工作风格
+ (NSDictionary *)readWorkStyles;

//头发
+ (NSDictionary *)readHairs;

//职业
+ (NSDictionary *)readProfession;

//专业
+ (NSDictionary *)readMajor;

//角色
+ (NSDictionary *)getRoleTypes;

//脚码
+ (NSArray *)getFeets;

+ (NSDictionary *)readFeets;

//按value排序得到key的数组
+ (NSArray *)sortedKeysFrom:(NSDictionary *)dict;

//数组按升排序
+ (NSArray *)sortedArrayAscending:(NSArray *)array;

@end
