//
//  McMyFeedListViewController.m
//  Mocha
//
//  Created by renningning on 15/4/23.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McMyFeedListViewController.h"
#import "McFeedTableViewCell.h"
#import "MJRefresh.h"
#import "UploadVideoManager.h"
#import "PhotoViewDetailController.h"
#import "PhotoBrowseViewController.h"
#import "McReportViewController.h"
#import "MCHotHeaderView.h"
#import "MCHotJingpaiCell.h"
#import "MCJingpaiDetailController.h"
#import "JinBiViewController.h"
#import "McModelCollectionViewCell.h"
#import "MCNewDongtaiCell.h"
#import "BrowseAlbumPhotosController.h"
#import "McFeedZhuanTiCell.h"
#import "McFeedPrivacyAlbumCell.h"

#ifdef TencentRelease
#import <MediaPlayer/MPMoviePlayerController.h>
#import "DaShangGoodsView.h"
#import "NewLoginViewController.h"


#endif

@interface McMyFeedListViewController () <McFeedTableViewCellDelegate,McBaseFeedControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) NSString *lastIndex;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, copy)   NSString *selfUid;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, copy)   NSString *photoIdStr;

@property (nonatomic, strong) DaShangGoodsView *dashangView;
@property (nonatomic, strong) MCHotHeaderView *headerView;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UICollectionView *MCcollectionView;
@property (nonatomic, copy) NSString *collectionID;


@property (nonatomic, assign) int jingpaiListCount;
//判断是否显示竞拍内容的开关
@property (nonatomic, assign) BOOL hasAuction;

#ifdef TencentRelease
@property (nonatomic, strong) NSMutableArray *playerArray;


#endif

@end

NSString * const MCDoMyFeedActionNotification = @"doMyFeedAction";

@implementation McMyFeedListViewController
#pragma mark - 视图生命周期及控件加载

-(UICollectionView *)collectionView{
    if (!_MCcollectionView) {
        _MCcollectionView = [[UICollectionView alloc]init];
    }
    return _MCcollectionView;
}

-(MCHotHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MCHotHeaderView alloc]init];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    BOOL isBangDing = UserDefaultGetBool(@"bangding");
    if (!isBangDing) {
        if (!self.isPersonDongTai) {
            [self.customTabBarController hidesTabBar:NO animated:NO];

        }
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     
    [self.customTabBarController hidesTabBar:YES animated:NO];
#ifdef TencentRelease
    [self clearPlayerVideo];

    
#endif
}


#ifdef TencentRelease
- (void)clearPlayerVideo
{
    for (int i=0; i<self.playerArray.count; i++) {
        MPMoviePlayerController *player = self.playerArray[i];
        if (player) {
            [player stop];
            [player.view removeFromSuperview];
        }
        
    }
    
}

#endif


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isPersonDongTai) {
        self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);

    }else
    {
        self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kTabBarHeight);

    }
#ifdef TencentRelease
    self.playerArray = @[].mutableCopy;
#endif
    _lastIndex = @"0";
    _listArray = [NSMutableArray arrayWithCapacity:0];
    NSString *uid = [USER_DEFAULT valueForKey:MOKA_USER_VALUE][@"id"];

    if (!self.isPersonDongTai) {
        self.currentUid = uid;
        
    }else
    {
        self.title = NSLocalizedString(@"show", nil);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCommitActionPerson:) name:@"doCommitActionPerson" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpDetailActionPerson:) name:@"doJumpDetailActionPerson" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpPersonCenter_person:) name:@"doJumpPersonCenter_person" object:nil];
        
        self.rightBtn = [[UIButton alloc]init];
        [_rightBtn setImage:[UIImage imageNamed:@"9(1)"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(changeView) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setFrame:CGRectMake(0.0f, 8.0f, 20.0f, 20.0f)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];

    }
    
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0)];
    _footerLabel.textColor = [UIColor colorForHex:kLikeLightGrayColor];
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.text = @"";
    _footerLabel.font = kFont14;
    self.tableView.tableFooterView = _footerLabel;

    [self addHeader];
    [self addFooter];
    [self addNotificationObserver];
}

//改变动态显示大图还是小图

-(void)changeView{
    
    _isTabelViewStyle = !_isTabelViewStyle;
    
    if (_isTabelViewStyle) {
        [self addTableViewToVC];
        
    }else{
        [self addCollectionViewToVC];
    }
}

