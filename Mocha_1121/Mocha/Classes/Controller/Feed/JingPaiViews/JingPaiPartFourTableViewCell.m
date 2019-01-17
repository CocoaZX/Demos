//
//  JingPaiPartFourTableViewCell.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JingPaiPartFourTableViewCell.h"
#import "MCJingPiaLabelsModel.h"
#import "CustomLabelView.h"

@interface JingPaiPartFourTableViewCell()

@property (strong, nonatomic) CustomLabelView *customLabel;

@end

@implementation JingPaiPartFourTableViewCell

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
    
    [self addSubview:self.labelTitleView];
    [self addSubview:self.labelsBackView];
    
    [self addLabelsToBack];
    
    __weak __typeof(self)weakSelf = self;
    
    [self.customLabel setTheCancelBlock:^{
        weakSelf.customLabel.hidden = YES;
    }];
    
    [self.customLabel setTheSureBlock:^(NSDictionary *diction) {
        weakSelf.customLabel.hidden = YES;
        
        
        [MBProgressHUD showHUDAddedTo:weakSelf.controller.view animated:YES];
        
        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"tag_name":getSafeString(diction[@"title"])}];
        [AFNetwork postRequeatDataParams:params path:PathPostAuctionAddTag success:^(id data){
            [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
            
            if ([data[@"status"] integerValue] == kRight) {
                NSMutableDictionary *dic = @{@"type":@"1",@"title":diction[@"title"],@"item":@"",@"selected":@"0",@"tagid":getSafeString(data[@"data"][@"tag_id"])}.mutableCopy;

                [LeafNotification showInController:weakSelf.controller withText:data[@"msg"]];
                
                [weakSelf.labelsArray insertObject:dic atIndex:self.labelsArray.count-1];
                [weakSelf resetLabelsView];
                [weakSelf.controller reloadTableView];
            }
            else{
                
                [LeafNotification showInController:weakSelf.controller withText:data[@"msg"]];
                
            }
            
            
        }failed:^(NSError *error){
            [MBProgressHUD hideHUDForView:weakSelf.controller.view animated:YES];
            
            [LeafNotification showInController:weakSelf.controller withText:@"当前网络不太顺畅哟"];
        }];
    }];
}



- (void)addLabelsToBack
{
    float itemWid = (kScreenWidth-40-self.space*2)/3;

    for (int i=0; i<self.labelsArray.count; i++) {
        if (i==(self.labelsArray.count-1)||self.labelsArray.count==0) {
            break;
        }
        NSDictionary *diction = self.labelsArray[i];
        int row = (int)i/3;
        int cln = (int)i%3;
        UIView *view = [self getLabelItemViewWithTitle:diction index:i];
        view.tag = i;
        BOOL isInArray = NO;
        for (int i=0; i<self.itemViewArray.count; i++) {
            UIView *vi = self.itemViewArray[i];
            if (view.tag==vi.tag) {
                isInArray = YES;
            }else
            {
            }
        }

        view.frame = CGRectMake(cln*(itemWid+self.space), row*(self.itemHeight+self.space),itemWid, self.itemHeight);

        if (!isInArray) {
            NSString *selected = diction[@"selected"];

            UIImageView *redArrow = [[UIImageView alloc] initWithFrame:CGRectMake(itemWid-20, 10, 27, 18)];
            redArrow.image = [UIImage imageNamed:@"onRed"];
            redArrow.tag = i;
            if ([selected isEqualToString:@"0"]) {
                redArrow.hidden = YES;
            }else
            {
                redArrow.hidden = NO;
            }
            [self.redArrowArray addObject:redArrow];
            
            [view addSubview:redArrow];
            [self.itemViewArray addObject:view];
            [self.labelsBackView addSubview:view];
        }
        
    }
    if (self.labelsArray.count!=0) {
        if (!_customView) {
            UIView *view = [self getLabelItemViewWithTitle:self.labelsArray[self.labelsArray.count-1] index:(int)self.labelsArray.count];
            
            _customView = view;
        }
        int row = (int)(self.labelsArray.count-1)/3;
        int cln = (int)(self.labelsArray.count-1)%3;
        
        _customView.frame = CGRectMake(cln*(itemWid+self.space), row*(self.itemHeight+self.space),itemWid, self.itemHeight);
        
        [self.labelsBackView addSubview:_customView];
    }
    
}

- (void)resetLabelsView
{
    
    [self addLabelsToBack];

}

