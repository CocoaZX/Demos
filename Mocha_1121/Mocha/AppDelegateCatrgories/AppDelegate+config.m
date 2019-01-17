//
//  AppDelegate+config.m
//  Mocha
//
//  Created by yfw－iMac on 15/12/4.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "AppDelegate+config.h"
#import "AFNetworkReachabilityManager.h"
#import "UploadVideoManager.h"

@implementation AppDelegate (config)

static NSString * const kRecipesStoreName = @"moka.sqlite";

- (void)configApp:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *isFirst = [USER_DEFAULT objectForKey:@"isFirst"];
    if (!isFirst) {
        [USER_DEFAULT setObject:@"http://api3.moka.vc"  forKey:@"api_url"];
        [USER_DEFAULT setObject:@"1" forKey:@"isFirst"];
    }
    //上传idfv
    [[SingleData shareSingleData] submitIDFV];
    
//    [[SingleData shareSingleData] getOnlineTagsData];
    
    
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kRecipesStoreName];
    
    //配置接口等信息
    [self mokaConfig];

    [self getLocation];

    [self setStateParams];

    [self configHXCellHeight];//配置环信约拍的高度

    [self performSelector:@selector(testSendMessage) withObject:nil afterDelay:2.0];
    
    [UploadVideoManager sharedInstance];
}

