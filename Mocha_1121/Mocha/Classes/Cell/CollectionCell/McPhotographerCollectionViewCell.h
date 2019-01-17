//
//  McPhotographerCollectionViewCell.h
//  Mocha
//
//  Created by zhoushuai on 15/11/12.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McPhotographerCollectionViewCell : UICollectionViewCell

{
    //显示相册图片
    UIImageView *_imgView;
    //显示相片信息视图
    UIView *_backgroundView;
    //相册名称
    UILabel *_albumLable;
    //分割线
    UILabel *_lineLabel;
    //作品数
    UILabel *_photoCountLable;
    
    
    //头像
    UIImageView *_headImgView;
    //昵称
    UILabel *_nameLabel;
    //住址
    UILabel *_addressLabel;
    
}

@property (nonatomic,strong)NSDictionary *dataDic;



@end
