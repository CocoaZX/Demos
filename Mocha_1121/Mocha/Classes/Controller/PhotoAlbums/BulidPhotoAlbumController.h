//
//  BulidPhotoAlbumController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/14.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface BulidPhotoAlbumController : McBaseViewController
//滑动视图
@property(nonatomic,strong)UIScrollView *mainScrollView;

//金币字符串
@property(nonatomic,copy)NSString *goldCountStr;

//是否是为了编辑
@property(nonatomic,assign)BOOL isEdit;
//编辑相册传入的相册信息
@property(nonatomic,strong)NSDictionary *albumDic;
//相册ID
@property(nonatomic,copy)NSString *albumID;

@end
