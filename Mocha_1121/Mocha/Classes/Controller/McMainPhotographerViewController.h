//
//  McMainPhotographerViewController.h
//  Mocha
//
//  Created by zhoushuai on 15/11/10.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "BaseMcMainViewController.h"

@interface McMainPhotographerViewController : BaseMcMainViewController

@property(nonatomic , strong)UICollectionView *collectionView;

//摄影师界面横向滚动条目类别
@property (nonatomic,copy)NSString *typeID;
//摄影师界面横向滚动条目列表名
@property (nonatomic,copy)NSString *workStyleID;


@end
