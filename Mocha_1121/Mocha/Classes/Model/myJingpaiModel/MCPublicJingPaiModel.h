//
//  MCPublicJingPaiModel.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCPublicJingPaiModel : NSObject

@property (copy, nonatomic) NSString *initial_price;
@property (copy, nonatomic) NSString *auction_type;
@property (copy, nonatomic) NSString *up_range;
@property (copy, nonatomic) NSString *img_urls;
@property (copy, nonatomic) NSString *video_url;
@property (copy, nonatomic) NSString *tag_ids;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *content;



- (NSDictionary *)getParam;


@end
