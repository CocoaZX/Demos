//
//  PersonPageViewModel.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/25.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "PersonPageViewModel.h"
#import "ReadPlistFile.h"

#import "McPersonalData.h"

@implementation PersonPageViewModel

- (instancetype)initWithDiction:(NSDictionary *)diction
{
    self = [super init];
    if (self) {
//        [self loadArrayWithFile];
        
        self.followNumber = [NSString stringWithFormat:@"%@",diction[@"followcount"]?diction[@"followcount"]:@""];
        self.fansNumber = [NSString stringWithFormat:@"%@",diction[@"fanscount"]?diction[@"fanscount"]:@""];
        self.timeLineNumber = [NSString stringWithFormat:@"%@",diction[@"trendscount"]?diction[@"trendscount"]:@""];
        self.photoNumber = [NSString stringWithFormat:@"%@",diction[@"mokacount"]?diction[@"mokacount"]:@""];
        self.userName = [NSString stringWithFormat:@"%@",diction[@"nickname"]?diction[@"nickname"]:@""];
        self.headerURL = [NSString stringWithFormat:@"%@",diction[@"head_pic"]?diction[@"head_pic"]:@""];
        self.authentication = [NSString stringWithFormat:@"%@",diction[@"authentication"]?diction[@"authentication"]:@""];
        self.mokaNumber = [NSString stringWithFormat:@"%@",diction[@"num"]?diction[@"num"]:@""];

        NSString *nameStr = [NSString stringWithFormat:@"%@",self.userName];
        if (nameStr.length==0) {
            nameStr = @"神秘女子";
        }
        
        
        NSString *job = [jobDict valueForKey:diction[@"job"]];
        NSString *provinceId = diction[@"province"];
        NSString *cityId = diction[@"city"];
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
        
        NSString *userType = diction[@"type"];
        NSString *typeStr = nil;
        switch ([userType integerValue]) {
            case 1:
                typeStr = @"模特";
                break;
            case 2:
                typeStr = @"摄影师";
                break;
            case 3:
                typeStr = @"化妆师";
                break;
            case 4:
                typeStr = @"经纪人";
                break;
            case 5:
                typeStr = @"其他";
                break;
                
            default:
                break;
        }
        
        NSString *sexStr = sexDict[diction[@"sex"]];
        NSString *major = [majorDict valueForKey:diction[@"major"]];
        NSString *name = [NSString stringWithFormat:@"%@  %@  %@%@  %@",sexStr?sexStr:@"",typeStr?typeStr:@"",province?province:@"",city?city:@"",job?job:@""]; //%@ ,major?major:@""
        NSString *introString = [NSString stringWithFormat:@"身高%@  体重%@kg",diction[@"height"]?diction[@"height"]:@"",diction[@"weight"]];
        self.height = [NSString stringWithFormat:@"%@",getSafeString(diction[@"height"])];
        self.weight = [NSString stringWithFormat:@"%@",getSafeString(diction[@"weight"])];
        self.sanwei = [NSString stringWithFormat:@"%@/%@/%@",diction[@"bust"],diction[@"waist"],diction[@"hipline"]];

        self.headerName = name;
        self.headerIntroduce = introString;
        
        NSString *dateStr = [SQCStringUtils compilationDate];
        NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
        NSString *yearStr = dateArray[0];
        NSString *birth = [NSString stringWithFormat:@"%@",diction[@"birth"]];
        NSArray *dateArray_dic = [birth componentsSeparatedByString:@"-"];
        NSString *yearStr_dic = dateArray_dic[0];
        NSString *ageStr = [NSString stringWithFormat:@"%d",[yearStr intValue]-[yearStr_dic intValue]];
        if ([ageStr intValue]>200||[ageStr isEqualToString:@"0"]) {
            ageStr = @"保密";
        }
        
        NSString *heightStr = [NSString stringWithFormat:@"%@",diction[@"height"]];
        if ([heightStr isEqualToString:@"0"]) {
            heightStr = @"保密";
        }
        NSString *bustStr = [NSString stringWithFormat:@"%@",diction[@"bust"]];
        if ([bustStr isEqualToString:@"0"]) {
            bustStr = @"保密";
        }
        NSString *hiplineStr = [NSString stringWithFormat:@"%@",diction[@"hipline"]];
        if ([hiplineStr isEqualToString:@"0"]) {
            hiplineStr = @"保密";
        }
        NSString *waistStr = [NSString stringWithFormat:@"%@",diction[@"waist"]];
        if ([waistStr isEqualToString:@"0"]) {
            waistStr = @"保密";
        }
        NSMutableArray *workStyleResults = @[].mutableCopy;
        NSString *workStyle = [NSString stringWithFormat:@"%@",diction[@"workstyle"]];
        if (workStyle.length>0) {
            NSArray *workStyles = [workStyle componentsSeparatedByString:@","];
            if (workStyles.count>0) {
                for (int i=0; i<workStyles.count; i++) {
                    NSString *string = [NSString stringWithFormat:@"%@",workStyles[i]];
                    if (string.length>0) {
                        [workStyleResults addObject:string];

                    }
                }
            }else
            {
                [workStyleResults addObject:workStyle];
            }
            
        }
        
        NSMutableArray *workTagsResult = @[].mutableCopy;
        NSString *workTag = [NSString stringWithFormat:@"%@",diction[@"worktags"]];
        if (workTag.length>0) {
            NSArray *workTags = [workTag componentsSeparatedByString:@","];
            if (workTags.count>0) {
                for (int i=0; i<workTags.count; i++) {
                    NSString *string = [NSString stringWithFormat:@"%@",workTags[i]];
                    if (string.length>0) {
                        [workTagsResult addObject:string];

                    }
                }
            }else
            {
//                [workTagsResult addObject:workTag];
            }
            
        }
        
        NSString *workExp = [NSString stringWithFormat:@"%@",diction[@"workhistory"]];

        NSMutableArray *faceTagsMutableArray = [SingleData shareSingleData].styleLabelTagsArray;
        
        if (!faceTagsMutableArray) {
//            [[SingleData shareSingleData] getOnlineTagsData];
            faceTagsMutableArray = [SingleData shareSingleData].styleLabelTagsArray;
        }

        NSMutableString *workStyleString = @"".mutableCopy;
        
        for (int i=0; i<workStyleResults.count; i++) {
            NSString *styleKey = workStyleResults[i];
            if (!styleKey) {
                styleKey = @"0";
            }
            NSString *value = nil;
            for (int k=0; k<faceTagsMutableArray.count; k++) {
                NSDictionary *diction = faceTagsMutableArray[k];
                NSString *theType = diction[@"id"];
                if ([theType isEqualToString:styleKey]) {
                    value = diction[@"name"];
                }
            }
            if (!value) {
                value = styleKey;
                
            }
            if (i==0) {
                [workStyleString appendFormat:@"%@",value];
            }else
            {
                [workStyleString appendFormat:@",%@",value];
                
            }
            [workStyleResults replaceObjectAtIndex:i withObject:value];
        }
        if (workStyleString.length<3) {
            workStyleString = @"保密".mutableCopy;
        }
//        self.shareDesc = [NSString stringWithFormat:@"年龄/%@ %@ %@%@ %@ 身高/%@ 胸围/%@ 臀围/%@ 腰围/%@点击查看",ageStr,job?job:@"保密",province?province:@"保密",city?city:@"保密",workStyleString,heightStr,bustStr,hiplineStr,waistStr];
        self.shareDesc = [NSString stringWithFormat:@"%@",diction[@"introduction"]];
        
        NSMutableArray *workMutableArray = [SingleData shareSingleData].workTagsArray;
        if (!workMutableArray) {
//            [[SingleData shareSingleData] getOnlineTagsData];
            workMutableArray = [SingleData shareSingleData].workTagsArray;
        }
        
        for (int i=0; i<workTagsResult.count; i++) {
            NSString *styleKey = workTagsResult[i];
            if (!styleKey) {
                styleKey = @"0";
            }
            NSString *value = nil;
            for (int k=0; k<workMutableArray.count; k++) {
                NSDictionary *diction = workMutableArray[k];
                NSString *theType = diction[@"id"];
                if ([theType isEqualToString:styleKey]) {
                    value = diction[@"name"];
                }
            }

            if (!value) {
                value = styleKey;
            }
            [workTagsResult replaceObjectAtIndex:i withObject:value];
        }

        
        NSString *height = [NSString stringWithFormat:@"身高/%@",diction[@"height"]];
        NSString *weight = [NSString stringWithFormat:@"体重/%@",diction[@"weight"]];
        NSString *bust = [NSString stringWithFormat:@"胸围/%@",diction[@"bust"]];
        NSString *hipline = [NSString stringWithFormat:@"臀围/%@",diction[@"hipline"]];
        NSString *waist = [NSString stringWithFormat:@"腰围/%@",diction[@"waist"]];
        NSString *foot = [NSString stringWithFormat:@"脚码/%@",[[feetDict allKeysForObject:diction[@"foot"]] firstObject]?[[feetDict allKeysForObject:diction[@"foot"]] firstObject]:@"保密"];
        NSString *hair = [NSString stringWithFormat:@"%@",diction[@"hair"]];
        //[[hairDict allKeysForObject:hair] firstObject]  hairDict[hair]
        NSString *hairName = [NSString stringWithFormat:@"头发/%@",[[hairDict allKeysForObject:hair] firstObject]?[[hairDict allKeysForObject:hair] firstObject]:@"保密"];
        
        NSString *money = [NSString stringWithFormat:@"费用/%@",diction[@"payment"]?diction[@"payment"]:@"保密"];
        NSString *majorstr = [NSString stringWithFormat:@"专业/%@",major?major:@"保密"];
        NSArray *personInfor = @[height,weight,bust,hipline,waist,foot,hairName,money,majorstr];
        NSArray *personInfoStatus = @[[NSNumber numberWithInteger:McPersonalTypeHeight],
                                      [NSNumber numberWithInteger:McPersonalTypeWeight],
                                      [NSNumber numberWithInteger:McPersonalTypeBwh],
                                      [NSNumber numberWithInteger:McPersonalTypeBwh],
                                      [NSNumber numberWithInteger:McPersonalTypeBwh],
                                      [NSNumber numberWithInteger:McPersonalTypeFoot],
                                      [NSNumber numberWithInteger:McPersonalTypeHair],
                                      [NSNumber numberWithInteger:McPersonalTypeDesiredSalary],
                                      [NSNumber numberWithInteger:McPersonalTypeMajor]];

        NSDictionary *dictionTemp = @{@"personInfor":personInfor,@"workExp":workExp,@"workStyleResults":workStyleResults.copy,@"workTagsResult":workTagsResult.copy,@"infoStatus":personInfoStatus};//添加status
        self.pictureViewDiction = dictionTemp;
        
        NSString *isFollow = [NSString stringWithFormat:@"%@",diction[@"isfollow"]?diction[@"isfollow"]:0];
        self.isFollowed = [isFollow boolValue];
       
        NSString *isBlack = [NSString stringWithFormat:@"%@",diction[@"isblack"]?diction[@"isblack"]:0];
        self.isBlack = [isBlack boolValue];
        
        
        NSMutableDictionary *dictMutable = [[NSMutableDictionary alloc] init];
        [dictMutable setValue:nameStr forKey:@"nickname"];
        
        NSDictionary *shareDict = [USER_DEFAULT valueForKey:MOKA_SHARE_VALUE];
        if ([shareDict isKindOfClass:[NSDictionary class]]) {
            NSString *title = [self stringFromString:shareDict[@"title"] WithDictionary:diction];
            
            self.shareTitle = [title stringByReplacingOccurrencesOfString:@"%}" withString:@""];
            NSString *dec = [self stringFromString:shareDict[@"description"] WithDictionary:diction];
            
            self.shareDesc = [dec stringByReplacingOccurrencesOfString:@"%}" withString:@""];
        }
    }
    return self;
}

