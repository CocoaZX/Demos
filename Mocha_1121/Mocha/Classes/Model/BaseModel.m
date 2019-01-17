//
//  BaseModel.m
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super init];
    if (self) {
        [self setAttributes:jsonDic];
    }
    
    return self;
}

- (void)setAttributes:(NSDictionary *)jsonDic
{
    
    NSDictionary *mapDic = [self attributeMapDictionary:jsonDic];
    
    for (NSString *jsonKey in mapDic) {
        NSString *modelAttr = [mapDic objectForKey:jsonKey];
        SEL seletor = [self stringToSel:modelAttr];
        
        //判断self 是否有seletor 方法
        if ([self respondsToSelector:seletor]) {
            //json字典中的value
            id value = [jsonDic objectForKey:jsonKey];
            
            if ([value isKindOfClass:[NSNull class]]) {
                value = @"";
            }
            
            //调用属性的设置器方法，参数是json的value
            [self performSelector:seletor withObject:value];
        }
        
    }
}

/*
 SEL 类型的创建方式有两种，例如：setNewsId: 的SEL类型
 1.第一种
 SEL selector = @selector(setNewsId:)
 2.第二种
 SEL selector = NSSelectorFromString(@"setNewsId:");
 */

//将属性名转成SEL类型的set方法
//newsId  --> setNewsId:
- (SEL)stringToSel:(NSString *)attName
{
    
    NSString *first = [[attName substringToIndex:1] uppercaseString]; //I
    NSString *end = [attName substringFromIndex:1];//mage
    
    NSString *setMethod = [NSString stringWithFormat:@"set%@%@:",first,end];
    
    return NSSelectorFromString(setMethod);
}





- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic
{
    NSMutableDictionary *mapDic = [NSMutableDictionary dictionary];
    
    for (id key in jsonDic) {
        [mapDic setObject:key forKey:key];
    }

    return mapDic;
}


@end
