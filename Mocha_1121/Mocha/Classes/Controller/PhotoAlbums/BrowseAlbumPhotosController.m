//
//  BrowseAlbumPhotosController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BrowseAlbumPhotosController.h"
#import "PhotoBrowseViewController.h"
#import "PhotoViewCell.h"
#import "MJRefresh.h"

@interface BrowseAlbumPhotosController ()<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)UICollectionView *collectionView;

//分享视图
@property(nonatomic,strong)UIActionSheet *shareSheet;
@property(nonatomic,strong)UIActionSheet *weiXinSheet;

@property(nonatomic,strong)NSDictionary *albumDic;
@property(nonatomic,strong)NSMutableArray *dataSource;

//是否需要模糊
@property(nonatomic,assign)BOOL needBlurry;
//需要打赏的金币数量
@property(nonatomic,copy)NSString *needGold;


@property(nonatomic,copy)NSString *lastIndex;

@end

@implementation BrowseAlbumPhotosController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.currentTitle;
    [self.view addSubview:self.collectionView];
    //设置导航栏
    [self setNavigationBar];
    //[self addHeader];
    //[self addFooter];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //获取相册中所有图片
    [self getAlbumPhotos];

}

//设置导航栏
- (void)setNavigationBar{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 45, 30)];
    [rightButton setImage:[UIImage imageNamed:@"mokafenxiang"] forState:UIControlStateNormal];
    
    [rightButton setTitle:@"推荐" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }


#pragma mark - UICollectionViewDataSource
//返回单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"将要显示cell");

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"PhotoViewCellID";
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(_needBlurry){
        cell.useConditionType = @"needBlurry";
    }else{
        cell.useConditionType = @"noNeedBlurry";

    }
 
    //测试
    //cell.useConditionType = @"needBlurry";
    NSDictionary *photoDic = self.dataSource[indexPath.row];
    cell.imgUrlString = photoDic[@"url"];
    cell.selectedImgView.hidden = YES;
    return cell;
}


//调整间距：针对于collectionView的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        //点击网络的图片，进入图片浏览界面
        PhotoBrowseViewController *photoBrow = [[PhotoBrowseViewController alloc]initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
        //查看图片的开始索引
        photoBrow.startWithIndex = indexPath.row;
        photoBrow.currentUid = self.currentUID;
        photoBrow.albumID = self.albumID;
        photoBrow.albumDic = self.albumDic;
        photoBrow.albumSettingDic = self.albumDic[@"setting"];
        //当前图片
        NSDictionary *currentPhotoDic= self.dataSource[indexPath.row];
        NSString *photoID = currentPhotoDic[@"photoId"];
        //使用同一方法赋值
        [photoBrow setDataFromPhotoId:photoID uid:self.currentUID withArray:self.dataSource];
        [self.navigationController pushViewController:photoBrow animated:YES];
}

/*
#pragma mark - 数据下拉刷新设置
- (void)addHeader
{
    __weak typeof(self) vc = self;
    [vc.collectionView addHeaderWithCallback:^{
        //下拉重新加载数据
        vc.lastIndex = @"0";
        [vc getUploadedPhotos];
     }];
    [self.collectionView headerBeginRefreshing];
}


//上拉加载更多
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [vc.collectionView addFooterWithCallback:^{
        [vc getUploadedPhotos];
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
 */



#pragma mark - 辅助方法
//使用更新后的相册信息设置当前用户对浏览照片的模糊设置
- (void)resetPrivacy{
    //相册所有人的id
    NSString *albumPersonId = getSafeString(_albumDic[@"authorId"]);
    if ([getCurrentUid() isEqualToString:albumPersonId]) {
        _needBlurry = NO;
        return;
    }
    
    //获取私密性数据
    NSDictionary *openDic = _albumDic[@"setting"][@"open"];
    NSString *isPrivate = [openDic objectForKey:@"is_private"];
    if ([isPrivate isEqualToString:@"0"]) {
        _needBlurry = NO;
        _is_private = NO;
        _needGold = openDic[@"visit_coin"];
    }else{
        _is_private = YES;
        //有私密设置
        NSArray *is_forever_uids_list = openDic[@"is_forever_uids_list"];
        
        _needBlurry = YES;
        for (int i = 0; i<is_forever_uids_list.count;i++){
          NSString *tempStr = getSafeString(is_forever_uids_list[i]);
            if ([tempStr isEqualToString:getCurrentUid()]) {
                _needBlurry = NO;
                break;
            }
        }
        _needGold = openDic[@"visit_coin"];
    }
}



