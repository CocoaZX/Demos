//
//  SinaManager.m
//  Mocha
//
//  Created by 小猪猪 on 15/6/21.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "SinaManager.h"
#import "WeiboUser.h"
#import <AdSupport/AdSupport.h>
@implementation SinaManager

static SinaManager *sinaM;
+ (SinaManager *)shareSinaManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sinaM = [[SinaManager alloc] init];
    });
    return sinaM;
}

- (void)authSinaRequestSuccess:(ThirdLoginComplete)success
{
    
    self.completeBlock = success;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaRedirectURI;
    request.scope = @"all";
    request.userInfo = @{
                         @"SSO_From":@"ViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.weiboToken = [NSString stringWithFormat:@"%@",[(WBAuthorizeResponse *)response accessToken]];
        self.weiboUserid = [NSString stringWithFormat:@"%@",[(WBAuthorizeResponse *)response userID]];
        [WBHttpRequest requestForUserProfile:self.weiboUserid withAccessToken:self.weiboToken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            
            NSLog(@"%@",result);
            WeiboUser *user = (WeiboUser *)result;
            NSString *nickname = [NSString stringWithFormat:@"%@",user.name];
            NSString *headerImage = [NSString stringWithFormat:@"%@",user.avatarLargeUrl];
            [ThirdLoginManager shareThirdLoginManager].isThirdLogin = YES;
            [ThirdLoginManager shareThirdLoginManager].thirdUserName = nickname;
            [ThirdLoginManager shareThirdLoginManager].thirdHeaderImageURL = headerImage;
            
            NSString *accessToken = [NSString stringWithFormat:@"%@",self.weiboToken];
            NSString *openId = [NSString stringWithFormat:@"%@",self.weiboUserid];
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            
            int expires = 3*30*24*60*60;
            
            NSDictionary *diction = @{@"nickname":nickname,
                                      @"headimgurl":headerImage,
                                      @"access_token":accessToken,
                                      @"openid":openId,
                                      @"plat_type":@(3),
                                      @"idfa":idfa,
                                      @"expires_in":@(expires)};
            
            if (error) {
                self.completeBlock(NO,nil);
                
            }else
            {
                [ThirdLoginManager shareThirdLoginManager].paraDiction = diction.copy;
                [ThirdLoginManager shareThirdLoginManager].lastThirdType = 2;
                self.completeBlock(YES,diction);
            }
            
        }];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        
    }
}
 


@end
