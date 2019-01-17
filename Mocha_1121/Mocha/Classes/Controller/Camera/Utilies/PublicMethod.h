//
//  PublicMethod.h
//  PinkPavsion
//
//  Created by infiart studio on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

typedef enum {
	OK_msg,
	Error_msg,
}MsgType;

@interface PublicMethod : NSObject <UIGestureRecognizerDelegate>
{
}


//md5加密
+ (NSString *)md5:(NSString *)input;

//截屏
+ (UIImage *)ScreenShots:(UIView *)view title:(NSString *)strTitle;

//iphone生成随机uuid串的代码
+ (NSString *)stringWithUUID;

//字符串转换时间格式
+ (NSDate *)dateFromString:(NSString *)string;

//时间转换字符串
+ (NSString *)fixStringForDate:(NSDate *)date;

+ (NSString *)fixCreateDate:(NSDate *)date;

+ (NSDate *)dateFromStr:(NSString *)dateString;

//解析Base64
+ (NSString *)decodeBase64:(NSString *)input;

/**
   @method 获取指定宽度情况ixa，字符串value的高度
   @param value 待计算的字符串
   @param fontSize 字体的大小
   @param andWidth 限制字符串显示区域的宽度
   @result float 返回的高度
 */
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
+ (float)heightWithios7ForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
+ (CGSize)sizeWithios7ForString:(NSString *)value fontSize:(float)fontSize;
+ (CGFloat)lineSpace:(CGFloat)fontSize;

//获取机器型号
+ (NSString *)platformString;

+ (NSString *)getDeviceInfo;

//是否隐藏tabbar
+ (void)hideTabBar:(UITabBarController *)tabbarcontroller;
+ (void)showTabBar:(UITabBarController *)tabbarcontroller;

//清除UITableView底部多余的分割线。
+ (void)setExtraCellLineHidden:(UITableView *)tableView;

//将图片缩放成指定大小（压缩方法）
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

// 是否wifi
+ (BOOL)IsEnableWIFI;

// 是否3G
+ (BOOL)IsEnable3G;

//检测网络类型
+ (BOOL)isEnableNetwork;

//创建ScrollView
+ (UIScrollView *)CreateScrollView:(CGRect)frame;

//创建自定义Button
+ (UIButton *)CreateCustomButton:(NSString *)Title frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor image:(UIImage *)image bgImage:(UIImage *)bgImage;

//创建UILabel
+ (UILabel *)CreateLabel:(NSString *)Title frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment;

//创建UITextField
+ (UITextField *)CreateTextField:(NSString *)placeholder frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor Isborder:(BOOL)Isborder;

//创建UITextView
+ (UITextView *)CreateTextView:(NSString *)Title frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment;

//两张照片合成
+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2 text:(NSString *)text textColor:(UIColor *)color;

//打电话
//+ (void)CallPhone:(NSString *)strPhone;
+ (void)CallPhone:(NSString *)strPhone superView:(UIView *)superView;

//控件加入背景
+ (void)CreateInputBg:(NSString *)img frame:(CGRect)frame panle:(UIView *)panle;

//提示框
+ (void)ShowMsg:(NSString *)strMsg view:(UIView *)view delegate:(id <MBProgressHUDDelegate> )delegate msgType:(MsgType)msgType;

//获取APP配置信息
+ (NSDictionary *)GetApplicationInfo;

//得到合成图片
+ (UIImage *)getImage:(UIImage *)image text:(NSString *)text textColor:(UIColor *)color backgroundImage:(UIImage *)backImg size:(CGSize)size;

//裁剪图片
+ (UIImage *)getImageFromImage:(UIImage *)bigImage Size:(CGSize)Size;

//设置tTabBarItem的字体颜色
+ (void)SetTabBarItemFontStyle:(UITabBarItem *)item HighlightedColor:(UIColor *)HighlightedColor NormalColor:(UIColor *)NormalColor fontSize:(float)fontSize;

//计算当前显示图片大小
+ (CGRect)frameForImage:(UIImage *)image inImageViewAspectFit:(UIImageView *)imageView;

//保存文件到本地
+ (BOOL)SaveFileToDocument:(NSData *)data fileName:(NSString *)fileName;

//根据文件名读取文件
+ (NSData *)getJsonDataByName:(NSString *)filename;

//拼接图片
+ (UIImage *)montageImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2 text:(NSString *)text textColor:(UIColor *)color textframe:(CGRect)textframe contextSize:(CGSize)contextSize;

/**
   dicArray：待排序的NSMutableArray。
   key：按照排序的key。
   yesOrNo：升序或降序排列，yes为升序，no为降序。
 **/
+ (void)changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;

@end
