//
//  PublicMethod.m
//  PinkPavsion
//
//  Created by infiart studio on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PublicMethod.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "Reachability.h"

#import "MBProgressHUD.h"

#import "VAUtils.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation PublicMethod


//md5加密 小写
+ (NSString *)md5:(NSString *)input {
	const char *cStr = [input UTF8String];
	unsigned char result[32];

	CC_MD5(cStr, strlen(cStr), result);

	return [NSString stringWithFormat:

	        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",

	        result[0], result[1], result[2], result[3],

	        result[4], result[5], result[6], result[7],

	        result[8], result[9], result[10], result[11],

	        result[12], result[13], result[14], result[15]

	];
}

//截屏
+ (UIImage *)ScreenShots:(UIView *)view title:(NSString *)strTitle {
	//支持retina高分的关键
	if (UIGraphicsBeginImageContextWithOptions != NULL) {
		UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
	}
	else {
		UIGraphicsBeginImageContext(view.frame.size);
	}

	//    UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	/*
	   //保存图像
	   NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/%@.png",strTitle];
	   [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
	   UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
	 */
	return image;
}

//iphone生成随机uuid串的代码
+ (NSString *)stringWithUUID {
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

//字符串转化时间格式
+ (NSDate *)dateFromString:(NSString *)string {
	//Wed Mar 14 16:40:08 +0800 2012
	if (!string) return nil;

	struct tm tm;
	time_t t;
	string = [string substringFromIndex:4];
	strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%a, %d %b %Y %H:%M:%S %z", &tm);
	tm.tm_isdst = -1;
	t = mktime(&tm);
	return [NSDate dateWithTimeIntervalSince1970:t];
}

//时间转换字符串
+ (NSString *)fixStringForDate:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *fixString = [dateFormatter stringFromDate:date];

	return fixString;
}

+ (NSString *)fixCreateDate:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[dateFormatter setDateFormat:@"yyMMddHHmmss"];
	NSString *fixString = [dateFormatter stringFromDate:date];
	return fixString;
}

+ (NSDate *)dateFromStr:(NSString *)dateString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

	NSDate *destDate = [dateFormatter dateFromString:dateString];

	return destDate;
}

//解析Base64
+ (NSString *)decodeBase64:(NSString *)input {
	NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	NSString *decoded = @"";

	NSString *encoded = [input stringByPaddingToLength:(ceil([input length] / 4) * 4)
	                                        withString:@"A"
	                                   startingAtIndex:0];

	int i;
	char a, b, c, d;
	UInt32 z;

	for (i = 0; i < [encoded length]; i += 4) {
		a = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 0, 1)]].location;
		b = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 1, 1)]].location;
		c = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 2, 1)]].location;
		d = [alphabet rangeOfString:[encoded substringWithRange:NSMakeRange(i + 3, 1)]].location;

		z = ((UInt32)a << 26) + ((UInt32)b << 20) + ((UInt32)c << 14) + ((UInt32)d << 8);
		decoded = [decoded stringByAppendingString:[NSString stringWithCString:(char *)&z encoding:NSUTF8StringEncoding]];
	}

	return decoded;
}

/**
   @method 获取指定宽度情况ixa，字符串value的高度
   @param value 待计算的字符串
   @param fontSize 字体的大小
   @param andWidth 限制字符串显示区域的宽度
   @result float 返回的高度
 */
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
	CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping]; //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
	return sizeToFit.height;
}

+ (float)heightWithios7ForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    value = value == nil ? @"" : value;
    CGSize sizeToFit;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        
        CGSize constraint = CGSizeMake(width, MAXFLOAT);
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: value attributes: attrs];
        CGRect rect = [attributedText boundingRectWithSize: constraint
                                                   options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   context: nil];
        sizeToFit = rect.size;
    } else
        sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit.height;
}

+ (CGSize)sizeWithios7ForString:(NSString *)value fontSize:(float)fontSize {
    value = value == nil ? @"" : value;
    CGSize sizeToFit;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        
        CGSize constraint = CGSizeMake(MAXFLOAT, MAXFLOAT);
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: value attributes: attrs];
        CGRect rect = [attributedText boundingRectWithSize: constraint
                                                   options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   context: nil];
        sizeToFit = rect.size;
    } else
        sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit;
}

