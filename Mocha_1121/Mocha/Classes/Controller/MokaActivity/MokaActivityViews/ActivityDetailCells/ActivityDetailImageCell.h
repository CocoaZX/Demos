//
//  ActivityDetailImageCell.h
//  Mocha
//
//  Created by zhoushuai on 16/2/17.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailImageCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgView;

//图片链接
@property (nonatomic,strong)NSDictionary *imgDic;
@property (nonatomic,assign)CGFloat leftPadding;


@end
