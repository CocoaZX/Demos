//
//  BaseModel.h
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (id)initContentWithDic:(NSDictionary *)jsonDic;

- (void)setAttributes:(NSDictionary *)jsonDic;

- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic;

@end
