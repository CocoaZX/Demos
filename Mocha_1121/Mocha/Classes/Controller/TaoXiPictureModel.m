//
//  TaoXiPictureModel.m
//  Mocha
//
//  Created by zhoushuai on 16/4/6.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiPictureModel.h"

@implementation TaoXiPictureModel


- (id)initWithData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        _picturelinkStr = [data objectForKey:@"url"];
        _pictureDesc = [data objectForKey:@"title"];
        
        _width = [data objectForKey:@"width"];
        _height = [data objectForKey:@"height"];
    }
    return self;
}



@end
