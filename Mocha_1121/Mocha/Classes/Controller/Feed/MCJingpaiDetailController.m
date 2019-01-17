//
//  MCJingpaiDetailController.m
//  Mocha
//
//  Created by TanJian on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJingpaiDetailController.h"
#import "MCJingpaiDetailHeaderView.h"
#import "headerForDetailVCFirstSection.h"
#import "DetailVCJingpaiCell.h"
#import "DetailVCPraiseCell.h"
#import "DetailVCCommentCell.h"
#import "headerForCommentSection.h"
#import "MCJingpaiView.h"
#import "MCShareJingpaiView.h"
#import "McReportViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MCJingpaiDetailModel.h"
#import "MCJingpaiCommitView.h"
#import "MCAuctionTipsController.h"
#import "JinBiViewController.h"
#import "auctionTips.h"

@interface MCJingpaiDetailController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) MCJingpaiView *jingpaiView;
@property (nonatomic, strong) UIActionSheet *moreSheet;
@property (nonatomic, strong) NSString *lastIndex;
@property (nonatomic, strong) MCJingpaiDetailModel *model;
@property (nonatomic, strong) MCJingpaiDetailHeaderView *headerView;
@property (nonatomic, strong) MCJingpaiCommitView *commitView;

@property (strong, nonatomic) NSMutableArray *commentDataArray;
@property (nonatomic, assign) BOOL isExistAuction;
@property (nonatomic, assign) BOOL isExistPraise;
@property (nonatomic, assign) BOOL isExistComment;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) int sectionCount;
@property (nonatomic, assign) BOOL isReload;

@property (nonatomic,assign) CGPoint contentOffset;

@end

