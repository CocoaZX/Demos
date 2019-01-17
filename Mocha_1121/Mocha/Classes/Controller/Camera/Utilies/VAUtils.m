//
//  SBWLUtils.m
//  valbum
//
//  Created by Zoe on 13-11-11.
//  Copyright (c) 2013年 上海上蓓网络科技有限公司. All rights reserved.
//

#import "VAUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString_RegEx.h"

#pragma mark 字体颜色

#define TEXT_BASE_COLOR [UIColor colorWithRed:255 / 255.0 green:58 / 255.0 blue:49 / 255.0 alpha:1.0]
#define TEXT_BLUE_COLOR [UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0]
#define TEXT_RED_COLOR [UIColor colorWithRed:255 / 255.0 green:34 / 255.0 blue:34 / 255.0 alpha:1.0]
#define TEXT_CHAMPAGNE_COLOR [UIColor colorWithRed:234 / 255.0 green:187 / 255.0 blue:0 / 255.0 alpha:1.0]

@implementation VAUtils

/**
   @method 根据dateString解析时间（秒）
   @param value 待计算的字符串
   @result NSDate 时间
 */
+ (NSDate *)dateFormatterByNSString:(NSString *)dateString {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:[@"1378437276157" longLongValue]];
	return date;
}

/**
   @method 根据dateString解析时间（毫秒）
   @param value 待计算的字符串
   @result NSDate 时间
 */
+ (NSDate *)dateFormatterByNSStringNew:(NSNumber *)dateString {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue] / 1000];
	return date;
}

+ (NSString *)myDateFormat {
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 5.0 && version < 6.0) {
		return @"yyyy-MM-dd'T'hh:mm:ss.SSS'Z'";
	}
	else {
		return @"YYYY-MM-dd'T'HH:mm:ss.SSSZ";
	}
}

+ (NSArray *)convertArray:(NSSet *)data orderKey:(NSString *)orderKey ascending:(BOOL)ascending {
	NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:orderKey ascending:ascending];
//    [array sortUsingDescriptors:[NSArray arrayWithObject:sort]]
	NSArray *resultArray = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
//    return [data allObjects];
	return resultArray;
}

+ (void)setImgBounds:(UIImageView *)img radius:(CGFloat)radius {
	//设置layer
	CALayer *layer = [img layer];
	//是否设置边框以及是否可见
	[layer setMasksToBounds:YES];
	//设置边框圆角的弧度
	[layer setCornerRadius:radius];
	//设置边框线的宽
	[layer setBorderWidth:0.1];
	//设置边框线的颜色
	[layer setBorderColor:[[UIColor colorWithRed:212 / 255.0 green:212 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor]];
}

+ (float)getScaleHeightWithScaleWidth:(float)scaleWidth originalWidth:(NSNumber *)originalWidth originalHeight:(NSNumber *)originalHeight {
	int scaleHeight = 0;
	scaleHeight = [originalHeight floatValue] * scaleWidth / [originalWidth floatValue];
	return scaleHeight;
}

+ (float)getScaleWidthtWithScaleHeight:(float)scaleHeight originalWidth:(NSNumber *)originalWidth originalHeight:(NSNumber *)originalHeight {
	int scaleWidth = 0;
    scaleWidth = [originalWidth floatValue] * scaleHeight / [originalHeight floatValue];
	return scaleWidth;
}

+ (UIButton *)getBackBtnStyle {
	int width = 44;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		width = 30;
	}
	UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 44.0)];
	backBtn.contentMode = UIViewContentModeLeft;
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	[backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[backBtn setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateHighlighted];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
	return backBtn;
}

+ (UIButton *)getRightBtnStyle:(NSString *)title titleColor:(UIColor *)titleColor {
	int width = 44;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		width = 30;
	}
	UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 44.0)];
	[backBtn setTitle:title forState:UIControlStateNormal];
	[backBtn setTitleColor:titleColor forState:UIControlStateNormal];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
	return backBtn;
}

+ (UIBarButtonItem *)getBarButtonStyle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
	int width = 60;
	UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30.0)];
	[backBtn setTitle:title forState:UIControlStateNormal];
	[backBtn setTitleColor:titleColor forState:UIControlStateNormal];
	[backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

	return temporaryBarButtonItem;
}

/**
   @method 设置btn
   @result UIColor btn样式
 */
+ (UIButton *)getBtnStyle:(NSString *)title {
	int width = 44;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		width = 30;
	}
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(260.0, 0.0, width, 44.0)];
	[btn setTitle:title forState:UIControlStateNormal];
	btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
	[btn setTitleColor:TEXT_BASE_COLOR forState:UIControlStateNormal];
	[btn setTitleColor:TEXT_BASE_COLOR forState:UIControlStateHighlighted];
	btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
	//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
	return btn;
}

