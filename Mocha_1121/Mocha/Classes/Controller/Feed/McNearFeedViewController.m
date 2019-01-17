//
//  McNearFeedViewController.m
//  Mocha
//
//  Created by XIANPP on 16/1/8.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McNearFeedViewController.h"
#import "McFeedTableViewCell.h"
#import "MJRefresh.h"
#import "AppDelegate+config.h"
#import "AppDelegate.h"
#import "MCHotHeaderView.h"
#import "MCHotJingpaiCell.h"
#import "MCJingpaiDetailController.h"
#import "JinBiViewController.h"
#import "McFeedZhuanTiCell.h"
#import "McFeedPrivacyAlbumCell.h"
#import "BrowseAlbumPhotosController.h"


@interface McNearFeedViewController ()<McFeedTableViewCellDelegate>

@property (nonatomic , strong) NSMutableArray *listArray;
@property (nonatomic , strong) NSString *lastIndex;
@property (nonatomic , strong) UILabel *footerLabel;

@property (nonatomic, strong) MCHotHeaderView *headerView;
@property (nonatomic, assign) int jingpaiListCount;
//判断是否显示竞拍内容的开关
@property (nonatomic, assign) BOOL hasAuction;

@end

@implementation McNearFeedViewController

-(MCHotHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MCHotHeaderView alloc]init];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lastIndex = @"0";
    _listArray = [NSMutableArray array];
    self.tableView.frame = CGRectMake(0,0,kDeviceWidth , kDeviceHeight -kTabBarHeight);
    //    [self requestGetList];
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 0)];
    _footerLabel.textColor = [UIColor colorForHex:kLikeLightGrayColor];
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.text = @"";
    _footerLabel.font = kFont14;
    self.tableView.tableFooterView = _footerLabel;
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kTabBarHeight);
    
    [self addHeader];
    [self addFooter];
    [self addNotificationObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL isBangDing = UserDefaultGetBool(@"bangding");
    if (!isBangDing) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:YES animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark notification
-(void)addNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePictureSuccess:) name:@"deletePictureSuccess" object:nil];
    //送礼完成刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"updateTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePictureSuccess:) name:@"deleteDynamicUpdate" object:nil];
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
        [self.tableView reloadData];
    }
}

#pragma mark - refresh
//手动给当前送礼cell的礼物数量+1
-(void)updateUI:(NSNotification *)text{
    
    NSDictionary *dict = text.userInfo;
    
    
    if (dict) {
        for (int i = 0; i < _listArray.count; i++) {
            NSMutableDictionary *onedict = [_listArray objectAtIndex:i];
            
            if ([onedict[@"id"] integerValue] == [dict[@"photoId"] integerValue]) {
                
                int temp = [onedict[@"info"][@"goodsCount"] intValue];
                NSString *newGoodsCount = [NSString stringWithFormat:@"%d",temp+1];
                
                NSDictionary *tempDict = onedict[@"info"];
                NSMutableDictionary *infoDict = tempDict.mutableCopy;
                [infoDict setObject:newGoodsCount forKey:@"goodsCount"];
                
                NSMutableDictionary *tempOneObjc = onedict.mutableCopy;
                
                [tempOneObjc setValue:infoDict forKey:@"info"];
                
                [self.listArray replaceObjectAtIndex:i withObject:tempOneObjc];
            
                break;
            }
            
        }
        [self.tableView reloadData];
        
    }
   
}


- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
        _jingpaiListCount = 0;
        _hasAuction = NO;
        [vc requestGetList];
        
    }];
    [self.tableView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [vc.tableView addFooterWithCallback:^{
        [vc requestGetList];
        _hasAuction = NO;
    }];
}

- (void)endRefreshing
{
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];
    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];
    }
}


#pragma mark - request

