//
//  McMainFeedViewController.m
//  Mocha
//
//  Created by XIANPP on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McMainFeedViewController.h"
#import "McModelCollectionViewCell.h"
#import "MJRefresh.h"
#import "PhotoBrowseViewController.h"
#import "PhotoViewDetailController.h"

@interface McMainFeedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *_identifier;
}
@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *dataSourceMutArr;
@property (nonatomic , copy)NSString *lastIndex;

@property (nonatomic , assign) NSIndexPath* currentIndex;


@end

@implementation McMainFeedViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCollectionView];
    _isNeedReload = YES;
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.currentTitle;
    self.navigationController.navigationBarHidden = NO;
    [self.collectionView headerBeginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isNeedReload = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - loadView
-(void)loadCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake((kDeviceWidth - 8)/3,(kDeviceWidth - 8)/3);
    flowLayout.sectionInset = UIEdgeInsetsMake(3,0,0,0);//3
    //是header与cell的间隔
    flowLayout.minimumInteritemSpacing =4;
    flowLayout.minimumLineSpacing = 4;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _identifier = [NSString stringWithFormat:@"McMainFeedCell"];
    [_collectionView registerClass:[McModelCollectionViewCell class] forCellWithReuseIdentifier:_identifier];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = NO;//为了下拉刷新，一定要YES

    
    [self.view addSubview:_collectionView];
    //添加刷新视图
    [self performSelector:@selector(addHeader) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(addFooter) withObject:nil afterDelay:0.1];

}



#pragma mark 视图刷新
//添加底部刷新视图
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [_collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestUserWithLastIndex:vc.lastIndex];
    }];
}

//添加顶部刷新视图
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [_collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"0";
        [vc requestUserWithLastIndex:vc.lastIndex];
    }];
    
    [_collectionView headerBeginRefreshing];
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

#pragma mark - netWork
-(void)requestUserWithLastIndex:(NSString *)lastIndex{
    NSString *uid = self.currentUid;
    NSDictionary *params = [AFParamFormat formatGetPhotoListParams:uid lastindex:_lastIndex pageSize:@"20"];
    [AFNetwork getPhotoList:params success:^(id data){
        [self requestDone:data];
        
    }failed:^(NSError *error){
        [self endRefreshing];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}

- (void)requestDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        NSArray *dataArr = data[@"data"];
        NSLog(@"%@",dataArr);
        if ([dataArr count] > 0) {
            if ([_lastIndex isEqualToString:@"0"]) {
                _dataSourceMutArr = [NSMutableArray arrayWithArray:dataArr];
            }
            else{
                [_dataSourceMutArr addObjectsFromArray:dataArr];
            }
            _lastIndex = data[@"lastindex"];
            //_footerLabel.text = @"上拉加载更多";
            
        }
        else{
            //            _footerLabel.text = @"已无更多";
            //            self.tableView.tableFooterView.height = 40;
            [LeafNotification showInController:self.customTabBarController withText:@"已无更多"];
        }
        
        if (_isNeedReload) {
            [self.collectionView reloadData];
        }
        
        
    }
    [self endRefreshing];
}



#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)_dataSourceMutArr.count);
    return self.dataSourceMutArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    McModelCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:_identifier forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataSourceMutArr[indexPath.row];
    
    [item initWithDictionary:dic];
    NSLog(@"%lu",(unsigned long)self.dataSourceMutArr.count);


    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *uid = self.currentUid;
    NSDictionary *dic = self.dataSourceMutArr[indexPath.row];
    self.currentIndex = indexPath;
//    NSString *photoId = getSafeString(dic[@"id"]);
    if ([dic[@"feedType"] isEqualToString:@"11"]) {
        [self jumpToVideoWithDictionary:dic];
    }else{

        [self jumpToPhotoWithIndex:indexPath.row uid:uid];
    }
}

- (void)jumpToVideoWithDictionary:(NSDictionary *)dic{
    PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
    [detailVc requestWithVideoId:dic[@"id"] uid:dic[@"uid"]];
    detailVc.isFromTimeLine = YES;
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    [self.navigationController pushViewController:detailVc animated:YES];

}

- (void)jumpToPhotoWithIndex:(long)index uid:(NSString *)uid{
    PhotoBrowseViewController *photoBrow = [[PhotoBrowseViewController alloc]initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
    photoBrow.superVC = self;
    photoBrow.currentUid = uid;
    int i = (int)index;
    NSMutableArray *photoArr = [NSMutableArray array];
    for (int j = 0; j < index + 1; j ++) {
        NSDictionary *dict = _dataSourceMutArr[j];
        if ([dict[@"feedType"] isEqualToString:@"11"]) {
            i --;
        }else{
            [photoArr addObject:dict];
        }
    }
    
    photoBrow.startWithIndex = i;
    
    [photoBrow setDataFromTimeLineWithUid:uid andArray:photoArr];
    
    [self.navigationController pushViewController:photoBrow animated:YES];
}

#pragma mark - lazyLoading
-(NSMutableArray *)dataSourceMutArr{
    if (!_dataSourceMutArr) {
        _dataSourceMutArr = [NSMutableArray array];
    }
    return _dataSourceMutArr;
}

@end
