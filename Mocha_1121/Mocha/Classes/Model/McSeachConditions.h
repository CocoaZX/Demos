//
//  McSeachConditions.h
//  Mocha
//
//  Created by renningning on 14-12-2.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    McFiltersTypeNone,
    McFiltersTypeArea,
    McFiltersTypeSex,
    McFiltersTypeAge,
    McFiltersTypeHeight,
    McFiltersTypeWeight,
    McFiltersTypeJob,
    McFiltersTypeBust,
    McFiltersTypeWaist,
    McFiltersTypeHipline,
    McFiltersTypeFoot,
    McFiltersTypeHair,
    McFiltersTypeLeg,
    McFiltersTypeDesiredSalary,
    McFiltersTypeWorkTags,
    McFiltersTypeFigureTags,
    McFiltersTypeUserType
}McFiltersType;


@interface McSeachConditions : NSObject

/*!
 @property  nickName
 @discussion    昵称
 */
@property (nonatomic, strong) NSString *nickName;

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
 @discussion    身高 (范围)
 */
@property (nonatomic, strong) NSString *height;

/*!
 @property  weight
 @discussion    体重 (范围)
 */
@property (nonatomic, strong) NSString *weight;

/*!
 @property  age
 @discussion    年龄／生日 (范围)
 */
@property (nonatomic, strong) NSString *age;

/*!
 @property  bust
 @discussion  三围／bwh即胸围bust、腰围waist、臀围hips三者的合称 (范围)
 */
@property (nonatomic, strong) NSString *bust;
/*!
 @property  waist
 @discussion    腰围 (范围)
 */
@property (nonatomic, strong) NSString *waist;
/*!
 @property  hips
 @discussion   臀围 (范围)
 */
@property (nonatomic, strong) NSString *hips;

/*!
 @property  hair
 @discussion    头发 (范围)
 */
@property (nonatomic, strong) NSString *hair;

/*!
 @property  leg
 @discussion    腿长 (范围)
 */
@property (nonatomic, strong) NSString *leg;

/*!
 @property  foot
 @discussion    脚码 (范围)
 */
@property (nonatomic, strong) NSString *foot;

/*!
 @property  area
 @discussion    地区
 */
@property (nonatomic, strong) NSString *area;

/*!
 @property  workTags
 @discussion    工作标签
 */
@property (nonatomic, strong) NSString *workTags;

/*!
 @property  figureTags
 @discussion    形象标签
 */
@property (nonatomic, strong) NSString *figureTags;

/*!
 @property  desiredSalary
 @discussion    期望薪水 (范围)
 */
@property (nonatomic, strong) NSString *desiredSalary;


/*!
 @property  userType
 @discussion    用户类型
 */
@property (nonatomic, strong) NSString *userType;

@end
