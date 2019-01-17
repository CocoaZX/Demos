//
//  ActivityDetailImageCell.m
//  Mocha
//
//  Created by zhoushuai on 16/2/17.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ActivityDetailImageCell.h"

@implementation ActivityDetailImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self _initViews];
        _leftPadding = 20;
    }
    return  self;
}
    
    

//初始化视图组件
- (void)_initViews{
    self.contentView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //_imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imgView];
}



- (void)setImgDic:(NSDictionary *)imgDic{
    if (_imgDic != imgDic) {
        _imgDic = imgDic;
        [self setNeedsDisplay];
    }
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = [[_imgDic objectForKey:@"width"] floatValue] ;
    CGFloat height = [[_imgDic objectForKey:@"height"] floatValue];
    CGFloat cellWidth =  kDeviceWidth - _leftPadding*2;
    CGFloat cellHeight = 0;
    //
    if (width  == 0 || height == 0) {
        cellHeight = cellWidth;
    }else{
          cellHeight = cellWidth*(height/width);
    }
        //
    if (width == 0 ||height == 0) {
        cellHeight = cellWidth;
    }else{
        cellHeight = cellWidth*(height/width);
    }
    

    
    
    
    
    
   _imgView.frame = CGRectMake(_leftPadding, 5, cellWidth,cellHeight);
    
    //NSString *jpg = [CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2];

    NSString *jpg = [NSString stringWithFormat:@"@1e_%@w_1c_0i_1o_90Q_1x.jpg",[NSNumber numberWithFloat:cellWidth*2]];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[_imgDic objectForKey:@"url"],jpg];
    [_imgView setImageWithURL:[NSURL URLWithString:url]  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}


/*
//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat imgH = [[_dataDic objectForKey:@"photoHeight"] floatValue];
    CGFloat imgW = [[_dataDic objectForKey:@"photoWidth"] floatValue];
    CGFloat height  = 0;
    if (imgH == 0 ||imgW == 0) {
        height = kDeviceWidth -20*2;
    }else{
        height = (imgH/imgW)*(kDeviceWidth -20*2);
    }
    _imgView.frame = CGRectMake(20, 0,(kDeviceWidth-20*2), height);
    
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",[_dataDic objectForKey:@"picture"],[CommonUtils imageStringWithWidth:kDeviceWidth*2 height:height*2]];
    NSURL *imgUrlString = [NSURL URLWithString:urlstring];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlstring];
    UIImage *image2 = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlstring];
    if (image||image2) {
        _imgView.image = image?:image2;
    }else
    {
        [_imgView setImageWithURL:imgUrlString usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    _imgView.backgroundColor = [UIColor purpleColor];

}
 */
//- (NSString *)getCompleteUrlString:(NSString *)imgString{
//    NSInteger wid = (kScreenWidth-20) * 2;
//    NSInteger hei = (NSInteger)230 * 2;
//    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
//    NSString *url = [NSString stringWithFormat:@"%@%@",imgString,jpg];
//    return url;
//}
//
@end
