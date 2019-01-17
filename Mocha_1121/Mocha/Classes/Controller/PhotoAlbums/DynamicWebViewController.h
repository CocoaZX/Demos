//
//  DynamicWebViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/25.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "McBaseWebViewController.h"
@interface DynamicWebViewController : McBaseWebViewController

//-------本界面的使用类型
//showDynamic 展示动态模卡
//createDynamic 创建动态模卡
@property(nonatomic,copy)NSString *conditionType;

//进入本界面的上一个界面的名字
@property(nonatomic,copy)NSString *fromVCName;


//进入本界面使用的网址
@property(nonatomic,copy)NSString *linkUrl;


//-------制作动态模卡
//图片ids数组
@property(nonatomic,strong)NSArray *photoIds;


//------显示动态moka
@property(nonatomic,strong)NSDictionary *dynamicDic;
//封面图片
@property(nonatomic,strong)UIImage *dynamicCoverImg;
//封面图片的链接
@property(nonatomic,strong)UIImage *dynamicCoverImgUrl;
//当前动态moka的主人的id
@property(nonatomic,copy)NSString *currentUid;


@end
