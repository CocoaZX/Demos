//
//  LocaPicturesViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "LocaPicturesViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PhotoViewCell.h"

@interface LocaPicturesViewController()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UIView *bottomView;

//存放ALAsset
@property(nonatomic,strong)NSMutableArray *dataSource;
//存放image
@property(nonatomic,strong)NSMutableArray *selectedPhotos;
//存放选中图片的路径
@property(nonatomic,strong)NSMutableArray *selectedPhotoUrls;


//必须持有ALAssetsLibrary
@property(nonatomic,strong)ALAssetsLibrary *alassetsLibrary;
//展示图片的大小
@property(nonatomic,assign)CGFloat imgWidth;


//小于9.0的系统使用普通缩略图
@property(nonatomic,assign)BOOL needThumbnail;

@end



@implementation LocaPicturesViewController


#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择图片";
    self.view.backgroundColor = [UIColor whiteColor];
    //判断显示那种缩略图
    //低于9.0系统的使用普通缩略图
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version <9.0) {
        _needThumbnail = YES;
    }else{
        _needThumbnail = NO;
    }
    
    _maxSelectCount = 9;
    //添加视图
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    [self getLoaclPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 获取数据
- (void)getLoaclPhotos{
    [self.dataSource removeAllObjects];
    //遍历所有文件夹
    [self.alassetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            //可以通过ValueProperty获取相册Group的信息
            //[self printGourpInfo:group];
            //通过文件夹来获取所有的ALAsset类型的图片或者视频
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    //可以通过ValueProperty获取相册ALAsset的信息
                    //[self printALAssetInfo:result];
                    //-----得到ALAsset
                    [self.dataSource addObject:result];
                }
            }];
        }
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        [LeafNotification showInController:self withText:@"读取相册图片信息失败"];
    }];
    
}


- (UIImage *)getImageFromALAsset:(ALAsset *)alasset{
    CGImageRef imgRef ;
    if (_needThumbnail) {
        imgRef = alasset.thumbnail;
    }else{
        imgRef = alasset.aspectRatioThumbnail;
    }
    return [UIImage imageWithCGImage:imgRef];
}



#pragma mark - UICollectionViewDataSource
//返回单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"PhotoViewCellID";
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    ALAsset *alasset = _dataSource[indexPath.row];
    
    if (indexPath.row <self.dataSource.count) {
        cell.image  = [self getImageFromALAsset:alasset];
    }
    
    //设置cell上图片的被选中状态
    NSString *url = [alasset valueForProperty:ALAssetPropertyAssetURL];
    BOOL imgExist = ([self.selectedPhotoUrls indexOfObject:url] == NSNotFound);
    cell.selectedImgView.hidden = imgExist;
    return cell;
}


//调整间距：针对于collectionView的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5,5,5, 5);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell *cell = (PhotoViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.selectedImgView.hidden) {
        //原来的图片没有被选中
        if(self.existCount +self.selectedPhotos.count >_maxSelectCount-1){
            //选择图片超过上限
            [LeafNotification showInController:self withText:[NSString stringWithFormat:@"最多可选%ld张",(long)_maxSelectCount]];
            return;
        }
        //隐藏选中图标
        cell.selectedImgView.hidden = NO;
        ALAsset *asset=self.dataSource[indexPath.row];
        //保存选中的图片和地址
        [self.selectedPhotos addObject:asset];
        [self.selectedPhotoUrls addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
        
    }else{
        //取消图片的被选中状态
        cell.selectedImgView.hidden = YES;
        ALAsset *asset=self.dataSource[indexPath.row];
        NSString *url=[asset valueForProperty:ALAssetPropertyAssetURL];
        //移除ALAsset
        for (ALAsset *a in self.dataSource) {
            NSString *tempUrl=[a valueForProperty:ALAssetPropertyAssetURL];
            if([url isEqual:tempUrl])
            {
                [self.selectedPhotos removeObject:a];
                break;
            }
        }
        //移除图片路径
        [self.selectedPhotoUrls removeObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }
    
    //重置统计信息
    UILabel *countLabel = [_bottomView viewWithTag:100];
    countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.selectedPhotos.count];
 }



#pragma mark - 事件点击
- (void)browseBtnClick:(UIButton *)btn{
    
}


//确认选择图片
- (void)sureBtnClick:(UIButton *)btn{
    //代码对象获取选中的图片
    if ([self.delegate respondsToSelector:@selector(getSelectedLocalPhotos:)]) {
        [self.delegate getSelectedLocalPhotos:self.selectedPhotos];
    }
    //返回界面
    [self.navigationController popViewControllerAnimated:YES];
}


 


#pragma mark - set/get方法
//集合视图
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置间距
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        //每个单元格的大小
        _imgWidth = (kDeviceWidth - 5 *5)/4;
        flowLayout.itemSize = CGSizeMake(_imgWidth, _imgWidth);
        //创建集合视图
        CGRect collectionViewRect = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 64 - 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor  = [UIColor whiteColor];
        
        //注册单元格
        [_collectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"PhotoViewCellID"];
    }
    return _collectionView;
}

//底部视图
- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, kDeviceHeight - 64 - 50, kDeviceWidth -10, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        //预览
        UIButton *browseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [browseBtn setTitle:@"预览" forState:UIControlStateNormal];
        [browseBtn addTarget:self action:@selector(browseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //[_bottomView addSubview:browseBtn];
        
        //显示count
        UILabel *countLable = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.right -50, 10, 30, 30)];
        countLable.tag = 100;
        countLable.text = @"0";
        countLable.font = [UIFont boldSystemFontOfSize:18];
        countLable.textColor = [UIColor whiteColor];
        countLable.textAlignment = NSTextAlignmentCenter;
        countLable.layer.cornerRadius = 15;
        countLable.layer.masksToBounds = YES;
        countLable.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
        [_bottomView addSubview:countLable];
        
        //确定按钮，返回原来界面
        //UIButton *surebtn = [[UIButton alloc] initWithFrame:CGRectMake(_bottomView.width -50 -80, 10, 80, 30)];
        UIButton *surebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, _bottomView.width -50, 40)];
        [surebtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [surebtn setTitle:@"确认" forState:UIControlStateNormal];
        [surebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [surebtn addTarget: self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:surebtn];
    }
    return _bottomView;
}


//本地所有对应的ALAsset的数组
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//被选中的ALAsset数组
- (NSMutableArray *)selectedPhotos{
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}
//被选中图片的地址数组
- (NSMutableArray *)selectedPhotoUrls{
    if (_selectedPhotoUrls == nil) {
        _selectedPhotoUrls = [NSMutableArray array];
    }
    return _selectedPhotoUrls;
}

//ALAssetsLibrary
- (ALAssetsLibrary *)alassetsLibrary{
    //ALAssetsLibrary库是iOS4之后可用的，但从最新的官方文档来看，iOS9之后这个库被废弃了，
    //当然有些功能还是可以用的，但是官方建议使用他们提供的Photos Framework
    if(_alassetsLibrary == nil){
        _alassetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _alassetsLibrary;
}




- (void)dealloc{
    
}
@end
