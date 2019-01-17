//
//  MCMacroDefinitionString.h
//  Mocha
//
//  Created by 小猪猪 on 16/6/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#ifndef MCMacroDefinitionString_h
#define MCMacroDefinitionString_h



///*域名快速切换开关 1正式域名， 0测试域名*/
//#define DOMAIN_SWITCH 1
//#if DOMAIN_SWITCH
///*正式域名*/
////#define DEFAULTURL                    @"http://api.mokacool.com"  //老的正式
////#define DEFAULTURL                    @"http://api.moka.vc" //正式
////#define DEFAULTURL                    @"http://zgq.api.mokacool.com"  //测试
////#define DEFAULTURL                    @"http://api2.moka.vc" //正式
////#define DEFAULTURL                    @"http://yzh.api.mokacool.com"  //测试
//
//#define ACCOUNT_DEFAULTURL            @"https://passport.360.cn/api.php?"
//#define SHOP_COUPON_URL               @"http://restapi.map.so.com/"
//#else
///*测试域名*/
////#define DEFAULTURL                    @"http://test.mokacool.com"
//#define ACCOUNT_DEFAULTURL            @"https://passport.360.cn/api.php?"
//#endif

//基URL
#define ORIGINALURL @"http://api3.moka.vc"
//测试环境基URL
#define ORIGINALURLTEST @"yzh.api.mokacool.com"


/* sign */
#define MOCHA_SECRET_KEY            @"MokaIHE#W!@#Hdfasjf132"


#define IsBangDingPhone @"BangDingPhoneSuccess"
#define IS_FIRST_STARTUP_App @"isFirstStartUpApp"  //是否首次启动App

#define MOKA_USER_VALUE @"moka_user_value" //用户信息的key
#define MOKA_USER_OVERDUE @"cookie_overdue"
#define MOKA_SHARE_VALUE @"moka_share_value" //用户信息的key
#define MOKA_SHARE_TIME  @"moka_share_time"
#define MOKA_USER_LOGO @"user_identity"

#define TABBARCLOSE_KEY  @"TabBarClose"
#define VERSION_FOR_SETTING_CHECK @"version_for_setting_check"  //检查版本
#define USER_LOCATION @"moka_user_location"  //地理位置
#define VGOODSIMG_BIG @"bigVgoodsImg"   //虚拟礼物列表


#define ConfigRechargeSetting          @"rechargeSetting"
#define ConfigExchangeSetting          @"exchangeSetting"
#define ConfigPrice          @"payparamter"
#define ConfigThird          @"isAppearThirdLogin"
#define ConfigShang          @"rewardEnable"
#define ConfigYuePai          @"covenantEnable"
#define ConfigNearFeed       @"near_feed"
#define ConfigNearHome       @"near_home"
#define ConfigAllowThirdLogin @"isAllowThirdLogin"
#define ConfigAllowBuyMember @"isAllowBuyMember"
#define ConfigAuction        @"isShowAuction"


/* coreData 文件名字、扩展名  数据库名 */
#define _CORE_DATA_DB @"Mocha"
#define _CORE_DATA_EXTENSION @"momd"
#define _CORE_DATA_PATH @"Mocha.sqlite3"


/*================= 色值数 =================*/
#define kLikeRedColor_new        @"#DA006C"
#define kLikeRedColor        @"#f45460"
#define kLikeLightRedColor   @"#f9a9af"
#define kLikeGrayColor       @"#989898"
#define kLikeWhiteColor      @"#f3f3f3"
#define kLikeLightGrayColor  @"#d2d2d2"
#define kLikeBlackColor      @"#333333"
#define kLikeGrayReleaseColor @"#efeff4"
#define kLikeLineColor       @"#dedede"
#define kLikeGreenLightColor @"#97cdca"
#define kLikeGreenDarkColor  @"#309b95"
#define kLikeGrayTextColor     @"#a4a4a4"
#define kLikeBlackTextColor    @"#434343"
#define kLikeBgRedColor        @"fcd9dc"
#define kLikeOrangeColor     @"FF8373"
#define kLikePinkColor        @"#fae5e5"
#define kLikeMemberNameColor   @"#f45460"



//是否打开 活动列表测试模式
#define HuoDongListRelease

//是否打开 活动发布测试模式
#define HuoDongFaBuRelease

//是否打开 环信测试模式
#define HXRelease

//#define HXShowAlert

//是否打开 aviary测试模式
#define AviaryRelease

//是否打开 Tusdk测试模式
//#define TusdkRelease

//是否打开 bugtags测试模式
#define BugtagsRelease


//是否打开 腾讯视频上传测试模式
#define TencentRelease

