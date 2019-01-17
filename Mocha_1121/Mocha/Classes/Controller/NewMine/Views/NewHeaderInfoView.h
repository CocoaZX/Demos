//
//  NewHeaderInfoView.h
//  Mocha
//
//  Created by sunqichao on 15/8/30.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
//个人数据
#import "McPersonalData.h"

@interface NewHeaderInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;

@property (weak, nonatomic) IBOutlet UIButton *headerClickButton;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dongtaiLabel;

@property (weak, nonatomic) IBOutlet UILabel *dongtaiNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuLabel;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *fensiLabel;

@property (weak, nonatomic) IBOutlet UILabel *fensiNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *dongtaiButton;

@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;

@property (weak, nonatomic) IBOutlet UIButton *fensiButton;

@property (weak, nonatomic) UIViewController *supCon;

@property (weak, nonatomic) IBOutlet UILabel *MyPage;

@property (weak, nonatomic) IBOutlet UIImageView *redImageView;


//头像链接
@property (nonatomic,copy)NSString * headImgURLString;

//地址Label
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

//认证视图
@property (weak, nonatomic) IBOutlet UIView *renZhengView;
//认证视图的背景图片
@property (weak, nonatomic) IBOutlet UIImageView *renzhengbgImgView;

//认证图片
@property (weak, nonatomic) IBOutlet UIImageView *renzhengImgView;
//认证状态
@property (weak, nonatomic) IBOutlet UILabel *renzhengInfoLabel;
//认证按钮
@property (weak, nonatomic) IBOutlet UIButton *renzhengBtn;
@property (weak, nonatomic) IBOutlet UIImageView *renzhengMarkImgView;

//个人信息字典
@property(nonatomic,strong)NSDictionary *dataDic;

//个人数据
@property (nonatomic,strong)McPersonalData *personalData;

- (void)initViewWithData:(NSDictionary *)diction withDic:(NSDictionary *)dataDic;

+ (NewHeaderInfoView *)getNewHeaderInfoView;

- (void)initHeadViewWithMokaValue;



@end
