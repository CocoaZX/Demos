//
//  JuBaoTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JuBaoTableViewCell.h"

@implementation JuBaoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.layer.cornerRadius = 10.0;
    
    [self addItemViews];
    
}

- (float)cellHeight
{
    float height = self.dataArray.count*50;
    _cellHeight = height+50;
    return _cellHeight;
}

- (void)addItemViews
{
    self.backView.frame = CGRectMake(20, 37, kScreenWidth-40, 50*self.dataArray.count);
    
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *diction = self.dataArray[i];
        
        UIView *view = [self getItemViewWithText:getSafeString(diction[@"type_name"]) index:i];
        view.frame = CGRectMake(0, i*50, kScreenWidth-40, 50);
        view.tag = i;
        if (![self isInTheArray:i]) {
            [self.viewsArray addObject:view];
            [self.backView addSubview:view];
        }
    }
    
}

- (BOOL)isInTheArray:(int)index
{
    BOOL isIn = NO;
    
    for (int i=0; i<self.viewsArray.count; i++) {
        UIView *view = self.viewsArray[i];
        if (view.tag==index) {
            isIn = YES;
            break;
        }
    }
    
    return isIn;
}

- (UIView *)getItemViewWithText:(NSString *)title index:(int)index
{
    UIView *view = [[UIView alloc] init];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [selectBtn setTag:index];
    [selectBtn setImage:[UIImage imageNamed:@"yuepaigray"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"yuepaired"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
    if (![self isInTheArray_button:index]) {
        [self.statusArray addObject:selectBtn];
        
    }
    
    UIButton *selectBtn_full = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn_full setFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [selectBtn_full setTag:index];
    [selectBtn_full setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [selectBtn_full setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [selectBtn_full addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
    if (![self isInTheArray_button_full:index]) {
        [self.statusArray_full addObject:selectBtn_full];
        
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-100, 50)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor blackColor];
    
    [view addSubview:selectBtn];
    [view addSubview:selectBtn_full];
    [view addSubview:label];
    
    return view;
}

- (BOOL)isInTheArray_button:(int)index
{
    BOOL isIn = NO;
    
    for (int i=0; i<self.statusArray.count; i++) {
        UIButton *view = self.statusArray[i];
        if (view.tag==index) {
            isIn = YES;
            break;
        }
    }
    
    return isIn;
}

- (BOOL)isInTheArray_button_full:(int)index
{
    BOOL isIn = NO;
    
    for (int i=0; i<self.statusArray_full.count; i++) {
        UIButton *view = self.statusArray_full[i];
        if (view.tag==index) {
            isIn = YES;
            break;
        }
    }
    
    return isIn;
}

- (void)selectState:(UIButton *)sender
{
    for (int i=0; i<self.statusArray.count; i++) {
        UIButton *view = self.statusArray[i];
        view.selected = NO;
    }
    UIButton *seleBtn = self.statusArray[sender.tag];
    seleBtn.selected = !seleBtn.selected;
    NSDictionary *diction = self.dataArray[sender.tag];
    self.choseType = diction[@"type_id"];
}





+ (JuBaoTableViewCell *)getJuBaoTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JuBaoTableViewCell" owner:self options:nil];
    JuBaoTableViewCell *cell = array[0];
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    NSArray *dataARr = descriptionDic[@"feedback_type"];
    
    cell.dataArray = dataARr.mutableCopy;
    
    cell.statusArray = @[].mutableCopy;
    cell.statusArray_full = @[].mutableCopy;
    cell.viewsArray = @[].mutableCopy;
    
    return cell;
    
}







@end
