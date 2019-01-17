//
//  PhotoAndDescriptionTableViewCell.m
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "PhotoAndDescriptionTableViewCell.h"
#import "CommonUtils.h"
@implementation PhotoAndDescriptionTableViewCell

#pragma mark - 视图生命周期及控件加载
- (void)awakeFromNib {
    // Initialization code
    if (self.defaultLabel == nil) {
        _defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200,20)];
        _defaultLabel.tag = 50;
        _defaultLabel.text = @"↑请输入内容描述";
        _defaultLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        [self.descriptionTxtView addSubview:_defaultLabel];
    }
    //输入框内文字的颜色
    _descriptionTxtView.bounces = NO;
    _descriptionTxtView.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    //
    _backLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
}


#pragma mark - 视图布局
- (void)setDataDic:(NSDictionary *)dataDic{
    if(_dataDic != dataDic){
        _dataDic = dataDic;
        [self setNeedsLayout];
    }
}

- (void)setPictureDesc:(NSString *)pictureDesc{
    if (_pictureDesc != pictureDesc) {
        _pictureDesc = pictureDesc;
    }
    [self setNeedsLayout];
}


- (void)setPictureImg:(UIImage *)pictureImg{
    if (_pictureImg != pictureImg) {
        _pictureImg = pictureImg;
    }
    [self setNeedsLayout];
}




- (void)layoutSubviews{
    [super layoutSubviews];
    _defaultLabel.hidden = YES;
    _photoImage.image = nil;
    NSLog(@"%@",_dataDic);
    if ([_cellType isEqualToString:@"netCell"]) {
        //1.套系详情界面的单元格
        //获取图片的真正宽和高,设置图片
        NSString *width = getSafeString(_dataDic[@"width"]);
        NSString *height = getSafeString(_dataDic[@"height"]);
        float floatWidth = [width floatValue];
        float floatHeight = [height floatValue];
        float trueWidth = kDeviceWidth;
        float trueHeight = floatHeight * trueWidth / floatWidth;
        
        NSString *url = [NSString stringWithFormat:@"%@%@",_dataDic[@"url"],[CommonUtils imageStringWithWidth:trueWidth * 2 height:trueHeight * 2]];
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:url]];
        _photoImgView_height.constant = trueHeight;
        
        //设置描述文字
        _descriptionTxtView.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
        NSString *descTxt = _dataDic[@"title"];
          if (descTxt.length == 0) {
            
            _descriptionTxtView.text = @"";
            _descriptionTxtView_height.constant = 0;
            
        }else{
            _descriptionTxtView.text = descTxt;
            CGFloat descHeight = [SQCStringUtils getCustomHeightWithText:descTxt viewWidth:kDeviceWidth -5*2 textSize:16] +8;
            _descriptionTxtView_height.constant = descHeight;
        }
    }else if([_cellType isEqualToString:@"netCellForEditting"]){
        //2.处于编辑状态的单元格
        //获取图片的真正宽和高,设置图片
        NSString *width = getSafeString(_dataDic[@"width"]);
        NSString *height = getSafeString(_dataDic[@"height"]);
        float floatWidth = [width floatValue];
        float floatHeight = [height floatValue];
        float trueWidth = kDeviceWidth;
        float trueHeight = floatHeight * trueWidth / floatWidth;
        
        NSString *url = [NSString stringWithFormat:@"%@%@",_dataDic[@"url"],[CommonUtils imageStringWithWidth:trueWidth * 2 height:trueHeight * 2]];
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:url]];
        _photoImgView_height.constant = trueHeight;
        
        //设置描述文字，这里使用了视图控制器里数组里的描述文字
        self.descriptionTxtView.text = _pictureDesc;
        if (self.pictureDesc.length == 0) {
            _defaultLabel.hidden = NO;
        }else{
            _defaultLabel.hidden =YES;
        }
        //删除按钮
        [self.contentView bringSubviewToFront: _deleteBtn];
        
        //设置输入框的高度是100
        _descriptionTxtView_height.constant = 100;

        /*
        if (descTxt.length == 0) {
            
            _descriptionTxtView.text = @"";
            _descriptionTxtView_height.constant = 0;
            
        }else{
            _descriptionTxtView.text = descTxt;
            CGFloat descHeight = [SQCStringUtils getCustomHeightWithText:descTxt viewWidth:kDeviceWidth -5*2 textSize:16] +8;
            
            _descriptionTxtView_height.constant = descHeight;
        }
        */
    }else if([_cellType isEqualToString:@"localCell"]){
        //3.处于编辑状态的本地图片单元格
        //设置本地图片
        self.photoImage.image = _pictureImg;
        CGFloat height = _pictureImg.size.height * kDeviceWidth / _pictureImg.size.width;

        self.photoImgView_height.constant  = height;
        
        //设置描述文字
        _descriptionTxtView.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
        
        _descriptionTxtView.text = _pictureDesc;
        
        //设置默认提示文字
        if (self.pictureDesc.length == 0) {
            _defaultLabel.hidden = NO;
        }else{
            _defaultLabel.hidden =YES;
        }

        //设置删除按钮
        [self.contentView bringSubviewToFront: _deleteBtn];
        
        //设置输入框的高度是100
        _descriptionTxtView_height.constant = 100;
        
//        if (descTxt.length == 0) {
//            _descriptionTxtView.text = @"";
//            _descriptionTxtView_height.constant = 0;
//            
//        }else{
//            _descriptionTxtView.text = descTxt;
//            CGFloat descHeight = [SQCStringUtils getCustomHeightWithText:descTxt viewWidth:kDeviceWidth -5*2 textSize:16] +8;
//            _descriptionTxtView_height.constant = descHeight;
//        }
    }
}