@implementation MCJingpaiDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.frame = CGRectMake(0,0,kDeviceWidth , kDeviceHeight-kTabBarHeight-50);
    
    self.isExistPraise = NO;
    self.isExistAuction = NO;
    self.isExistComment = NO;
    self.sectionCount = 0;
    
    _auctionLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    _commentLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    
    if (!self.isOnAuction) {
        _jingpaiButton.userInteractionEnabled = NO;
        
        _auctionImg.image = [UIImage imageNamed:@"auctionIcon_normal"];
        _auctionLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
        
    }
    NSLog(@"%@",_jingpaiID);
    self.title = @"竞拍详情";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    
    [self.jingpaiButton addTarget:self action:@selector(appearJingpaiView) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseButton addTarget:self action:@selector(didClickLikeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(didCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAuctionCommitList) name:@"updateAuctionCommitController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(auctionDetailToRechargeVC) name:@"detailVCjumpToAuctionRecharge" object:nil];
    
    [self addHeader];
    [self addFooter];
    
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"0";
        [self getJingpaiDetailInfo];
        
        self.isReload = NO;
    }];
    [self.tableView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [vc.tableView addFooterWithCallback:^{
        [vc updateAuctionDetailUI];
        
        _isReload = NO;
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



-(void)auctionDetailToRechargeVC{
    JinBiViewController *rechargeVC = [[JinBiViewController alloc]init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
}
#pragma mark private

//设置界面
-(void)setupUI{
    
    if (!self.isOnAuction) {
        _jingpaiButton.userInteractionEnabled = NO;
        
        _auctionImg.image = [UIImage imageNamed:@"auctionIcon_normal"];
        _auctionLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
        
    }
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(100, 0, 22, 23)];
    [leftBtn setImage:[UIImage imageNamed:@"doubleBack"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToLastController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBtn setFrame:CGRectMake(100, 7, 45, 30)];
    
    [rightBtn setImage:[UIImage imageNamed:@"mokafenxiang"] forState:UIControlStateNormal];
    
    [rightBtn setTitle:@"推荐" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [rightBtn addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self likeButtonHighlight:_isLike];
    
    //添加头视图
    float headerH = [MCJingpaiDetailHeaderView getHeightWithData:self.model];
    MCJingpaiDetailHeaderView *headerView = [[MCJingpaiDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, headerH)];
    headerView.superVC = self;
    [headerView setupUI:self.model];
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    //控制器navigationItem分享按钮
    self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友", nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self volumeWith:0];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerView.player stop];
}

-(void)backToLastController{
    [self.navigationController popViewControllerAnimated:YES];
}


//KVO监听界面offset方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGPoint newSize = CGPointZero;
    if([change objectForKey:@"new"] != [NSNull null]) {
        newSize = [[change objectForKey:@"new"] CGPointValue];
    }
    if ((newSize.y - self.contentOffset.y)*(newSize.y - self.contentOffset.y)<20000) {
        self.contentOffset = newSize;
    }
    
    
}

#pragma 普通方法
//弹出竞价view
-(void)appearJingpaiView{

    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    if (!uid) {
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return;
        
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //判断是否是app第一次被打开
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"firstAuction.plist"];
    NSString *auctionData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (!(auctionData.length > 0)) {
        
        NSString *tempStr = @"secondAuction";
        [tempStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        auctionTips *tipsView = [[auctionTips alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        tipsView.superVCType = superElse;
        tipsView.superVC = self;
        [tipsView setupUI];
        
        [window addSubview:tipsView];
        
        return;
    }

    MCJingpaiView *jingpaiView = [[MCJingpaiView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    jingpaiView.superVCType = superElse;
    jingpaiView.auctionID = self.model.auction_id;
    jingpaiView.up_range = self.model.up_range;
    jingpaiView.lastPrice = _model.last_price?_model.last_price:_model.initial_price;
    jingpaiView.auction_des = _model.auction_description;
    jingpaiView.shareImg = _headerView.shareImg;
    jingpaiView.superVC = self;
    
    [jingpaiView setupUI];
    
    [self.view addSubview:jingpaiView];

}

- (void)didClickLikeBtn
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
        [LeafNotification showInController:self withText:@"请先登录"];
        return;
    }
    
    _isLike = !_isLike;
    NSString *auctionID = getSafeString(self.model.auction_id);
    NSString *object_type = @"15";
    NSDictionary *dict = [AFParamFormat formatLikeActionParams:auctionID userId:uid objectType:object_type];

    _praiseButton.userInteractionEnabled = NO;
    if (_isLike) {
        [self zanMethod:dict];
    }else{
        [self cancleZan:dict];
    }
}

- (void)likeButtonHighlight:(BOOL)isLike
{ 
    if (isLike) {

        
        _zanImg.image = [UIImage imageNamed:@"heart_highlighted"];
        _zanLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    }
    else{

        
        _zanImg.image = [UIImage imageNamed:@"heart"];
        _zanLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    }
}

-(void)didCommitBtn{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
        [LeafNotification showInController:self withText:@"请先登录"];
        return;
    }
    
    MCJingpaiCommitView *commitView = [[MCJingpaiCommitView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    commitView.superVC = self;
    commitView.model = self.model;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:commitView];
    
}

-(void)fenxiang{
    NSLog(@"分享方法");
    
    if ([self.model.opCode isEqualToString:@"5"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"竞拍未通过审核不能分享" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self.moreSheet showInView:self.view];
}

#pragma mark alert代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            
        case 2://QQ好友
        {
            
            NSString *url = self.model.img_urls[0][@"url"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            if (!imageData) {
                imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendAuctionLinkToQQdecription:self.model.auction_description title:@"我在MOKA发现一个竞拍,快来抢拍" imageData:imageData auctionID:self.model.auction_id isQZone:NO];
        }
            break;
        case 1://推荐微信好友
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            
            UIImage *headerImg = self.headerView.shareImg;
            if (!headerImg) {
                headerImg = [UIImage imageNamed:@"AppIcon"];
            }
            NSString *auctionID = self.model.auction_id;
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentToWXFriendsAuctionId:auctionID header:headerImg shareTitle:@"我在MOKA发现一个竞拍，快来抢拍" shareDes:self.model.auction_description];
        }
            break;
            
        case 0://推荐微信朋友圈
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            UIImage *headerImg = self.headerView.shareImg;
            if (!headerImg) {
                headerImg = [UIImage imageNamed:@"AppIcon"];
            }
            NSString *auctionID = self.model.auction_id;
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentToWXFriendsAuctionId:auctionID header:headerImg shareTitle:@"我在MOKA发现一个竞拍，快来抢拍" shareDes:self.model.auction_description];
        }
            break;

        default:
            
            break;
    }

}

#pragma mark tableview代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.model.auctors.count<=5) {
            return self.model.auctors.count;
        }else{
            return 5;
        }
        
    }else if(section == 1){
        
        if (self.isExistPraise) {
            return 1;
        }else{
            return 0;
        }
        
    }else{
        
        return self.commentDataArray.count;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 50;
    }else if(indexPath.section == 1){
        
        float height = [DetailVCPraiseCell getHeightWithArr:self.model.likeusers];
        return height ;
    }else{
        float height = 0;
        
        //isreload打开则是显示详情中的评论，非评论列表的评论
        height = [DetailVCCommentCell getHeightWithDict:self.commentDataArray[indexPath.row]];
        
        return height ;

    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        DetailVCJingpaiCell *cell = [[DetailVCJingpaiCell alloc]init];
        cell.superVC = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupUI:self.model.auctors[indexPath.row]];
        if (indexPath.row == 0) {
            cell.profitLabel.hidden = YES;
        }else{
            cell.winImageView.hidden = YES;
        }
        
        return cell;
    }else if(indexPath.section == 1){
        DetailVCPraiseCell *cell = [[DetailVCPraiseCell alloc]init];
        cell.superVC = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupUI:self.model.likeusers];
        return cell;
    }else{
        DetailVCCommentCell *cell = [[DetailVCCommentCell alloc]init];
        cell.superVC = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell setupUI:self.commentDataArray[indexPath.row]];

        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
        {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (!uid) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                
                [LeafNotification showInController:self withText:@"请先登录"];
                return;
            }
            
            MCJingpaiCommitView *commitView = [[MCJingpaiCommitView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
            commitView.superVC = self;
            commitView.model = self.model;

            commitView.replyID = getSafeString(self.commentDataArray[indexPath.row][@"id"]);
        
            commitView.replyName = [NSString stringWithFormat:@"%@",self.commentDataArray[indexPath.row][@"nickname"]];

           
            commitView.commitField.placeholder = [NSString stringWithFormat:@"回复@%@",commitView.replyName];

            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:commitView];
            break;
        }
        default:
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.isExistAuction) {
            headerForDetailVCFirstSection *view = [[headerForDetailVCFirstSection alloc]init];
            view.frame = CGRectMake(0,0 , kDeviceWidth, 40);
            view.superVC = self;
            [view setupUI:self.model];
            return view;
        }else{
            return nil;
        }
        
    }else if(section == 1){
        
        return nil;
    }else{
        if (self.isExistComment) {
            headerForCommentSection *view = [[headerForCommentSection alloc]init];
            view.frame = CGRectMake(0,0 , kDeviceWidth, 40);
            [view.commentButton addTarget:self action:@selector(didCommitBtn) forControlEvents:UIControlEventTouchUpInside];
            return view;
        }else{
            return nil;
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.isExistAuction) {
            return 40;
        }else{
            return 0;
        }
        
    }else if (section == 1){
        
        return 0;
    }else{
        if (self.isExistComment) {
            return 40;
        }else{
            return 0;
        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}


#pragma mark 网络请求方法
-(void)getJingpaiDetailInfo{
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"auctionId":self.jingpaiID}];
    
    [AFNetwork getAuctionInfo:params path:PathForAuctionInfo success:^(id data) {
        NSLog(@"%@",data[@"data"]);
        NSDictionary *dict = data[@"data"];
        if ([data[@"status"] integerValue] == kRight) {
            
            MCJingpaiDetailModel *model = [[MCJingpaiDetailModel alloc]initWithDictionary:dict error:nil];
            self.model = model;
            
            if (model.auctors.count>0) {
                self.isExistAuction = YES;
                self.sectionCount++;
            }else{
                self.isExistAuction = NO;
            }
            if (model.likeusers.count>0) {
                self.isExistPraise = YES;
                self.sectionCount++;
            }else{
                self.isExistPraise = NO;
            }
            if (model.comments.count>0) {
                self.isExistComment = YES;
                self.sectionCount++;
            }else{
                self.isExistComment = NO;
            }
            
            if ([self.model.isLike isEqualToString:@"1"]) {
                _isLike = YES;
            }else{
                _isLike = NO;
            }
            
            if ([getSafeString(dict[@"opCode"]) isEqualToString:@"0"] ) {
                _isOnAuction = YES;
            }else{
                _isOnAuction = NO;
            }
            
            [self setupUI];
            [self.tableView reloadData];
        }else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        [self endRefreshing];
    } failed:^(NSError *error) {
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅"];
        [self endRefreshing];
    }];
    
}

