//
//  PhotoViewDetailController.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/18.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "PhotoViewDetailController.h"
#import "CommentTableViewCell.h"
#import "GoodsForPhotoDetailCell.h"
#import "PhotoDetailView.h"
#import "ReadPlistFile.h"
#import "PhotoBrowseViewController.h"
#import "PersonPageDetailViewModel.h"
#import "DaShangView.h"
#import "DaShangGoodsView.h"
#import "NewLoginViewController.h"

@interface PhotoViewDetailController ()<UIActionSheetDelegate,PhotoDetailViewDelegate,UITextFieldDelegate>
{
    BOOL isUpdate;
    NSDictionary *headDict;//add
    NSString *replyId;
    NSString *objectType;
}


@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (weak, nonatomic) IBOutlet UITextField *commentTextfield;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) PhotoDetailView *tableViewHeadView;

@property (strong, nonatomic) NSMutableArray *commentDataArray;
@property (nonatomic,strong) NSMutableArray *goodsInfoArr;
@property (nonatomic,strong) NSDictionary *photoInfo;
@property (nonatomic,strong) NSDictionary  *dataDict;


@property (strong, nonatomic) NSString *photoid;
@property (strong, nonatomic) NSString *photo_uid;
@property (nonatomic,strong) NSString *currentFeedType;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *currentPid;

@property (assign, nonatomic) BOOL isCurrentUid;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) UIActionSheet *moreSheet;
@property (strong, nonatomic) UIActionSheet *shareSheet;

@property (strong, nonatomic) NSMutableDictionary *infoNumDict;

@property (strong, nonatomic) NSString *picUrl;

@property (nonatomic , strong) NSDictionary *commentLimitDic;

@property (strong , nonatomic) DaShangGoodsView *dashang;
@property (nonatomic,assign) CGPoint contentOffset;



@end

@implementation PhotoViewDetailController

#pragma mark - 视图生命周期及控件加载

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initViews];
    [self getRule_fontlimit];
    
    [self.mainTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUI) name:@"refreshDetailContrller" object:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SingleData shareSingleData].isInThePhotoDetail = NO;

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SingleData shareSingleData].isInThePhotoDetail = YES;
    self.commentTextfield.delegate = self;
    //	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    self.navigationController.navigationBarHidden = NO;
    //self.title = @"照片详情";
    self.mainTableView.showsVerticalScrollIndicator = NO;

    [self resetTableView];

    [self.view bringSubviewToFront:self.commentView];
    
    self.commentView.hidden = YES;
    self.publishButton.hidden = YES;
    
    [self processData:headDict];//add暂时
    
    self.commentView.frame = CGRectMake(0, kScreenHeight-118, kScreenWidth, 54);
    self.publishButton.frame = CGRectMake(kScreenWidth-81, 0, 81, 54);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.commentView.hidden = NO;
        self.publishButton.hidden = NO;
        
    } completion:^(BOOL finished) {
        
    }];
    


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.commentTextfield resignFirstResponder];
    [self.tableViewHeadView.player stop];
    [self.tableViewHeadView.player.view removeFromSuperview];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.commentView.frame = CGRectMake(0, kScreenHeight-118, kScreenWidth, 54);
    self.publishButton.frame = CGRectMake(kScreenWidth-81, 0, 81, 54);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.commentView.hidden = NO;
        self.publishButton.hidden = NO;
        
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.isJumpToShang) {
        [self.mainTableView setContentOffset:CGPointMake(0, 300) animated:YES];
    }
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

-(void)dealloc{
    [self.mainTableView removeObserver:self forKeyPath:@"contentOffset"];
}

//送礼完成后刷新数据
-(void)resetUI{

    [self setCommentDataByPid:self.photoid];

}