//删除此套系
- (IBAction)delegateAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegatePhoto:)]) {
        [self.delegate delegatePhoto:sender];
    }
}



-(void)initWithDictionary:(NSDictionary *)dict{
//<<<<<<< .mine
//    
//=======
//    NSString *width = getSafeString(dict[@"width"]);
//    NSString *height = getSafeString(dict[@"height"]);
//    float floatWidth = [width floatValue];
//    float floatHeight = [height floatValue];
//    float trueWidth = kDeviceWidth;
//    float trueHeight = floatHeight * trueWidth / floatWidth;
//    NSString *url = [NSString stringWithFormat:@"%@%@",dict[@"url"],[CommonUtils imageStringWithWidth:trueWidth * 2 height:trueHeight * 2]];
//    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:url]];
////    [self.photoImage setFrame:CGRectMake(0, 0, 10, 10)];
//    NSLog(@"%@",dict);
//    self.descriptionTextfield.text = dict[@"title"];
//>>>>>>> .r634
}


#pragma mark - 获取视图
+(PhotoAndDescriptionTableViewCell *)getPhotoAndDescriptionTableViewCell{
    PhotoAndDescriptionTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PhotoAndDescriptionTableViewCell" owner:nil options:nil].lastObject;
    return cell;
}

//套系界面返回高度
+(float)getCellHeightWithDictionary:(NSDictionary *)dic{
    //图片
    NSString *width = getSafeString(dic[@"width"]);
    NSString *height = getSafeString(dic[@"height"]);
    float floatWidth = [width floatValue];
    float floatHeight = [height floatValue];
    float trueWidth = kDeviceWidth;
    float trueHeight = floatHeight * trueWidth / floatWidth;
    
    //文字描述
    NSString *descTxt = dic[@"title"];
    if (descTxt.length == 0) {
        
     }else{
           CGFloat descHeight = [SQCStringUtils getCustomHeightWithText:descTxt viewWidth:kDeviceWidth -5*2 textSize:16] +8;
         trueHeight += descHeight;
     }
    
    return trueHeight + 10;
}


@end
