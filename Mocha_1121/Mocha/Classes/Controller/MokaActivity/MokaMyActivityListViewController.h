//
//  MokaMyActivityListViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/2/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface MokaMyActivityListViewController :McBaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//集合视图
@property (nonatomic,strong)UICollectionView *collectionView;

//显示的活动类型:0.我参加 1.我发布
@property(nonatomic,copy)NSString *activityType;

//是我发布的活动
@property(nonatomic,assign)BOOL isMyPublishAT;

//底部视图控制器
@property(nonatomic,strong)UINavigationController *superNVC;


@end
