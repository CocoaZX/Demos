//
//  XiangCeCollectionTableViewCell.h
//  Mocha
//
//  Created by zhoushuai on 16/5/6.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiangCeCollectionTableViewCell : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic,weak)UIViewController *superVC;

//相册数据源
@property(nonatomic,strong)NSArray *dataArray;

//是否是主人
@property(nonatomic,assign)BOOL isMaster;
//当前id
@property(nonatomic,copy)NSString *currentUID;

//顶部标题
@property(nonatomic,strong)UIView *topView;
//集合视图
@property(nonatomic,strong)UICollectionView *collectionView;



+(CGFloat)getXiangCeTableViewCellHeight:(NSArray *)array;

@end
