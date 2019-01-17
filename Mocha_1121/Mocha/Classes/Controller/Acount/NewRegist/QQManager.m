//
//  QQManager.m
//  Mocha
//
//  Created by 小猪猪 on 15/6/21.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "QQManager.h"
#import <AdSupport/AdSupport.h>

@implementation QQManager


static QQManager *qqM;
+ (QQManager *)shareQQManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qqM = [[QQManager alloc] init];
    });
    return qqM;
}

- (id)init
{
    
    self.oauth = [[TencentOAuth alloc] initWithAppId:QQAppid andDelegate:self];

    return self;
}



- (void)authQQRequestSuccess:(ThirdLoginComplete)success
{
    self.completeBlock = success;
    
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    
    [self.oauth authorize:permissions inSafari:NO];
    
}

- (void)tencentDidLogin
{
    NSLog(@"login success");
    [self.oauth getUserInfo];

}

-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);
    self.nickName = [NSString stringWithFormat:@"%@",response.jsonResponse[@"nickname"]];
    self.headerImageURL = [NSString stringWithFormat:@"%@",response.jsonResponse[@"figureurl_2"]];
    [ThirdLoginManager shareThirdLoginManager].isThirdLogin = YES;
    [ThirdLoginManager shareThirdLoginManager].thirdUserName = self.nickName;
    [ThirdLoginManager shareThirdLoginManager].thirdHeaderImageURL = self.headerImageURL;

    NSString *accessToken = [NSString stringWithFormat:@"%@",self.oauth.accessToken];
    NSString *openId = [NSString stringWithFormat:@"%@",self.oauth.openId];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    int expires = 3*30*24*60*60;
    
    NSDictionary *diction = @{@"nickname":self.nickName,
                              @"headimgurl":self.headerImageURL,
                              @"access_token":accessToken,
                              @"openid":openId,
                              @"plat_type":@(2),
                              @"idfa":idfa,
                              @"expires_in":@(expires)};

    
    if (response.errorMsg) {
        self.completeBlock(NO,nil);
        
    }else
    {
        [ThirdLoginManager shareThirdLoginManager].paraDiction = diction.copy;
        [ThirdLoginManager shareThirdLoginManager].lastThirdType = 2;
        self.completeBlock(YES,diction);
    }
    
}

@end
