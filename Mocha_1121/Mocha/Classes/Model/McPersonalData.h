//
//  McPersonalData.h
//  Mocha
//
//  Created by renningning on 14-11-25.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    McPersonalTypeNone,
    McpersonalTypeNickName,
    McPersonalTypeMark,
    McPersonalTypeSex,
    McPersonalTypeHeight,
    McPersonalTypeWeight,
    McPersonalTypeHair,
    McPersonalTypeFoot,
    McPersonalTypeBirth,
    McPersonalTypeLeg,
    McPersonalTypeArea,
    McPersonalTypeWorkTags,
    McPersonalTypeFigureTags,
    McPersonalTypeWorkStyle,
    McPersonalTypeWorkExperience,
    McPersonalTypeWorkIntroduction,
    McPersonalTypeWorkWorkPlace,
    McPersonalTypeMajor,
    McPersonalTypeJob,
    McPersonalTypeBwh,
    McPersonalTypeDesiredSalary
}McPersonalType;


@interface McPersonalData : NSObject

/*!
 @property  headUrl
 @discussion     头像URL
 */
@property (nonatomic, strong) NSString *headUrl;

/*!
 @property  nickName
 @discussion    昵称
 */
@property (nonatomic, strong) NSString *nickName;

/*!
 @property  accountName
 @discussion    账户名/用户名
 */
@property (nonatomic, strong) NSString *accountName;

/*!
 @property  job
 @discussion    职业
 */
@property (nonatomic, strong) NSString *job;

/*!
 @property  sex
 @discussion    性别
 */
@property (nonatomic, strong) NSString *sex;

/*!
 @property  height
 @discussion    身高
 */
@property (nonatomic, strong) NSString *height;

/*!
 @property  weight
 @discussion    体重
 */
@property (nonatomic, strong) NSString *weight;

/*!
 @property  age
 @discussion    年龄／生日
 */
@property (nonatomic, strong) NSString *age;

/*!
 @property  measurements
 @discussion    三围／bwh即胸围bust、腰围waist、臀围hips三者的合称
 */
@property (nonatomic, strong) NSString *measurements;

/*!
 @property  bust
 @discussion    三围／bwh即胸围bust、腰围waist、臀围hips三者的合称
 */
@property (nonatomic, strong) NSString *bust;
/*!
 @property  waist
 @discussion    三围／bwh即胸围bust、腰围waist、臀围hips三者的合称
 */
@property (nonatomic, strong) NSString *waist;
/*!
 @property  hips
 @discussion    三围／bwh即胸围bust、腰围waist、臀围hips三者的合称
 */
@property (nonatomic, strong) NSString *hips;

/*!
 @property  hair
 @discussion    头发
 */
@property (nonatomic, strong) NSString *hair;

/*!
 @property  leg
 @discussion    腿长
 */
@property (nonatomic, strong) NSString *leg;

/*!
 @property  feetCode
 @discussion    脚码
 */
@property (nonatomic, strong) NSString *feetCode;

/*!
 @property  area
 @discussion    地区
 */
@property (nonatomic, strong) NSString *area;

/*!
 @property  constellation
 @discussion    星座
 */
@property (nonatomic, strong) NSString *constellation;


/*!
 @property  major
 @discussion    专业
 */
@property (nonatomic, strong) NSString *major;

/*!
 @property  signName
 @discussion    个性签名
 */
@property (nonatomic, strong) NSString *signName;

/*!
 @property  workType
 @discussion    工作风格
 */
@property (nonatomic, strong) NSString *workType;

/*!
 @property  workExperience
 @discussion    工作经验
 */
@property (nonatomic, strong) NSString *workExperience;

/*!
 @property  introduction
 @discussion    个人介绍
 */
@property (nonatomic, strong) NSString *introduction;

/*!
 @property  introduction
 @discussion    工作室
 */
@property (nonatomic, strong) NSString *workPlace;

/*!
 @property  workLabel
 @discussion    工作标签
 */
@property (nonatomic, strong) NSString *workLabel;

/*!
 @property  figureLabel
 @discussion    形象标签
 */
@property (nonatomic, strong) NSString *figureLabel;


/*!
 @property  desiredSalary
 @discussion    期望薪水
 */
@property (nonatomic, strong) NSString *desiredSalary;

/*!
 @property  hasPassword
 @discussion   密码是否有值
 */
@property (nonatomic, strong) NSString * hasPassword;

/*
 @property  authentication
 @discussion   加V认证
 */
@property (nonatomic, strong) NSString *authentication;

/*
 @property phoneNumber
 @discussion 绑定手机号
 */

@property (nonatomic , strong) NSString *phoneNumber;

@end
