//
//  PersonPageViewModel.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/25.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonPageViewModel : NSObject
{
    NSDictionary *sexDict;
    NSDictionary *jobDict;
    NSArray *areaArray;
    NSDictionary *hairDict;
    NSDictionary *majorDict;
    NSDictionary *workTagDict;
    NSDictionary *figureTagDict;
    NSDictionary *feetDict;
}

//头部信息
@property (nonatomic, strong) NSString *followNumber;
@property (nonatomic, strong) NSString *fansNumber;
@property (nonatomic, strong) NSString *timeLineNumber;
@property (nonatomic, strong) NSString *photoNumber;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *headerURL;
@property (nonatomic, strong) NSString *headerName;
@property (nonatomic, strong) NSString *headerIntroduce;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) BOOL isBlack;
@property (nonatomic, strong) NSString *mokaNumber;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *sanwei;
//微信
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, strong) NSString *authentication;
//个人资料
@property (nonatomic, strong) NSDictionary *pictureViewDiction;

- (instancetype)initWithDiction:(NSDictionary *)diction;

- (NSString *)getCutHeaderURLWithView:(UIImageView *)imgView;

- (NSString *)getShareURLWithUid:(NSString *)uid;

@end