+ (id)parseJson:(NSData *)data {
	if (!data) {
		return nil;
	}
	NSError *error;
	return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
}

/**
 *@name 获取文件路径
 */
+ (NSString *)getFilePath:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
	NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:fileName];
	return downloadPath;
}

/**
 *@name 判断网络环境是否是wifi
 */
+ (BOOL)isWifi {
	//TODO
	return YES;
}

/**
 *@name dic转化成json
 */
+ (NSString *)dic2Json:(id)dic {
	if ([NSJSONSerialization isValidJSONObject:dic]) {
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:dic
		                                               options:NSJSONWritingPrettyPrinted
		                                                 error:&error];
		NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		strData = [strData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		return strData;
	}
	else
		return nil;
}

/**
 *@name dic转化成data
 */
+ (NSData *)dic2Data:(NSDictionary *)dic {
	if ([NSJSONSerialization isValidJSONObject:dic]) {
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:dic
		                                               options:NSJSONWritingPrettyPrinted
		                                                 error:&error];
		return data;
	}
	else
		return nil;
}


+ (NSString *)setEmptyStr:(NSString *)str {
	if (str == nil) {
		str = @"";
	}
	return str;
}

#pragma mark - 设置btn稍后可点击
+ (void)setBtnEnableLater:(UIButton *)sender ctr:(UIViewController *)ctr {
	sender.enabled = NO;
	[ctr performSelector:@selector(setBtnCanEnable:) withObject:sender afterDelay:2];
}

+ (void)setBtnCanEnable:(UIButton *)sender {
	sender.enabled = YES;
}

#pragma mark - 利用正则表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

#pragma mark - 利用正则表达式验证密码
+ (BOOL)isValidatePwd:(NSString *)pwd {
	NSString *emailRegex = @"^[0-9a-zA-Z_\\~\\`\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\-\\=\\+\\{\\}\\[\\]\\;\\'\\:\\\"\"\\,\\.\\/\\<\\>\\?\\|\\\\]{6,12}$";

	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:pwd];
}

#pragma mark - 利用正则表达式验证用户名
+ (BOOL)isValidateUName:(NSString *)username {
	NSString *emailRegex = @"^[a-zA-Z_]{1}[a-zA-Z0-9_]{5,11}$";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:username];
}

/**
 判断手机号码是否正确
 @returns yes or no
 */
+(BOOL)mobileJudging:(NSString*)phone {
    NSString*  phoneExpression=[NSString stringWithUTF8String:"^1[358][0-9]{9}$"];
    if ([phone grep:phoneExpression options:REG_ICASE]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - 判断是否登录
+ (BOOL)isLoginState {
	NSString *usrStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_USR"];
	if (usrStr) {
		return YES;
	}
	else {
		return NO;
	}
}

#pragma mark - 判断是否vip
+ (BOOL)isVipState {
	NSString *usrStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_VIP"];
	if (usrStr) {
		return YES;
	}
	else {
		return NO;
	}
}

#pragma mark - 重新获取skey
+ (void)relogin {
//    if ([self isLoginState]) {
//        NSString *usrStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_USR"];
//        NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_PWD"];
////        NSString *pcd = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_PCD"];
//        if (pwd != nil && ![pwd isEqualToString:@""]) {
//            [ApplicationDelegate.netEngine sendLogin:usrStr pwd:pwd pcd:nil completionHandler:^(NSData *data) {} errorHandler:^(NSData *data, NSError *error) {}];
//        }
////        else if (pcd != nil && ![pcd isEqualToString:@""]) {
////            [ApplicationDelegate.netEngine sendLogin:usrStr pwd:nil pcd:pcd completionHandler:^(NSData *data) {} errorHandler:^(NSData *data, NSError *error) {}];
////        }
//    }
}

#pragma mark - 获取带sid的url
+ (NSString *)getSidUrl:(NSString *)baseUrl {
	NSString *url = [[NSString alloc] initWithString:baseUrl];
	NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_COOKIE"];
	if (dic) {
		NSString *sid = [dic objectForKey:@"Value"];
		if ([baseUrl rangeOfString:@"?"].location == NSNotFound) {
			url = [NSString stringWithFormat:@"%@?sid=%@", baseUrl, sid];
		}
		else
			url = [NSString stringWithFormat:@"%@&sid=%@", baseUrl, sid];
	}
	return url;
}

/**
 *@name 加密前字符
 *@return md5加密 小写
 */
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

/**
 *@name 图片动画失真解决
 */
+ (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize {
	CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
	CGImageRef imageRef = image.CGImage;

	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();

	// Set the quality level to use when rescaling
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);

	CGContextConcatCTM(context, flipVertical);
	// Draw into the context; this scales the image
	CGContextDrawImage(context, newRect, imageRef);

	// Get the resized image from the context and a UIImage
	CGImageRef newImageRef = CGBitmapContextCreateImage(context);
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

	CGImageRelease(newImageRef);
	UIGraphicsEndImageContext();

	return newImage;
}

+ (BOOL)isUserInstallWXB:(NSString *)uuid {
	NSString *strUrl = [NSString stringWithFormat:@"com.weixiangben.my%@://", [uuid substringWithRange:NSMakeRange(0, 28)]];

	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strUrl]];
}







