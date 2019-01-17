//
//  DynamicCollectionViewCell.m
//  Mocha
//
//  Created by zhoushuai on 16/4/21.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DynamicCollectionViewCell.h"

@interface DynamicCollectionViewCell ()<UIAlertViewDelegate>

@end

@implementation DynamicCollectionViewCell


- (void)awakeFromNib{
    [self.contentView bringSubviewToFront:self.deleteBtn];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;

}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//初始化视图组件
- (void)_initViews{
    
}


//数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic !=  dataDic) {
        _dataDic = dataDic;
        [self setNeedsLayout];
    }
}

//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    //设置封面图片
    _imgView.image= nil;
    NSString *imgUrlStr = [_dataDic objectForKey:@"cover_url"];
    if (imgUrlStr.length != 0) {
        NSString *bigImgJpg = [CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2];
        NSString *bigImgCompleteurl = [NSString stringWithFormat:@"%@%@",imgUrlStr,bigImgJpg];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:bigImgCompleteurl]];
    }else{
        //使用默认图片
    }
    
    //设置相册名称
    _albumNameLabel.text = _dataDic[@"title"];
    
    
    //删除按钮
    if([self.currentUid isEqualToString:getCurrentUid()]){
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
}


#pragma mark - 事件点击
- (IBAction)deleteDynamicAlbum:(id)sender {
    
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"删除动态模卡？" message:@"删除的动态模卡将不能恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert show];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //
    }else{
        //删除动态模卡
        [[NSNotificationCenter defaultCenter] postNotificationName:@"requestForDeleteDynamicAlbum" object:_indexPath];
    }
}



@end
