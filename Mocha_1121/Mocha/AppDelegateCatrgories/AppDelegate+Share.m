//
//  AppDelegate+Share.m
//  Mocha
//
//  Created by yfw－iMac on 15/12/4.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "AppDelegate+Share.h"
#import "PublicMethod.h"

@implementation AppDelegate (Share)

- (void)share:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    TencentOAuth *_tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppid andDelegate:self];

}

#pragma mark winxin

-(void) changeScene:(NSInteger)scene
{
    _scene = scene;
}


- (void)sendImageContentWithImage:(UIImage *)image title:(NSString *)title shareURL:(NSString *)urlString
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = title;
    
    UIImage *sizeImage = [PublicMethod scaleToSize:image size:CGSizeMake(250, 250)];
    
    NSData *pngData = UIImageJPEGRepresentation(sizeImage, 0.5);
    
    UIImage *sendImg = [UIImage imageWithData:pngData];
    
    [message setThumbImage:sendImg];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.baidu.com";
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}

- (void)sendImageContentWithImage:(UIImage *)image title:(NSString *)titleString
{
    [SingleData shareSingleData].isFromeShare = YES;
    
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *sizeImage = [PublicMethod scaleToSize:image size:CGSizeMake(250, 250)];
    
    NSData *pngData = UIImageJPEGRepresentation(sizeImage, 0.5);
    
    UIImage *sendImg = [UIImage imageWithData:pngData];
    
    [message setThumbImage:sendImg];
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
    message.messageExt = NSLocalizedString(@"Mocard", nil);
    message.messageAction = @"<action>test</action>";
    
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)sendLinkContentTitle:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage shareURL:(NSString *)urlString
{
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSString *shareURL = [NSString stringWithFormat:@"http://api2.moka.vc/a/%@",urlString];
    //获取服务器配置
    NSString *webUrl = [USER_DEFAULT objectForKey:@"webUrl"];
    if(webUrl.length >0){
       // http://yzh.web.mokacool.com";
        shareURL = [NSString stringWithFormat:@"%@/a/%@",webUrl,urlString];
    }
    
    UIImage *sizeImage = [PublicMethod scaleToSize:headerImage size:CGSizeMake(100, 100)];
    
    NSData *da = UIImageJPEGRepresentation(sizeImage, 0.005);
    UIImage *sendImg = [UIImage imageWithData:da];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = descString;
    [message setThumbImage:sendImg];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareURL;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}

- (void)sendLinkContentTitle:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage URL:(NSString *)urlString uid:(NSString *)uidString isTaoXi:(BOOL)isTaoXi
{
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSString *shareURL = [NSString stringWithFormat:@"http://moka.vc/%@",uidString];
    if (isTaoXi) {
        shareURL = [NSString stringWithFormat:@"%@/share/package/%@",[USER_DEFAULT objectForKey:@"webUrl"],uidString];
    }
    UIImage *sizeImage = [PublicMethod scaleToSize:headerImage size:CGSizeMake(100, 100)];
    
    NSData *da = UIImageJPEGRepresentation(sizeImage, 0.005);
    UIImage *sendImg = [UIImage imageWithData:da];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = descString;
    [message setThumbImage:sendImg];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareURL;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}


//竞拍详情分享
- (void)sendLinkContentToWXFriendsAuctionId:(NSString *)auctionID header:(UIImage *)firstImage
                                 shareTitle:(NSString *)title shareDes:(NSString *)description
{
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSString  *shareURL = [NSString stringWithFormat:@"%@/share/auction?id=%@",[USER_DEFAULT objectForKey:@"webUrl"],auctionID];
    
    UIImage *sizeImage = [PublicMethod scaleToSize:firstImage size:CGSizeMake(100, 100)];
    NSData *da = UIImageJPEGRepresentation(sizeImage, 0.005);
    UIImage *sendImg = [UIImage imageWithData:da];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:sendImg];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareURL;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}

//qq竞拍分享
- (void)sendAuctionLinkToQQdecription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData auctionID:(NSString *)auctionID isQZone:(BOOL)isQZone
{
    
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSData* data  = [NSData dataWithData:imageData];
    
    NSString *shareURL = [NSString stringWithFormat:@"%@/share/auction?id=%@",[USER_DEFAULT objectForKey:@"webUrl"],auctionID];
    
    NSString *des = decription;
    
    if (decription.length>512) {
        des = [[decription substringFromIndex:0] substringToIndex:512];
    }
    
    QQApiNewsObject *img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL] title:title description:des previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    if (!isQZone) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
        
    }else{
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
        
    }
    
}




#pragma mark - 分享到微信朋友圈
- (void)sendWeiXInLinkContentTitle:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage URL:(NSString *)urlString uid:(NSString *)uidString withuseType:(NSString *)type
{
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSString *shareURL = @"";
    if ([type isEqualToString:@"webPageShare"]){
        shareURL = urlString;
    }else{
        //前缀
        NSString *webUrl = @"http://moka.vc";
        NSString *configUrl = [USER_DEFAULT objectForKey:@"webUrl"];
        if(configUrl.length >0){
            webUrl = configUrl;
        }
        shareURL = [NSString stringWithFormat:@"%@/%@",webUrl,urlString];
    }
    //设置图片
    UIImage *sizeImage = [PublicMethod scaleToSize:headerImage size:CGSizeMake(100, 100)];
    NSData *da = UIImageJPEGRepresentation(sizeImage, 0.005);
    UIImage *sendImg = [UIImage imageWithData:da];
    
    WXMediaMessage *message = [WXMediaMessage message];
    //设置title
    message.title = title;
    //设置描述
    message.description = descString;
    [message setThumbImage:sendImg];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareURL;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}