+ (CGFloat)lineSpace:(CGFloat)fontSize {
    return [PublicMethod heightWithios7ForString:@"永" fontSize:fontSize andWidth:290.0] - fontSize;
}

+ (NSString *)getDeviceVersion {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = (char *)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	return platform;
}

//获取机型
+ (NSString *)platformString {
	NSString *platform = [self getDeviceVersion];
	//iPhone
	if ([platform isEqualToString:@"iPhone1,1"]) return@ "iPhone 1G";
	if ([platform isEqualToString:@"iPhone1,2"]) return@ "iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"]) return@ "iPhone 3GS";
	if ([platform isEqualToString:@"iPhone3,1"]) return@ "iPhone 4";
	if ([platform isEqualToString:@"iPhone3,2"]) return@ "Verizon iPhone 4";
	if ([platform isEqualToString:@"iPhone3,3"]) return@ "iPhone 4 (CDMA)";
	if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
	if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM/WCDMA)";
	if ([platform isEqualToString:@"iPhone4,2"]) return @"iPhone 5 (CDMA)";

	//iPot Touch
	if ([platform isEqualToString:@"iPod1,1"]) return@ "iPod Touch 1G";
	if ([platform isEqualToString:@"iPod2,1"]) return@ "iPod Touch 2G";
	if ([platform isEqualToString:@"iPod3,1"]) return@ "iPod Touch 3G";
	if ([platform isEqualToString:@"iPod4,1"]) return@ "iPod Touch 4G";
	if ([platform isEqualToString:@"iPod5,1"]) return@ "iPod Touch 5G";
	//iPad
	if ([platform isEqualToString:@"iPad1,1"]) return@ "iPad";
	if ([platform isEqualToString:@"iPad2,1"]) return@ "iPad 2 (WiFi)";
	if ([platform isEqualToString:@"iPad2,2"]) return@ "iPad 2 (GSM)";
	if ([platform isEqualToString:@"iPad2,3"]) return@ "iPad 2 (CDMA)";
	if ([platform isEqualToString:@"iPad2,4"]) return@ "iPad 2 New";
	if ([platform isEqualToString:@"iPad2,5"]) return@ "iPad Mini (WiFi)";
	if ([platform isEqualToString:@"iPad3,1"]) return@ "iPad 3 (WiFi)";
	if ([platform isEqualToString:@"iPad3,2"]) return@ "iPad 3 (CDMA)";
	if ([platform isEqualToString:@"iPad3,3"]) return@ "iPad 3 (GSM)";
	if ([platform isEqualToString:@"iPad3,4"]) return@ "iPad 4 (WiFi)";
	if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) return@ "Simulator";

	return platform;
}

