//
//  McEventInfo.h
//  Mocha
//
//  Created by renningning on 15-3-31.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    McPersonalTypeTextView,
    McpersonalTypeTextField,
    McPersonalTypeTextFieldNumber,

}McEventTextType;


@interface McEventInfo : NSObject

/*!
 @property  eid
 @discussion     招聘活动Id
 */
@property (nonatomic, strong) NSString *eid;

/*!
 @property  publisherDict
 @discussion     发布活动人的信息
 */
@property (nonatomic, strong) NSDictionary *publisherDict;


/*!
 @property  img
 @discussion    招聘活动Logo
 */
@property (nonatomic, strong) NSString *img;

/*!
 @property  startTime
 @discussion    开始时间
 */
@property (nonatomic, strong) NSString *startTime;

/*!
 @property  endTime
 @discussion    结束时间
 */
@property (nonatomic, strong) NSString *endTime;

/*!
 @property  title
 @discussion    招聘活动标题／主题
 */
@property (nonatomic, strong) NSString *title;

/*!
 @property  detail
 @discussion    招聘活动描述
 */
@property (nonatomic, strong) NSString *detail;

/*!
 @property  requirement
 @discussion    招聘要求
 */
@property (nonatomic, strong) NSString *requirement;

/*!
 @property  number
 @discussion    招聘人数
 */
@property (nonatomic, strong) NSString *number;

/*!
 @property  payment
 @discussion    价格
 */
@property (nonatomic, strong) NSString *payment;

/*!
 @property  area
 @discussion    招聘活动地区
 */
@property (nonatomic, strong) NSString *area;

/*!
 @property  address
 @discussion  招聘活动具体地点
 */
@property (nonatomic, strong) NSString *address;

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
