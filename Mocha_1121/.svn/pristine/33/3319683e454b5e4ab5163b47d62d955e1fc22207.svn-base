//
//  QQManager.h
//  Mocha
//
//  Created by 小猪猪 on 15/6/21.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQManager : NSObject<TencentSessionDelegate>

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headerImageURL;

@property (nonatomic, retain) TencentOAuth *oauth;

@property (strong, nonatomic) ThirdLoginComplete completeBlock;


- (void)authQQRequestSuccess:(ThirdLoginComplete)success;

+ (QQManager *)shareQQManager;



@end