+ (NSString *)getDeviceInfo {
	CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
	CTCarrier *carrier = info.subscriberCellularProvider;

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defs objectForKey:@"AppleLanguages"];
	NSString *preferredLang = [languages objectAtIndex:0];

	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
	                      [self getDeviceVersion], @"platform",
	                      [[UIDevice currentDevice] systemName], @"name",
	                      [[UIDevice currentDevice] systemVersion], @"version",
	                      [[UIDevice currentDevice] model], @"model",
	                      preferredLang, @"language",
	                      carrier.description, @"carrier",
	                      nil];

	NSString *strDevice = [VAUtils dic2Json:dict];
	strDevice = [strDevice stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	strDevice = [strDevice stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    strDevice = strDevice == nil ? @"" : strDevice;

	return strDevice;
}

//是否隐藏tabbar
+ (void)hideTabBar:(UITabBarController *)tabbarcontroller {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0];
	for (UIView *view in tabbarcontroller.view.subviews) {
		if ([view isKindOfClass:[UITabBar class]]) {
			[view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
		}
		else {
			[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
		}
	}
	[UIView commitAnimations];
}

+ (void)showTabBar:(UITabBarController *)tabbarcontroller {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0];
	for (UIView *view in tabbarcontroller.view.subviews) {
		NSLog(@"%@", view);

		if ([view isKindOfClass:[UITabBar class]]) {
			[view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
		}
		else {
			[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
		}
	}

	[UIView commitAnimations];
}

//清除UITableView底部多余的分割线。
+ (void)setExtraCellLineHidden:(UITableView *)tableView {
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor clearColor];
	[tableView setTableFooterView:view];
}

//将图片缩放成指定大小（压缩方法）
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
	// 创建一个bitmap的context
	// 并把它设置成为当前正在使用的context
	UIGraphicsBeginImageContext(size);
	// 绘制改变大小的图片
	[img drawInRect:CGRectMake(0, 0, size.width, size.height)];
	// 从当前context中创建一个改变大小后的图片
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();
	// 返回新的改变大小后的图片
	return scaledImage;
}

// 是否wifi
+ (BOOL)IsEnableWIFI {
	BOOL isExistenceNetwork = NO;
	Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
	switch ([r currentReachabilityStatus]) {
		case NotReachable:
			isExistenceNetwork = NO;
			//   NSLog(@"没有网络");
			break;

		case ReachableViaWWAN:
			isExistenceNetwork = NO;
			//   NSLog(@"正在使用3G网络");
			break;

		case ReachableViaWiFi:
			isExistenceNetwork = YES;
			//  NSLog(@"正在使用wifi网络");
			break;
	}
	return isExistenceNetwork;
}

// 是否3G
+ (BOOL)IsEnable3G {
	BOOL isExistenceNetwork = NO;
	Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
	switch ([r currentReachabilityStatus]) {
		case NotReachable:
			isExistenceNetwork = NO;
			//   NSLog(@"没有网络");
			break;

		case ReachableViaWWAN:
			isExistenceNetwork = YES;
			//   NSLog(@"正在使用3G网络");
			break;

		case ReachableViaWiFi:
			isExistenceNetwork = NO;
			//  NSLog(@"正在使用wifi网络");
			break;
	}
	return isExistenceNetwork;
}

//检测网络类型
+ (BOOL)isEnableNetwork {
	BOOL isExistenceNetwork = YES;
	Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
	switch ([r currentReachabilityStatus]) {
		case NotReachable:
			isExistenceNetwork = NO;
			//   NSLog(@"没有网络");
			break;

		case ReachableViaWWAN:
			isExistenceNetwork = YES;
			//   NSLog(@"正在使用3G网络");
			break;

		case ReachableViaWiFi:
			isExistenceNetwork = YES;
			//  NSLog(@"正在使用wifi网络");
			break;
	}
	return isExistenceNetwork;
//    if (!isExistenceNetwork) {
//        UIAlertView *myalert = [[UIAlertView alloc]
//                                initWithTitle:NSLocalizedString(@"Network error", @"Network error")
//                                message:NSLocalizedString(@"Network isnt connected.Please check.", nil)
//                                delegate:self
//                                cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
//                                otherButtonTitles:nil];
//
//        [myalert show];
//        return;
//    }
}

//创建ScrollView
+ (UIScrollView *)CreateScrollView:(CGRect)frame {
	CGSize Size = frame.size;
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
	[scrollView setContentSize:CGSizeMake(Size.width, Size.height + 1)];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setScrollEnabled:YES];

	return scrollView;
}

//创建自定义Button
+ (UIButton *)CreateCustomButton:(NSString *)Title frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor image:(UIImage *)image bgImage:(UIImage *)bgImage {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setTitle:Title forState:UIControlStateNormal];
	btn.frame = frame;
	btn.titleLabel.font = font;
	[btn setTitleColor:textColor forState:UIControlStateNormal];
	[btn setImage:image forState:UIControlStateNormal];
	[btn setBackgroundImage:bgImage forState:UIControlStateNormal];
	btn.backgroundColor = [UIColor clearColor];

	return btn;
}

