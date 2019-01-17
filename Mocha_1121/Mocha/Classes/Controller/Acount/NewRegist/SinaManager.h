//
//  SinaManager.h
//  Mocha
//
//  Created by 小猪猪 on 15/6/21.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"

@interface SinaManager : NSObject<WeiboSDKDelegate>

@property (strong, nonatomic) NSString *weiboToken;
@property (strong, nonatomic) NSString *weiboUserid;

@property (strong, nonatomic) ThirdLoginComplete completeBlock;

- (void)authSinaRequestSuccess:(ThirdLoginComplete)success;


+ (SinaManager *)shareSinaManager;



@end
