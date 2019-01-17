//
//  PersonPageDetailViewModel.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/31.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "PersonPageDetailViewModel.h"
#import "ReadPlistFile.h"

@implementation PersonPageDetailViewModel

- (instancetype)initWithDiction:(NSDictionary *)diction
{
    self = [super init];
    if (self) {
//        [self loadArrayWithFile];
        
        self.likeusers = diction[@"likeusers"];
        self.rewardUsers = diction[@"rewardUsers"];
        self.goodsUserCount = diction[@"info"][@"goodsuserCount"];
        
        
        
        NSDictionary *photoDic = diction[@"info"];
        
        self.photoDic = photoDic;
        NSDictionary *userDic = diction[@"user"];
        
        NSString *provinceId = userDic[@"province"]?userDic[@"province"]:@"";
        NSString *cityId = userDic[@"city"]?userDic[@"city"]:@"";
        NSString *province = @"";
        NSString *city = @"";
        for (NSDictionary *dicts in areaArray) {
            if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
                province = dicts[@"name"];
                NSArray *citys = dicts[@"citys"];
                for (NSDictionary *cityDict in citys) {
                    if ([cityDict[@"id"] integerValue] == [cityId integerValue]) {
                        city = cityDict[@"name"];
                    }
                }
            }
        }
        NSString *sexStr = sexDict[userDic[@"sex"]?userDic[@"sex"]:@""];
        NSString *type = [jobDict valueForKey:userDic[@"job"]?userDic[@"job"]:@""];
        NSString *major = [majorDict valueForKey:userDic[@"major"]?userDic[@"major"]:@""];
        NSString *desc = [NSString stringWithFormat:@"%@ %@%@ %@ %@",sexStr,province,city,type?type:@"",major?major:@""];
        NSString *headURL = [NSString stringWithFormat:@"%@",userDic[@"head_pic"]?userDic[@"head_pic"]:@""];
        NSString *name = [NSString stringWithFormat:@"%@",userDic[@"nickname"]?userDic[@"nickname"]:@""];
        self.headerURL = headURL;
        self.headerName = name;
        self.headerDescription = desc;
        
        
        self.userId = [NSString stringWithFormat:@"%@",userDic[@"id"]];
        self.contentImageURL = photoDic[@"url"]?photoDic[@"url"]:@"";
#warning changeCDN
        self.coverImageUrl = getSafeString(photoDic[@"cover_url"]);
        self.themeString = getSafeString(diction[@"feedType"]?diction[@"feedType"]:@"");
        self.tagString = photoDic[@"url"]?photoDic[@"url"]:@"";
        
        self.titleString = getSafeString(photoDic[@"title"]);
        self.object_type = getSafeString(photoDic[@"object_type"]);
        
        self.islike = [NSString stringWithFormat:@"%@",photoDic[@"islike"]?photoDic[@"islike"]:@""];
        self.isfavorite = [NSString stringWithFormat:@"%@",photoDic[@"isfavorite"]?photoDic[@"isfavorite"]:@""];
        self.isRewarded = [NSString stringWithFormat:@"%@",photoDic[@"isRewarded"]?photoDic[@"isRewarded"]:@""];
        self.rewardAmount = [NSString stringWithFormat:@"%@",photoDic[@"rewardAmount"]];
        self.totalReward = [NSString stringWithFormat:@"%@",photoDic[@"totalReward"]];
        self.totalRewardUser = [NSString stringWithFormat:@"%@",photoDic[@"rewarduserCount"]];
        self.view_number = [NSString stringWithFormat:@"浏览%@",photoDic[@"view_number"]];

        self.timeString = [CommonUtils dateTimeIntervalString:photoDic[@"createline"]?photoDic[@"createline"]:@""];
        self.width = [NSString stringWithFormat:@"%@",photoDic[@"width"]];
        self.height = [NSString stringWithFormat:@"%@",photoDic[@"height"]];
        self.scaleHeight = (kScreenWidth/[self.width intValue])*[self.height intValue];
        
    }
    return self;
}

- (void)loadArrayWithFile
{
    sexDict = [ReadPlistFile readSex];
    
    areaArray = [ReadPlistFile readAreaArray];
    
//    workTagDict = [ReadPlistFile readWorkTags];
//    
//    figureTagDict = [ReadPlistFile readWorkStyles];
//    
//    hairDict = [ReadPlistFile readHairs];
//    
//    jobDict = [ReadPlistFile readProfession];
//    
//    majorDict = [ReadPlistFile readMajor];
    
}

- (NSString *)getCutHeaderURLWithView:(UIImageView *)imgView
{
    NSInteger wid = CGRectGetWidth(imgView.frame) * 2;
    NSInteger hei = CGRectGetHeight(imgView.frame) * 2;
    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
    NSString *url = [NSString stringWithFormat:@"%@%@",self.headerURL,jpg];
    return url;
}

@end