//创建UILabel
+ (UILabel *)CreateLabel:(NSString *)Title frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment {
	UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
	[lbl setText:Title];
	[lbl setBackgroundColor:[UIColor clearColor]];
	[lbl setFont:font];
	[lbl setTextColor:textColor];
	[lbl setTextAlignment:TextAlignment];
	lbl.lineBreakMode = kTextLineBreakByWordWrapping_SC; //允许换行
	lbl.numberOfLines = 0;

	float minimumFontSize = font.pointSize - 5;
	lbl.adjustsFontSizeToFitWidth = YES;
    #if __IPHONE_6_0
    lbl.minimumScaleFactor = minimumFontSize;
    #else
    lbl.minimumFontSize = minimumFontSize;
    #endif
	return lbl;
}

//创建UITextField
+ (UITextField *)CreateTextField:(NSString *)placeholder frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor Isborder:(BOOL)Isborder {
	UITextField *txtIput = [[UITextField alloc] initWithFrame:frame];
	if (Isborder) {
		txtIput.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
		txtIput.layer.borderWidth = 0.5;
	}
	[txtIput setBackgroundColor:[UIColor clearColor]];
	txtIput.font = font;
	txtIput.placeholder = placeholder;
	txtIput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	return txtIput;
}

//创建UITextView
+ (UITextView *)CreateTextView:(NSString *)Title frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)TextAlignment {
	UITextView *txtview = [[UITextView alloc] initWithFrame:frame];
	[txtview setBackgroundColor:[UIColor clearColor]];
	txtview.textColor = textColor;
	txtview.font = font;
	txtview.text = Title;
	txtview.textAlignment = TextAlignment;
	[txtview setShowsHorizontalScrollIndicator:NO];
	txtview.editable = NO;

	return txtview;
}

//两张照片合成
+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2 text:(NSString *)text textColor:(UIColor *)color {
	float fontSize = 10.0;
	CGRect rcImage;
	CGSize sizeTextCanDraw = CGSizeMake(0.0, 0.0);
	if (![text isEqualToString:@""]) {
		sizeTextCanDraw = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] forWidth:rect1.size.width lineBreakMode:NSLineBreakByWordWrapping];
	}
	rcImage = CGRectMake(0, 0, rect1.size.width + sizeTextCanDraw.height, rect1.size.height + sizeTextCanDraw.height);

	CGSize size = CGSizeMake(rcImage.size.width, rcImage.size.height);

	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	//设置矩形填充颜色：红色
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
	//填充矩形
	CGContextFillRect(context, rcImage);
	//设置画笔颜色：黑色
	CGContextSetRGBStrokeColor(context, 0, 0.0, 0.0, 0.4);
	//设置画笔线条粗细
	CGContextSetLineWidth(context, 1.0);
	//画矩形边框
	CGContextAddRect(context, rcImage);
	//执行绘画
	CGContextStrokePath(context);

	rect1.origin.x = (rcImage.size.width - rect1.size.width) / 2;
	rect1.origin.y = (rcImage.size.height - rect1.size.height) / 2;
	rect2.origin.x = (rcImage.size.width - rect2.size.width) / 2;
	rect2.origin.y = (rcImage.size.height - rect2.size.height) / 2;
	[image1 drawInRect:rect1];
	[image2 drawInRect:rect2];

	// 绘制文字
	//    CGContextSetStrokeColorWithColor(context, color.CGColor);
	if (![text isEqualToString:@""]) {
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGRect rcTextRect = CGRectMake(0, rect1.size.height - 5, rcImage.size.width, sizeTextCanDraw.height);
		[text drawInRect:rcTextRect withFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
	}
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();

	return resultingImage;
}

