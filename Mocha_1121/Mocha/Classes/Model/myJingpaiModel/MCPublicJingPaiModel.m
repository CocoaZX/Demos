//
//  MCPublicJingPaiModel.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCPublicJingPaiModel.h"

@implementation MCPublicJingPaiModel




- (NSDictionary *)getParam
{
    NSDictionary *diction =  @{@"initial_price":self.initial_price,
                               @"auction_type":self.auction_type,
                               @"up_range":self.up_range,
                               @"img_urls":self.img_urls,
                               @"longitude":self.longitude,
                               @"latitude":self.latitude,
                               @"video_url":self.video_url,
                               @"description":self.content,
                               @"tag_ids":self.tag_ids};
    
    return diction;
}


@end
