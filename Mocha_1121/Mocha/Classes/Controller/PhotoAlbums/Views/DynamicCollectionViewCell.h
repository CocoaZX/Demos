//
//  DynamicCollectionViewCell.h
//  Mocha
//
//  Created by zhoushuai on 16/4/21.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



//数据源
@property(nonatomic,strong)NSDictionary *dataDic;
//单元格索引
@property(nonatomic,strong)NSIndexPath *indexPath;
//所在视图控制器
@property(nonatomic,weak)UIViewController *superVC;

//动态模卡的主人
@property(nonatomic,copy)NSString *currentUid;


@end