-(void)addTableViewToVC{
    if (self.isPersonDongTai) {
        self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        
    }else
    {
        self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kTabBarHeight);
        
    }
    
    [_rightBtn setImage:[UIImage imageNamed:@"9(1)"] forState:UIControlStateNormal];
    
    [self.MCcollectionView removeFromSuperview];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}


-(void)addCollectionViewToVC{
    
    CGRect mcCollectionFrame ;
    if (self.isPersonDongTai) {
        mcCollectionFrame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64);
        
    }else
    {
        mcCollectionFrame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kTabBarHeight-64);
        
    }
    [_rightBtn setImage:[UIImage imageNamed:@"1(1)"] forState:UIControlStateNormal];
    
    self.MCcollectionView.delegate = self;
    self.MCcollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake((kDeviceWidth - 8)/3,(kDeviceWidth - 8)/3);
    flowLayout.sectionInset = UIEdgeInsetsMake(3,0,0,0);//3
    //是header与cell的间隔
    flowLayout.minimumInteritemSpacing =4;
    flowLayout.minimumLineSpacing = 4;
    
    
    self.MCcollectionView = [[UICollectionView alloc]initWithFrame:mcCollectionFrame collectionViewLayout:flowLayout];
    _MCcollectionView.delegate = self;
    _MCcollectionView.dataSource = self;
    _MCcollectionView.backgroundColor = [UIColor whiteColor];
    _collectionID = [NSString stringWithFormat:@"McMainFeedCell"];
    [_MCcollectionView registerClass:[McModelCollectionViewCell class] forCellWithReuseIdentifier:_collectionID];
    _MCcollectionView.showsVerticalScrollIndicator = NO;
    _MCcollectionView.alwaysBounceVertical = YES;//为了下拉刷新，一定要YES
    
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.MCcollectionView];
//    [self.MCcollectionView reloadData];
    
    [self performSelector:@selector(addHeader) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(addFooter) withObject:nil afterDelay:0.1];
    
}

#pragma mark notification
-(void)addNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePictureSuccess:) name:@"deletePictureSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"updateTableView" object:nil];
    
}

//手动给当前送礼cell的礼物数量+1
-(void)updateUI:(NSNotification *)text{
    
    NSDictionary *dict = text.userInfo;
    
    if (dict) {
        for (int i = 0; i < _listArray.count; i++) {
            NSMutableDictionary *onedict = [_listArray objectAtIndex:i];
            
            if ([onedict[@"id"] integerValue] == [dict[@"photoId"] integerValue]) {
                
                int temp = [onedict[@"goodsCount"] intValue];
                NSString *newGoodsCount = [NSString stringWithFormat:@"%d",temp+1];
                
                NSMutableDictionary *tempOneObjc = onedict.mutableCopy;
                [tempOneObjc setValue:newGoodsCount forKey:@"goodsCount"];
                
                [self.listArray replaceObjectAtIndex:i withObject:tempOneObjc];
                
                break;
                
            }
        }
        
        if (_isTabelViewStyle) {
            [self.tableView reloadData];
        }else{
            [self.MCcollectionView reloadData];
        }
        
    }
    
}


-(void)deletePictureSuccess:(NSNotification *)sender{
    NSDictionary *dic = sender.object;
    if (dic) {
        
        for (NSDictionary *dictionary in self.listArray) {
            if ([dictionary[@"id"] integerValue] == [dic[@"id"] integerValue]) {
                [self.listArray removeObject:dictionary];
                break;
            }
        }
        if (_isTabelViewStyle) {
            [self.tableView reloadData];
        }else{
            [self.MCcollectionView reloadData];
        }
    }
}

- (void)doCommitActionPerson:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    
    PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
    id photo = feedDict[@"info"];
    if (photo) {
        [detailVc requestWithPhotoId:feedDict[@"info"][@"id"] uid:feedDict[@"user"][@"id"]];
    }else
    {
        [detailVc requestWithPhotoId:feedDict[@"id"] uid:feedDict[@"uid"]];
        
    }
    detailVc.isFromTimeLine = YES;
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
     
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark notification
- (void)doJumpDetailActionPerson:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    NSInteger currentIndex = [feedDict[@"index"] integerValue];
    NSString *uid = self.currentUid;
    NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"id"]];
    PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
    browseVC.startWithIndex = 0;
    browseVC.currentUid = uid;
    [browseVC setDataFromPhotoId:photoId uid:uid];
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
     
    [self.navigationController pushViewController:browseVC animated:YES];
    
}