- (NSString *)getCutHeaderURLWithView:(UIImageView *)imgView
{
    NSInteger wid = CGRectGetWidth(imgView.frame) * 2;
    NSInteger hei = CGRectGetHeight(imgView.frame) * 2;
    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
    NSString *url = [NSString stringWithFormat:@"%@%@",self.headerURL,jpg];
    return url;
}

- (NSString *)getShareURLWithUid:(NSString *)uid
{
    NSString *shareURL = [NSString stringWithFormat:@"http://test.q8oils.cc/u/%@",uid];
    return shareURL;
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
//    
//    feetDict = [ReadPlistFile readFeets];
    
}

- (NSString *)stringFromString:(NSString *)str WithDictionary:(NSDictionary *)diction
{
    NSMutableString *mutableStr = [NSMutableString stringWithString:@""];
    //fangfa 1
    NSArray *arr = [str componentsSeparatedByString:@"{%"];
    for (NSString *oneStr in arr) {
        NSRange ange = [oneStr rangeOfString:@"%}"];
        if (ange.length > 0) {
            NSString *indexStr = [oneStr substringToIndex:ange.location];
            if(indexStr.length > 0){
                NSString *valueStr = [self changeStringWithKey:indexStr WithDictionary:diction];
                [mutableStr appendString:[oneStr stringByReplacingOccurrencesOfString:indexStr withString:valueStr]];
            }
        }
        else{
           [mutableStr appendString:oneStr];
        }
    }
    
    return mutableStr;
}

