//
//  NewMokaCardTableViewCell.h
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMyPageViewController.h"

@interface NewMokaCardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleView;

@property (weak, nonatomic) IBOutlet UIView *titleBottomView;

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *nocardLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet UILabel *numberBack;

@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@property (weak, nonatomic) IBOutlet UIButton *buildButton;

@property (weak, nonatomic) IBOutlet UIButton *DownloadButton;

@property (weak, nonatomic) IBOutlet UIButton *SharedButton;

@property (weak , nonatomic) IBOutlet UIButton *DetilButton;



- (IBAction)DetilButton:(id)sender;

@property (strong, nonatomic) NSMutableArray *imgViewArray;

@property (strong, nonatomic) NSMutableArray *buttonArray;

@property (strong, nonatomic) UIView *cardDetailView;

@property (strong, nonatomic) NSDictionary *dataDiction;

@property (strong, nonatomic) NSMutableArray *albumArray;

@property (strong, nonatomic) UIImageView *leftImgV;

@property (strong, nonatomic) UIImageView *rightOneImgV;

@property (strong, nonatomic) UIImageView *rightTwoImgV;

@property (weak, nonatomic) NewMyPageViewController *supCon;

@property (copy, nonatomic) NSString *currentUid;

@property (copy, nonatomic) NSString *currentUserName;

@property (assign, nonatomic) BOOL hiddenTitleView;

@property (assign, nonatomic) BOOL hiddenFootView;

@property (strong , nonatomic) UIView *footView;

@property (strong , nonatomic) NSDictionary *mokaListDic;


@property (weak, nonatomic) IBOutlet UILabel *introduceLab;


//模卡图片底部的logo图片
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
//模卡图片底部,显示身高信息的lable
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;


//索引
@property (nonatomic,strong)NSIndexPath *indexpath;
//头部分割线
@property(nonatomic,strong)UILabel *topFengeXianLabel;

- (void)initViewWithData:(NSDictionary *)diction;


+ (NewMokaCardTableViewCell *)getNewMokaCardTableViewCell;

@property (assign , nonatomic) CGSize *informationSize;

- (IBAction)SharedButton:(id)sender;







@end
