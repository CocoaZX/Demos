//
//  MokaPhotosViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaPhotosViewController.h"
#import "PhotoViewCell.h"
#import "MJRefresh.h"
#import "DynamicWebViewController.h"
#import "JSONKit.h"

@interface MokaPhotosViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

//视图
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,assign)CGFloat imgWidth;

//相册图片数组
@property(nonatomic,strong)NSMutableArray *albumPhotos;

//被选中图片的ID
@property(nonatomic,strong)NSMutableArray *selectedPhotoIDs;

//请求索引
@property(nonatomic,copy)NSString *lastIndex;

@end

@implementation MokaPhotosViewController


#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _currentTitle;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    
    self.lastIndex = @"0";
    
    //添加刷新视图
    [self addHeader];
    [self addFooter];
    
    //注册集合视图的头视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"descriptionHeadViewID"];

    //请求数据
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        [self getXiangCePhotos];
    }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
        [self getDynamicPhotos];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.currentTitle;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
 }


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }



#pragma mark - 数据下拉刷新设置
//下拉刷新
- (void)addHeader
{
    //删除照片,下拉会刷新，不会上拉加载更多
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        __weak typeof(self) vc = self;
        [_collectionView addHeaderWithCallback:^{
            //下拉重新加载数据
            vc.lastIndex = @"0";
            [vc getXiangCePhotos];
        }];
    }
}


//上拉加载更多
- (void)addFooter
{
    //deletePrivacyPhoto
    //制作动态模卡，不需下拉刷新，只需要上拉加载更多
    if ([self.conditionType isEqualToString:@"dynamicMoka"]) {
        __unsafe_unretained typeof(self) vc = self;
        [vc.collectionView addFooterWithCallback:^{
            //动态模卡上拉刷新
            [vc getDynamicPhotos];
         }];
    }
}


- (void)endRefreshing
{
    if ([self.collectionView isHeaderRefreshing]) {
        [self.collectionView headerEndRefreshing];
    }
    if ([self.collectionView isFooterRefreshing]) {
        [self.collectionView footerEndRefreshing];
    }
}


#pragma mark - 网络操作
//删除相册里的照片：获取相册里的图片
- (void)getXiangCePhotos{
    if (self.albumID) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setObject:@"2" forKey:@"album_type"];
        [mdic setObject:self.albumID forKey:@"id"];
        NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];        [AFNetwork getMokaDetail:params success:^(id data) {
            [self endRefreshing];
            //取出本次取出的数据
            NSArray *arr = data[@"data"][@"photos"];
            if([_lastIndex isEqualToString:@"0"]){
                [self.albumPhotos removeAllObjects];
            }
            [self.albumPhotos addObjectsFromArray:arr];
            //重新设置lastIndex;
            //self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            [self.collectionView reloadData];
        } failed:^(NSError *error) {
            [self endRefreshing];
        }];
    }
}


//获取动态里的所有图片
- (void)getDynamicPhotos{
    NSString *uid = getCurrentUid();
    if (uid) {
        NSDictionary *dic = @{@"lastindex":_lastIndex };
        NSDictionary *params = [AFParamFormat formatTempleteParams:dic];
        [AFNetwork getDynamicPhotoList:params success:^(id data) {
            [self endRefreshing];
            if ([data[@"status"] integerValue] == kRight) {
                NSArray *photos = data[@"data"];
                if (photos.count > 0) {
                    if ([_lastIndex isEqualToString:@"0"]) {
                        [self.albumPhotos removeAllObjects];
                        [self.albumPhotos addObjectsFromArray:data[@"data"]];
                    }else{
                        [self.albumPhotos addObjectsFromArray:data[@"data"]];
                    }
                    //获取下次请求需要的参数
                    self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                    [self.collectionView reloadData];
                }
            }else{
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
        } failed:^(NSError *error) {
            [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
            [self endRefreshing];
        }];
    }else{
        //执行登陆界面
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
    }
}



//
- (void)deleteXiangCePhotos{
    
    NSString *photoJson = [SQCStringUtils JSONStrWithArray:self.selectedPhotoIDs];
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"albumid":self.albumID,@"photoids":photoJson}];
    [AFNetwork getMokaDelete:params success:^(id data){
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:data[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
         }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        return 1;
    }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
        return 1;
    }
    return 1;
}

//返回单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        return self.albumPhotos.count;
    }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
        return self.albumPhotos.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"PhotoViewCellID";
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        //删除相册照片
        NSDictionary *dic = self.albumPhotos[indexPath.row];
        cell.imgUrlString = dic[@"url"];
        if(([self.selectedPhotoIDs indexOfObject:dic[@"photoId"] ] ==NSNotFound)){
            cell.selectedImgView.hidden =YES;
        }else{
            cell.selectedImgView.hidden = NO;
        }

    }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
        //选择动态里的照片
        NSDictionary *dic = self.albumPhotos[indexPath.row];
        cell.imgUrlString = dic[@"url"];
        if(([self.selectedPhotoIDs indexOfObject:dic[@"photoId"] ] ==NSNotFound)){
            cell.selectedImgView.hidden =YES;
        }else{
            cell.selectedImgView.hidden = NO;
        }
    }
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
        //增加张数限制
        if([self.conditionType isEqualToString:@"dynamicMoka"]){
            //动态模卡的选择限制
            if(self.selectedPhotoIDs.count >_maxSelectCount-1){
                //选择图片超过上限
                [LeafNotification showInController:self withText:[NSString stringWithFormat:@"最多可选%ld张",(long)_maxSelectCount]];
                return;
            }
        }
        //设置图标被选中
        cell.selectedImgView.hidden = NO;
        [self.selectedPhotoIDs addObject:_albumPhotos[indexPath.row][@"photoId"]];
    }else{
        //取消图片的被选中状态
        cell.selectedImgView.hidden = YES;
        [self.selectedPhotoIDs removeObject:_albumPhotos[indexPath.row][@"photoId"]];
        }
    
    //重置统计信息
    UILabel *countLabel = [_bottomView viewWithTag:100];
    countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.selectedPhotoIDs.count];
}


