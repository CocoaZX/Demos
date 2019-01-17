//
//  XiangCeTableViewCell.m
//  Mocha
//
//  Created by zhoushuai on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "XiangCeTableViewCell.h"
#import "XiangCeView.h"
#import "UploadAlbumPhotosController.h"
#import "AlbumDetailViewController.h"
#import "MokaPhotosViewController.h"
#import "BrowseAlbumPhotosController.h"
#import "DynamicAlbumsViewController.h"

@implementation XiangCeTableViewCell

#pragma mark - 视图生命周期及控件加载
- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor = [UIColor orangeColor];
        [self _initViews];
    }
    return self;
    
}

//初始化视图组件
- (void)_initViews{
    //分割线
    UILabel *fengexianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    fengexianLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self.contentView addSubview:fengexianLabel];
    
    //标题：作品
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 40)];
    themeLabel.text = @"作品";
    themeLabel.textAlignment = NSTextAlignmentCenter;
    //themeLabel.backgroundColor = [UIColor redColor];
    themeLabel.font = [UIFont boldSystemFontOfSize:17];
    themeLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:themeLabel];
}


//数据源
- (void)setDataArray:(NSArray *)dataArray{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    [self setNeedsLayout];
}

//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[XiangCeView class]]) {
            [view removeFromSuperview];
        }
    }

    CGFloat cellWidth = (kDeviceWidth -50)/2;
    CGFloat cellHeiht = cellWidth;

    //行与列
    NSInteger row = 0;
    NSInteger cols = 0;
    for (int i = 0; i<_dataArray.count; i++) {
        //当前行
        if ((i%2) ==0) {
            row ++;
        }

        cols = i%2;
    
        CGFloat leftPadding = 20;
        CGFloat padding = 10;
        XiangCeView *albumCtrlView = [[[NSBundle mainBundle] loadNibNamed:@"XiangCeView" owner:nil options:nil] lastObject];
        albumCtrlView.frame = CGRectMake(leftPadding +cols *(cellWidth +padding), 10 + 40 +(cellHeiht +padding)*(row-1), cellWidth, cellHeiht);
        albumCtrlView.dataDic = _dataArray[i];
        albumCtrlView.tag = i;
        //[albumCtrlView addTarget:self action:@selector(albumClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:albumCtrlView];
     }
}


#pragma mark - 事件点击
//点击单元格
- (void)albumClick:(UIControl *)ctrl{
    NSDictionary *dic = _dataArray[ctrl.tag];
    
    //判别动态模卡
    NSString *xiangCellType =getSafeString(dic[@"type"]);
    if((xiangCellType.length != 0) && [xiangCellType isEqualToString:@"dynamicMOKA"]){
        //显示动态模卡列表
        //动态模卡
        DynamicAlbumsViewController *dynamicAlbumsVC = [[DynamicAlbumsViewController alloc] init];
        dynamicAlbumsVC.currentUid = self.currentUID;
        [self.superVC.navigationController pushViewController:dynamicAlbumsVC animated:YES];
    }else{
        //查看相册
        if(_isMaster){
            //本人
            UploadAlbumPhotosController *uploadPhotosVC = [[UploadAlbumPhotosController alloc] initWithNibName:@"UploadAlbumPhotosController" bundle:nil];
            
            uploadPhotosVC.albumID = dic[@"albumId"];
            uploadPhotosVC.currentTitle = getSafeString(dic[@"title"]);
            uploadPhotosVC.currentUID = self.currentUID;
            [self.superVC.navigationController pushViewController:uploadPhotosVC animated:YES];
        }else{
            //非本人
            BrowseAlbumPhotosController *browsePhotoVC = [[BrowseAlbumPhotosController alloc] init];
            browsePhotoVC.albumID = dic[@"albumId"];
            browsePhotoVC.currentTitle = getSafeString(dic[@"title"]);
            browsePhotoVC.currentUID = self.currentUID;
            [self.superVC.navigationController pushViewController:browsePhotoVC animated:YES];
        }
    }
}


//获取单元格高度
+(CGFloat)getXiangCeTableViewCellHeight:(NSMutableArray *) array{
    
    CGFloat cellWidth = (kDeviceWidth -50)/2;
    CGFloat cellHeiht = cellWidth;
    NSInteger rowCount = 0;
    if (array.count%2 == 0) {
        rowCount = array.count/2;
    }else{
        rowCount = array.count/2 +1;
    }
    //分割线 + themeLabel + (单元+间隙）
    return 10 + 40 +rowCount *(cellHeiht +10);
}


@end
