//
//  MCMacroDefinitionCode.h
//  Mocha
//
//  Created by 小猪猪 on 16/6/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#ifndef MCMacroDefinitionCode_h
#define MCMacroDefinitionCode_h







/*================= 字体大小 =================*/
#define kFont18  [UIFont systemFontOfSize:18]
#define kFont17  [UIFont systemFontOfSize:17]
#define kFont16  [UIFont systemFontOfSize:16]
#define kFont15  [UIFont systemFontOfSize:15]
#define kFont14  [UIFont systemFontOfSize:14]
#define kFont13  [UIFont systemFontOfSize:13]
#define kFont12  [UIFont systemFontOfSize:12]
#define kFont11  [UIFont systemFontOfSize:11]
#define kFont10  [UIFont systemFontOfSize:10]

#define kFontBold18  [UIFont boldSystemFontOfSize:18]
#define kFontBold16  [UIFont boldSystemFontOfSize:16]





//默认URL
#define  DEFAULTURL [[NSUserDefaults standardUserDefaults] objectForKey:@"api_url"]

#define CovenantTips [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_tips"] //　约拍标题
#define CovenantCreate [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_create"] //　发起约拍
#define CovenantBail [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_bail"] //　支付定金
#define CovenantAccept [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_accept"] //　接受约拍
#define CovenantJoin [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_join"] //　参与拍摄
#define CovenantOver [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_over"] //　确实付款
#define CovenantCancel [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_over"] //　取消约拍
#define CovenantTaoXiTips [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_set_create"] //　套系标题
#define CovenantTaoXiBail [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_set_bail"]   //  套系第二步描述
#define CovenantTaoXiJoin [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_set_join"]    // 套系第三步
#define CovenantTaoXiOver [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_set_over"]  //套系第四步
#define CovenantCrearTaoXiTips [[NSUserDefaults standardUserDefaults] objectForKey:@"covenant_set_create_tips"] //套系小字


#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]



#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//color
#define COLOR_alpha(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


//frame and size
#define SC_DEVICE_BOUNDS    [[UIScreen mainScreen] bounds]
#define SC_DEVICE_SIZE      [[UIScreen mainScreen] bounds].size

#define SC_APP_FRAME        [[UIScreen mainScreen] applicationFrame]
#define SC_APP_SIZE         [[UIScreen mainScreen] applicationFrame].size

#define SELF_CON_FRAME      self.view.frame
#define SELF_CON_SIZE       self.view.frame.size
#define SELF_VIEW_FRAME     self.frame
#define SELF_VIEW_SIZE      self.frame.size

#define  kDeviceWidth        [[UIScreen mainScreen] bounds].size.width
#define  kDeviceHeight       [[UIScreen mainScreen] bounds].size.height


#define App_Delegate  (AppDelegate *)[UIApplication sharedApplication].delegate
#define Latitude  [(AppDelegate *)[UIApplication sharedApplication].delegate lat]
#define Longitude  [(AppDelegate *)[UIApplication sharedApplication].delegate lng]


/*
 * NSUserDefaults
 */
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define MCAPI_Data_Object1(k1)    [[NSUserDefaults standardUserDefaults] objectForKey:k1]
#define MCAPI_Data_setObect1(o,k1)  [[NSUserDefaults standardUserDefaults] setObject:o forKey:k1]
#define UserDefaultSetBool(o,k1)  [[NSUserDefaults standardUserDefaults] setBool:o forKey:k1]
#define UserDefaultGetBool(k1)  [[NSUserDefaults standardUserDefaults] boolForKey:k1]


#define YBUUID     MCAPI_Data_Object1(@"UUID")
#define YBMOBILE   MCAPI_Data_Object1(@"mobile")
#define YBTOKEN    MCAPI_Data_Object1(@"token")
#define YBUSERID   MCAPI_Data_Object1(@"id")

#define NewbackgroundColor [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:240.0f/255.0f alpha:1.0f]


#define IOS_VERSION_9_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


// Is OS version greater than or equal to iOS 7.0
#define IsOSVersionAtLeastiOS7() (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)




#if __IPHONE_6_0 // iOS6 and later

#   define kTextAlignmentCenter_SC    NSTextAlignmentCenter
#   define kTextAlignmentLeft_SC      NSTextAlignmentLeft
#   define kTextAlignmentRight_SC     NSTextAlignmentRight

#   define kTextLineBreakByWordWrapping_SC      NSLineBreakByWordWrapping
#   define kTextLineBreakByCharWrapping_SC      NSLineBreakByCharWrapping
#   define kTextLineBreakByClipping_SC          NSLineBreakByClipping
#   define kTextLineBreakByTruncatingHead_SC    NSLineBreakByTruncatingHead
#   define kTextLineBreakByTruncatingTail_SC    NSLineBreakByTruncatingTail
#   define kTextLineBreakByTruncatingMiddle_SC  NSLineBreakByTruncatingMiddle

#else // older versions

#   define kTextAlignmentCenter_SC    UITextAlignmentCenter
#   define kTextAlignmentLeft_SC      UITextAlignmentLeft
#   define kTextAlignmentRight_SC     UITextAlignmentRight

#   define kTextLineBreakByWordWrapping_SC       UILineBreakModeWordWrap
#   define kTextLineBreakByCharWrapping_SC       UILineBreakModeCharacterWrap
#   define kTextLineBreakByClipping_SC           UILineBreakModeClip
#   define kTextLineBreakByTruncatingHead_SC     UILineBreakModeHeadTruncation
#   define kTextLineBreakByTruncatingTail_SC     UILineBreakModeTailTruncation
#   define kTextLineBreakByTruncatingMiddle_SC   UILineBreakModeMiddleTruncation

#endif

















#endif /* MCMacroDefinitionCode_h */