//拼接图片
+ (UIImage *)montageImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2 text:(NSString *)text textColor:(UIColor *)color textframe:(CGRect)textframe contextSize:(CGSize)contextSize {
	float fontSize = 20.0;
	CGRect rcImage;
	rcImage = CGRectMake(0, 0, contextSize.width, contextSize.height);

	CGSize size = contextSize;

	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	//设置矩形填充颜色：红色
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
	//填充矩形
	CGContextFillRect(context, rcImage);
	//设置画笔颜色：黑色
	CGContextSetRGBStrokeColor(context, 0, 0.0, 0.0, 0.4);
	//设置画笔线条粗细
	CGContextSetLineWidth(context, 1.0);
	//画矩形边框
	CGContextAddRect(context, rcImage);
	//执行绘画
	CGContextStrokePath(context);

	[image1 drawInRect:rect1];
	[image2 drawInRect:rect2];

	// 绘制文字
	CGContextSetStrokeColorWithColor(context, color.CGColor);
	if (![text isEqualToString:@""]) {
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGRect rcTextRect = textframe;

		int height = [self heightForString:text fontSize:fontSize andWidth:rcTextRect.size.width];
		int top = (rcTextRect.size.height - height) / 2 + rcTextRect.origin.y;
		rcTextRect.origin.y = top;
		rcTextRect.size.height = height;

		UILabel *label = [[UILabel alloc] initWithFrame:rcTextRect];
		label.text = text;
		label.numberOfLines = 0;
		[label drawTextInRect:rcTextRect];
//        [text drawInRect:rcTextRect withFont:[UIFont systemFontOfSize:fontSize] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentLeft];
	}

	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();

	return resultingImage;
}

//打电话
+ (void)CallPhone:(NSString *)strPhone superView:(UIView *)superView {
	NSString *strUrl = [NSString stringWithFormat:@"tel:%@", strPhone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];

	UIWebView *callWebview = [[UIWebView alloc] init];
	NSURL *telURL = [NSURL URLWithString:strUrl];
	[callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
	[superView addSubview:callWebview];
}

//控件加入背景
+ (void)CreateInputBg:(NSString *)img frame:(CGRect)frame panle:(UIView *)panle {
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.image = [UIImage imageNamed:img];
	[panle addSubview:imageView];
}

+ (void)ShowMsg:(NSString *)strMsg view:(UIView *)view delegate:(id <MBProgressHUDDelegate> )delegate msgType:(MsgType)msgType {
	NSString *img;
	switch (msgType) {
		case OK_msg:
			img = @"37x-Checkmark.png";
			break;

		case Error_msg:
			img = @"errorMsg.png";
			break;

		default:
			img = @"37x-Checkmark.png";
			break;
	}

	MBProgressHUD *mHUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:mHUD];
	// Set custom view mode
	//mHUD.dimBackground = YES;//是否需要遮罩
	mHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
	mHUD.mode = MBProgressHUDModeCustomView;
	mHUD.delegate = delegate;
	mHUD.detailsLabelText = strMsg;

	[mHUD show:YES];
	[mHUD hide:YES afterDelay:2];
}

//获取APP配置信息
+ (NSDictionary *)GetApplicationInfo {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"application" ofType:@"json"];
	NSData *content = [NSData dataWithContentsOfFile:path];
	NSError *error;
	NSDictionary *kitData = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableLeaves error:&error];

	return kitData;
}

//得到合成图片
+ (UIImage *)getImage:(UIImage *)image text:(NSString *)text textColor:(UIColor *)color backgroundImage:(UIImage *)backImg size:(CGSize)size {
	UIImage *returnImg = nil;

	CGSize imageSize = image.size;

	CGFloat maxWidth = size.width;
	CGFloat maxHeight = size.height;

	// 创建一个bitmap的context
	CGFloat scale = [[UIScreen mainScreen] scale];
	UIGraphicsBeginImageContext(CGSizeMake(maxWidth * scale, maxHeight * scale));

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);

	CGContextClearRect(context, CGRectMake(0, 0, maxWidth, maxHeight));

	// 绘制图片
	[backImg drawInRect:CGRectMake(0, 0, maxWidth, maxHeight)]; //背景

	CGGradientRef backgroundGradient;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.0,  // Start color
		                      1.0, 1.0, 1.0, 0.7 }; // End color

	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	backgroundGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	CGPoint centerPoint = CGPointMake(maxWidth, maxHeight);
	CGContextDrawRadialGradient(context, backgroundGradient, centerPoint, 0.0, centerPoint, maxWidth, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(backgroundGradient);

	CGRect rcImage = CGRectMake((maxWidth - imageSize.width) / 2, (maxHeight - imageSize.height) / 2, imageSize.width, imageSize.height);
	//设置矩形填充颜色：红色
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
	//填充矩形
	CGContextFillRect(context, rcImage);
	//设置画笔颜色：黑色
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.1);
	//设置画笔线条粗细
	CGContextSetLineWidth(context, 0.2);
	//画矩形边框
	CGContextAddRect(context, rcImage);
	//执行绘画
	CGContextStrokePath(context);

	[image drawInRect:rcImage]; //前景

	// 绘制文字
	//    CGContextSetStrokeColorWithColor(context, color.CGColor);
	CGSize sizeTextCanDraw = [text sizeWithFont:[UIFont systemFontOfSize:8] forWidth:size.width lineBreakMode:NSLineBreakByWordWrapping];
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGRect rcTextRect = CGRectMake(0, size.height - sizeTextCanDraw.height - 8, size.width, sizeTextCanDraw.height);
	[text drawInRect:rcTextRect withFont:[UIFont systemFontOfSize:8] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

	// 从当前context中创建一个改变大小后的图片
	returnImg = UIGraphicsGetImageFromCurrentImageContext();
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();

	return [UIImage imageWithCGImage:returnImg.CGImage scale:scale orientation:UIImageOrientationUp];
}

