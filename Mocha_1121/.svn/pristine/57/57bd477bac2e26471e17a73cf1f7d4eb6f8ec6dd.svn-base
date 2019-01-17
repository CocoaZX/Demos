//
//  ActivityDetailMemberCell.h
//  Mocha
//
//  Created by zhoushuai on 16/2/17.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MokaActivityDetailViewController.h"

@interface ActivityDetailMemberCell : UITableViewCell

//报名情况
@property (nonatomic,strong)UIView *baoMingView;
@property (nonatomic,strong)UILabel *baoMingTitleLabel;
@property (nonatomic,strong)UIButton *baoMingManagerButton;
@property (nonatomic,strong)UIView *baoMingPersonView;


//群聊
@property (nonatomic,strong)UIControl *qunLiaoControl;
@property (nonatomic,strong)UIImageView *qunLiaoImgView;
@property (nonatomic,strong)UILabel *qunLiaoTxtLabel;
@property (nonatomic,strong)UILabel *qunLiaoCoutLabel;
@property (nonatomic,strong)UIImageView *enterQunLiaoImgView;

//数据源
@property (nonatomic,strong)NSDictionary *dataDic;
//活动类型
@property (nonatomic,assign)NSInteger typeNum;
//导航控制器
@property (nonatomic,weak) MokaActivityDetailViewController *superVC;
//
@property (nonatomic,assign)CGFloat leftPadding;

//获取单元高度
+ (CGFloat)getActivityDetailMemberCellHeight:(NSDictionary *)dataDic;
@end