- (void)configHXCellHeight
{
 
    if (kScreenWidth==320) {
        [[NSUserDefaults standardUserDefaults] setObject:@"200" forKey:@"YUEPAIVIEWWIDTH"];
        [[NSUserDefaults standardUserDefaults] setObject:@"110" forKey:@"YUEPAIVIEWHEIGHT"];

    }else if(kScreenWidth==375)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"230" forKey:@"YUEPAIVIEWWIDTH"];
        [[NSUserDefaults standardUserDefaults] setObject:@"140" forKey:@"YUEPAIVIEWHEIGHT"];
        
        
    }else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"280" forKey:@"YUEPAIVIEWWIDTH"];
        [[NSUserDefaults standardUserDefaults] setObject:@"170" forKey:@"YUEPAIVIEWHEIGHT"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testSendMessage
{
//    [ChatManager sendPaySuccessMessage:@{}];
    
}
 
- (void)getShareContent
{
    NSDate *time = [USER_DEFAULT valueForKey:MOKA_SHARE_TIME];
    if (!time) {
        [USER_DEFAULT setObject:[NSDate date] forKey:MOKA_SHARE_TIME];
        [USER_DEFAULT synchronize];
    }
    else if([[NSDate date] timeIntervalSinceDate:time] < 3600 * 24 ){
        return;
    }//3600 * 24
    else {
        [USER_DEFAULT setObject:[NSDate date] forKey:MOKA_SHARE_TIME];
        [USER_DEFAULT synchronize];
    }
    
    NSDictionary *params = [AFParamFormat formatSystemShareContent];
    [AFNetwork systemShareContent:params success:^(id data){
//        NSLog(@"share:%@",data);
        if ([data[@"status"] integerValue] == kRight) {
            [USER_DEFAULT setObject:data forKey:MOKA_SHARE_VALUE];
            [USER_DEFAULT synchronize];
        }
    }failed:^(NSError *error){
        
    }];
}


- (void)mokaConfig
{

    NSDictionary *params = [AFParamFormat formatConfiguer];
    //通过ORIGINAL基URL，获取请求配置数据
    //获取到api_url字段确定在程序中将要使用的默认URL，即DEFAULTURL
    NSString *pathAll = [NSString stringWithFormat:@"%@/setting/ios?%@",ORIGINALURL,[AFNetwork getCompleteURLWithParams:params]];
 
        [AFNetwork postConfigWithPath:pathAll success:^(NSDictionary* data) {
//            NSLog(@"%@",data);
            if (data) {
                NSDictionary *diction=[NSDictionary dictionaryWithDictionary:data];
//                NSLog(@"获取到配置信息：%@",diction);
                NSDictionary *rule_fontlimitDic = [NSDictionary dictionary];
                NSDictionary *lang_descrptionDic = [NSDictionary dictionary];
                
                //存入沙盒中
                //获取此应用发起请求数据要使用的默认URL
                NSString *api_url = [diction objectForKey:@"api_url"];
                //api_url = @"http://192.168.1.41:800";
                if (api_url.length > 0) {
                    [USER_DEFAULT setObject:api_url forKey:@"api_url"];
                }
                
                //首页摄影师作品类别选择
                NSString *cameristType = [diction objectForKey:@"option_camerist_id"];
                if (cameristType.length > 0) {
                    [USER_DEFAULT setObject:cameristType forKey:@"option_camerist_id"];
                }
                
                NSArray *userAttrsList = [diction objectForKey:@"userAttrs"];
                if (userAttrsList.count > 0) {
                    [USER_DEFAULT setObject:userAttrsList forKey:@"userAttrs"];
                }
                
                //首页火爆vc的广告图
                NSDictionary *mainHotAdvDic = [diction objectForKey:@"hot_adv"];
                if (mainHotAdvDic) {
                    [USER_DEFAULT setObject:mainHotAdvDic forKey:@"hot_adv"];
                }
                
                //获取发布按钮中的hot状态
                NSString *hotIndex = [diction objectForKey:@"hot_menu"];
                if (hotIndex.length > 0) {
                    [USER_DEFAULT setObject:hotIndex forKey:@"hot_menu"];
                }
                
                //存入秀中竞拍的banner信息
                NSDictionary *auctionBannerInfo = [diction objectForKey:@"auction"];
                if (auctionBannerInfo) {
                    [USER_DEFAULT setObject:auctionBannerInfo forKey:@"auctionBannerInfo"];
                }
                
                //存入沙盒中环信的key
                NSString *easeAppName = diction[@"ease"][@"appname"];
                if(easeAppName.length>0){
                    [USER_DEFAULT setObject:easeAppName forKey:@"easeAppName"];
                }
                //获取官网地址
                NSString *webUrl = diction[@"web_url"];
                if(webUrl.length>0){
                    [USER_DEFAULT setObject:webUrl forKey:@"webUrl"];
                }
                
                //保存火爆页面详细榜单列表的配置信息
                NSDictionary *popularTop = [diction objectForKey:@"popularity_top"];
                if (popularTop) {
                    [USER_DEFAULT setObject:popularTop forKey:@"popularity_top"];
                }
                NSDictionary *popularBar = [diction objectForKey:@"popularity_bar"];
                if (popularBar) {
                    [USER_DEFAULT setObject:popularBar forKey:@"popularity_bar"];
                }
                
                
                //保存相关的网页跳转链接
                NSDictionary *webUrlsDic = [diction objectForKey:@"webUrls"];
                if (webUrlsDic ) {
                    [USER_DEFAULT setObject:webUrlsDic forKey:@"webUrlsDic"];
                }
                //保存一些默认图片的链接
                NSDictionary *defaultPicturesDic = [diction objectForKey:@"defaultPictures"];
                if (defaultPicturesDic ) {
                    [USER_DEFAULT setObject:defaultPicturesDic forKey:@"defaultPicturesDic"];
                }

                //保存应用进入时显示的广告图链接
                NSArray *guideArr = [diction objectForKey:@"guides"];
                if (guideArr.count) {
                    NSDictionary *guideDic = [diction objectForKey:@"guides"][0];
                    if (guideDic) {
                        [USER_DEFAULT setObject:guideDic forKey:@"guides"];
                    }
                }
                
                //获取文案字数限制
                if (diction[@"rule_fontlimit"]) {
                    rule_fontlimitDic = [diction objectForKey:@"rule_fontlimit"];
                    [USER_DEFAULT setObject:rule_fontlimitDic forKey:@"rule_fontlimit"];
                }
                //私密相册的金额限制
                NSDictionary *album_private_coinArr = [diction objectForKey:@"album_private_coin"];
                if(album_private_coinArr){
                    [USER_DEFAULT setObject:album_private_coinArr forKey:@"album_private_coin"];

                }
                
                //获取文案描述
                if (diction[@"lang"]) {
                    lang_descrptionDic = [diction objectForKey:@"lang"];
                    [USER_DEFAULT setObject:lang_descrptionDic forKey:@"lang_description"];
                }
                
                //设置热门秀竞拍cell文案
                [USER_DEFAULT setObject:diction[@"lang"][@"auction_feeds_tip"] forKey:@"auction_feeds_tip"];

                //设置约拍名称
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_tips"] forKey:@"covenant_tips"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_create"] forKey:@"covenant_create"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_bail"] forKey:@"covenant_bail"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_accept"] forKey:@"covenant_accept"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_join"] forKey:@"covenant_join"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_over"] forKey:@"covenant_over"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_set_create"] forKey:@"covenant_set_create"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_set_bail"] forKey:@"covenant_set_bail"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_set_join"] forKey:@"covenant_set_join"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_set_over"] forKey:@"covenant_set_over"];
                [USER_DEFAULT setObject:diction[@"lang"][@"covenant_set_create_tips"] forKey:@"covenant_set_create_tips"];
                //设置图片后缀
                [USER_DEFAULT setObject:diction[@"pic_postfix"] forKey:@"pic_postfix"];
                //正式接口
