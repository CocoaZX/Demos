//
//  PrivacySettingViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/14.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "BulidPhotoAlbumController.h"
@interface PrivacySettingViewController : McBaseViewController


@property(nonatomic,strong)BulidPhotoAlbumController *superVC;

//金币个数字符串
@property(nonatomic,copy)NSString *goldCountStr;

//选中金币的索引
@property(nonatomic,assign)NSInteger goldSelectedIndex;

@end