#pragma mark - rule_fontlimitDic
-(void)getRule_fontlimit{
    NSDictionary *rule_fontlimit = [USER_DEFAULT objectForKey:@"rule_fontlimit"];
    _commentLimitDic = [NSDictionary dictionary];
    if (rule_fontlimit) {
        if (rule_fontlimit[@"comment"]) {
            _commentLimitDic = rule_fontlimit[@"comment"];
        }
    }
    if (_commentLimitDic[@"max"] == nil) {
        [_commentLimitDic setValue:[NSNumber numberWithInt:60] forKey:@"max"];
        [_commentLimitDic setValue:[NSNumber numberWithInt:1] forKey:@"min"];
    }
    _commentTextfield.placeholder = [NSString stringWithFormat:@"添加评论 %@字以内",_commentLimitDic[@"max"]];
}



- (void)doBackAction:(id)sender
{
    if (isUpdate) {
        [self updateInfoDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTimeLineView" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 45, 30)];
    [rightButton setImage:[UIImage imageNamed:@"mokafenxiang"] forState:UIControlStateNormal];
    
    [rightButton setTitle:@"推荐" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [rightButton addTarget:self action:@selector(doIntoSettingVC_other:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];


    
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        self.navigationItem.rightBarButtonItem = rightItem;
        
        
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    [self.publishButton setImage:[UIImage imageNamed:@"sendCommentButton"] forState:UIControlStateHighlighted];
    
    self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"推荐给QQ好友",@"推荐到微信", @"保存图片", nil];//发送给好友
    
    self.shareSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"朋友圈", @"微信好友", nil];
}
#pragma mark - rightItem
- (void)doIntoSettingVC_other:(id)sender
{
    
    [self.moreSheet showInView:self.view];
    
}

- (void)updateInfoDict
{
    NSString *selfUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!selfUid) {
        return;
    }
    
    NSDictionary *dict = [AFParamFormat formatPhotoDetailParams:self.photoid uid:selfUid];
    [AFNetwork getPhotoDetail:dict success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfoDict" object:data[@"data"][@"info"]];

            
        }
    }failed:^(NSError *error){
         [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}

- (void)likeMethod:(id)sender
{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return;
    }
    [SVProgressHUD show];

    if ([self.tableViewHeadView.likeButton.titleLabel.textColor isEqual:[UIColor lightGrayColor]]) {
        NSString *photoId = self.photoid;
        NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid objectType:self.currentFeedType];
        [AFNetwork likeAdd:dict success:^(id data){
            
            if ([data[@"status"] integerValue] == kRight) {
                isUpdate = YES;
                [self.tableViewHeadView.likeButton setImage:[UIImage imageNamed:@"zannew2"] forState:UIControlStateNormal];
                [self.tableViewHeadView.likeButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
                if ([self.currentFeedType isEqualToString:@"11"]) {
                    [self requestWithVideoId:getSafeString(self.currentPid) uid:self.userID];
                }else{
                    [self requestWithPhotoId:getSafeString(self.currentPid) uid:self.userID];
                }
                [SVProgressHUD dismiss];
                [LeafNotification showInController:self withText:@"点赞成功"];
            }
            if([data[@"status"] integerValue] == kReLogin){
                [SVProgressHUD dismiss];

                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }else{
                [LeafNotification showInController:self withText:data[@"msg"]];
                [SVProgressHUD dismiss];
            }
        }failed:^(NSError *error){
            [SVProgressHUD dismiss];

        }];
    }else
    {
        NSString *photoId = self.photoid;
        NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid objectType:self.currentFeedType];
        [AFNetwork likeCancel:dict success:^(id data){
            
            if ([data[@"status"] integerValue] == kRight) {
                isUpdate = YES;
                [self.tableViewHeadView.likeButton setImage:[UIImage imageNamed:@"zangray"] forState:UIControlStateNormal];
                [self.tableViewHeadView.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                if ([self.currentFeedType isEqualToString:@"11"]) {
                    [self requestWithVideoId:getSafeString(self.currentPid) uid:self.userID];
                }else{
                    [self requestWithPhotoId:getSafeString(self.currentPid) uid:self.userID];
                }
                [SVProgressHUD dismiss];
                [LeafNotification showInController:self withText:@"取消赞成功"];
            }
            if([data[@"status"] integerValue] == kReLogin){
                [SVProgressHUD dismiss];

                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
        }failed:^(NSError *error){
            [SVProgressHUD dismiss];

        }];
    }
    
}

- (void)privateMethod:(id)sender
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return;
    }
    if ([self.tableViewHeadView.privateButton.titleLabel.textColor isEqual:[UIColor lightGrayColor]]) {
        

        NSString *photoId = self.photoid;
        NSDictionary *dict = [AFParamFormat formatFavoriteActionParams:photoId userId:uid];
        [AFNetwork favoriteAdd:dict success:^(id data){
            
            if ([data[@"status"] integerValue] == kRight) {
                isUpdate = YES;
                [self.tableViewHeadView.privateButton setImage:[UIImage imageNamed:@"unCollection"] forState:UIControlStateNormal];
                [self.tableViewHeadView.privateButton setBackgroundImage:[UIImage imageNamed:@"cellButtonRed"] forState:UIControlStateNormal];
                
                [self.tableViewHeadView.privateButton setTitleColor:[UIColor colorWithRed:239/255.0 green:59/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            if([data[@"status"] integerValue] == kReLogin){
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
        }failed:^(NSError *error){
            
        }];
    }else
    {
        

        NSString *photoId = self.photoid;
        NSDictionary *dict = [AFParamFormat formatFavoriteActionParams:photoId userId:uid];
        [AFNetwork favoriteCancel:dict success:^(id data){
            
            if ([data[@"status"] integerValue] == kRight) {
                isUpdate = YES;
                [self.tableViewHeadView.privateButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
                [self.tableViewHeadView.privateButton setBackgroundImage:[UIImage imageNamed:@"cellButtonGray"] forState:UIControlStateNormal];
                
                [self.tableViewHeadView.privateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            if([data[@"status"] integerValue] == kReLogin){
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
        }failed:^(NSError *error){
            
        }];
    }
    
}

#pragma mark - 请求数据：图片和视频详情
- (void)requestWithPhotoId:(NSString *)pid uid:(NSString *)uid
{
    self.title = @"照片详情";
    self.currentFeedType = @"6";
    self.userID = uid;
    self.currentPid = pid;
    NSString *selfUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
     if ([selfUid isEqualToString:uid]) {
        self.isCurrentUid = YES;
     }else{
        self.isCurrentUid = NO;
     }
    
    if (!pid) {
        return;
    }
    NSDictionary *dict = [AFParamFormat formatPhotoDetailParams:pid uid:self.userID];//selfUid
    [AFNetwork getPhotoDetail:dict success:^(id data){
        
        [SVProgressHUD dismiss];
        self.photoInfo = data;
        
        NSString *status = [NSString stringWithFormat:@"%@",data[@"status"]];
        if ([status isEqualToString:@"0"]) {
            //创建表头视图
            self.tableViewHeadView = [PhotoDetailView getPhotoDetailView];
            self.tableViewHeadView.delegate = self;
            
            self.tableViewHeadView.userID = data[@"data"][@"user"][@"id"];
            self.userID = data[@"data"][@"user"][@"id"];
            headDict = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            [self processData:data[@"data"]];
            //重置表头视图
            [self resetTableViewHeaderView:data[@"data"]];
            
            self.dataDict = data[@"data"];
            //获取评论数据
            [self setCommentDataByPid:pid];

        }else
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",data[@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            
        }
        
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];

        
        
    }];
}

- (void)requestWithVideoId:(NSString *)vid uid:(NSString *)uid{
    self.title = @"视频详情";
    self.userID = uid;
    self.currentPid = vid;
    NSString *selfUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    self.currentFeedType = @"11";
    //    if (!selfUid) {
    //        return;
    //    }
    if ([selfUid isEqualToString:uid]) {
        self.isCurrentUid = YES;
    }else
    {
        self.isCurrentUid = NO;
    }
    if (!vid) {
        return;
    }
    
    NSDictionary *dict = [AFParamFormat formatVideoDetailParams:vid uid:uid];//selfUid
    [AFNetwork getVideoDetail:dict success:^(id data) {
        NSString *status = [NSString stringWithFormat:@"%@",data[@"status"]];
        if ([status isEqualToString:@"0"]) {
            self.tableViewHeadView = [PhotoDetailView getPhotoDetailView];
            self.tableViewHeadView.delegate = self;
            self.tableViewHeadView.userID = data[@"data"][@"user"][@"id"];
            self.userID = data[@"data"][@"user"][@"id"];
            headDict = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[@"data"]];
            [dic setObject:@"11" forKey:@"feedType"];
            [self processData:data[@"data"]];
            [self resetTableViewHeaderView:dic];
            
            self.dataDict = dic;
            [self setCommentDataByPid:vid];
            NSString *videoUrl = getSafeString(data[@"data"][@"info"][@"url"]);
            
        }else
        {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",data[@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            
        }
        

    } failed:^(NSError *error) {
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];

}

#pragma mark alertView actionSheet
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *webUrl = [USER_DEFAULT objectForKey:@"webUrl"];

    NSString *videoShareUrl = [NSString stringWithFormat:@"%@/v/%@",webUrl,self.dataDict[@"info"][@"id"]];
    
    if (actionSheet==self.moreSheet) {
        switch (buttonIndex) {
            case 0:
            {
                UIImage *image = self.tableViewHeadView.contentImageView.image;

                if ([self.currentFeedType isEqualToString:@"11"]) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 1);
                    [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone_video:NO decription:@"视频分享" title:@"视频分享" imageData:imageData targetUrl:videoShareUrl objectId:@""];
                }else
                {
                    
                    [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQWithImageData:self.picUrl previewImage:image title:@"分享" description:nil];

                }
                
            }
                break;
            case 1:
            {
                [self.shareSheet showInView:self.view];
                
            }
                break;
            case 2:
            {
                [self savePhotoToPhone];
            }
                break;
                
            default:
                break;
        }
        
    }else if(actionSheet==self.shareSheet)
    {
        if (buttonIndex==0) {
            UIImage *image = self.tableViewHeadView.contentImageView.image;
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];

            if ([self.currentFeedType isEqualToString:@"11"]) {

                [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle_video:@"视频分享" desc:@"视频分享" header:image URL:videoShareUrl uid:@"视频分享"];
            }else
            {
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"分享"];
                
            }
            
        }else if (buttonIndex==1)
        {
            UIImage *image = self.tableViewHeadView.contentImageView.image;
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            
            if ([self.currentFeedType isEqualToString:@"11"]) {
                
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle_video:@"视频分享" desc:@"视频分享" header:image URL:videoShareUrl uid:@"视频分享"];

            }else
            {
                
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"分享"];

            }
            
        }
    }

}


