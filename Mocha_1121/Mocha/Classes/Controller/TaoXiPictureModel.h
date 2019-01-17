//
//  TaoXiPictureModel.h
//  Mocha
//
//  Created by zhoushuai on 16/4/6.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"

/*此类用于封装 套系编辑界面的图片对象
暂时未用到此类
*/


@interface TaoXiPictureModel : NSObject
//网络图片，图片链接
@property(nonatomic,copy)NSString *picturelinkStr;
//如果是本地图片，没有链接只有图片对象
@property(nonatomic,strong)UIImage *image;

//图片描述
@property(nonatomic,copy)NSString *pictureDesc;

//图片的宽和高
@property(nonatomic,copy)NSString *width;
@property(nonatomic,copy)NSString *height;


- (id)initWithData:(NSDictionary *)data;

@end
