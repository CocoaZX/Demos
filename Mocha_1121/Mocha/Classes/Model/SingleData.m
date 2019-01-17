//
//  SingleData.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/11.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "SingleData.h"
#import "JSONKit.h"
#import <AdSupport/AdSupport.h>
@implementation SingleData


SingleData *datasingle = nil;
+ (SingleData *)shareSingleData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datasingle = [[SingleData alloc] init];
        datasingle.photoArray = @[].mutableCopy;
        datasingle.otherPhotoArray = @[].mutableCopy;
    });
    return datasingle;
}

- (void)getOnlineTagsData
{
    NSDictionary *param = [AFParamFormat formatSystemFeedBackParams:@{}];

    [AFNetwork getUserAttrlist:param success:^(id data) {
        NSMutableArray *dataArray = @[].mutableCopy;
        
        id returnObj = data[@"data"];
        
        if ([returnObj isKindOfClass:[NSArray class]]) {
            dataArray = returnObj;
        }else if ([returnObj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *tagsDic = returnObj;
            NSArray *allKeys = tagsDic.allKeys;
            for (int i=0; i<allKeys.count; i++) {
                NSString *keyString = allKeys[i];
                NSDictionary *dict = tagsDic[keyString];
                [dataArray addObject:dict];
            }
            
        }
        
        
        for (int i=0; i<dataArray.count; i++) {
            NSDictionary *diction = dataArray[i];
            NSString *dicId = [NSString stringWithFormat:@"%@",diction[@"id"]];
            id what = diction[@"list"];
            NSMutableArray *targetArray = @[].mutableCopy;
            if ([what isKindOfClass:[NSDictionary class]]) {
                NSDictionary *tagsDic = diction[@"list"];
                NSArray *allKeys = tagsDic.allKeys;
                for (int i=0; i<allKeys.count; i++) {
                    NSString *keyString = allKeys[i];
                    NSDictionary *dict = tagsDic[keyString];

                    [targetArray addObject:dict];
                }
                
            }else if([what isKindOfClass:[NSArray class]])
            {
                targetArray = [NSMutableArray arrayWithArray:what];
            }
            if ([dicId isEqualToString:@"4"]) {
                self.styleLabelTagsArray = targetArray;

            }
            if ([dicId isEqualToString:@"3"]) {
                self.hairTagsArray = targetArray;
                
            }
            if ([dicId isEqualToString:@"5"]) {
                self.workTagsArray = targetArray;
                
            }
            if ([dicId isEqualToString:@"6"]) {
                self.professionLabelTagsArray = targetArray;
                
            }
            if ([dicId isEqualToString:@"7"]) {
                self.majorTagsArray = targetArray;
                
            }
            if ([dicId isEqualToString:@"1"]) {
                self.footsizeTagsArray = targetArray;
                
            }
            
        }
        
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)submitIDFV
{
//    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSDictionary *diction = [AFParamFormat formatPostIdfa:idfa];
    [AFNetwork uploadIdfv:diction success:^(id data) {
        NSString *status = [NSString stringWithFormat:@"%@",data[@"status"]];
        if ([status isEqualToString:@"8002"]&&[status isEqualToString:@"1"]) {
            [self performSelector:@selector(submitIDFV) withObject:nil afterDelay:60.0f];
        }
        
    } failed:^(NSError *error) {
        
    }];
}


@end
