//
//  McProvinceViewController.h
//  Mocha
//
//  Created by renningning on 14-12-4.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseTableViewController.h"
#import "McPersonalData.h"
#import "McSeachConditions.h"
#import "McEventInfo.h"

@interface McProvinceViewController : McBaseTableViewController

@property (nonatomic, strong) McEventInfo *eventInfo;
@property (nonatomic, strong) McPersonalData *personalData;
@property (nonatomic, strong) McSeachConditions *filterData;
@property (nonatomic, strong) NSMutableDictionary *paramsDictionary; //组合参数

//区别：编辑和筛选
@property (nonatomic, assign) NSInteger editOrSearch;
//是否显示不限
@property (nonatomic, assign) BOOL isbuxian;

//回调的block
@property (nonatomic, copy) ChangeFinishBlock returenBlock;

//做名称标记区分，最开始需要显示地区列表，是哪个视图控制器发起的
@property (nonatomic,copy)NSString *sourceVCName;

- (void)setCallBack:(ChangeFinishBlock)block;


@end
