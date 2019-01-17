//
//  FieryListSectionView.m
//  Mocha
//
//  Created by TanJian on 16/5/26.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "FieryListSectionView.h"

@interface FieryListSectionView ()

@property (nonatomic,strong)UIImage *leftImgNormal;
@property (nonatomic,strong)UIImage *leftImgHigh;
@property (nonatomic,strong)UIImage *rightImgNormal;
@property (nonatomic,strong)UIImage *rightImgHigh;

@end



@implementation FieryListSectionView

-(instancetype)init{
    return [[NSBundle mainBundle] loadNibNamed:@"FieryListSectionView" owner:self options:nil].lastObject;
}

-(void)awakeFromNib{
    
    _leftTitleLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    _rightTitleLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    _leftLine.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    _rightLine.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    
    _leftTitleLabel.text = @"榜单名";
    _rightTitleLabel.text = @"榜单名";
    _leftLine.hidden = NO;
    _rightLine.hidden = YES;
    
    [self setupUI];
    
}

-(void)diselectedWithType:(NSString *)type{
    
    if ([type isEqualToString:@"2"]) {
        [self didClickBtn:_leftBtn];
    }else{
        [self didClickBtn:_rightBtn];
    }
    
    
    
}




- (IBAction)didClickBtn:(UIButton *)sender {
    
    //通知界面数据刷新
    switch (sender.tag) {
            
        case 2:{
            _leftTitleLabel.textColor = [UIColor colorForHex:kLikeRedColor];
            _rightTitleLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
            _leftLine.hidden = NO;
            _rightLine.hidden = YES;
            _leftImg.image = [UIImage imageNamed:@"hongrenHigh"];
            _rightImg.image = [UIImage imageNamed:@"caifuNormal"];
            
        }
            break;
            
        case 1:{
            _rightTitleLabel.textColor = [UIColor colorForHex:kLikeRedColor];
            _leftTitleLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
            _leftLine.hidden = YES;
            _rightLine.hidden = NO;
            _rightImg.image = [UIImage imageNamed:@"caifuHigh"];
            _leftImg.image = [UIImage imageNamed:@"hoongrenhuiNormal"];
            
        }
            
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"swapFieryListType" object:@{@"type":[NSString stringWithFormat:@"%ld",(long)sender.tag]}];
    
}

-(void)setupUI{
    
    //配置接口取数据显示
    //保存火爆页面详细榜单列表的配置信息

    NSDictionary *popularBar = [USER_DEFAULT objectForKey:@"popularity_bar"];
    
    if (popularBar) {
        _leftTitleLabel.text = getSafeString(popularBar[@"rank"][@"title"]);
        _rightTitleLabel.text = getSafeString(popularBar[@"money"][@"title"]);
        
        _leftImg.image = [UIImage imageNamed:@"hongrenHigh"];
        _rightImg.image = [UIImage imageNamed:@"caifuNormal"];
        
    }  
    
}



@end