- (UIView *)getLabelItemViewWithTitle:(NSDictionary *)diction index:(int)index
{
    JingPiaLabelItemModel *item = diction[@"item"];

    NSString *title = diction[@"title"];
    NSString *type = diction[@"type"];

    float itemWid = (kScreenWidth-40-self.space*2)/3;
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWid, self.itemHeight)];
    itemView.layer.cornerRadius = 10.0;
    itemView.backgroundColor = [UIColor whiteColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWid, self.itemHeight)];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [itemView addSubview:titleLabel];
    
    UIButton *clickBtn = [self addButtonBaseClickButton];
    [clickBtn setFrame:CGRectMake(0, 0, itemWid, self.itemHeight)];
    [clickBtn setTag:index];
    if ([type isEqualToString:@"0"]) {
        [clickBtn addTarget:self action:@selector(labelChosen:) forControlEvents:UIControlEventTouchUpInside];
        titleLabel.text = item.tag_name;

    }else if ([type isEqualToString:@"1"])
    {
        [clickBtn addTarget:self action:@selector(labelChosen:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([type isEqualToString:@"2"])
    {
        [clickBtn addTarget:self action:@selector(customAddLabel:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    [itemView addSubview:clickBtn];
    
    return itemView;
}

- (void)labelChosen:(UIButton *)sender
{
    LOG_METHOD;
    
    
    
    UIImageView*imgView = self.redArrowArray[sender.tag];

    NSMutableDictionary *dic = self.labelsArray[sender.tag];
    NSString *selet = dic[@"selected"];
    if ([selet isEqualToString:@"0"]) {
        NSMutableArray *tagArr = @[].mutableCopy;
        for (int i=0; i<self.labelsArray.count; i++) {
            NSDictionary *diction = self.labelsArray[i];
            NSString *selectid = getSafeString(diction[@"selected"]);
            if ([selectid isEqualToString:@"1"]) {
                NSString *tagid = getSafeString(diction[@"tagid"]);
                if (tagid.length>0) {
                    [tagArr addObject:tagid.copy];
                    
                }
            }
            
        }
        if (tagArr.count>2) {
            [LeafNotification showInController:self.controller withText:@"标签最多只能选3个"];
            return;
        }
        [dic setObject:@"1" forKey:@"selected"];
        imgView.hidden = NO;
    }else
    {
        [dic setObject:@"0" forKey:@"selected"];
        imgView.hidden = YES;

    }
    
    [self.labelsArray replaceObjectAtIndex:sender.tag withObject:dic];
    
//    [self resetLabelsView];

}

- (void)customAddLabel:(id)sender
{
    LOG_METHOD;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            self.customLabel.hidden = NO;
            [window addSubview:self.customLabel];
            
            break;
        }
    }
}

- (CustomLabelView *)customLabel
{
    if (!_customLabel) {
        _customLabel = [CustomLabelView getCustomLabelView];
        _customLabel.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
    }
    
    return _customLabel;
}

- (UIView *)labelsBackView
{
    if (!_labelsBackView) {
        _labelsBackView = [[UIView alloc] init];
        _labelsBackView.backgroundColor = [UIColor clearColor];
    }
    _labelsBackView.frame = CGRectMake(20, 50, kScreenWidth-40, self.cellHeight-50);
    return _labelsBackView;
}


- (UIView *)labelTitleView
{
    if (!_labelTitleView) {
        _labelTitleView = [[UIView alloc] init];
        [_labelTitleView addSubview:[self addTitleView]];
        _labelTitleView.backgroundColor = [UIColor clearColor];
    }
    _labelTitleView.frame = CGRectMake(20, 0, kScreenWidth-40, 50);
    return _labelTitleView;
}

- (UIView *)addTitleView
{
    float labelWidth = 80;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 50)];
    
    UILabel *lineOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, (kScreenWidth-40-labelWidth)/2, 1)];
    lineOne.backgroundColor = [UIColor grayColor];
    [back addSubview:lineOne];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-40-labelWidth)/2, 0, labelWidth, 50)];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = @"选标签";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [back addSubview:titleLabel];
    
    UILabel *lineTwo = [[UILabel alloc] initWithFrame:CGRectMake( (kScreenWidth-40-labelWidth)/2+labelWidth, 25, (kScreenWidth-40-labelWidth)/2, 1)];
    lineTwo.backgroundColor = [UIColor grayColor];
    [back addSubview:lineTwo];
    
    return back;
}

- (int)space
{
    if (_space==0) {
        _space = 10;
    }
    return _space;
}

- (float)itemHeight
{
    if (_itemHeight==0.0) {
        _itemHeight = 40.0;
    }
    return _itemHeight;
}

- (float)cellHeight
{
    int cln = (int)self.labelsArray.count/3+1;
    if (self.labelsArray.count%3==0) {
        cln = cln - 1;
    }
    float height = (self.itemHeight+self.space)*cln+50;
    _cellHeight = height;
    return _cellHeight;
}

- (UIButton *)addButtonBaseClickButton
{
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickButton setFrame:CGRectMake(0, 0, self.itemHeight, self.itemHeight)];
    [clickButton setClipsToBounds:YES];
    [clickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return clickButton;
}

- (NSArray *)getTagsIdArr
{
    NSMutableArray *tagArr = @[].mutableCopy;
    for (int i=0; i<self.labelsArray.count; i++) {
        NSDictionary *diction = self.labelsArray[i];
        NSString *tagid = getSafeString(diction[@"tagid"]);
        if (tagid.length>0) {
            [tagArr addObject:tagid.copy];

        }
    }
    return tagArr.copy;
}

- (NSString *)getIdString
{
    NSMutableArray *tagArr = @[].mutableCopy;
    for (int i=0; i<self.labelsArray.count; i++) {
        NSDictionary *diction = self.labelsArray[i];
        NSString *selectid = getSafeString(diction[@"selected"]);
        if ([selectid isEqualToString:@"1"]) {
            NSString *tagid = getSafeString(diction[@"tagid"]);
            if (tagid.length>0) {
                [tagArr addObject:tagid.copy];
                
            }
        }
        
    }
    LOG(@"%@",tagArr);
    NSArray *tempArr = [NSArray arrayWithArray:tagArr];
    NSString *string = [SQCStringUtils JSONStringWithArray:tempArr.copy];
    return string;
}

/**
 *  type = 0 表示系统标签
 *  type = 1 表示自定义标签
 *  type = 2 表示添加自定义标签
 */
+ (JingPaiPartFourTableViewCell *)getJingPaiPartFourTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JingPaiPartFourTableViewCell" owner:self options:nil];
    JingPaiPartFourTableViewCell *cell = array[0];
    cell.labelsArray = @[].mutableCopy;
    cell.redArrowArray = @[].mutableCopy;
    cell.itemViewArray = @[].mutableCopy;
    return cell;
    
}

@end
