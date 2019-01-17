//
//  DynamicAlbumsViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/21.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface DynamicAlbumsViewController : McBaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//集合视图
@property (nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,copy)NSString *currentUid;

@end
