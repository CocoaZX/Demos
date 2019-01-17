//
//  GoodsForPhotoDetailCell.h
//  Mocha
//
//  Created by TanJian on 16/3/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsForPhotoDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

+ (GoodsForPhotoDetailCell *)getGoodsCell;
- (void)setCellWithDict:(NSDictionary *)dict;
- (void)setCellWithDictForMyGoodsList:(NSDictionary *)dict;
@end
