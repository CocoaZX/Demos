//
//  WeixinMagnager.h
//  Mocha
//
//  Created by 小猪猪 on 15/6/21.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface WeixinMagnager : NSObject<WXApiDelegate>


@property (strong, nonatomic) NSString *weixinCode;
@property (strong, nonatomic) NSString *weixinAccess_token;
@property (strong, nonatomic) NSString *weixinExpires_in;
@property (strong, nonatomic) NSString *weixinOpenid;
@property (strong, nonatomic) NSString *weixinNickname;
@property (strong, nonatomic) NSString *weixinHeaderImageURL;

@property (strong, nonatomic) ThirdLoginComplete completeBlock;

- (void)sendAuthRequestWithController:(UIViewController *)controller success:(ThirdLoginComplete)success;


+ (WeixinMagnager *)shareWeixinManager;


@end
