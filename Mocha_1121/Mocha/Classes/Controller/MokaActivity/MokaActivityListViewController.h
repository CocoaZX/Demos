//
//  MokaActivityListViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"
@interface MokaActivityListViewController : McBaseViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//集合视图
@property (nonatomic,strong)UICollectionView *collectionView;


@end
