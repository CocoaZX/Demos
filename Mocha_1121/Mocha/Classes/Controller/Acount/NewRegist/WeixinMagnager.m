//
//  WeixinMagnager.m
//  Mocha
//
//  Created by 小猪猪 on 15/6/21.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "WeixinMagnager.h"
#import <AdSupport/AdSupport.h>

@implementation WeixinMagnager

static WeixinMagnager *weixinM;
+ (WeixinMagnager *)shareWeixinManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weixinM = [[WeixinMagnager alloc] init];
    });
    return weixinM;
}



- (void)sendAuthRequestWithController:(UIViewController *)controller success:(ThirdLoginComplete)success
{
    self.completeBlock = success;
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = @"moka";
    
    [WXApi sendAuthReq:req viewController:controller delegate:self];
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        if (resp.errCode==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SharedSuccess" object:nil];

        }

    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        self.weixinCode = [NSString stringWithFormat:@"%@",temp.code];
        [self getAccess_token];
    }
    else if ([resp isKindOfClass:[PayResp class]])
    {
        if (resp.errCode==0) {
            //支付成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WxPaySuccess" object:nil];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payFailed" object:nil];
        }
        
    }
}



-(void)getAccess_token
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPI,WXApp_SECRET,self.weixinCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                /*
                 
                 {
                 access_token = OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A;
                 expires_in = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 refresh_token = OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA;
                 scope = snsapi_userinfo,snsapi_base;
                 }
                 
                 */
                
                self.weixinExpires_in = [NSString stringWithFormat:@"%@",dic[@"expires_in"]];
                self.weixinAccess_token = [NSString stringWithFormat:@"%@",dic[@"access_token"]];
                self.weixinOpenid = [NSString stringWithFormat:@"%@",dic[@"openid"]];
                
                [self getUserInfo];
            }
        });
    });
}

-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.weixinAccess_token,self.weixinOpenid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0;
                 language = zh_CN;
                 nickname = xxx;
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                NSString *openId = [NSString stringWithFormat:@"%@",dic[@"openid"]];
                NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

                self.weixinNickname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
                
                self.weixinHeaderImageURL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"headimgurl"]];
                
                [ThirdLoginManager shareThirdLoginManager].isThirdLogin = YES;
                [ThirdLoginManager shareThirdLoginManager].thirdUserName = self.weixinNickname;
                [ThirdLoginManager shareThirdLoginManager].thirdHeaderImageURL = self.weixinHeaderImageURL;

                NSDictionary *diction = @{@"nickname":self.weixinNickname,
                                          @"headimgurl":self.weixinHeaderImageURL,
                                          @"access_token":self.weixinAccess_token,
                                          @"openid":openId,
                                          @"plat_type":@(1),
                                          @"idfa":idfa,
                                          @"expires_in":self.weixinExpires_in};
                [ThirdLoginManager shareThirdLoginManager].paraDiction = diction.copy;
                [ThirdLoginManager shareThirdLoginManager].lastThirdType = 1;

                self.completeBlock(YES,diction);
            }
        });
        
    });
    
}


@end