-(void)requestGetList{
    //添加经纬度
    CLLocationDegrees lat = Latitude;
    CLLocationDegrees lon = Longitude;
    NSNumber *latNum = [NSNumber numberWithDouble:lat];
    NSNumber *lngNum = [NSNumber numberWithDouble:lon];
    NSDictionary *paramsDic = @{@"lastindex":_lastIndex,@"latitude":latNum ,@"longitude":lngNum};
    NSDictionary *params = [AFParamFormat formatFeedGetListParams:paramsDic];
    [AFNetwork getFeedsNearList:params success:^(id data) {
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *dataArr = data[@"data"];
            if ([dataArr count] > 0) {
                NSLog(@"%@",data[@"data"]);
                if ([_lastIndex isEqualToString:@"0"]) {
                    _listArray = [NSMutableArray arrayWithArray:dataArr];
                }else{
                    [_listArray addObjectsFromArray:dataArr];
                }
                _lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                
                //获取竞拍类型数据的条数
                //需求是暂时不显示banner
//                for (NSDictionary *dict in _listArray) {
//                    NSString *type = getSafeString(dict[@"info"][@"object_type"]);
//                    if ([type isEqualToString:@"15"]) {
//                        _hasAuction = YES;
//                        break;
//                    }
//                }
                
                if (_hasAuction) {
                    
                    //iOS7后苹果会默认给header下留一个navigationbar的高度，设置为no
                    self.tableView.autoresizesSubviews = NO;
                    self.headerView.frame = CGRectMake(0, 0, kDeviceWidth, 180*kDeviceHeight/667);
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
                    
                }else{
                    
                }


                
                [self.tableView reloadData];
            }else{
               [LeafNotification showInController:self.customTabBarController withText:@"已无更多"];
            }
        }
        else{
            [LeafNotification showInController:self.customTabBarController withText:[NSString stringWithFormat:@"%@",data[@"msg"]]];
        }
        [self endRefreshing];
    } failed:^(NSError *error) {
        [self endRefreshing];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _listArray[indexPath.row];
    NSString *objectType = getSafeString(dict[@"info"][@"object_type"]);

    if ([objectType isEqualToString:@"15"]) {

        static NSString *CellIdentifier = @"hotJingpaiCell";
        MCHotJingpaiCell *cell = (MCHotJingpaiCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MCHotJingpaiCell class])
                                                  owner:self
                                                options:nil] objectAtIndex:0];
        }
        
        cell.superNearVC = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
        
        [cell setDataWithDict:_listArray[indexPath.row]];
        
        return cell;
        
    }else{
        
        {
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
                    NSString *identifier = [NSString stringWithFormat:@"McFeedTableViewCell"];
                    McFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (cell == nil) {
                        
                        cell = [McFeedTableViewCell getFeedTableViewCell];
                    }
                    cell.selfCon = self;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.cellDelegate = self;
                    cell.currentIndex = (int)indexPath.row;
                    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
                    [cell setCellItemWithDiction:dict atIndex:indexPath.row isNear:YES];
                    return cell;
                    break;
                }
            }
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    //创建一个cell对象，使用cell对象重新计算高度
    NSDictionary *dict = _listArray[indexPath.row];
    NSString *objectType = getSafeString(dict[@"info"][@"object_type"]);
 
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
                CGFloat cellHeight = [McFeedTableViewCell getCellHeight:dict];
                return cellHeight;
                break;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = _listArray[indexPath.row];
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
                    NSDictionary *dict = @{@"array":_listArray,@"index":[NSNumber numberWithInteger:indexPath.row]};
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
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpVideoDetailAction" object:dict];
                    }else
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpDetailAction" object:dict];
                    }
                    break;
                }
            }
        }
    }
}

#pragma mark cellDelegate
- (void)doTouchUpInsideWithItem:(NSDictionary *)dict status:(NSInteger)status
{
    switch (status) {
            
        case 3://评论
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doCommitAction" object:dict];
            break;
        case 100://举报
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpJuBao" object:dict];
            break;
        case 101:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doDelegatePhoto" object:dict];
            break;
        default:
            break;
    }
}

//点赞取消赞会走
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
        
        [self.tableView reloadData];
    }
}

- (void)doJumpPersonCenter:(NSDictionary *)itemDict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpPersonCenter" object:itemDict];
}

- (void)doJumpType:(NSInteger)type fromCommentDict:(NSDictionary *)commentDict
{
    switch (type) {
        case 0:
            if (self.feedDelegate && [self.feedDelegate respondsToSelector:@selector(doTouchUpActionWithDict:actionType:)]) {
                NSDictionary *dict = @{@"pid":commentDict[@"photoid"],@"uid":commentDict[@"uid"]};
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
    if (self.feedDelegate && [self.feedDelegate respondsToSelector:@selector(doTouchUpActionWithDict:actionType:)]) {
        [self.feedDelegate doTouchUpActionWithDict:itemDict actionType:McFeedActionTypePhotoDetail];
    }
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
