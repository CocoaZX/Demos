//
//  BrowseAlbumPhotosController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface BrowseAlbumPhotosController : McBaseViewController


@property(nonatomic,copy)NSString *albumID;

@property(nonatomic,copy)NSString *currentTitle;

@property(nonatomic,copy)NSString *currentUID;
//相册本身是否有私密性
@property(nonatomic,assign)BOOL is_private;

@end
