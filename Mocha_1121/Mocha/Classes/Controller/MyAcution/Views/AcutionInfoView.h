//
//  AcutionInfoView.h
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcutionInfoView : UIView

//竞拍进度显示
@property (weak, nonatomic) IBOutlet UILabel *acutionInfoLabel;
//显示时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//图片展示
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//显示详情Label
@property (weak, nonatomic) IBOutlet UILabel *auctionDetailLabel;
//显示价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property(nonatomic,strong) IBOutlet UIView* view;


//数据源
@property(nonatomic,strong)NSDictionary *dataDic;


@end
