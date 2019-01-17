//
//  MokaPhotosViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface MokaPhotosViewController : McBaseViewController

//当前用户的ID
@property(nonatomic,copy)NSString *currentUID;
//相册ID
@property(nonatomic,copy)NSString *albumID;
//页面标题
@property(nonatomic,copy)NSString *currentTitle;


//最多和最少选择张数
@property(nonatomic,assign)NSInteger maxSelectCount;
@property(nonatomic,assign)NSInteger minSelectCount;

//使用该界面类型:
//选择相册照片删除：deletePrivacyPhoto
//选取动态里的照片制作动态模卡：dynamicMoka
@property(nonatomic,copy)NSString *conditionType;


@end