//是否打开 发布竞拍功能
//#define PublicJingPaiRelease

//是否打开 VIP版本
//#define MokaVipRelease

#ifdef MokaVipRelease

//VIP版本第三方key
#define umengAppkey @"56ac3462e0f55a7ab1001045"
#define QQAppid @"1105068443"
//绑定支付的APPID
#define WXAPI @"wx138dec6e136a87c3"
//#define WXApp_SECRET @"ba7c8bcb25e3f39436dab794b1494ab5"
#define WXApp_SECRET @"bca8c72e6794399ad14b54d67680624d"

#define TUSDKKEY  @"a7388fcad13c5d76-00-wl7so1"
#define kSinaAppKey  @"1472465934"
// 2. Your AppID (found in iTunes Connect)
#define kHarpyAppID  @"1078198879"

//商户号，填写商户对应参数
#define MCH_ID   @"1312999801"

//商户API密钥，填写相应参数
//#define PARTNER_ID  @"64CC22895ECA02D681557A4A166EAFC7"
#define PARTNER_ID    @"9411af079b3c04e1d41fcfc9763690be"

#else

//正式版本第三方key
#define umengAppkey @"55a5f74167e58ebbf6002946"
#define QQAppid @"1104201023"
//#define WXAPI @"wx09c361de9c7a3822"
//#define WXApp_SECRET @"bca8c72e6794399ad14b54d67680624d"
//新的微信
#define WXAPI @"wx326971e492525d08"
#define WXApp_SECRET @"78fab7d253c80dfe3d82b8e964282f21"

#define TUSDKKEY @"54c563500f0f4465-01-inr3o1"
#define kSinaAppKey  @"2581531947"
// 2. Your AppID (found in iTunes Connect)
#define kHarpyAppID  @"954184093"
//商户号，填写商户对应参数
//#define MCH_ID          @"1248518701"
#define MCH_ID       @"1331096501"

//商户API密钥，填写相应参数
//#define PARTNER_ID  @"9411af079b3c04e1d41fcfc9763690be"
//#define PARTNER_ID  @"64CC22895ECA02D681557A4A166EAFC7"
#define PARTNER_ID   @"bca8c72e6794399ad14b54d67680624d"



#endif



// 个推
#if PUSH_TEST_SWITCH
/*正式推送*/
#ifdef MokaVipRelease
//VIP版本i
#define kAppId           @"LQdmXm8cH89nrIhTZHbMW9"
#define kAppKey          @"i5KquxJI1lAXEvzCB5wYy4"
#define kAppSecret       @"CjcunZwPhJ7UL7UhBq73i8"
#else
//正式版本
#define kAppId           @"ns0T4zZJJr9A1x6Zr4zqO5"
#define kAppKey          @"0LzZDICl6w8GsjYLD6LxB9"
#define kAppSecret       @"MLgdEGo8597pyoMvG0efB4"
#endif

#else
/*测试推送*/
#define kAppId           @"1oCvsOQS497UDsGISfLt26"
#define kAppKey          @"YjyEffEBjw9gWTb7xDydg5"
#define kAppSecret       @"ZUfUbaGzYB8UzDHb1uyc79"
#endif


//环信
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"




/**
 *  接口path
 */
/*用户信息*/
#define PathLabelList     @"/tags/getlist?"
#define PathMobileCode    @"/tools/mobilecode?"
#define PathRegister      @"/account/register?"
#define PathLogin         @"/account/login?"
#define PathLogout        @"/account/logout?"

#define PathGetBangDingPhone   @"/user/bindmobile?"
#define PathGetThirdLogin   @"/third_platform/login?"

#define PathResetPwd      @"/account/resetpwd?"
#define PathGetUserInfo   @"/user/profile?"
#define PathSearch        @"/search/result?"
#define PathEditInfo      @"/user/edit?"
#define PathChangePwd     @"/user/changepwd?"
#define PathUserCenter    @"/user/moka?"  //用户中心
#define PathGetPhotoList   @"/user/feed?" //动态
//用户所有动态里的图片
#define PathGetDynamicPhotoList   @"/album/getPhotosList?"

#define PathGetCreateAlbum   @"/album/create?" //创建相册
#define PathGetMokaList   @"/album/lists?" //用户moka列表
#define PathGetMokaSetDefault   @"/album/setDefault?" //设置默认
#define PathGetMokaDetail   @"/album/detail?" //获取相册详情
#define PathGetDeleteAlbum   @"/album/delete?" //删除相册
#define PathGetMokadeletePhoto   @"/album/deletePhoto?" //删除相片
#define PathGetEditAlbum     @"/album/edit?" //编辑相册
#define PathGetEditPhoto     @"/photo/update?" //编辑照片
#define PathGetDeleteAuction @"/auction/delete?" //删除竞拍