- (void)sendLinkContentTitle_video:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage URL:(NSString *)urlString uid:(NSString *)uidString
{
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSString *shareURL = urlString;
    
    UIImage *sizeImage = [PublicMethod scaleToSize:headerImage size:CGSizeMake(100, 100)];
    
    NSData *da = UIImageJPEGRepresentation(sizeImage, 0.005);
    UIImage *sendImg = [UIImage imageWithData:da];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = descString;
    [message setThumbImage:sendImg];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareURL;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
}

-(void)weixinSendImageContentWithImage:(UIImage *)image URL:(NSString *)urlString uid:(NSString *)uidString{
    [SingleData shareSingleData].isFromeShare = YES;
    UIImage *sizeImage = [PublicMethod scaleToSize:image size:CGSizeMake(100, 100)];
    NSData *da = UIImageJPEGRepresentation(sizeImage, 0.005);
    UIImage *sendImg = [UIImage imageWithData:da];
    
    //    NSString *shareURL = [NSString stringWithFormat:@"http://api2.moka.vc/u/%@",uidString];
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:sendImg];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(sendImg);
    
    message.mediaObject = ext;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

//qq\qzone

- (void)sendMessageToQQWithImageData:(NSString *)imageUrl previewImage:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    QQApiImageObject* img = [QQApiImageObject objectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]  previewImageData:UIImageJPEGRepresentation(image,0)  title:title description:@""];
    //    QQApiWebImageObject *webImg = [QQApiWebImageObject objectWithPreviewImageURL:[NSURL URLWithString:imageUrl] title:title description:description];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
}

- (void)sendMessageToQQWithImageDataReallyData:(NSData *)imageData previewImage:(UIImage *)image title:(NSString *)title description:(NSString *)description
{
    QQApiImageObject* img = [QQApiImageObject objectWithData:imageData  previewImageData:UIImageJPEGRepresentation(image,0.5)  title:title description:@""];
    //    QQApiWebImageObject *webImg = [QQApiWebImageObject objectWithPreviewImageURL:[NSURL URLWithString:imageUrl] title:title description:description];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
}


- (void)sendMessageToQQIsQzone:(BOOL)isQZone decription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData targetUrl:(NSString *)targetUrl objectId:(NSString *)objectId isTaoXi:(BOOL)isTaoXi
{
    
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSData* data  = [NSData dataWithData:imageData];
    //前缀
    NSString *webUrl = @"http://moka.vc";
     NSString *configUrl = [USER_DEFAULT objectForKey:@"webUrl"];
     if(configUrl.length >0){
         webUrl = configUrl;
      }
    NSString *shareURL = [NSString stringWithFormat:@"%@/%@/%@",webUrl,targetUrl,objectId];
  
    
    if ([targetUrl isEqualToString:@"u"]) {
        shareURL = [NSString stringWithFormat:@"%@/%@",webUrl,objectId];
//        NSLog(@"%@",shareURL);
    }
    
    if (isTaoXi) {
        shareURL = [NSString stringWithFormat:@"%@/share/package/%@",webUrl, objectId];
    }
    
    NSString *des = decription;
    
    if (decription.length>512) {
        des = [[decription substringFromIndex:0] substringToIndex:512];
    }
    
    QQApiNewsObject *img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL] title:title description:des previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    if (!isQZone) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
        
    }else{
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
        
    }
    
}
#pragma mark - 分享到QQ
- (void)sendMessageToQQIsQzone:(BOOL)isQZone decription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData targetUrl:(NSString *)targetUrl objectId:(NSString *)objectId withuseType:(NSString *)type
{
    
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSData* data  = [NSData dataWithData:imageData];
    
    
    NSString *shareURL = @"";
    if ([type isEqualToString:@"webPageShare"]){
        shareURL = targetUrl;
    }else{
        //前缀
        NSString *webUrl = @"http://moka.vc";
        NSString *configUrl = [USER_DEFAULT objectForKey:@"webUrl"];
        if(configUrl.length >0){
            webUrl = configUrl;
        }
        //url
        shareURL = [NSString stringWithFormat:@"%@/%@",webUrl,targetUrl];
    }

    
    //描述
    NSString *des = decription;
    if (decription.length>512) {
        des = [[decription substringFromIndex:0] substringToIndex:512];
    }
    
    QQApiNewsObject *img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL] title:title description:des previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    if (!isQZone) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
        
    }else{
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
        
    }
}





- (void)sendMessageToQQIsQzone_video:(BOOL)isQZone decription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData targetUrl:(NSString *)targetUrl objectId:(NSString *)objectId
{
    
    [SingleData shareSingleData].isFromeShare = YES;
    
    NSData* data  = [NSData dataWithData:imageData];
    
    NSString *shareURL = targetUrl;
    
    NSString *des = decription;
    
    if (decription.length>512) {
        des = [[decription substringFromIndex:0] substringToIndex:512];
    }
    
//    title = @"亲，终于找到我了，我是雯雯";
//    des = @"这是我的模特卡喔！这里有我的活动照片和完整个人介绍，要是喜欢呢，就给宝宝点赞噢！耶~";
//    shareURL = @"http://moka.vc/957";

    QQApiNewsObject *img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL] title:title description:des previewImageData:data];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    if (!isQZone) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
        
    }else{
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
        
    }
    
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:sendResp.result message:sendResp.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}
#pragma mark - Sina

-(void)sendMessageToSinaWithPic:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = imageData;
    message.imageObject = imageObject;
    WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    
    
    [WeiboSDK sendRequest:request];
}


@end