#pragma mark Refresh
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    
    if (_isTabelViewStyle) {
        [self.tableView addHeaderWithCallback:^{
            vc.lastIndex = @"0";
            _hasAuction = NO;
            [vc requestGetList];
            
        }];
        [self.tableView headerBeginRefreshing];
        
    }else{
        [self.MCcollectionView addHeaderWithCallback:^{
            vc.lastIndex = @"0";
            _hasAuction = NO;
            [vc requestGetList];
            
        }];
        
    }
    
    
    
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    
    if (_isTabelViewStyle) {
        [vc.tableView addFooterWithCallback:^{
            [vc requestGetList];
            _hasAuction = NO;
        }];
        
    }else{
        [vc.MCcollectionView addFooterWithCallback:^{
            [vc requestGetList];
            _hasAuction = NO;
        }];
    }
    
}

- (void)endRefreshing
{
    if (_isTabelViewStyle) {
        if ([self.tableView isHeaderRefreshing]) {
            [self.tableView headerEndRefreshing];
        }
        if ([self.tableView isFooterRefreshing]) {
            [self.tableView footerEndRefreshing];
        }
        
    }else{
        if ([self.MCcollectionView isHeaderRefreshing]) {
            [self.MCcollectionView headerEndRefreshing];
        }
        if ([self.MCcollectionView isFooterRefreshing]) {
            [self.MCcollectionView footerEndRefreshing];
        }
    }
    
    
}

#pragma mark Request
- (void)requestGetList
{
    NSString *uid = self.currentUid;
    _selfUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    [USER_DEFAULT synchronize];
    if (!self.isPersonDongTai) {
        if (!_selfUid)
        {
            [self endRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.customTabBarController];
                return;
            });
        }
        
        //添加了经纬度信息
        CLLocationDegrees lat = Latitude;
        CLLocationDegrees lng = Longitude;
        NSNumber *latNum = [NSNumber numberWithDouble:lat];
        NSNumber *lngNum = [NSNumber numberWithDouble:lng];
        NSDictionary *parmas = [AFParamFormat formatFeedGetListParams:@{@"lastindex":_lastIndex,@"latitude":latNum ,@"longitude":lngNum,@"pagesize":@"18"}];
        [AFNetwork getFeedsMyList:parmas success:^(id data){
            [self requestDone:data];
        }failed:^(NSError *error){
            [self endRefreshing];
        }];
    }else
    {
        NSDictionary *params = [AFParamFormat formatGetPhotoListParams:uid lastindex:_lastIndex];
        [AFNetwork getPhotoList:params success:^(id data){
        
            [self requestDone:data];
            
        }failed:^(NSError *error){
            [self endRefreshing];
            [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        }];

        
    }
    
}