/***************  2015 10 07 ***************/

#define PathUserReward    @"/reward/create?"  //打赏
//通用支付：用于h5界面调起的支付
#define PathCustomPay    @"/ucenter/h5Pay?"


#define PathUserWalletCards    @"/wallet/cards?"  //优惠券
#define PathUserWalletAccountLogs    @"/wallet/accountLogs?"  //账户明细
#define PathUserWalletSummary    @"/wallet/summary?"  //我的钱包
#define PathUserWalletVirtualGoods  @"/wallet/virtualGoods?"  //用户礼物列表
#define PathUserWalletVgoods  @"/wallet/vgoods?"//系统礼物列表

/***************  2015 11 18 ***************/

#define PathUserYuePai    @"/covenant/create?"  //约拍
#define PathUserYuePaiList    @"/covenant/lists?"  //约拍列表
#define PathUserYuePaiPay    @"/covenant/bail?"  //约拍支付
#define PathUserYuePaiDetail    @"/covenant/detail?"  //约拍详情
#define PathUserYuePaiJieShou    @"/covenant/accept?"  //接受约拍
#define PathUserYuePaiCanJia    @"/covenant/join?"  //参加约拍
#define PathUserYuePaiJieShu    @"/covenant/over?"  //结束约拍
#define PathUserYuePaiPingLun    @"/covenant/evaluate?"  //约拍评论
#define PathUserYuePaiPingLunList    @"/covenant/getEvaluates?"  //约拍评论列表
#define PathUserYuePaiDelete      @"/covenant/delete?"//约拍删除

/***************  2015 12 10 ***************/
//首页附近的人
#define PathHomeNearPersons @"/home/near?"
//首页火爆
#define PathHomeFiery @"/home/hot?"

//提现
#define PathCashing @"/wallet/rebate?"
#define PathRecharge @"/wallet/recharge?"

//名片
#define PathPersonCard @"/user/card?"
#define PathEditPersonCard @"/user/editCard?"

//身价
#define PathUcenter_Rank @"/ucenter/rank?"

#define PathUcenter_Setting @"/ucenter/setting?"

/***************  2016 02 28 ***************/
//会员购买
#define PathMemberBuy @"/ucenter/buy?"

/***************  2016 03 15 ***************/
#define PathGetExchangeCoin   @"/wallet/exchangeCoin?" //金币兑换
#define PathGetCoinToMoney   @"/wallet/coinToMoney?" //金币兑换成钱
#define PathGetonceSign   @"/video/onceSign?" //视频上传签名一次性
#define PathGetSign   @"/video/sign?" //视频上传签名多次性
#define PathGetVideoDelete   @"/video/delete?" //删除视频

#define PathGetNewLogin   @"/account/newlogin?" //新登陆

/***************  2016 04 18 ***************/
#define PathPostAuctionCreate   @"/auction/create?" //发布竞拍
#define PathPostAuctionTagList   @"/auction/tagsList?" //获取发布竞拍标签列表
#define PathPostAuctionAddTag   @"/auction/createTags?" //添加标签
#define PathPostAuctionJoin   @"/auction/join?"//参与竞拍
#define PathForAuctionInfo @"/auction/info?" //竞拍详情

//竞拍列表
#define PathPostForAuctionList @"/auction/auctionList?"
//发送验证竞拍码
#define PathPostForSendAuctionNumber @"/auction/verify?"




//上传  idfv
#define PathUploadIdfv @"/omygreen/idfa?"

#define PathGetUserAttrlist @"/user/attrlist?"

#define PathAddBlack  @"/black_lists/add?"
#define PathRemoveBlack  @"/black_lists/remove?"

/*图片相关*/
#define PathMainUserIndex  @"/home/index?" //首页
#define PathTongBuCid  @"/push/updatecid?" //同步cid
#define PathRecommendIndex @"/home/recommend?"
#define PathSystemMessage @"/system/message?"//系统消息
#define PathUpdatepath @"/version/info?"//版本更新

//首页火爆推荐列表
#define PathFieryFeeds  @"/home/popularity?"


#define PathUploadPhoto    @"/photo/upload?"
#define PathUploadVideo    @"/video/add?" //上传视频
#define PathFeedList       @"/feeds/getlist" //好友动态
#define PathGetPhotoInfo   @"/photo/info?"
#define PathGetVideoDetail @"/media/info?" //视频详情，是photoInfo的别名

