//
//  McSeachShowCollectionViewController.m
//  Mocha
//
//  Created by renningning on 14-12-18.
//  Copyright (c) 2014年 renningning. All rights reserved.
//
//推荐用户列表

//显示搜索结果的界面
#import "McSeachShowCollectionViewController.h"
#import "McSearchCollectionViewCell.h"
#import "MJRefresh.h"

#import "McSeachViewController.h"

@interface McSeachShowCollectionViewController ()
{
    BOOL isRoot;
}

@end

@implementation McSeachShowCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

static NSString * const reuseHeaderIdentifier = @"HeaderCell";

//一定初始化
- (id)init
{
    // UICollectionViewFlowLayout的初始化（与刷新控件无关）
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kDeviceWidth - 30)/2,(kDeviceWidth - 30)/2 + 40);
    layout.sectionInset = UIEdgeInsetsMake(10,10,0,10);//
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    return [self initWithCollectionViewLayout:layout];
}

- (void)setController
{
    self.type = 0;
    self.paramsDictionary = [NSMutableDictionary dictionary];
    self.dataArray = [NSMutableArray array];
    self.lastIndex = @"0";
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.navigationItem.title = @"发现";
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"topBar3"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.collectionView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[McSearchCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    if(_type == 1){
        [self addFooter];
        
    }
    else if(_type == 2){
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    }
    else if(_type == 0){
        [self addHeader];
        [self addFooter];
        self.navigationItem.leftBarButtonItem = nil;
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setFrame:CGRectMake(0, 0, 30, 30)];
        [searchBtn setImage:[UIImage imageNamed:@"topBar6"] forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(doJumpSearchVC:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}


#pragma mark action
- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doJumpSearchVC:(id)sender
{
    McSeachViewController *searchVC = [[McSeachViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark private
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestMoreDataWithLastindex:vc.lastIndex];
        
    }];
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"0";
        [vc requestMoreDataWithLastindex:vc.lastIndex];
        
    }];
    
    [self.collectionView headerBeginRefreshing];
}

- (void)requestMoreDataWithLastindex:(NSString *)lastindex
{
    [_paramsDictionary setValue:lastindex forKey:@"lastindex"];
    NSDictionary *params = [AFParamFormat formatSearchMochaParams:_paramsDictionary];
    [AFNetwork searchInfo:params success:^(id data){
        [self doSearchMoreDone:data];
    }failed:^(NSError *error){
        // 加载数据失败，1秒后调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.collectionView headerEndRefreshing];
        });
        
      [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}

- (void)doSearchMoreDone:(id)data
{
    if ([data[@"status"] integerValue]== kRight) {
        NSArray *arr = data[@"data"][@"user"];
        if ([arr count] > 0) {
            if ([_lastIndex isEqualToString:@"0"]) {
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray arrayWithArray:arr];
            }
            else{
                [self.dataArray addObjectsFromArray:arr];
            }
            
            _lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            
            [self.collectionView reloadData];
        }
    }
    if ([self.collectionView isHeaderRefreshing]){
        [self.collectionView headerEndRefreshing];
    }
    if ([self.collectionView isFooterRefreshing]) {
        [self.collectionView footerEndRefreshing];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    McSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [cell setCollectionViewCellWithValue:dict];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 2) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 240, 20)];
        [label setText:@"搜索结果为空，推荐以下模特"];
        label.font = kFont14;
        label.textColor = [UIColor colorForHex:kLikeGrayColor];
        [reusableView addSubview:label];
        return reusableView;
    }
    
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeZero;
    
    if (_type == 2) {
        size = CGSizeMake(kDeviceWidth, 40);
    }
    
    return size;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    
    NSString *userName = dict[@"nickname"];
    NSString *uid = dict[@"id"];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    [self.navigationController pushViewController:newMyPage animated:YES];
}


@end