//裁剪图片
+ (UIImage *)getImageFromImage:(UIImage *)bigImage Size:(CGSize)Size {
	CGFloat width = CGImageGetWidth(bigImage.CGImage);
	CGFloat height = CGImageGetHeight(bigImage.CGImage);
	//大图bigImage
	//定义myImageRect，截图的区域
	CGRect myImageRect = CGRectMake((width - Size.width) / 2, (height - Size.height) / 2, Size.width, Size.height);
	CGImageRef imageRef = bigImage.CGImage;
	CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
	UIGraphicsBeginImageContext(myImageRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, myImageRect, subImageRef);
	UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
	UIGraphicsEndImageContext();
	return smallImage;
}

//设置tTabBarItem的字体颜色
+ (void)SetTabBarItemFontStyle:(UITabBarItem *)item HighlightedColor:(UIColor *)HighlightedColor NormalColor:(UIColor *)NormalColor fontSize:(float)fontSize {
	[item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
	                              HighlightedColor, UITextAttributeTextColor,
	                              [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
	                              [UIFont systemFontOfSize:fontSize], UITextAttributeFont, nil]
	                    forState:UIControlStateSelected];
	[item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
	                              NormalColor, UITextAttributeTextColor,
	                              [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
	                              [UIFont systemFontOfSize:fontSize], UITextAttributeFont, nil]
	                    forState:UIControlStateNormal];
}

//计算当前显示图片大小
+ (CGRect)frameForImage:(UIImage *)image inImageViewAspectFit:(UIImageView *)imageView {
	float imageRatio = image.size.width / image.size.height;

	float viewRatio = imageView.frame.size.width / imageView.frame.size.height;

	if (imageRatio < viewRatio) {
		float scale = imageView.frame.size.height / image.size.height;

		float width = scale * image.size.width;

		float topLeftX = (imageView.frame.size.width - width) * 0.5;

		return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
	}
	else {
		float scale = imageView.frame.size.width / image.size.width;

		float height = scale * image.size.height;

		float topLeftY = (imageView.frame.size.height - height) * 0.5;

		return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
	}
}



//保存文件到本地
+ (BOOL)SaveFileToDocument:(NSData *)data fileName:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];

	BOOL result = [[NSFileManager defaultManager] createFileAtPath:appFile
	                                                      contents:data
	                                                    attributes:nil];
	return result;
}

//根据文件名读取文件
+ (NSData *)getJsonDataByName:(NSString *)filename {
	NSData *content = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:filename];

	if ([[NSFileManager defaultManager] fileExistsAtPath:appFile]) {
		content = [NSData dataWithContentsOfFile:appFile];
	}

//    NSString *result = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];

	return content;
}

/**
   dicArray：待排序的NSMutableArray。
   key：按照排序的key。
   yesOrNo：升序或降序排列，yes为升序，no为降序。
 **/
+ (void)changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo {
	NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
	NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor, nil];
	[dicArray sortUsingDescriptors:descriptors];

	NSLog(@"%@", dicArray);
}

@end