//                [USER_DEFAULT setObject:@"http://api2.moka.vc"  forKey:@"api_url"];
                //审核接口
                //[USER_DEFAULT setObject:  forKey:@"api_url"];
                //测试接口
                [USER_DEFAULT setObject:@"http://yzh.api.mokacool.com" forKey:@"api_url"];
                [USER_DEFAULT synchronize];
                
                
                BOOL isUseAviary = NO;
                BOOL isAppearThirdLogin = NO;
                BOOL isAppearShang = NO;
                BOOL isAppearYuePai = NO;
                //BOOL isAppearNormal = NO;
                BOOL isAppearMember = NO;
                BOOL isNearFeed = NO;
                BOOL isNearHome = NO;
                BOOL isAllowThirdLogin = NO;
                BOOL isAppearAuction = NO;
                
                NSString *aviary = [NSString stringWithFormat:@"%@",diction[@"isUseAviary"]];
                NSString *third = [NSString stringWithFormat:@"%@",diction[ConfigThird]];
                NSString *shang = [NSString stringWithFormat:@"%@",diction[ConfigShang]];
                NSString *yuepai = [NSString stringWithFormat:@"%@",diction[ConfigYuePai]];
                NSString *near_feed = [NSString stringWithFormat:@"%@",diction[ConfigNearFeed]];
                NSString *near_home = [NSString stringWithFormat:@"%@",diction[ConfigNearHome]];
                NSString *allowLogin = [NSString stringWithFormat:@"%@",diction[ConfigAllowThirdLogin]];
                NSString *menber = [NSString stringWithFormat:@"%@",diction[ConfigShang]];
                NSString *auction = [NSString stringWithFormat:@"%@",diction[ConfigAuction]];
                
                if ([aviary isEqualToString:@"1"]) {
                    isUseAviary = YES;
                    //                NSString *key = [NSString stringWithFormat:@"%@",diction[@"aviaryAppkey"]];
                    //                NSString *secret = [NSString stringWithFormat:@"%@",diction[@"aviaryAppsecret"]];
                    
                }
                
                if ([third isEqualToString:@"1"]) {
                    isAppearThirdLogin = YES;
                }
                
                if ([shang isEqualToString:@"1"]) {
                    isAppearShang = YES;
                }
                
                if ([yuepai isEqualToString:@"1"]) {
                    isAppearYuePai = YES;
                }
                
                if ([near_feed isEqualToString:@"1"]) {
                    isNearFeed = YES;
                }
                
                if ([near_home isEqualToString:@"1"]) {
                    isNearHome = YES;
                }
                
                if ([allowLogin isEqualToString:@"1"]) {
                    isAllowThirdLogin = YES;
                }
                if ([menber isEqualToString:@"1"]) {
                    isAppearMember = YES;
                }
                if ([auction isEqualToString:@"1"]) {
                    isAppearAuction = YES;
                }
                //测试完记得关