//热门动态－我的动态-附近动态
#define PathMyFeeds    @"/feeds/myfeeds?" //某个用户可以看到的动态
#define PathHotFeeds   @"/feeds/hots?" //热门动态列表
#define PathNearFeeds  @"/feeds/near?" //附近动态

//

/*私信接口*/
#define PathSaveinfo            @"/account/saveinfo?"

#define PathMsgSend            @"/messages/add?"
#define PathMsgGroup           @"/messages/groups?"
#define PathMsgConversation    @"/messages/conversations?"
#define PathMsgRead            @"/messages/read?"
#define PathMsgDeleteGroup     @"/messages/delgroup?"
#define PathMsgDelete          @"/messages/delmessage?"

/*关注*/
#define PathFriendAddFollow    @"/friends/follow?"
#define PathFriendUnFollow     @"/friends/unfollow?"
#define PathFriendRemoveFuns   @"/friends/removefans?"// 暂未用
#define PathFriendFollowers    @"/friends/followers?"//
#define PathFriendFuns         @"/friends/fans?"
#define PathFriendFollow       @"/messages/delmessage?"//暂无

/*点赞*/
#define PathLikeAdd      @"/likes/add?"
#define PathLikeCancel   @"/likes/cancel?"
#define PathLikeList     @"/likes/getlist?"

/*收藏*/
#define PathFavoriteAdd      @"/favorite/add?"
#define PathFavoriteDelete   @"/favorite/cancel?"
#define PathFavoriteList     @"/favorite/getlist?"

/*删除*/
#define PathDeletePicture     @"/photo/delete?"
#define PathDeleteVideo       @"/video/delete?"

/*评论*/
#define PathCommentAdd      @"/comments/add?"
#define PathCommentDelete   @"/comments/delete?"
#define PathCommentList     @"/comments/getlist?"
#define PathCommentMyList   @"/comments/mylist?"
#define PathShangMyList     @"/wallet/rewards?"   //原有的我收到的打赏
#define pathVGoodsMyList    @"/wallet/virtualGoods?"   //现在的我收到的礼物列表






/*关注*/
#define PathFollowAdd         @"/friends/follow?"
#define PathFollowCancel      @"/friends/unfollow?"
#define PathFollowList        @"/friends/followlist?"

//粉丝
#define PathFriendFunList     @"/friends/fanslist?"

/*反馈*/

#define PathSystemFeedBack   @"/system/feedback?"

/*举报*/
#define PathSystemReport     @"/system/report?"

//认证接口
#define PathPersonRenZheng     @"/user/auth?"


/*分享内容*/
#define PathSystemShare    @"/system/sharetemplate?"


/*接口活动*/
#define PathEventPublish    @"/event/publish?"
#define PathEventDelete     @"/event/del?"
#define PathEventSignUp     @"/event/signup?"
#define PathEventCancel     @"/event/cancel?"
#define PathEventInfo       @"/event/info?"
#define PathEventGetList    @"/event/getlist?"
#define PathEventMySignUp   @"/event/mysignup?"
#define PathEventMyRelease   @"/event/myeventlist?"
#define PathEventSearch    @"/event/search?"

#define PathEventLike       @"/event/like?"
#define PathEventCancelLike @"/event/cancellike?"

#define PathEventSignList   @"/event/signuplist?"  //活动对应的报名列表
#define PathEventSignPass   @"/event/signuppass?"
#define PathEventApperal  @"/event/approval?"

#define PathEventCommentList @"/event/commentlist?"
#define PathEventComment  @"/event/comment?"

#define PathEventSearch @"/event/search?"


//对于聊天的设置
//根据群聊id获取活动成员
#define PathUcenter_groupchat @"/ucenter/groupchat?"
//退出群聊
#define PathUcenter_quitchar @"/ucenter/quitchar?"
//设置群消息免打扰
#define PathUcenter_noturb @"/ucenter/noturb?"
//聊天踢人

#define PathUcenter_t @"/ucenter/t?"



/**
 * key
 */
#define NetworkKeyMobile @"mobile"
#define NetworkKeyCode @"code"

#define NetworkKeyToken   @"token"

#define NetworkKeyLoginType @"logintype"
#define NetworkKeyPass @"password"

#define NetworkKeyUserID  @"uid"
#define NetworkKeyPhotoId @"photoid"

#define NetworkKeyToUserId @"friendid"



//分享相册
//share/PrivatyAlbum?id=
#define PathSharePrivacyAlbum @"share/Album?id="
#define PathShareOpenAlbum @"share/Album?id="
//分享相册到qq
#define PathShareAlbumQQ @"share/AlbumQQ?id="




#endif /* MCMacroDefinitionString_h */