- (void)savePhotoToPhone
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在保存...";
    self.hud.removeFromSuperViewOnHide = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage *image = self.tableViewHeadView.contentImageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
    });
    
}

- (void)setCommentDataByPid:(NSString *)pid
{
    self.photoid = pid;
    
    //网络请求得到photoid的礼物信息
    [self setGoodsDataByPid:pid];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:pid forKey:@"object_id"];
    [dict setValue:@"100" forKey:@"pagesize"];
    [dict setValue:self.currentFeedType forKey:@"object_type"];
    NSDictionary *params = [AFParamFormat formatGetCommentListParams:dict];
    [AFNetwork getCommentsList:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            isUpdate = YES;
        }
        NSArray *comment = data[@"data"];
        
        NSArray *tempspec_result = [comment sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1[@"createline"] compare:obj2[@"createline"] options:NSNumericSearch];
        }];
        
        self.commentDataArray = tempspec_result.mutableCopy;
        
        [self.mainTableView reloadData];
        //让点赞后数据刷新界面不跳
        
//        self.mainTableView.contentOffset = self.contentOffset;
    }failed:^(NSError *error){
        
    }];
    
    
    
}


-(void)setGoodsDataByPid:(NSString *)pid{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:pid forKey:@"object_id"];
    [dict setObject:self.currentFeedType forKey:@"object_type"];
    NSDictionary *params = [AFParamFormat formatGetGoodsListParams:dict];
    
    [AFNetwork getPhotoDetail:params success:^(id data) {
        
        if ([data[@"status"] integerValue] == kRight){
            
            
            NSMutableArray *goodsInfoArr = data[@"data"][@"info"][@"goodusers"];
            self.goodsInfoArr = goodsInfoArr;

            
        
            [self.mainTableView reloadData];
            //让点赞后数据刷新界面不跳
            
            self.mainTableView.contentOffset = self.contentOffset;
        }
    } failed:^(NSError *error) {
        
    }];
    
}