-(void)updateAuctionCommitList{
    
    _lastIndex = @"0";
    [self updateAuctionDetailUI];
}


//音量控制
-(void)volumeWith:(float)vol{
    
    float volume = [MPMusicPlayerController applicationMusicPlayer].volume;
    if (volume>0.0000001) {
        __block UISlider *volumeViewSlider = nil;
        
        __block MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-150, -150, 100, 100)];
        volumeView.hidden = NO;
        [self.view addSubview:volumeView];
        
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:vol];
        });
    }else{

    }
    
}
////请求评论数据
-(void)updateAuctionDetailUI{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.model.auction_id forKey:@"object_id"];
    [dict setValue:@"5" forKey:@"pagesize"];
    [dict setValue:@"15" forKey:@"object_type"];
    [dict setValue:_lastIndex forKey:@"lastindex"];
    
    NSDictionary *params = [AFParamFormat formatGetCommentListParams:dict];
    
    [AFNetwork getCommentsList:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *dataArr = data[@"data"];
            
            if ([dataArr count] > 0) {
                if ([_lastIndex isEqualToString:@"0"]) {
                    self.commentDataArray = [NSMutableArray arrayWithArray:dataArr];
                }
                else{
                    [_commentDataArray addObjectsFromArray:dataArr];
                }
                
                _lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                //        self.isReload = YES;
                [self.tableView reloadData];
                self.tableView.contentOffset = self.contentOffset;
                
                
            }else{
                [LeafNotification showInController:self withText:@"已无更多"];
            }
            
            
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
        [self endRefreshing];
    }failed:^(NSError *error){
        
        [self endRefreshing];
        
    }];
}



