//
//  UserInfo.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

 

@end

@implementation UserInfoData

 
+(JSONKeyMapper*)keyMapper
{
    return   [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"uid"}];
}

@end

@implementation Setting

 

@end

@implementation SettingMessage

 

@end

@implementation MessageSettingDesc

 

@end

@implementation MessageEnable

 

@end

@implementation MessageRankRewardItem

 

@end

@implementation PopupItem

 

@end

@implementation AlbumsItem

 
+(JSONKeyMapper*)keyMapper
{
    return   [[JSONKeyMapper alloc] initWithDictionary:@{@"default":@"defaultValue",@"description":@"desc"}];
}


@end

@implementation PhotosItem

 

@end