- (void)gotoPersonPage
{
    
    NSString *userName = @"";
    NSString *uid = self.userID;
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
        ;
    
    [self.navigationController pushViewController:newMyPage animated:YES];
}

- (void)processData:(NSDictionary *)diction
{
    [self resetTableView];
    
    self.mainTableView.tableHeaderView = self.tableViewHeadView;
    self.tableViewHeadView.superCon = self;
    
    [self.mainTableView reloadData];
    self.mainTableView.contentOffset = self.contentOffset;
    [self.tableViewHeadView.likeButton addTarget:self action:@selector(likeMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableViewHeadView.privateButton addTarget:self action:@selector(privateMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableViewHeadView.headerClickButton addTarget:self action:@selector(gotoPersonPage) forControlEvents:UIControlEventTouchUpInside];
    [self.tableViewHeadView.shangButton addTarget:self action:@selector(shangMethod:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)resetTableViewHeaderView:(NSDictionary *)diction{
    PersonPageDetailViewModel *detailModel = [[PersonPageDetailViewModel alloc] initWithDiction:diction];
    self.currentFeedType = getSafeString(detailModel.photoDic[@"object_type"]);
    
    self.photo_uid = detailModel.userId;
    self.picUrl = detailModel.contentImageURL;

    [self.tableViewHeadView reSetDetailViewFrameWithDetailModel:detailModel];

    //改头视图的高度
    CGRect tableViewRect = self.tableViewHeadView.frame;
    tableViewRect.size.height += 15;
    NSString *titleStr = [NSString stringWithFormat:@"%@",diction[@"info"][@"title"]];
    if ([titleStr isEqualToString:@"(null)"]) {
        titleStr = @"";
    }
    if (titleStr && titleStr.length) {
        CGSize titleSize = [CommonUtils sizeFromText:titleStr textFont:[UIFont systemFontOfSize:16] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 25, MAXFLOAT)];
        if (titleSize.height > 15) {
            tableViewRect.size.height += titleSize.height - 15;
        }
    }
    //
    float w = 25;
    int space = 7;
    //计算一行能放置的头像个数
    NSUInteger count = (kScreenWidth - 20)/(w+space);
    //计算点赞头像行数
    NSUInteger line = detailModel.likeusers.count/count;
    float likeHeight = line * 30;
    //加上点赞视图的高度
    tableViewRect.size.height += likeHeight;
    //重置表头视图高度
    self.tableViewHeadView.frame = tableViewRect;
    self.mainTableView.tableHeaderView = self.tableViewHeadView;
    [self.mainTableView reloadData];
    self.mainTableView.contentOffset = self.contentOffset;
}


- (void)resetTableView
{
    if (self.isFromTimeLine) {
        self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-120+44);
        
        if (kScreenWidth==320) {
            
        }else if(kScreenWidth==375)
        {
            
            self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-100);

        }else
        {
            self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-100);
            
            
        }
        
    }else
    {
        
        self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-104);
        if (kScreenWidth==320) {
            
        }else if(kScreenWidth==375)
        {
            
            
        }else
        {
            self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-124);
            
        }
    }
    self.mainTableView.contentOffset = self.contentOffset;
    
}