#pragma mark - 网络请求
- (void)getAlbumPhotos{
    if (self.albumID) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setObject:@"2" forKey:@"album_type"];
        [mdic setObject:self.albumID forKey:@"id"];
        NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];
        
         [AFNetwork getMokaDetail:params success:^(id data) {
            //[self endRefreshing];
            //NSLog(@"得到相册内的数据：%@",data);
            self.albumDic = data[@"data"];
            self.title = self.albumDic[@"title"];
            self.currentUID = self.albumDic[@"authorId"];
            //重置私密性
            [self resetPrivacy];
            
            [self.dataSource removeAllObjects];
            //取出本次取出的图片数据
            NSArray *arr = data[@"data"][@"photos"];
            if (arr.count >0) {
                /*
                if([_lastIndex isEqualToString:@"0"]){
                    [self.dataSource removeAllObjects];
                }
                 */
                [self.dataSource addObjectsFromArray:arr];
                //重新设置lastIndex;
                //self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                [self.collectionView reloadData];
            }
        } failed:^(NSError *error) {
            //[self endRefreshing];
            [LeafNotification showInController:self withText:@"网络不太顺畅哦"];
        }];
    }
}



#pragma mark - 事件点击
//导航栏上的分享
- (void)rightBtnClick:(UIButton *)btn{
    if (_shareSheet == nil) {
        _shareSheet =[[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"推荐给QQ好友",@"推荐到微信",nil];}
    [_shareSheet showInView:self.view];
}


#pragma mark -UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *shareString = @"";
    NSString *shareDesc = @"";
    //配置中分享相册文案
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    if (self.is_private) {
        //私密分享
        shareString = PathSharePrivacyAlbum;
        shareDesc = getSafeString([descriptionDic objectForKey:@"sharePrivacyAlbumDesc"]);
    }else{
        //公开分享
        shareString = PathShareOpenAlbum;
        shareDesc = getSafeString([descriptionDic objectForKey:@"sharePublicAlbumDesc"]);
    }
    
    //取出已经上传的相册中第一张图片
    UIImage *image;
    if (self.dataSource.count>0) {
        //如果是私密相册,要获取一张模糊处理的照片
        if (self.is_private) {
            NSDictionary *imgDic = self.dataSource[0];
            NSString *url = getSafeString(imgDic[@"url"]);
            if (url.length != 0) {
                CGFloat imgWidth = (kDeviceWidth - 5 *5)/4;
                NSString *urlString = [NSString stringWithFormat:@"%@%@",url,[CommonUtils imageStringWithWidth:2 * imgWidth height:imgWidth]];
                NSString *finalImageStr = [NSString stringWithFormat:@"%@|30-15bl",urlString];
                NSString *handleuUrlStr = [finalImageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:handleuUrlStr]];
                image = [UIImage imageWithData:imageData];
            }
        }else{
            //公开相册直接获取图片
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            PhotoViewCell *cell = (PhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            image = cell.imgView.image;
        }
        if (!image) {
            image = [UIImage imageNamed:@"AppIcon40x40"];
        }
    }else{
        image = [UIImage imageNamed:@"AppIcon40x40"];
    }

 
    if (actionSheet == self.shareSheet) {
        if(buttonIndex  == 0){
            //推荐给QQ好友
            shareString = PathShareAlbumQQ;
            NSString *shareTitle = @"相册分享";
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            NSString *shareURL = [NSString stringWithFormat:@"%@%@",shareString, self.albumID];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:shareDesc title:shareTitle imageData:imageData targetUrl:shareURL objectId:@"" withuseType:@""];

        }else if(buttonIndex == 1){
            //推荐到微信
            [self showWeiXinSheet];
        }
    }else{
        //分享到微信或者朋友圈
        if(buttonIndex == 0){
            //分享到朋友圈
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            NSString *shareTitle = @"相册分享";
            NSString *shareURL = [NSString stringWithFormat:@"%@%@",shareString ,self.albumID];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendWeiXInLinkContentTitle:shareTitle desc:shareDesc header:image URL:shareURL uid:@"" withuseType:@""];
        }else if(buttonIndex == 1){
            //分享到微信好友
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            NSString *shareTitle = @"相册分享";
                        NSString *shareURL = [NSString stringWithFormat:@"%@%@",shareString ,self.albumID];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendWeiXInLinkContentTitle:shareTitle desc:shareDesc header:image URL:shareURL uid:@"" withuseType:@""];
        }
    }
}


- (void)showWeiXinSheet{
    if (_weiXinSheet == nil) {
        _weiXinSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"朋友圈", @"微信好友", nil];
    }
    [_weiXinSheet showInView:self.view];
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
        CGFloat imgWidth = (kDeviceWidth - 5 *5)/4;
        flowLayout.itemSize = CGSizeMake(imgWidth, imgWidth);
        //创建集合视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight -kNavHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
        //代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //注册集合视图单元格
        [_collectionView registerClass:[PhotoViewCell class] forCellWithReuseIdentifier:@"PhotoViewCellID"];
    }
    return _collectionView;
}


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSDictionary *)albumDic{
    if (_albumDic == nil) {
        _albumDic = [NSDictionary dictionary];
    }
    return _albumDic;
}

@end
