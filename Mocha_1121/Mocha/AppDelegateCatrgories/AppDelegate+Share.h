//
//  AppDelegate+Share.h
//  Mocha
//
//  Created by yfw－iMac on 15/12/4.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Share)

- (void)share:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

-(void)changeScene:(NSInteger)scene;

-(void)weixinSendImageContentWithImage:(UIImage *)image URL:(NSString *)urlString uid:(NSString *)uidString;

- (void)sendImageContentWithImage:(UIImage *)image title:(NSString *)titleString;

- (void)sendLinkContentTitle:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage URL:(NSString *)urlString uid:(NSString *)uidString isTaoXi:(BOOL)isTaoXi;
//新增:分享到朋友圈
//新增方法：
//在使用的地方直接拼接后半部分的url字符串
//type：预留字段，便于区别不同的操作
- (void)sendWeiXInLinkContentTitle:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage URL:(NSString *)urlString uid:(NSString *)uidString withuseType:(NSString *)type;

- (void)sendImageContentWithImage:(UIImage *)image title:(NSString *)title shareURL:(NSString *)urlString;

- (void)sendLinkContentTitle:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage shareURL:(NSString *)urlString;

- (void)sendLinkContentTitle_video:(NSString *)title desc:(NSString *)descString header:(UIImage *)headerImage URL:(NSString *)urlString uid:(NSString *)uidString;

//竞拍分享
- (void)sendLinkContentToWXFriendsAuctionId:(NSString *)auctionID header:(UIImage *)headerImage shareTitle:(NSString *)title shareDes:(NSString *)description;
- (void)sendAuctionLinkToQQdecription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData auctionID:(NSString *)auctionID isQZone:(BOOL)isQZone;

//qq
- (void)sendMessageToQQIsQzone:(BOOL)isQZone decription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData targetUrl:(NSString *)targetUrl objectId:(NSString *)objectId isTaoXi:(BOOL)isTaoXi;

#pragma mark - 分享到QQ
//新增方法：
//在使用的地方直接拼接后半部分的url字符串
//type：预留字段，便于区别不同的操作
- (void)sendMessageToQQIsQzone:(BOOL)isQZone decription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData targetUrl:(NSString *)targetUrl objectId:(NSString *)objectId withuseType:(NSString *)type;

- (void)sendMessageToQQWithImageData:(NSString *)imageUrl previewImage:(UIImage *)image title:(NSString *)title description:(NSString *)description;

- (void)sendMessageToQQWithImageDataReallyData:(NSData *)imageData previewImage:(UIImage *)image title:(NSString *)title description:(NSString *)description;

- (void)sendMessageToQQIsQzone_video:(BOOL)isQZone decription:(NSString *)decription title:(NSString *)title imageData:(NSData *)imageData targetUrl:(NSString *)targetUrl objectId:(NSString *)objectId;

//新浪
- (void)sendMessageToSinaWithPic:(UIImage *)image;

@end
