//
//  PhotoBrowseViewController.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/11.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McMainFeedViewController.h"

@interface PhotoBrowseViewController : UIViewController


@property (nonatomic, assign) NSUInteger startWithIndex;

@property (nonatomic, strong) NSString *currentUid;

@property (nonatomic, strong) NSString *isNeedShangView;

@property (nonatomic, assign) BOOL isCurrentUser;

@property (nonatomic, copy) NSString *currentName;

@property (nonatomic, strong) NSString *lastIndexId;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic , assign)int isHeader;
@property (nonatomic ,strong )McMainFeedViewController *superVC;


//是否一单进入界面就显示打赏
@property (nonatomic,assign)BOOL firstShowDaShang;
//是否需要显示模糊
@property(nonatomic,assign)BOOL needBlurry;

//相册ID
@property (nonatomic,copy)NSString *albumID;
//相册详情
@property (nonatomic,strong)NSDictionary *albumDic;
//相册打赏相关信息
@property(nonatomic,strong)NSDictionary *albumSettingDic;

//模卡
- (void)setDataFromMokaWithUid:(NSString *)uid;

//动态
- (void)setDataFromTimeLineWithUid:(NSString *)uid andArray:(NSMutableArray *)array;

//关注
- (void)setDataFromCollectionWithUid:(NSString *)uid;

//影集
- (void)setDataFromYingJiWithUid:(NSString *)uid andArray:(NSMutableArray *)array;

//热门动态
- (void)setDataFromFeedArray:(NSArray *)array;

//个人动态
- (void)setDataFromFeedArray_person:(NSArray *)array;

//统一入口
- (void)setDataFromPhotoId:(NSString *)photoId uid:(NSString *)uid;

//统一入口 array
- (void)setDataFromPhotoId:(NSString *)photoId uid:(NSString *)uid withArray:(NSArray *)array;






@end
