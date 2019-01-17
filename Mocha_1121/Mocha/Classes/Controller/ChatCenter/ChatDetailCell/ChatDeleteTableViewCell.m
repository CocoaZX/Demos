//
//  ChatDeleteTableViewCell.m
//  Mocha
//
//  Created by zhoushuai on 16/1/4.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ChatDeleteTableViewCell.h"

@implementation ChatDeleteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
    }
    return self;
}


//初始化视图组件
- (void)_initViews{
    //复选框,显示是否被选中
    _checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
    //_checkImgView.layer.borderColor = [[CommonUtils colorFromHexString:kLikeGreenLightColor] CGColor];
    //_checkImgView.layer.borderWidth = 1;
    [self.contentView addSubview:_checkImgView];
    
    //图片
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_checkImgView.right +10, 5, 50, 50)];
    [self.contentView addSubview:_imgView];
    
    //昵称
    _titleLab  = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right +10, 25, 200, 20)];
    _titleLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLab];
    
}



//数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic !=  dataDic) {
        _dataDic = dataDic;
        self.userID = [_dataDic objectForKey:@"id"];
        [self setNeedsLayout];
    }
}


//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    //头像
    NSString *headerURLString = [NSString stringWithFormat:@"%@%@",[_dataDic objectForKey:@"head_pic"],[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:headerURLString]];
    
    //昵称
     _titleLab.text =[_dataDic objectForKey:@"nickname"];
    
    //显示是否被选中
    if ([self.sourceVC.deleteMemberIds containsObject:self.userID]) {
    _checkImgView.image = [UIImage imageNamed:@"checked"];
    }else{
    _checkImgView.image = [UIImage imageNamed:@"check"];
    }
}

//按钮事件
//单元格的操作，记录了哪些被选中将要删除的id
//- (void)checkBtnClick:(UIButton *)btn{
//    btn.selected = !btn.selected;
//    NSMutableArray *mArr = _sourceVC.deleteMemberIds;
//
//    if (btn.selected) {
//        [mArr addObject:[_dataDic objectForKey:@"id"]];
//    }else{
//        [mArr removeObject:[_dataDic objectForKey:@"id"]];
//    }
//}
@end