- (void)requestDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        
        NSArray *dataArr = data[@"data"];
        if ([dataArr count] > 0) {
            if ([_lastIndex isEqualToString:@"0"]) {
                _listArray = [NSMutableArray arrayWithArray:dataArr];
            }
            else{
                [_listArray addObjectsFromArray:dataArr];
            }
            _lastIndex = data[@"lastindex"];
            
            //朋友秀如果需要banner则打开
            //获取竞拍类型数据的条数
//            for (NSDictionary *dict in _listArray) {
//                if ([getSafeString(dict[@"info"][@"object_type"]) isEqualToString:@"15"]) {
//                    if (!_isPersonDongTai) {
//                        _hasAuction = YES;
//                    }
//                    
//                    break;
//                }
//            }
            
            if (_hasAuction) {
                
                //iOS7后苹果会默认给header下留一个navigationbar的高度，设置为no
                self.tableView.autoresizesSubviews = NO;
                self.headerView.frame = CGRectMake(0, 0, kDeviceWidth, 230*kDeviceWidth/375);
                self.tableView.tableHeaderView = self.headerView;
                
                for (NSDictionary *dict in _listArray) {
                    NSString *type = getSafeString(dict[@"info"][@"object_type"]);
                    if ([type isEqualToString:@"15"]) {
                        NSDictionary *bannerDict = [USER_DEFAULT objectForKey:@"auctionBannerInfo"];
                        NSString *url = bannerDict[@"banner_url"];
                        [self.headerView setupUIWith:dict withCount:0 withBannerImgUrl:url];
                        break;
                    }
                }
            }

            //是否根据有无竞拍数据显示banner头
            
//            if (_hasAuction) {
//                
//                //iOS7后苹果会默认给header下留一个navigationbar的高度，设置为no
//                //                self.tableView.autoresizesSubviews = NO;
//                self.headerView.frame = CGRectMake(0, 0, kDeviceWidth, 180*kDeviceHeight/667);
//                self.tableView.tableHeaderView = self.headerView;
//                
//                
//                NSMutableDictionary *dict = _listArray[0];
////                NSLog(@"%@",dict);
//                NSString *url = dict[@"info"][@"banner"];
//                [self.headerView setupUIWith:dict withCount:_jingpaiListCount withBannerImgUrl:url];
//            }
            if (_isTabelViewStyle) {
                [self.tableView reloadData];
            }else{
                [self.MCcollectionView reloadData];
            }
 
 
        }
        else{
//            _footerLabel.text = @"已无更多";
//            self.tableView.tableFooterView.height = 40;
            [LeafNotification showInController:self.customTabBarController withText:@"已无更多"];
        }
        
        
        
    }
    [self endRefreshing];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_listArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //个人动态改版，原版直接去掉if判断
    if (!_isPersonDongTai) {
        
        NSDictionary *dict = _listArray[indexPath.row];
        NSString *objectType = getSafeString(dict[@"info"][@"object_type"]);
        
        if ([objectType isEqualToString:@"15"]) {
            
            static NSString *CellIdentifier = @"hotJingpaiCell";
            MCHotJingpaiCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MCHotJingpaiCell class])owner:self options:nil] objectAtIndex:0];
            }
            
            cell.superListVC = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellDelegate = self;

            [cell setDataWithDict:dict];
            
            return cell;
            
        }else{
            
            NSString *zhuantiPic = getSafeString(dict[@"info"][@"object_parent_type"]);
            NSInteger object_parent_type = [zhuantiPic integerValue];
            switch (object_parent_type) {
                case 10:
                {
                    NSString *identifier = [NSString stringWithFormat:@"McFeedZhuanTiCell"];
                    McFeedZhuanTiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (cell == nil) {
                        cell = [McFeedZhuanTiCell getFeedZhuanTiCell];
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
                    cell.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
                    [cell initWithDict:dict];
                    cell.cellDelegate = self;
                    return cell;
                    break;
                }
                case 16:
                {//相册单元格
                    NSString *identifier = [NSString stringWithFormat:@"McFeedAlbumCellID"];
                    McFeedPrivacyAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (cell == nil) {
                        cell = [McFeedPrivacyAlbumCell getMcFeedPrivacyAlbumCell];
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
                    cell.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
                    cell.dataDic = dict;
                    cell.cellDelegate = self;
                    return cell;
                    
                    break;
                }
                    
                default:{
                    //普通秀单元格
                    NSString *identifier = [NSString stringWithFormat:@"McFeedListTableViewCell"];
                    McFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (cell == nil) {
                        
                        cell = [McFeedTableViewCell getFeedTableViewCell];
                        
                    }
                    
                    cell.selfCon = self;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.cellDelegate = self;
                    cell.currentIndex = (int)indexPath.row;
                    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
                    [cell setCellItemWithDiction_mine:dict atIndex:indexPath.row];
                    
                    return cell;
                    break;
                }
            }
        }

    }else{
        
        //个人动态
        MCNewDongtaiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCNewDongtaiCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"MCNewDongtaiCell" bundle:nil] forCellReuseIdentifier:@"MCNewDongtaiCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MCNewDongtaiCell"];
        }
        
        if (indexPath.row == 0) {
            cell.isHiddenLine = YES;
        }else{
            cell.isHiddenLine = NO;
        }
        
        cell.superVC = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < _listArray.count) {
            [cell setupNewDongtaiCellView:_listArray[indexPath.row]];
            cell.index = indexPath.row;
        }

        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPersonDongTai) {
        
        if (indexPath.row<_listArray.count) {
            
            float height = [MCNewDongtaiCell getNewDongtaiCellHeight:_listArray[indexPath.row]];
            return height;
        }else{
            return 0;
        }
        
    }else{
        //创建一个cell对象，使用cell对象重新计算高度
        NSDictionary *dict = _listArray[indexPath.row];
        NSString *objectType ;
    
        objectType = dict[@"info"][@"object_type"];

        if ([objectType isEqualToString:@"15"]) {

            CGFloat cellHeight = [MCHotJingpaiCell getJingpaiCellHeightWith:_listArray[indexPath.row]];
            return cellHeight;
            
        }else{
            NSString *zhuantiPic = getSafeString(dict[@"info"][@"object_parent_type"]);
            NSInteger object_parent_type = [zhuantiPic integerValue];
            switch (object_parent_type) {
                case 10:
                {
                    return [McFeedZhuanTiCell getHeightWithDict:dict];
                    break;
                }
                case 16:
                {
                    return [McFeedPrivacyAlbumCell getMcFeedPrivacyAlbumCelllHeight];
                    break;
                }
                    
                default:{
                    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
                    CGFloat cellHeight = [McFeedTableViewCell getCellHeight_mine:dict];
                    return cellHeight;
                    break;
                }
            }

        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc] init];
    
    if (_listArray.count <= 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    }
    else{
        [view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    }
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont systemFontOfSize:14];
    view.textColor = [UIColor lightGrayColor];
    view.text = @"暂无动态";
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_listArray.count <= 0){
        return 40.0;
    }
    
    return 0.0;
}

//UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _listArray[indexPath.row];
    NSString *objectType ;
    if (_isPersonDongTai) {
        objectType = dict[@"object_type"];
    }else{
        objectType = dict[@"info"][@"object_type"];
    }
    
    if (_isPersonDongTai) {
        
        if ([objectType isEqualToString:@"11"])
        {
            
            [self jumpToVideoWithDictionary:dict];
            
        }else if([objectType isEqualToString:@"6"])
        {
            
            NSString *parent_type = getSafeString(dict[@"info"][@"object_parent_type"]);
            if ([parent_type isEqualToString:@"16"])
            {
                //跳转私密相册
                NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
                BrowseAlbumPhotosController *browsePhotoVC = [[BrowseAlbumPhotosController alloc] init];
                browsePhotoVC.albumID = dict[@"info"][@"object_parent_id"];
                browsePhotoVC.currentTitle = getSafeString(dict[@"info"][@"title"]);
                browsePhotoVC.currentUID = dict[@"info"][@"uid"];
//                NSLog(@"%@-%@-%@",browsePhotoVC.albumID,browsePhotoVC.currentTitle,browsePhotoVC.currentUID );
                [self.navigationController  pushViewController:browsePhotoVC animated:YES];

            }else
            {
                PhotoViewDetailController *detailVC = [[PhotoViewDetailController alloc] init];
                NSString *photoID = getSafeString(dict[@"id"]);
                NSString *uid = getSafeString(dict[@"uid"]);
                [detailVC requestWithPhotoId:photoID uid:uid];
                
                [self.navigationController  pushViewController:detailVC animated:YES];
//                NSLog(@"%@",dict);
                //跳转浏览页方法
//                [self jumpToPhotoWithIndex:indexPath.row uid:uid];
            }
        }else if([objectType isEqualToString:@"15"])
        {
            [self jumpToDetailJingpaiVC:dict];
        }else{
            //动态后期其他类型的跳转
        }
    }else{
//        NSDictionary *dict = _listArray[indexPath.row];
        NSString *objectType = getSafeString(dict[@"info"][@"object_type"]);

        if ([objectType isEqualToString:@"15"]) {
            //跳转竞拍详情
            NSDictionary *dict = _listArray[indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpDetailJingpaiVC" object:dict];
            
        }else{
            
            NSString *zhuantiPic = getSafeString(dict[@"info"][@"object_parent_type"]);
            NSInteger object_parent_type = [zhuantiPic integerValue];
            switch (object_parent_type) {
                    
                case 16://私密相册
                {
                    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
                    BrowseAlbumPhotosController *browsePhotoVC = [[BrowseAlbumPhotosController alloc] init];
                    browsePhotoVC.albumID = dict[@"info"][@"object_parent_id"];
                    browsePhotoVC.currentTitle = getSafeString(dict[@"info"][@"title"]);
                    browsePhotoVC.currentUID = dict[@"info"][@"uid"];
                    [self.superNVC  pushViewController:browsePhotoVC animated:YES];
                    break;
                }
                    
                default:{
                    {
                        NSDictionary *dic = @{@"array":_listArray,@"index":[NSNumber numberWithInteger:indexPath.row]};
                        NSString *feedType = @"";
                        id photo = _listArray[indexPath.row][@"info"];
                        if (photo) {
                            feedType = _listArray[indexPath.row][@"info"][@"feedType"];
                        }else
                        {
                            feedType = _listArray[indexPath.row][@"feedType"];
                        }
                        
                        //根据类型跳转
                        if ([feedType isEqualToString:@"11"]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpVideoDetailAction" object:dic];
                           
                        }else
                        {
                            NSDictionary *dict = @{@"array":_listArray,@"index":[NSNumber numberWithInteger:indexPath.row]};
                            
                            //跳转浏览页方法
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpDetailAction" object:dict];
                            
                        }
                        
                    }
                    
                }
                break;
            }
        }
    }
}




