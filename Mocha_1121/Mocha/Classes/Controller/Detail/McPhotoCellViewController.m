//
//  McPhotoCellViewController.m
//  Mocha
//
//  Created by renningning on 14-12-10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

/*
 minimumLineSpacing    行间距
 minimumInteritemSpacing   Cell间距
 itemSize        cell的尺寸
 sectionInset     区内边距
 */

#import "McPhotoCellViewController.h"
#import "McImageCollectionViewCell.h"

#import "McPhotoDetailViewController.h"
#import "PhotoBrowseViewController.h"
#import "McPreviewViewController.h"

#import "MJRefresh.h"


@interface McPhotoCellViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain) UICollectionView * collectionView;
@property (nonatomic,retain) NSMutableArray *collectionArray;
@property (nonatomic, retain) NSString *lastIndex;

@end

NSString *const McCollectionViewCellIdentifier = @"ImageCollectionViewCell";

@implementation McPhotoCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _collectionArray = [NSMutableArray array];
    _lastIndex = @"0";
    
    //collectionViewLayout不能为nil
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kDeviceWidth - 30)/2,(kDeviceWidth - 30)/2 + 40);
    flowLayout.sectionInset = UIEdgeInsetsMake(10,10,0,10);//
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight -kNavHeight) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[McImageCollectionViewCell class] forCellWithReuseIdentifier:McCollectionViewCellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_collectionView];
    
    
    [self addHeader];
    [self addFooter];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block

        [vc requestGetList:vc.lastIndex];
        
    }];
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"0";
        
        [vc requestGetList:vc.lastIndex];
        
    }];
    
    [self.collectionView headerBeginRefreshing];
}


#pragma mark request
- (void)requestGetList:(NSString *)lastIndex
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:_lastIndex forKey:@"lastindex"];
    switch (_type) {
        case McListTypeComment:
        {
            self.navigationItem.title = @"评论";
            NSDictionary *params = [AFParamFormat formatGetCommentListParams:dict];
            [AFNetwork getCommentsList:params success:^(id data){
                [self getListDone:data];
            }failed:^(NSError *error){
                
            }];
        }
            break;
        case McListTypeFavorite:
        {
            self.navigationItem.title = @"收藏";
    
            NSDictionary *params = [AFParamFormat formatGetFavoriteListParams:dict];
            [AFNetwork getFavoriteList:params success:^(id data){
                [self getListDone:data];
            }failed:^(NSError *error){
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)getListDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        NSArray *dataArr = data[@"data"];
        if ([dataArr count] > 0) {
            if ([_lastIndex isEqualToString:@"0"]) {
                self.collectionArray = [NSMutableArray arrayWithArray:dataArr];
            }
            else {
                [self.collectionArray addObjectsFromArray:dataArr];
            }
            
            self.lastIndex = [dataArr lastObject][@"id"];
            
        }
        
        [self.collectionView reloadData];
    }
    if ([self.collectionView isHeaderRefreshing]) {
        [self.collectionView headerEndRefreshing];
    }
    if ([self.collectionView isFooterRefreshing]) {
        [self.collectionView footerEndRefreshing];
    }
    
}



#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_collectionArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    McImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:McCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = [_collectionArray objectAtIndex:indexPath.row];
    
    [cell setCollectionViewCellWithValue:dict];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    PhotoBrowseViewController *previewVC = [[PhotoBrowseViewController alloc] init];
    previewVC.startWithIndex = indexPath.row;
    previewVC.currentUid = uid;
    [previewVC setDataFromCollectionWithUid:uid];
    [self.navigationController pushViewController:previewVC animated:YES];
}

//设置元素大小
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    UICollectionViewLayoutAttributes *attri = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
//    return attri.size;
//}

@end
