//
//  XiangCeCollectionTableViewCell.m
//  Mocha
//
//  Created by zhoushuai on 16/5/6.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "XiangCeCollectionTableViewCell.h"


#import "XiangCeTableViewCell.h"
#import "XiangCeView.h"
#import "UploadAlbumPhotosController.h"
#import "AlbumDetailViewController.h"
#import "MokaPhotosViewController.h"
#import "BrowseAlbumPhotosController.h"
#import "DynamicAlbumsViewController.h"

@implementation XiangCeCollectionTableViewCell

#pragma mark - 视图生命周期及控件加载

- (void)awakeFromNib{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self _initViews];
    }
    return self;
    
}


-(void)_initViews{
    //添加顶部视图
    [self.contentView addSubview:self.topView];
    //添加集合视图
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView reloadData];
}




#pragma mark - 获取数据
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
    [self.collectionView reloadData];
    self.collectionView.height = [XiangCeCollectionTableViewCell getXiangCeTableViewCellHeight:self.dataArray] -50;

}



#pragma mark - UICollectionViiewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //相册的个数
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XiangCeView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor purpleColor];
    cell.dataDic = _dataArray[indexPath.row];
    return cell;
}


//调整间距：针对于collectionView的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,20,0,20 );
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _dataArray[indexPath.row];
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



#pragma mark - 事件点击
#pragma mark - set/get方法
//集合视图
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置间距
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        //每个单元格的大小
        CGFloat imgWidth = (kDeviceWidth - 50)/2;
        flowLayout.itemSize = CGSizeMake(imgWidth, imgWidth);
        //创建集合视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, kDeviceWidth, self.height) collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册集合视图单元格
        UINib *nib = [UINib nibWithNibName:@"XiangCeView"
                                    bundle: [NSBundle mainBundle]];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"CollectionCellID"];
    }
    return _collectionView;
}



//初始化视图组件
- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
        //分割线
        UILabel *fengexianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
        fengexianLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
        [_topView addSubview:fengexianLabel];
        
        //标题：作品
        UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 40)];
        themeLabel.text = @"作品";
        themeLabel.textAlignment = NSTextAlignmentCenter;
        //themeLabel.backgroundColor = [UIColor redColor];
        themeLabel.font = [UIFont boldSystemFontOfSize:17];
        themeLabel.textColor = [UIColor blackColor];
        [_topView addSubview:themeLabel];
    }
    
    return _topView;
}


//获取单元格高度
+(CGFloat)getXiangCeTableViewCellHeight:(NSArray *) array{
    CGFloat cellWidth = (kDeviceWidth -50)/2;
    CGFloat cellHeiht = cellWidth;
    NSInteger rowCount = 0;
    if (array.count%2 == 0) {
        rowCount = array.count/2;
    }else{
        rowCount = array.count/2 +1;
    }
    //分割线 + themeLabel + (单元+间隙）
    return 50 +rowCount *(cellHeiht +10);
}


@end