- (NSString *)changeStringWithKey:(NSString *)key WithDictionary:(NSDictionary *)diction
{
    if ([key isEqualToString:@"province"]) {
        NSString *provinceId = diction[@"province"];
        NSString *province = @"";
       
        for (NSDictionary *dicts in areaArray) {
            if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
                province = dicts[@"name"];
                
            }
        }
        return province;
    }
    else if([key isEqualToString:@"city"]){
        NSString *provinceId = diction[@"province"];
        NSString *cityId = diction[@"city"];
        NSString *city = @"";
        for (NSDictionary *dicts in areaArray) {
            if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
                
                NSArray *citys = dicts[@"citys"];
                for (NSDictionary *cityDict in citys) {
                    if ([cityDict[@"id"] integerValue] == [cityId integerValue]) {
                        city = cityDict[@"name"];
                    }
                }
            }
        }
        return city;
    }
    else if([key isEqualToString:@"sex"]){
        return sexDict[diction[@"sex"]]?sexDict[diction[@"sex"]]:@"保密";
    }
    else if([key isEqualToString:@"major"]){
        return [majorDict valueForKey:diction[@"major"]]?[majorDict valueForKey:diction[@"major"]]:@"保密";
    }
    else if([key isEqualToString:@"job"]){
        return [jobDict valueForKey:diction[@"job"]]?[jobDict valueForKey:diction[@"job"]]:@"保密";
    }
    else if([key isEqualToString:@"workstyle"]){
        NSMutableArray *workStyleResults = @[].mutableCopy;
        NSString *workStyle = [NSString stringWithFormat:@"%@",diction[@"workstyle"]];
        if (workStyle.length>0) {
            NSArray *workStyles = [workStyle componentsSeparatedByString:@","];
            if (workStyles.count>0) {
                for (int i=0; i<workStyles.count; i++) {
                    NSString *string = [NSString stringWithFormat:@"%@",workStyles[i]];
                    if (string.length>0) {
                        [workStyleResults addObject:string];
                        
                    }
                }
            }else
            {
                [workStyleResults addObject:workStyle];
            }
        }
        
        NSMutableArray *faceTagsMutableArray = [SingleData shareSingleData].styleLabelTagsArray;
        
        NSMutableString *workStyleString = @"".mutableCopy;
        for (int i=0; i<workStyleResults.count; i++) {
            NSString *styleKey = workStyleResults[i];
            if (!styleKey) {
                styleKey = @"0";
            }
            NSString *value = nil;
            for (int k=0; k<faceTagsMutableArray.count; k++) {
                NSDictionary *diction = faceTagsMutableArray[k];
                NSString *theType = diction[@"id"];
                if ([theType isEqualToString:styleKey]) {
                    value = diction[@"name"];
                }
            }
            if (!value) {
                value = styleKey;
                
            }
            if (i==0) {
                [workStyleString appendFormat:@"%@",value];
            }else
            {
                [workStyleString appendFormat:@",%@",value];
                
            }
            [workStyleResults replaceObjectAtIndex:i withObject:value];
        }
        if (workStyleString.length < 1) {
            workStyleString = @"保密".mutableCopy;
        }
        return workStyleString;
    }
    else if([key isEqualToString:@"worktags"]){
        NSMutableArray *workTagsResult = @[].mutableCopy;
        NSString *workTag = [NSString stringWithFormat:@"%@",diction[@"worktags"]];
        if (workTag.length>0) {
            NSArray *workTags = [workTag componentsSeparatedByString:@","];
            if (workTags.count>0) {
                for (int i=0; i<workTags.count; i++) {
                    NSString *string = [NSString stringWithFormat:@"%@",workTags[i]];
                    if (string.length>0) {
                        [workTagsResult addObject:string];
                        
                    }
                }
            }
            
        }
        NSMutableArray *workMutableArray = [SingleData shareSingleData].workTagsArray;
        
        for (int i=0; i<workTagsResult.count; i++) {
            NSString *styleKey = workTagsResult[i];
            if (!styleKey) {
                styleKey = @"0";
            }
            NSString *value = nil;
            for (int k=0; k<workMutableArray.count; k++) {
                NSDictionary *diction = workMutableArray[k];
                NSString *theType = diction[@"id"];
                if ([theType isEqualToString:styleKey]) {
                    value = diction[@"name"];
                }
            }
            
            if (!value) {
                value = styleKey;
            }
            [workTagsResult replaceObjectAtIndex:i withObject:value];
        }
    }
    else if([key isEqualToString:@"hair"]){
        NSString *hair = [NSString stringWithFormat:@"%@",diction[@"hair"]];
        return [[hairDict allKeysForObject:hair] firstObject]?[[hairDict allKeysForObject:hair] firstObject]:@"保密";
    }
    else if([key isEqualToString:@"foot"]){
        return [[feetDict allKeysForObject:diction[@"foot"]] firstObject]?[[feetDict allKeysForObject:diction[@"foot"]] firstObject]:@"保密";
    }
    else if ([key isEqualToString:@"type"]){
        NSString *userType = diction[@"type"];
        NSString *typeStr = nil;
        switch ([userType integerValue]) {
            case 1:
                typeStr = @"模特";
                break;
            case 2:
                typeStr = @"摄影师";
                break;
            case 3:
                typeStr = @"化妆师";
                break;
            case 4:
                typeStr = @"经纪人";
                break;
            case 5:
                typeStr = @"其他";
                break;
                
            default:
                break;
        }
        return typeStr;
    }
    
    
    return diction[key];
}

@end
