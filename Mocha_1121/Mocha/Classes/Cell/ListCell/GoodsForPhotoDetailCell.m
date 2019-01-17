//
//  GoodsForPhotoDetailCell.m
//  Mocha
//
//  Created by TanJian on 16/3/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "GoodsForPhotoDetailCell.h"

@implementation GoodsForPhotoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (GoodsForPhotoDetailCell *)getGoodsCell
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GoodsForPhotoDetailCell" owner:self options:nil];
    GoodsForPhotoDetailCell *cell = nibs[0];
    cell.headImg.layer.cornerRadius = 19;
    cell.headImg.clipsToBounds = YES;
    cell.nickNameLable.textColor = [UIColor colorForHex:kLikeGrayTextColor];

//    UIView *lineImageView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 0.5)];
//    lineImageView.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
//    [cell addSubview:lineImageView];

    return cell;
}


- (void)setCellWithDict:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    
    NSString *urlString = dict[@"goodUser"][@"head_pic"];
    [self.headImg setImageWithURL:[NSURL URLWithString:urlString?urlString:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nickNameLable.text = dict[@"goodUser"][@"nickname"];
    
    //设置会员昵称颜色
     NSString *isMember = [NSString stringWithFormat:@"%@",getSafeString(dict[@"goodUser"][@"member"])];
    if ([isMember isEqualToString:@"1"]) {
        self.nickNameLable.textColor = [CommonUtils colorFromHexString:kLikeMemberNameColor];
    }else{
        self.nickNameLable.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    }

    self.descriptionLabel.text = [NSString stringWithFormat:@"送你%@",dict[@"vgoods_name"]];
    NSString *goodsUrl = dict[@"vgoods_img"];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsUrl] placeholderImage:[UIImage imageNamed:@"xianhua"]];
    NSString *createTime = dict[@"createline"];
    self.timeLabel.text = [CommonUtils dateTimeIntervalString:createTime];
    
}

-(void)setCellWithDictForMyGoodsList:(NSDictionary *)dict{
    NSString *urlString = dict[@"url"];
    [self.headImg setImageWithURL:[NSURL URLWithString:urlString?urlString:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nickNameLable.text = dict[@"from_user"][@"nickname"];
    self.descriptionLabel.text = [NSString stringWithFormat:@"送你%@",dict[@"vgoods_name"]];
    NSString *goodsUrl = dict[@"vgoods_img"];
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsUrl] placeholderImage:[UIImage imageNamed:@"xianhua"]];
    NSString *createTime = dict[@"createline"];
    self.timeLabel.text = [CommonUtils dateTimeIntervalString:createTime];

}

@end
