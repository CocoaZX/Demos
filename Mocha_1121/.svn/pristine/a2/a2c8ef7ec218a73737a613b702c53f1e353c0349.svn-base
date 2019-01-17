//
//  BuildNewMcTableViewCell.m
//  Mocha
//
//  Created by XIANPP on 15/11/23.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "BuildNewMcTableViewCell.h"
#import "BuildMokaCardViewController.h"
@implementation BuildNewMcTableViewCell

- (void)awakeFromNib {
    self.height =  70;
    //self.addButton.backgroundColor = [UIColor purpleColor];
    //分割线
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //顶部分割线
    if (!_topLineLabel){
        _topLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
        _topLineLabel.hidden = NO;
        _topLineLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
        [self addSubview:_topLineLabel];
    }
    //计算文字宽度
    CGSize titleSize = [@"创建新模卡" sizeWithFont:[UIFont systemFontOfSize:18 ] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGFloat width = titleSize.width;
    
    //图片
    UIImageView *addImgView  = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth -20 -10 -width)/2, 37 , 20, 20)];
    addImgView.image = [UIImage imageNamed:@"NewBuild"];
    [self.contentView addSubview:addImgView];
    
   //文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(addImgView.right +10 ,32, width, 30)];
    titleLabel.text = @"创建新模卡";
   // titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    [self.contentView addSubview:titleLabel];
    
    
 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 }

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    
}

- (void)setSupCon:(NewMyPageViewController *)supCon{
    if (_supCon != supCon) {
        _supCon = supCon;
        [self setNeedsLayout];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];

}


- (IBAction)createNewMokaCardBtnClick:(UIButton *)sender {
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    BuildMokaCardViewController *build = [[BuildMokaCardViewController alloc] initWithNibName:@"BuildMokaCardViewController" bundle:[NSBundle mainBundle]];
    [self.supCon.navigationController pushViewController:build animated:YES];
}



@end