- (void)shangMethod:(UIButton *)sender
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    if (!uid) {
        
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        
        NewLoginViewController *loginVC = [[NewLoginViewController alloc]initWithNibName:[NSString stringWithFormat:@"NewLoginViewController"] bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
        
        return;
    }
    
    NSString *photoId = self.photoid;
    self.dashang= [[DaShangGoodsView  alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dashang.superController = self;
    
    self.dashang.currentPhotoId = photoId;
    self.dashang.animationType = @"dashangWithNoAnimation";
    self.dashang.targetUid = self.photo_uid;
    self.dashang.dashangType = self.currentFeedType;
    
    [self.dashang setUpviews];
    [self.dashang addToWindow];

}



- (void)gotoTheUserPage
{
    NSString *userName = @"";
    NSString *uid = self.userID;
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
        ;
    
    [self.navigationController pushViewController:newMyPage animated:YES];
}
- (NSString *)returnFliterSpaceStringWithString:(NSString *)spceString
{
    BOOL isDone = NO;
    NSMutableString *result = spceString.mutableCopy;

    while (!isDone) {
        NSRange spcaeRang = [result rangeOfString:@" "];
        if (spcaeRang.length>0) {
            [result replaceCharactersInRange:spcaeRang withString:@""];
        }else
        {
            isDone = YES;
        }
        if (isDone) {
            
        }else
        {
            [self returnFliterSpaceStringWithString:result.copy];
        }
    }
    
    
    return result.copy;
}

- (IBAction)sendComment:(id)sender {
    
    BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!isBangDing && uid) {
        [self.commentTextfield resignFirstResponder];

        [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
        return;
    }
    if (!uid) {
        [self.commentTextfield resignFirstResponder];
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewController];
        return;
    }
    if (self.commentTextfield.text&&self.commentTextfield.text.length>0) {
        [self.commentTextfield resignFirstResponder];
       
        //如果评论的长度大于0再发评论，发评论后的判断规则坐在服务端。
        if (self.commentTextfield.text.length>0) {
//            NSString *commentStr = [self returnFliterSpaceStringWithString:self.commentTextfield.text];
            
            NSDictionary *params = [AFParamFormat formatCommentActionParams:self.photoid userId:uid content:self.commentTextfield.text object_type:self.currentFeedType];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([self.commentTextfield.placeholder rangeOfString:@"回复@"].length) {
                NSString *commentStr = [NSString stringWithFormat:@"%@%@",self.commentTextfield.placeholder,self.commentTextfield.text];
                commentStr = [commentStr substringFromIndex:2];
                self.commentTextfield.text = commentStr;
                 params = [AFParamFormat formatCommentActionParams:self.photoid userId:uid content:self.commentTextfield.text replyID:replyId object_type:self.currentFeedType];
            }
            [AFNetwork commentsAdd:params success:^(id data){
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:self.photoid forKey:@"photoid"];
                [dict setValue:@"100" forKey:@"pagesize"];
                [dict setValue:self.currentFeedType forKey:@"object_type"];
                NSDictionary *params = [AFParamFormat formatGetCommentListParams:dict];
                [AFNetwork getCommentsList:params success:^(id data){
                    
                    NSArray *comment = data[@"data"];
                    
                    NSArray *tempspec_result = [comment sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        return [obj1[@"createline"] compare:obj2[@"createline"] options:NSNumericSearch];
                    }];
                    
                    
                    self.commentDataArray = tempspec_result.mutableCopy;

                    [self.mainTableView reloadData];
                    self.mainTableView.contentOffset = self.contentOffset;

                }failed:^(NSError *error){
                    
                }];
                
                if ([data[@"status"] integerValue] == kRight) {
                    self.commentTextfield.text = @"";
                    [LeafNotification showInController:self withText:data[@"msg"]];

                }else
                {
                    
                    [LeafNotification showInController:self withText:data[@"msg"]];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];

                }
                
            }failed:^(NSError *error){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [LeafNotification showInController:self withText:@"网络错误"];
            }];
        }
    }else
    {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.detailsLabelText = @"请输入内容";
        self.hud.removeFromSuperViewOnHide = YES;
        [self.hud hide:YES afterDelay:1.0];
    }
   
}