#pragma mark collection代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    McModelCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionID forIndexPath:indexPath];
    
    NSDictionary *dic = _listArray[indexPath.row];
    
    [item initWithDictionary:dic];
    
    
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _listArray[indexPath.row];
    NSString *objectType ;
    if (_isPersonDongTai) {
        objectType = dict[@"object_type"];
    }else{
        objectType = dict[@"info"][@"object_type"];
    }
    
    if ([objectType isEqualToString:@"11"]) {
        [self jumpToVideoWithDictionary:dict];
    }else if([objectType isEqualToString:@"6"]){
        NSString *parent_type = getSafeString(dict[@"info"][@"object_parent_type"]);
        if ([parent_type isEqualToString:@"16"])
        {
            //跳转私密相册
            NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
            BrowseAlbumPhotosController *browsePhotoVC = [[BrowseAlbumPhotosController alloc] init];
            browsePhotoVC.albumID = dict[@"info"][@"object_parent_id"];
            browsePhotoVC.currentTitle = getSafeString(dict[@"info"][@"title"]);
            browsePhotoVC.currentUID = dict[@"info"][@"uid"];
            NSLog(@"%@-%@-%@",browsePhotoVC.albumID,browsePhotoVC.currentTitle,browsePhotoVC.currentUID );
            [self.navigationController  pushViewController:browsePhotoVC animated:YES];
            
        }else
        {
            PhotoViewDetailController *detailVC = [[PhotoViewDetailController alloc] init];
            NSString *photoID = getSafeString(dict[@"id"]);
            NSString *uid = getSafeString(dict[@"uid"]);
            [detailVC requestWithPhotoId:photoID uid:uid];
            [self.navigationController  pushViewController:detailVC animated:YES];

        }

    }else if([objectType isEqualToString:@"15"]){
        [self jumpToDetailJingpaiVC:dict];
    }else{
        //跳转私密相册
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
//    photoBrow.superVC = self;
    photoBrow.currentUid = uid;
    int i = (int)index;
    NSMutableArray *photoArr = [NSMutableArray array];
    for (int j = 0; j < index + 1; j ++) {
        NSDictionary *dict = _listArray[j];
        if ([dict[@"feedType"] isEqualToString:@"6"]) {
            [photoArr addObject:dict];
        }else{
            i --;
        }
    }
    
    photoBrow.startWithIndex = i;
    
    [photoBrow setDataFromTimeLineWithUid:uid andArray:photoArr];
    
    [self.navigationController pushViewController:photoBrow animated:YES];
}

-(void)jumpToDetailJingpaiVC:(NSDictionary *)dict{
    
    
    NSDictionary *feedDict = dict;
    
    MCJingpaiDetailController *jingpaiDetailVC = [[MCJingpaiDetailController alloc]init];
    MCHotJingpaiModel *model = [[MCHotJingpaiModel alloc]initWithDictionary:feedDict error:nil];
    jingpaiDetailVC.jingpaiID = model.info.auctionID;
    
    if ([getSafeString(model.info.opCode) isEqualToString:@"0"] ) {
        jingpaiDetailVC.isOnAuction = YES;
    }else{
        jingpaiDetailVC.isOnAuction = NO;
    }

    [self.navigationController pushViewController:jingpaiDetailVC animated:YES];
}


