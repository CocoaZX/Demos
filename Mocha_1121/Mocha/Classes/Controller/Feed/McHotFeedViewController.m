 //
//  McHotFeedViewController.m
//  Mocha
//
//  Created by renningning on 15/4/22.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McHotFeedViewController.h"
#import "McFeedTableViewCell.h"
#import "MJRefresh.h"
#import "PhotoBrowseViewController.h"
#import "DaShangView.h"
#import "NewLoginViewController.h"
#import "MCHotHeaderView.h"
#import "MCHotJingpaiCell.h"
#import "MCJingpaiDetailController.h"
#import "JinBiViewController.h"
#import "McFeedZhuanTiCell.h"

#import "McFeedPrivacyAlbumCell.h"

#import "BrowseAlbumPhotosController.h"
NSString * const MCDoChatActionNotification = @"doHotFeedAction";

@interface McHotFeedViewController ()<McFeedTableViewCellDelegate,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) NSString *lastIndex;
@property (nonatomic, copy) NSString *currentUid;
@property (nonatomic, assign) BOOL hasAuction;

@property (nonatomic, strong) MCHotHeaderView *headerView;


//判断是否显示竞拍内容的开关
@property (nonatomic,assign)BOOL isAppearJingpai;

@end

@implementation McHotFeedViewController

#pragma mark - 视图生命周期及控件加载

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
     _lastIndex = @"0";
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
     self.tableView.frame = CGRectMake(0,0,kDeviceWidth , kDeviceHeight -kTabBarHeight);
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    

    [self addHeader];
    [self addFooter];
    [self addNotificationObserver];
}


-(void)updateUI:(NSNotification *)text{
    
    NSDictionary *dict = text.userInfo;
    
    //手动给当前送礼cell的礼物数量+1
    if (dict) {
        for (int i = 0; i < _listArray.count; i++) {
            NSMutableDictionary *onedict = [_listArray objectAtIndex:i];
            
            if ([onedict[@"id"] integerValue] == [dict[@"photoId"] integerValue]) {
                int temp = 0;
                if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
                    temp = [onedict[@"info"][@"goodsCount"] intValue];
                    
                }
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
        
    }else{
        //竞价成功，通知刷新
        [self.tableView reloadData];
    }
    
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

#pragma mark notification
-(void)addNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePictureSuccess:) name:@"deletePictureSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"updateTableView" object:nil];
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

#pragma mark Refresh
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
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

#pragma mark - 请求处理数据
- (void)requestGetList
{
    //添加经纬度
    CLLocationDegrees lat = Latitude;
    CLLocationDegrees lng = Longitude;
    NSNumber *latNum = [NSNumber numberWithDouble:lat];
    NSNumber *lngNum = [NSNumber numberWithDouble:lng];
    
    NSDictionary *parmas = [AFParamFormat formatFeedGetListParams:@{@"lastindex":_lastIndex,@"latitude":latNum ,@"longitude":lngNum}];
    
    [AFNetwork getFeedsHotList:parmas success:^(id data){
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

        if ([dataArr count] > 0) {
            if ([_lastIndex isEqualToString:@"0"]) {
                _listArray = [NSMutableArray arrayWithArray:dataArr];
            }
            else{
                [_listArray addObjectsFromArray:dataArr];
            }
            
            
            //获取竞拍类型数据的条数
            for (NSDictionary *dict in _listArray) {

                NSString *typeString = @"";
                if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
                    typeString = getSafeString(dict[@"info"][@"object_type"]);

                }
                if ([typeString isEqualToString:@"15"]) {

                    //在即将开始和正在进行中才显示banner

                    NSString *opcode = @"";
                    if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
                        opcode = getSafeString(dict[@"info"][@"opCode"]);
                        
                    }
                    if ([opcode isEqualToString:@"0"] || [opcode isEqualToString:@"2"]) {
                        _hasAuction = YES;
                        break;
                    }
                    
                }
            }
            
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
            
            _lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            
            [self.tableView reloadData];
        }
        else {
            [LeafNotification showInController:self.customTabBarController withText:@"已无更多"];
        }

    }
    
    [self endRefreshing];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _listArray[indexPath.row];
    NSString *objectType = @"";
    if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
        objectType = getSafeString(dict[@"info"][@"object_type"]);
        
    }
    if ([objectType isEqualToString:@"15"]) {
         static NSString *CellIdentifier = @"hotJingpaiCell";
        MCHotJingpaiCell *cell = (MCHotJingpaiCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
             cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MCHotJingpaiCell class])
                                                  owner:self
                                                options:nil] objectAtIndex:0];
        }
        
        cell.superHotVC = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
        [cell setDataWithDict:_listArray[indexPath.row]];
        return cell;
    }else{
        NSString *zhuantiPic = @"";
        if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
            zhuantiPic = getSafeString(dict[@"info"][@"object_parent_type"]);
            
        }
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
                [cell setCellItemWithDiction:dict atIndex:indexPath.row isNear:NO];
                return cell;
                break;
            }
        }
    }
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个cell对象，使用cell对象重新计算高度
    NSDictionary *dict = _listArray[indexPath.row];
    NSString *objectType = @"";
    if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
        objectType = getSafeString(dict[@"info"][@"object_type"]);
        
    }
    
    if ([objectType isEqualToString:@"15"]) {
        
        CGFloat cellHeight = [MCHotJingpaiCell getJingpaiCellHeightWith:_listArray[indexPath.row]];
        return cellHeight;
        
    }else{
        
        NSString *zhuantiPic = @"";
        if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
            zhuantiPic = getSafeString(dict[@"info"][@"object_parent_type"]);
            
        }
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

    return 0;
}

//UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dict = _listArray[indexPath.row];
    NSString *objectType = @"";
    if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
        objectType = getSafeString(dict[@"info"][@"object_type"]);
        
    }
    if ([objectType isEqualToString:@"15"]) {
        //跳转竞拍详情

        NSDictionary *dict = _listArray[indexPath.row];
        NSLog(@"%@",dict);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpDetailJingpaiVC" object:dict];
        
        NSLog(@"跳转竞拍详情");
    }else{
        
        NSString *zhuantiPic = @"";
        if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
            zhuantiPic = getSafeString(dict[@"info"][@"object_parent_type"]);
            
        }
        NSInteger object_parent_type = [zhuantiPic integerValue];
        switch (object_parent_type) {

            case 16://私密相册
            {
                NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];

                NSString *albumID = @"";
                NSString *currentTitle = @"";
                NSString *currentUID = @"";

                if ([dict[@"info"] isKindOfClass:[NSDictionary class]]) {
                    albumID = getSafeString(dict[@"info"][@"object_parent_id"]);
                    currentTitle = getSafeString(dict[@"info"][@"title"]);
                    currentUID = getSafeString(dict[@"info"][@"uid"]);
                }
                BrowseAlbumPhotosController *browsePhotoVC = [[BrowseAlbumPhotosController alloc] init];
                
                browsePhotoVC.albumID = albumID;
                browsePhotoVC.currentTitle = currentTitle;
                browsePhotoVC.currentUID = currentUID;
                [self.superNVC  pushViewController:browsePhotoVC animated:YES];
                 break;
            }
                
            default:{
                {
                NSDictionary *dict = @{@"array":_listArray,@"index":[NSNumber numberWithInteger:indexPath.row]};
                //    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
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

#pragma mark - cellDelegate
- (void)doTouchUpInsideWithItem:(NSDictionary *)dict status:(NSInteger)status
{
    switch (status) {
        
        case 3://热门动态 评论
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doCommitAction" object:dict];
            break;
        case 100:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpJuBao" object:dict];
            break;
        case 101:
            [LeafNotification showInController:self withText:@"热门动态无法删除"];
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


#pragma mark - set/get方法

-(MCHotHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MCHotHeaderView alloc]init];
    }
    return _headerView;
}


@end