//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    //请求数据
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        return CGSizeMake(0, 0);
     }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
         CGSize size = {kDeviceWidth,60};//+5
         return size;

     }
    return CGSizeMake(0, 0);
}

//返回头视图，类似headerView和FootView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"descriptionHeadViewID" forIndexPath:indexPath];
    
    [reusableView addSubview:self.headView];
    return reusableView;
}






#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        if (buttonIndex == 0) {
            
        }else{
            //删除照片
            [self deleteXiangCePhotos];
        }

    }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
        
    }

}



#pragma mark - 事件点击
- (void)sureButtonClick:(UIButton *)btn{
    if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
        //删除照片
        NSInteger count = [self.selectedPhotoIDs count];
        if (count == 0) {
            [LeafNotification showInController:self withText:@"您还没有选择照片"];
            return;
        }
        
        NSString *messageStr = [NSString stringWithFormat:@"确定删除%ld张照片",(unsigned long)[self.selectedPhotoIDs count]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除照片" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alertView show];
     }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
         //动态模卡
         NSInteger count = [self.selectedPhotoIDs count];
         if (count <_minSelectCount) {
             [LeafNotification showInController:self withText:[NSString stringWithFormat: @"至少选择%ld张图片",(long)_minSelectCount]];
             return;
         }
         
         //制作动态模卡的界面
         DynamicWebViewController *dynamicWebVC = [[DynamicWebViewController alloc] initWithNibName:@"DynamicWebViewController" bundle:nil];
         dynamicWebVC.conditionType = @"createDynamic";
         //设置链接
         NSString *webUrl = [USER_DEFAULT objectForKey:@"webUrl"];
         NSString *dynamicCreateUrl = [NSString stringWithFormat:@"%@/dynamic/template",webUrl];
         dynamicWebVC.linkUrl = dynamicCreateUrl;
         //已经选中图片
        dynamicWebVC.photoIds = self.selectedPhotoIDs;
         [self.navigationController pushViewController:dynamicWebVC animated:YES];
    }
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
        CGRect rect = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 64 - 60);
        CGRect collectionViewRect = rect;
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
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, kDeviceHeight - 64 - 60, kDeviceWidth -10, 60)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *surebtn = [[UIButton alloc] initWithFrame:CGRectMake(10 , 5, _bottomView.width - 10*2, 50)];
        surebtn.layer.cornerRadius = 5;
        surebtn.layer.masksToBounds = YES;
        //确定按钮，返回原来界面
        [surebtn addTarget: self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:surebtn];

        if ([self.conditionType isEqualToString:@"deletePrivacyPhoto"]) {
            [surebtn setTitle:@"删除照片" forState:UIControlStateNormal];
            [surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            surebtn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];

        }else if([self.conditionType isEqualToString:@"dynamicMoka"]){
            surebtn.frame = CGRectMake(kDeviceWidth - 140, 5, 80, 50);
            [surebtn setTitle:@"开始制作" forState:UIControlStateNormal];
            [surebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            surebtn.backgroundColor = [UIColor clearColor];
            //显示count
            UILabel *countLable = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.right -50, 15, 30, 30)];
            countLable.tag = 100;
            countLable.text = @"0";
            countLable.font = [UIFont boldSystemFontOfSize:18];
            countLable.textColor = [UIColor whiteColor];
            countLable.textAlignment = NSTextAlignmentCenter;
            countLable.layer.cornerRadius = 15;
            countLable.layer.masksToBounds = YES;
            countLable.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
            [_bottomView addSubview:countLable];
        }
    }
    return _bottomView;
}



- (NSMutableArray *)albumPhotos{
    if (_albumPhotos == nil) {
        _albumPhotos = [NSMutableArray array];
    }
    return _albumPhotos;
}

- (NSMutableArray *)selectedPhotoIDs{
    if (_selectedPhotoIDs == nil) {
        _selectedPhotoIDs = [NSMutableArray array];
    }
    return _selectedPhotoIDs;
}



- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
        /*
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 20)];
        leftLabel.text = @"你的动态照片";
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        [_headView addSubview:leftLabel];
         */
        
        //
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth -200, 20, 180, 20)];
        rightLabel.text = @"已列出你所有的动态照片";
        rightLabel.font = [UIFont systemFontOfSize:16];
        rightLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [_headView addSubview:rightLabel];
     }
    return _headView;
}

@end
