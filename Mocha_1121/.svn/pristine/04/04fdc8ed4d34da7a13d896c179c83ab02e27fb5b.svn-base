//
//  SBWLUtils.h
//  valbum
//
//  Created by Zoe on 13-11-11.
//  Copyright (c) 2013年 上海上蓓网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface VAUtils : NSObject
#pragma mark 以下为格式化时间
/**
   @method 根据dateString解析时间（秒）
   @param value 待计算的字符串
   @result NSDate 时间
 */
+ (NSDate *)dateFormatterByNSString:(NSString *)dateString;

/**
   @method 根据dateString解析时间（毫秒）
   @param value 待计算的字符串
   @result NSDate 时间
 */
+ (NSDate *)dateFormatterByNSStringNew:(NSNumber *)dateString;

//时间格式化
+ (NSString *)myDateFormat;

//将nsset按照某一字段排序
+ (NSArray *)convertArray:(NSSet *)data orderKey:(NSString *)orderKey ascending:(BOOL)ascending;
//设置圆角
+ (void)setImgBounds:(UIImageView *)img radius:(CGFloat)radius;
//计算高度 todo
+ (float)getScaleHeightWithScaleWidth:(float)scaleWidth originalWidth:(NSNumber *)originalWidth originalHeight:(NSNumber *)originalHeigh;
//计算宽度
+ (float)getScaleWidthtWithScaleHeight:(float)scaleHeight originalWidth:(NSNumber *)originalWidth originalHeight:(NSNumber *)originalHeight;

+ (UIButton *)getBackBtnStyle;
+ (UIButton *)getRightBtnStyle:(NSString *)title titleColor:(UIColor *)titleColor;
+ (UIBarButtonItem *)getBarButtonStyle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;


/**
 判断手机号码是否正确
 @returns yes or no
 */
+(BOOL)mobileJudging:(NSString*)phone;

/**
   @method 设置btn
   @result UIColor btn样式
 */
+ (UIButton *)getBtnStyle:(NSString *)title;

/**
   @method 解析json
   @param 解析数据
   @result id
 */
+ (id)parseJson:(NSData *)data;

/**
 *@name 获取文件路径
 *@param fileName
 */
+ (NSString *)getFilePath:(NSString *)fileName;

/**
 *@name 判断网络环境是否是wifi
 */
+ (BOOL)isWifi;

/**
 *@name dic转化成json
 */
+ (NSString *)dic2Json:(id)dic;

/**
 *@name dic转化成data
 */
+ (NSData *)dic2Data:(NSDictionary *)dic;

/**
 *@name 下载文件，视频，音乐
 */
//+ (void)downloadFile:(NSString *)fileName len:(int)len url:(NSString *)url;

/**
 *@name 设置nil str
 *@param str
 */
+ (NSString *)setEmptyStr:(NSString *)str;

#pragma mark - 设置btn稍后可点击
+ (void)setBtnEnableLater:(UIButton *)sender ctr:(UIViewController *)ctr;

+ (void)setBtnCanEnable:(UIButton *)sender;

#pragma mark - 利用正则表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

#pragma mark - 利用正则表达式验证密码
+ (BOOL)isValidatePwd:(NSString *)pwd;

#pragma mark - 利用正则表达式验证用户名
+ (BOOL)isValidateUName:(NSString *)username;
/**
 *@name 判断是否登录
 *@return YES 已登录
 */
+ (BOOL)isLoginState;

/**
 *@name 判断是否vip
 *@return
 */
+ (BOOL)isVipState;

/**
 *@name 重新登录
 *@return
 */
+ (void)relogin;

/**
 *@name 获取带sid的url
 *@name 基础url
 *@return 转换后的url
 */
+ (NSString *)getSidUrl:(NSString *)baseUrl;

/**
 *@name 加密前字符
 *@return md5加密 小写
 */
+ (NSString *)md5:(NSString *)input;

/**
 *@name 图片动画失真解决
 */
+ (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize;

//判断客户是否安装微相本
+ (BOOL)isUserInstallWXB:(NSString *)uuid;
 
/**
 *  去掉左右两边空格
 *
 *  @param value 字符串
 *
 *  @return
 */
+ (NSString *)stringRemoveSpace:(NSString *)value;

/**
 *  UITableViewCell添加分割线
 *
 *  @param cell
 *  @param leftSpace
 */
//+ (void)addSiglineByCell:(UIView *)cell leftSpace:(float)leftSpace;

/**
 *  没有相册访问权限
 *
 *  @param myerror
 */
+ (void)readLocalPhotoError:(NSError *)myerror;

/**
 *  去除左右空格
 *
 */
+ (NSString *)trim:(NSString *)str;

//+ (NSArray *)toNormal:(NSArray *)array;

/**
 *  判断是图片文件
 *
 *  @param fileName
 *
 *  @return
 */
+ (BOOL)isPhoto:(NSString *)fileName;

/**
 *  判断是否含有中文
 *
 */
+ (BOOL)containsChinese:(NSString *)str;

/**
 *  像素转为实际字体大小
 *
 *  @param px
 *
 *  @return
 */
+ (CGFloat)getFontSizeByPX:(CGFloat)px;

 
//+ (NSString *)getFormatStringFromDate:(NSDate *)date;


/**
 返回字符串高度
 @param str 字符串
 @param width 要显示的宽度
 @param font 要计算的字体大小
 @returns 字符串的高度
 */
+ (float)getStringHeight:(NSString *)str width:(float)width font:(float)font;


//把表情符号什么的都换@“”

+ (NSString *)changeContactToNoFace:(NSString *)string;

@end

//@interface NSData (parseJson)
//
//+(id)parseJson;
//
//@end

@interface UIView (MHScreenShot2)
- (UIImage *)screenshotMH;
@end
