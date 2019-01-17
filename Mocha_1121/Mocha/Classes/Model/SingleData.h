//
//  SingleData.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/11.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleData : NSObject

@property (nonatomic, strong) NSMutableArray *hotLabelTagsArray;
@property (nonatomic, strong) NSMutableArray *professionLabelTagsArray;
@property (nonatomic, strong) NSMutableArray *majorTagsArray;
@property (nonatomic, strong) NSMutableArray *brandLabelTagsArray;
@property (nonatomic, strong) NSMutableArray *styleLabelTagsArray;
@property (nonatomic, strong) NSMutableArray *hairTagsArray;
@property (nonatomic, strong) NSMutableArray *workTagsArray;
@property (nonatomic, strong) NSMutableArray *footsizeTagsArray;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *otherPhotoArray;

@property (nonatomic, assign) BOOL isForceUpdate;

@property (nonatomic, assign) BOOL isFromPaiZhao;

@property (nonatomic, assign) int currnetImageType;

@property (nonatomic, assign) BOOL isFromPersonalPage;

@property (nonatomic, assign) BOOL isFromeShare;

@property (nonatomic, assign) BOOL isAppearRedPoint;

@property (nonatomic, assign) BOOL isFromePay;

@property (nonatomic, assign) BOOL isInThePhotoDetail;

+ (SingleData *)shareSingleData;

- (void)getOnlineTagsData;

- (void)submitIDFV;

@end
