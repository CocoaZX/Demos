//
//  DynamicAlbumsViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/21.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DynamicAlbumsViewController.h"
#import "DynamicCollectionViewCell.h"
#import "DynamicAlbumsViewController.h"
#import "MJRefresh.h"
#import "DynamicWebViewController.h"
@interface DynamicAlbumsViewController ()

//请求数据相关============
//数据源
@property (nonatomic,strong)NSMutableArray *dataSource;
//上次请求数据
@property (nonatomic,copy)NSString *lastIndex;

//视图布局相关============
//集合视图单元格的宽度
@property (nonatomic,assign)CGFloat cellWidth;
//集合视图单元格高度
@property (nonatomic,assign)CGFloat cellHeight;

@end

@implementation DynamicAlbumsViewController

#pragma  mark - 视图生命周期及加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.title = @"动态模卡";
    [self.view addSubview:self.collectionView];

    //刷新视图的操作
    [self addHeader];
    [self addFooter];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForDeleteAlbum:) name:@"requestForDeleteDynamicAlbum" object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

//初始化视图
- (void)_initViews{
    //导航栏
    //    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    [_rightButton setTitle:@"发布" forState:UIControlStateNormal];
    //    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [_rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    //    [_rightButton addTarget:self action:@selector(publishMethod) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    //    [self.navigationItem setRightBarButtonItem:rightItem];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"requestForDeleteDynamicAlbum" object:nil];
 }


#pragma mark - 加载数据
- (void)addHeader
{
    __weak typeof(self) vc = self;
    [_collectionView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
        [vc requestDynamicAlbumsData];
        
    }];
    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) vc = self;
    [_collectionView addFooterWithCallback:^{
        [vc requestDynamicAlbumsData];
    }];
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



- (void)requestDynamicAlbumsData
{
     NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setObject:@"4" forKey:@"album_type"];
    [mdic setObject:self.currentUid forKey:@"uid"];
    [mdic setObject:_lastIndex forKey:@"lastindex"];
    NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];
    [AFNetwork getMokaList:params success:^(id data){
        [self endRefreshing];
         if ([data[@"status"] integerValue] == kRight){
            NSArray *dynamicArr = data[@"data"];
             if (dynamicArr.count >0) {
                if ([_lastIndex isEqualToString:@"0"]) {
                    [self.dataSource removeAllObjects];
                 }
                [self.dataSource addObjectsFromArray:dynamicArr];
                self.lastIndex = data[@"lastindex"];
                [self.collectionView reloadData];
            }
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [self endRefreshing];
         [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}


- (void)requestForDeleteAlbum:(NSNotification *)notification{
    //从通知中获取到动态模卡的albumId
    NSIndexPath *indexPath = notification.object;
    NSDictionary *dic = _dataSource[indexPath.row];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":dic[@"albumId"]}];
    [AFNetwork getDeleteAlbum:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            //删除相册成功
            [_dataSource removeObjectAtIndex:indexPath.row];
            [self.collectionView reloadData];
         }
         //其他情况
        [LeafNotification showInController:self withText:data[@"msg"]];

    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}


#pragma mark - 集合视图：UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString  *cellIdentifier = @"collectionViewCellID";
    DynamicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.superVC = self;
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.indexPath = indexPath;
    cell.currentUid = self.currentUid;
    cell.dataDic = dic;
    return cell;
}


//返回单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(_cellWidth, _cellHeight);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,20, 10, 20);
}



//查看动态模卡
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    //制作动态模卡的界面
    DynamicWebViewController *dynamicWebVC = [[DynamicWebViewController alloc] initWithNibName:@"DynamicWebViewController" bundle:nil];
    dynamicWebVC.conditionType = @"showDynamic";
    DynamicCollectionViewCell *cell = (DynamicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    dynamicWebVC.dynamicCoverImg =cell.imgView.image;
    dynamicWebVC.currentUid = self.currentUid;
    dynamicWebVC.dynamicDic = dic;
    //设置链接
    NSString *webUrl = [USER_DEFAULT objectForKey:@"webUrl"];
    NSString *dynamicUrl = [NSString stringWithFormat:@"%@/dynamic/detail?id=%@&album_type=4",webUrl, dic[@"albumId"]];
    dynamicWebVC.linkUrl = dynamicUrl;
    NSLog(@"-------%@",dynamicUrl);
    [self.navigationController pushViewController:dynamicWebVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource.count == indexPath.row + 12) {
        [self requestDynamicAlbumsData];
    }
}


 
#pragma mark - set/get方法
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //集合视图
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _cellWidth = (kDeviceWidth -55)/2;
        _cellHeight = _cellWidth +50;
        flowLayout.itemSize = CGSizeMake(_cellWidth,_cellHeight );
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight -kNavHeight) collectionViewLayout:flowLayout];
        _collectionView.alwaysBounceVertical = YES;
        
        //注册单元格
        UINib *nib = [UINib nibWithNibName:@"DynamicCollectionViewCell"
                                    bundle: [NSBundle mainBundle]];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"collectionViewCellID"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
