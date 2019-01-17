//
//  AcutionTableCell.h
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcutionTableCell : UITableViewCell
//xib组件
//竞拍进度详情
@property (weak, nonatomic) IBOutlet UILabel *acutionInfoLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//详情
@property (weak, nonatomic) IBOutlet UILabel *AcutionDetailLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;



@property(nonatomic,strong)NSDictionary *dataDic;


+ (AcutionTableCell *)getAcutionTableCell;

@end
