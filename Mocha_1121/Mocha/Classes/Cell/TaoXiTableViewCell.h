//
//  TaoXiTableViewCell.h
//  Mocha
//
//  Created by XIANPP on 16/2/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoXiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *buildBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *decriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *labelView;


@property (weak, nonatomic) IBOutlet UILabel *labeone;

@property (weak, nonatomic) IBOutlet UILabel *labeltwo;

@property (weak, nonatomic) IBOutlet UILabel *labelthree;

@property (weak, nonatomic) IBOutlet UILabel *labelfour;

//顶部分割线
@property (weak, nonatomic) IBOutlet UILabel *topFengeXianLabel;


//是否是第一个单元格
@property(nonatomic,assign)BOOL isFirstCell;

//当前屏幕下，以TaoXiScale为比例的时候,展示的imgView的高度
@property(nonatomic,assign)CGFloat imgViewHeight;
//数据源
@property(nonatomic,strong)NSDictionary *dic;


@property (weak, nonatomic) NewMyPageViewController *supCon;

@property (copy, nonatomic) NSString *currentUid;

//头部分割线
//@property(nonatomic,strong)UILabel *topFengeXianLabel;

+(TaoXiTableViewCell *)getTaoXiTableViewCell;

//-(void)initWithDictionary:(NSDictionary *)dict;

@end
