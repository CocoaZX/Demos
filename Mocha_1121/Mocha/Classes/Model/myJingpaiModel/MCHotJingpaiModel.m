//
//  MCHotJingpaiModel.m
//  Mocha
//
//  Created by TanJian on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCHotJingpaiModel.h"

@implementation MCJingpaiInfoModel

+(JSONKeyMapper*)keyMapper
{
    return   [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"auctionID"}];
}

@end

@implementation MCJingpaiUserModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"uid"}];
}

@end

@implementation MCLastUserInfo

+(JSONKeyMapper*)keyMapper
{
    return   [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"uid"}];
}

@end


@implementation MCHotJingpaiModel

+(JSONKeyMapper*)keyMapper
{
    return   [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"auctionID"}];
}

@end
