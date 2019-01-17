//
//  NewPersonalHeaderView.h
//  Mocha
//
//  Created by sun on 15/8/31.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildCropViewController.h"

@interface NewPersonalHeaderView : UIView<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,changeMokaPictureDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIView *numberView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIImageView *renZhengImg;

@property (weak, nonatomic) IBOutlet UILabel *mokaNumber;

@property (weak, nonatomic) IBOutlet UILabel *userType;

@property (weak, nonatomic) IBOutlet UILabel *sex;

@property (weak, nonatomic) IBOutlet UILabel *citys;

@property (weak, nonatomic) IBOutlet UIImageView *maleImageView;


@property (weak, nonatomic) IBOutlet UILabel *dongtai;
@property (weak, nonatomic) IBOutlet UILabel *guanzhu;
@property (weak, nonatomic) IBOutlet UILabel *fensi;

@property (weak, nonatomic) IBOutlet UILabel *dongtaiNum;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuNum;
@property (weak, nonatomic) IBOutlet UILabel *fensiNum;


@property (weak, nonatomic) IBOutlet UIButton *dongtaiButton;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;
@property (weak, nonatomic) IBOutlet UIButton *fensiButton;

@property (weak, nonatomic) UIViewController *supCon;

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *userName;

@property(copy,nonatomic)NSString *rankUrl;

//提示用户改变背景的视图
@property (nonatomic,strong)UIControl *changeBgView;

@property (nonatomic , strong)UIImage *headerImage;

@property (weak, nonatomic) IBOutlet UIView *MokaCardView;


//身价按钮
@property (strong, nonatomic)UIControl *personValueCtrol;
//身价图标
@property (strong, nonatomic)UIImageView *personValueImgView;
//身价值
@property (strong, nonatomic)UILabel *personValueLabel;

//等级信息
@property (weak, nonatomic) IBOutlet UIView *levelView;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *levelInfoBtn;


@property (nonatomic , copy)NSString *headerURL;

//粉丝变化block
@property (nonatomic , copy)void *(^fensiBlock)(NSString *changeStr);

@property (weak, nonatomic) IBOutlet UIImageView *VipImageView;

@property (weak, nonatomic) IBOutlet UIImageView *redImageView;


- (void)initViewWithData:(NSDictionary *)diction;

- (void)resetBackView;

- (IBAction)headerBut:(UIButton *)sender;

- (IBAction)CardBut:(UIButton *)sender;


+ (NewPersonalHeaderView *)getNewPersonalHeaderView;


@end
