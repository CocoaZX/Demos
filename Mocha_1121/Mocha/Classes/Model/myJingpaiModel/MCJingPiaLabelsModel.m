//
//  MCJingPiaLabelsModel.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJingPiaLabelsModel.h"

@implementation MCJingPiaLabelsModel

@end
@implementation JingPiaLabelModel

@end
@implementation JingPiaLabelItemModel


+(JSONKeyMapper*)keyMapper
{
    return   [[JSONKeyMapper alloc] initWithDictionary:@{@"status":@"labelstatus"}];
}

@end
