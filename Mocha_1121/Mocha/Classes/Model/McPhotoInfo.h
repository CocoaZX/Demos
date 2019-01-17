//
//  McPhotoInfo.h
//  Mocha
//
//  Created by renningning on 14-11-28.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface McPhotoInfo : NSObject

/*!
 @property  pid
 @discussion     图片Id
 */
@property (nonatomic, strong) NSString *pid;

/*!
 @property  uid
 @discussion    用户Id
 */
@property (nonatomic, strong) NSString *uid;

/*!
 @property  pic
 @discussion    照片Url地址
 */
@property (nonatomic, strong) NSString *pic;

/*!
 @property  tags
 @discussion    标签
 */
@property (nonatomic, strong) NSString *tags;

/*!
 @property  title
 @discussion    照片标题
 */
@property (nonatomic, strong) NSString *title;

/*!
 @property  detail
 @discussion    照片描述
 */
@property (nonatomic, strong) NSString *detail;

/*!
 @property  width
 @discussion    照片宽度
 */
@property (nonatomic, strong) NSString *width;

/*!
 @property  height
 @discussion  照片高度
 */
@property (nonatomic, strong) NSString *height;

/*!
 @property  longitude
 @discussion    经度
 */
@property (nonatomic, strong) NSString *longitude;

/*!
 @property  latitude
 @discussion    纬度
 */
@property (nonatomic, strong) NSString *latitude;

/*!
 @property  status
 @discussion    状态1显示，1=正常，0=禁用，-4=删除
 */
@property (nonatomic, strong) NSString *status;

@end
