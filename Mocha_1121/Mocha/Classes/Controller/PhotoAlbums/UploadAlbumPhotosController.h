//
//  UploadAlbumPhotosController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface UploadAlbumPhotosController : McBaseViewController

@property(nonatomic,copy)NSString *albumID;

@property(nonatomic,copy)NSString *currentTitle;

@property(nonatomic,copy)NSString *currentUID;

//是否私密
@property(nonatomic,assign)BOOL is_private;

@property(nonatomic,strong)NSString *fromVCName;

//不需要重新加载数据
@property(nonatomic,assign)BOOL notNeedReload;


@end