- (void)actionDoneWithItem:(NSDictionary *)dict message:(NSString *)msg isReload:(BOOL)isReload
{
    
    
    if (msg.length>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LeafNotification showInController:self withText:[NSString stringWithFormat:@"%@",msg]];
            
        });
        
    }
    if (isReload) {
        
        for (int i = 0; i < [_listArray count]; i++) {
            NSDictionary *onedict = [_listArray objectAtIndex:i];
            if ([onedict[@"id"] integerValue] == [dict[@"id"] integerValue]) {
                
                [_listArray replaceObjectAtIndex:i withObject:dict];
                
                break;
            }
            
        }
        
        if (_isTabelViewStyle) {
            [self.tableView reloadData];
        }else{
            [self.MCcollectionView reloadData];
        }
    }
    
}
#pragma mark cellDelegate
- (void)doTouchUpInsideWithItem:(NSDictionary *)dict status:(NSInteger)status
{
    switch (status) {
        case 1:
            break;
        case 2:
            
            break;
        case 3://关注动态 评论
        {
            if (!self.isPersonDongTai) {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"doCommitAction" object:dict];
//                NSLog(@"%@",dict);
            }else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"doCommitActionPerson" object:dict];
                
            }
        }
            break;
        case 100:
            if (self.isPersonDongTai) {//个人动态
                [self isPersonDongTaiIsMasterActionSheetSet:dict];
            }else//关注动态
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpJuBao" object:dict];
                
            }
            
            break;
        case 101:
            if (self.isPersonDongTai) {//个人动态
                [self isPersonDongTaiIsMasterActionSheetSet:dict];
            }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doDelegatePhoto" object:dict];
            }
            break;
        default:
            break;
    }
}
//个人动态举报和删除
-(void)isPersonDongTaiIsMasterActionSheetSet:(NSDictionary *)dict{
    NSString *alertStr = @"举报";
    NSString *uid = [NSString stringWithFormat:@"%@",dict[@"uid"]];
    self.currentJuBaoUid = uid;
    self.selfUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (dict[@"id"]) {
        self.photoIdStr = dict[@"id"];
    }
    if ([self.selfUid isKindOfClass:[NSString class]]) {
        if ([self.selfUid isEqualToString:self.currentUid]) {
            alertStr = @"删除";
            _isMaster = YES;
        }else{
            _isMaster = NO;
        }
    }
    UIActionSheet *jubaoSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:[NSString stringWithFormat:@"%@",alertStr], nil];
    [jubaoSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if (uid) {
           
            if (_isMaster) {
                [self isMasterDelegatePhoto];
            }else{
                MCJuBaoViewController *report = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];

            report.targetUid = self.currentJuBaoUid;
            [self.navigationController pushViewController:report animated:YES];
            }
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            
        }
    }
}

-(void)isMasterDelegatePhoto{
    NSString *uid = [self getSafeStr:[NSString stringWithFormat:@"%@", [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]]];
    NSString *photoId = [self getSafeStr:self.photoIdStr];
    NSDictionary *dict = [AFParamFormat formatDeleteActionParams:photoId userId:uid];
    [AFNetwork deletePicture:dict success:^(id data){

        if([data[@"status"] integerValue] == kRight){
            NSLog(@"删除");
            [LeafNotification showInController:self.customTabBarController withText:@"已成功删除"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePictureSuccess" object:dict];
        }
        else{
            [LeafNotification showInController:self.customTabBarController withText:data[@"msg"]];

        }
        
    }failed:^(NSError *error){
        
        [LeafNotification showInController:self.customTabBarController withText:@"当前网络不太顺畅哟"];
    }];
}

- (void)actionDone:(NSString *)msg isReload:(BOOL)isReload
{
    [LeafNotification showInController:self withText:msg];
    if (isReload) {
        if (_isTabelViewStyle) {
            [self.tableView reloadData];
        }else{
            [self.MCcollectionView reloadData];
        }
    }
}

- (void)doJumpPersonCenter_person:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *itemDict = notify.object;
    
    NSString *userName = @"";
    NSString *uid = @"";
    if (itemDict[@"user"][@"id"]) {
        uid = itemDict[@"user"][@"id"];
    }
    if (uid) {
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.currentTitle = userName;
        newMyPage.currentUid = uid;
        
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT synchronize];
        
        
        
        [self.navigationController pushViewController:newMyPage animated:YES];
    }
}

- (void)doJumpPersonCenter:(NSDictionary *)itemDict
{
    if (self.isPersonDongTai) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpPersonCenter_person" object:itemDict];

    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpPersonCenter" object:itemDict];

    }
}