#pragma mark commitTableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CommentTableViewCell getCommentCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row >= self.goodsInfoArr.count) {

        NSString *content = self.commentDataArray[indexPath.row - self.goodsInfoArr.count][@"content"];
        float width = cell.descriptionLabel.frame.size.width;
        CGSize size = [CommonUtils sizeFromText:content textFont:cell.descriptionLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, 200)];
        if (size.height > 21) {
            return size.height + 40;
        }
    }
    return 61;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentDataArray.count+self.goodsInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell显示为礼物时
    if (indexPath.row<self.goodsInfoArr.count) {
        NSString *identifier = @"GoodsTableViewCell";
        GoodsForPhotoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [GoodsForPhotoDetailCell getGoodsCell];
        }
        NSInteger row = indexPath.row;
        cell.headBtn.tag = 200+row;
        [cell.headBtn addTarget:self action:@selector(jumpToNewMyPageWithIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setCellWithDict:self.goodsInfoArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //cell显示为评论时
        NSString *identifier = @"CommentTableViewCell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSInteger row = indexPath.row;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 60, 60);
        [button setTag:200 + row];
        [button addTarget:self action:@selector(jumpToNewMyPageWithIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        if (!cell) {
            cell = [CommentTableViewCell getCommentCell];
            [cell addSubview:button];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        [cell reSetFrame];

        
        NSDictionary *dict = self.commentDataArray[indexPath.row-self.goodsInfoArr.count];
        NSString *urlString = self.commentDataArray[indexPath.row- self.goodsInfoArr.count][@"head_pic"];
        [cell.headerImageView setImageWithURL:[NSURL URLWithString:urlString?urlString:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        NSString *name = getSafeString(self.commentDataArray[indexPath.row-self.goodsInfoArr.count][@"nickname"]);
        NSString *content = getSafeString(self.commentDataArray[indexPath.row-self.goodsInfoArr.count][@"content"]);
        NSString *createline = [NSString stringWithFormat:@"%@",self.commentDataArray[indexPath.row- self.goodsInfoArr.count][@"createline"]];
        
        cell.nameLabel.text = name;
        //设置会员昵称颜色
        NSString *isMember = getSafeString(dict[@"member"]);
        if ([isMember isEqualToString:@"1"]) {
            cell.nameLabel.textColor = [CommonUtils colorFromHexString:kLikeMemberNameColor];
        }else{
            cell.nameLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
        }

        cell.descriptionLabel.text = content;
        
        float width = cell.descriptionLabel.frame.size.width;
        CGSize size = [CommonUtils sizeFromText:content textFont:cell.descriptionLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, 200)];
        if (size.height > 21) {
            cell.descriptionLabel.numberOfLines = 0;
            CGRect frame = cell.descriptionLabel.frame;
            frame.size.height = size.height;
            cell.descriptionLabel.frame = frame;
        }
        cell.supCon = self;
        cell.timeString.text = [CommonUtils dateTimeIntervalString:createline];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.commentTextfield isFirstResponder]) {
        self.commentTextfield.placeholder =
        _commentTextfield.placeholder = [NSString stringWithFormat:@"添加评论 %@字以内",_commentLimitDic[@"max"]];
        [self.commentTextfield resignFirstResponder];
        return;
    }
    
    if (indexPath.row<self.goodsInfoArr.count) {
    
        
    }else{
        
        NSDictionary *dict = [self.commentDataArray objectAtIndex:(indexPath.row-self.goodsInfoArr.count)];
        NSString *nickName = dict[@"nickname"];
        replyId = dict[@"id"];
        [self.commentTextfield becomeFirstResponder];
        self.commentTextfield.placeholder = [NSString stringWithFormat:@"回复@%@  ",nickName];
    }
    
}

-(void)jumpToNewMyPageWithIndexPath:(id)sender
{
    UIButton *but = sender;
    
    if (but.tag) {
        
        NSDictionary *dict = [[NSDictionary alloc]init];
        NSString *userName = @"";
        NSString *uid = @"";
        
        if (but.tag<self.goodsInfoArr.count+200) {
            
            dict = self.goodsInfoArr[but.tag-200];
            uid = dict[@"goodUser"][@"id"];
        }else{
            dict = [self.commentDataArray objectAtIndex:(but.tag - self.goodsInfoArr.count - 200)];
            uid = dict[@"uid"];
        }
        
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.currentTitle = userName;
        newMyPage.currentUid = uid;
        
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT synchronize];
        
        ;
        
        [self.navigationController pushViewController:newMyPage animated:YES];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int jumpSpace = 118+250;
    if (kScreenWidth==320) {
        
    }else if(kScreenWidth==375)
    {
        jumpSpace = 118+270;

    }else
    {
        jumpSpace = 118+270;
        
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.commentView.frame = CGRectMake(0, kScreenHeight-jumpSpace, kScreenWidth, 54);

    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.commentTextfield resignFirstResponder];

    [UIView animateWithDuration:0.5 animations:^{
        self.commentView.frame = CGRectMake(0, kScreenHeight-118, kScreenWidth, 54);
        
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.commentTextfield resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.commentView.frame = CGRectMake(0, kScreenHeight-118, kScreenWidth, 54);
        
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    
    self.hud.detailsLabelText = msg;
    [self.hud hide:YES afterDelay:1.0];
}

#pragma mark delegate
- (void)doLikeUsersToPersonCenter:(NSString *)uid
{
    NSString *userName = @"";
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
        ;
    
    [self.navigationController pushViewController:newMyPage animated:YES];
    
}

#pragma mark - textFieldDetegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.commentTextfield)
    {
        [self.commentTextfield addTarget:self action:@selector(rangeOfTextField:) forControlEvents:UIControlEventEditingChanged];
    }
}

-(void)rangeOfTextField:(UITextField *)textField{
    NSString *placeHolder = _commentTextfield.placeholder;
    NSRange range = [placeHolder rangeOfString:@"回复@"];
    if (range.length) {
        if (textField.text.length > [_commentLimitDic[@"max"] intValue]+5 - placeHolder.length) {
            [LeafNotification showInController:self withText:[NSString stringWithFormat:@"不能超过%@个字",_commentLimitDic[@"max"]]];
            [textField resignFirstResponder];
        }
        return;
    }
    
    if (textField.text.length > [_commentLimitDic[@"max"] intValue]+5) {
        [LeafNotification showInController:self withText:[NSString stringWithFormat:@"不能超过%@个字",_commentLimitDic[@"max"]]];
        [textField resignFirstResponder];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *maxNumStr = _commentLimitDic[@"max"];
    NSInteger maxNum = [maxNumStr integerValue];
    if (textField == self.commentTextfield) {
        if ([textField.placeholder rangeOfString:@"回复@"].length) {
            if(textField.text.length > maxNum){
                [LeafNotification showInController:self withText:[NSString stringWithFormat:@"最多%@个字",_commentLimitDic[@"max"]]];
                NSString *str = [NSString stringWithFormat:@"%@",textField.text];
                str = [str substringToIndex:[_commentLimitDic[@"max"] intValue] - textField.placeholder.length];
                self.commentTextfield.text = str;
            }
        }
        
        if(textField.text.length > maxNum){
            [LeafNotification showInController:self withText:[NSString stringWithFormat:@"最多%@个字",_commentLimitDic[@"max"]]];
            NSString *str = [NSString stringWithFormat:@"%@",textField.text];
            str = [str substringToIndex:[_commentLimitDic[@"max"] intValue]];
            self.commentTextfield.text = str;
        }
   }
}

@end