-(void)zanMethod:(NSDictionary *)dict{
    
    [AFNetwork likeAdd:dict success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            
            NSString *headImg = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
            NSString *myUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            NSDictionary *dict = @{@"head_pic":headImg,@"id":myUid};
            [self.model.likeusers addObject:dict];
            
            _isLike = YES;
            _isExistPraise = YES;
            [self likeButtonHighlight:_isLike];
            [self.tableView reloadData];
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else if ([data[@"status"] integerValue] == 1){
            
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        _praiseButton.userInteractionEnabled = YES;
    }failed:^(NSError *error){
        [LeafNotification showInController:self withText:@"当前网络不太顺畅"];
    }];
}

-(void)cancleZan:(NSDictionary *)dict{
    
    
    [AFNetwork likeCancel:dict success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            
            _isLike = NO;
            [self likeButtonHighlight:_isLike];
            
            NSString *myUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            for (NSDictionary *likerDict in self.model.likeusers) {
                if ([likerDict[@"id"] isEqualToString:myUid]) {
                    [self.model.likeusers removeObject:likerDict];
                    if (self.model.likeusers<=0) {
                        _isExistPraise = NO;
                    }
                    [self.tableView reloadData];
                    break;
                }
            }
            
            
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else if ([data[@"status"] integerValue] == 1){
            
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        _praiseButton.userInteractionEnabled = YES;
    }failed:^(NSError *error){
        [LeafNotification showInController:self withText:@"当前网络不太顺畅"];
    }];
}

#pragma mark alertDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self auctionDetailToRechargeVC];
            break;
            
        default:
            break;
    }
}


@end