/**
 *  去掉左右两边空格
 *
 *  @param value 字符串
 *
 *  @return
 */
+ (NSString *)stringRemoveSpace:(NSString *)value {
	NSString *urlString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return urlString;
}



/**
 *  没有相册访问权限
 *
 *  @param myerror
 */
+ (void)readLocalPhotoError:(NSError *)myerror{
    
    NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
    if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location != NSNotFound) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您关闭了欢聚访问手机照片的权限。您可以在“设置-隐私-照片”中打开。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else {
        NSLog(@"相册访问失败.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您关闭了欢聚访问手机照片的权限。您可以在“设置-隐私-照片”中打开。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

+ (NSString *)trim:(NSString *)str {
    return str == nil ? nil : [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


/**
 *  判断是图片文件
 *
 *  @param fileName
 *
 *  @return
 */
+ (BOOL)isPhoto:(NSString *)fileName{
    
    NSArray * rslt = [fileName componentsSeparatedByString:@"."];
    if ([rslt count] == 2) {
        NSString * fileType = [[rslt objectAtIndex:1] lowercaseString];
        if ([fileType isEqualToString:@"jpg"] ||
            [fileType isEqualToString:@"jpeg"] ||
            [fileType isEqualToString:@"png"])
            return YES;
        else
            return NO;
    }

    return NO;
}

+ (BOOL)containsChinese:(NSString *)str {
    if (str == nil) {
        return NO;
    }
    for(int i = 0; i < [str length];i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return YES;
    }
    return NO;
}

/**
 *  像素转为实际字体大小
 *
 *  @param px
 *
 *  @return
 */
+ (CGFloat)getFontSizeByPX:(CGFloat)px {
    CGFloat pt=(px/96)*72;
    return pt;
}




 
/**
 返回字符串高度
 @param str 字符串
 @param width 要显示的宽度
 @param font 要计算的字体大小
 @returns 字符串的高度
 */
+ (float)getStringHeight:(NSString *)str width:(float)width font:(float)font{
    CGSize contentSize;
    CGSize rectSize = CGSizeMake(width,MAXFLOAT);
    if (IsOSVersionAtLeastiOS7() >= 7.0) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
        contentSize = [str boundingRectWithSize:CGSizeMake(rectSize.width, rectSize.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }else{
        contentSize = [str sizeWithFont:[UIFont systemFontOfSize:font]
                      constrainedToSize:CGSizeMake(rectSize.width, rectSize.height)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    return contentSize.height;
    
}

+ (NSString *)changeContactToNoFace:(NSString *)string
{
    NSMutableString *finalString = @"".mutableCopy;
    for (int i=0; i<string.length; i++) {
        NSString *item = [[string substringFromIndex:i] substringToIndex:1];
        NSLog(@"******** %@",item);
        if (![self isInAToZ:item]) {
            item = @"";
        }
        [finalString appendString:item];
    }
    
    return finalString.copy;
}

+ (BOOL)isInAToZ:(NSString *)str
{
    BOOL results = YES;
    
    NSString *AZ = @"QWERTYUIOPLKJHGFDSAZXCVBNM";
    
    NSRange range = [AZ rangeOfString:str];
    
    if (range.length>0) {
        results = YES;
    }else
    {
        results = NO;
    }
    return results;
}


@end

@implementation UIView (MHScreenShot)

- (UIImage *)screenshotMH {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
	if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
		[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
	}
	else {
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	}
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end

//@implementation NSData (parseJson)
//
//+(id)parseJson{
//    NSError *error;
//    return [NSJSONSerialization JSONObjectWithData:parseJson options:NSJSONReadingMutableLeaves error:&error];
//}
//
//@end