//                            isAppearThirdLogin = YES;
//                            isAppearShang = YES;
//                            isAppearYuePai = YES;
                //            isAppearNormal = YES;
                MCAPI_Data_setObect1(diction[ConfigPrice], ConfigPrice);
                MCAPI_Data_setObect1(diction[ConfigRechargeSetting], ConfigRechargeSetting);
                MCAPI_Data_setObect1(diction[ConfigExchangeSetting], ConfigExchangeSetting);//金币兑换配置
                UserDefaultSetBool(isUseAviary, @"isUseAviary");
                UserDefaultSetBool(isAppearThirdLogin, ConfigThird);
                UserDefaultSetBool(isAppearShang, ConfigShang);
                UserDefaultSetBool(isAppearYuePai, ConfigYuePai);
                UserDefaultSetBool(isNearFeed, ConfigNearFeed);
                UserDefaultSetBool(isNearHome, ConfigNearHome);
                UserDefaultSetBool(isAllowThirdLogin, ConfigAllowThirdLogin);
                UserDefaultSetBool(isAppearMember, ConfigAllowBuyMember);
                UserDefaultSetBool(isAppearAuction, ConfigAuction);
                
            }
        } failed:^(NSError *error) {
            
        }];
}


#pragma mark private

- (void)getLocation
{
    /*获取经纬度*/
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.distanceFilter = 5.0;
    
    //检查定位服务是否对本app禁用
    BOOL enable=[CLLocationManager locationServicesEnabled];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    int status=[CLLocationManager authorizationStatus];
    if(!enable ||status < 3){
        //请求权限
        if (SYSTEM_VERSION >= 8.0){
            [self.locManager requestWhenInUseAuthorization];
        }
        //    requestAlwaysAuthorization,    NSLocationAlwaysUsageDescription
        //    requestWhenInUseAuthorization   NSLocationWhenInUseUsageDescription
    }
#endif
    [self.locManager startUpdatingLocation];
    
}


- (void)setStateParams
{
    
    [self isNetWorkReachable];
    
}

//网络检测
- (BOOL)isNetWorkReachable{
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                [LeafNotification showInController:self.mainNavController withText:@"网络不通..." type:LeafNotificationTypeRemind];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                [LeafNotification showInController:self.mainNavController withText:@"网络通过WIFI连接..." type:LeafNotificationTypeRemind];
                
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                [LeafNotification showInController:self.mainNavController withText:@"网络通过流量连接..." type:LeafNotificationTypeRemind];
                break;
            }
            default:
                break;
        }
        
    }];
    
    
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

#pragma mark CLLocationManagerDelegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self decompilingLocation:newLocation];
    self.lat =newLocation.coordinate.latitude;
    self.lng =newLocation.coordinate.longitude;
}
#else
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if ([locations count] > 0) {
        CLLocation *newLocation = [locations lastObject];
        self.lat =newLocation.coordinate.latitude;
        self.lng =newLocation.coordinate.longitude;
        [self.locManager stopUpdatingLocation];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self decompilingLocation:newLocation];
        });
    }
}
#endif


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"manager_error:%@",error);//“kCLErrorDomain”错误
}

- (void)decompilingLocation:(CLLocation *)location{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count) {
            CLPlacemark *placemark = [placemarks firstObject];
//            NSLog(@"%@",placemark.locality);
//            NSLog(@"%@",placemark.subLocality);
            NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
            NSString *cityStr = placemark.locality;
            if ([cityStr isEqualToString:@"北京市"]|[cityStr isEqualToString:@"重庆市"]|[cityStr isEqualToString:@"天津市"]|[cityStr isEqualToString:@"上海市"]) {
                cityStr = placemark.subLocality;
            }
            [locationDic setValue:cityStr forKey:@"city"];
            [USER_DEFAULT setValue:locationDic forKey:USER_LOCATION];
        }
    }];
}

@end