- (void)doJumpType:(NSInteger)type fromCommentDict:(NSDictionary *)commentDict
{
    switch (type) {
        case 0:
            if (self.feedDelegate && [self.feedDelegate respondsToSelector:@selector(doTouchUpActionWithDict:actionType:)]) {
                NSDictionary *dict = @{@"pid":commentDict[@"id"],@"uid":commentDict[@"uid"]};
                [self.feedDelegate doTouchUpActionWithDict:dict actionType:McFeedActionTypeComment];
            }
            break;
        case 1:
            if (self.feedDelegate && [self.feedDelegate respondsToSelector:@selector(doTouchUpActionWithDict:actionType:)]) {
                NSDictionary *dict = @{@"uid":commentDict[@"uid"]};
                [self.feedDelegate doTouchUpActionWithDict:dict actionType:McFeedActionTypePersonCenter];
            }
            break;
            
        default:
            break;
    }
}

- (void)doJumpDaShangView:(NSDictionary *)itemDict
{
    if (self.isPersonDongTai) {
        [self doTouchUpActionWithDict:itemDict actionType:McFeedActionTypePhotoDetail];
    }else
    {
        if (self.feedDelegate && [self.feedDelegate respondsToSelector:@selector(doTouchUpActionWithDict:actionType:)]) {
            [self.feedDelegate doTouchUpActionWithDict:itemDict actionType:McFeedActionTypePhotoDetail];
        }
    }
   
    
}

- (void)doTouchUpActionWithDict:(NSDictionary *)itemDict actionType:(NSInteger)type
{
    switch (type) {
        case McFeedActionTypeComment:{
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithPhotoId:itemDict[@"pid"] uid:itemDict[@"uid"]];
            detailVc.isFromTimeLine = YES;
            
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            
             
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case McFeedActionTypePhotoDetail:{
            
            NSDictionary *feedDict = itemDict;
            [self showDashangView:feedDict];
            //原有的跳转照片查看页打赏方法
//            NSDictionary *feedDict = itemDict;
//            NSString *uid = [NSString stringWithFormat:@"%@",feedDict[@"uid"]];
//            NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"id"]];
//            PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
//            browseVC.startWithIndex = 0;
//            browseVC.currentUid = uid;
//            browseVC.isNeedShangView = @"1";
//            //    [browseVC setDataFromFeedArray:feedDict[@"array"]];
//            //    browseVC.dataArray = feedDict[@"array"];
//            [browseVC setDataFromPhotoId:photoId uid:uid];
//            
//            
//            UserDefaultSetBool(NO, @"isHiddenTabbar");
//            [USER_DEFAULT synchronize];
//            
//             
//            [self.navigationController pushViewController:browseVC animated:YES];
        }
            break;
        case McFeedActionTypePersonCenter:{
            
            
            NSString *userName = @"";
            NSString *uid = itemDict[@"uid"];
            
            NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
            newMyPage.currentTitle = userName;
            newMyPage.currentUid = uid;
            
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            
             
            
            [self.navigationController pushViewController:newMyPage animated:YES];
        }
            
        default:
            break;
    }
}

//跳转打赏覆盖界面
-(void)showDashangView:(NSDictionary *)dict{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    //如果没有登录，进入登录界面
    if (!uid) {
        [self goToLoginVC];
        return;
    }
    
//    NSDictionary *feedDict = itemDict;
//    
//    NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"id"]];
//    NSString *dashangType = [NSString stringWithFormat:@"%@",feedDict[@"feedType"]];
//    NSString *targetUid = [NSString stringWithFormat:@"%@",feedDict[@"uid"]];
//    

    
    self.dashangView = [[DaShangGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dashangView.superController = self;
    self.dashangView.animationType = @"dashangWithNoAnimation";
    
    NSString *photoId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    NSString *dashangType = [NSString stringWithFormat:@"%@",dict[@"feedType"]];
    
    
    self.dashangView.targetUid = _currentUid;
    self.dashangView.currentPhotoId = photoId;
    self.dashangView.dashangType = dashangType;
    
    
    [self.dashangView setUpviews];
    [self.dashangView addToWindow];
    

    
}

- (void)goToLoginVC{
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
    [USER_DEFAULT synchronize];
    NewLoginViewController *login = [[NewLoginViewController alloc] initWithNibName:@"NewLoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:login animated:YES];
}

-(NSString *)getSafeStr:(NSString *)str{
    if (str == nil) {
        str = @"";
    }
    return str;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
