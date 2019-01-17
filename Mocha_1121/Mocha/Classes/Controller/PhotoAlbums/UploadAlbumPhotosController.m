//
//  UploadAlbumPhotosController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "UploadAlbumPhotosController.h"
#import "LocaPicturesViewController.h"
#import "BulidPhotoAlbumController.h"
#import "MokaPhotosViewController.h"
#import "PhotoBrowseViewController.h"
#import "UploadPictureCell.h"
#import "AFNetworking.h"
#import "PhotoModel.h"
@interface UploadAlbumPhotosController ()<ChooseLoaclPhotos,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIAlertViewDelegate>

//提示还没有上传图片的视图
@property (weak, nonatomic) IBOutlet UIView *noPicturesView;
//上传图片按钮
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//完成按钮
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

//约束==========
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadBtn_top;

//本地已经选中的图片
@property(nonatomic,strong)NSMutableArray *localPhotos;
//本地已经选中的图片的链接
//@property(nonatomic,strong)NSMutableArray *localPhotoUrls;
//从本地选中但是未上传的图片
@property(nonatomic,strong)NSMutableArray *unloadPhotos;
//选择的本地图片的路径
//@property(nonatomic,strong)NSMutableDictionary *localPhotoUrlDic;

//进入本界面获取到的已经上传的图片数组
@property(nonatomic,strong)NSMutableArray *haveUploadedPhotoArray;
//请求网络获取的相册的信息
@property(nonatomic,strong)NSDictionary *albumDic;


//分享视图
@property(nonatomic,strong)UIActionSheet *shareSheet;
@property(nonatomic,strong)UIActionSheet *weiXinSheet;
//@property(nonatomic,strong)UIView *headView;

@end

@implementation UploadAlbumPhotosController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.currentTitle;
    
    _collectionView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    //注册集合视图单元格
    UINib *nib = [UINib nibWithNibName:@"UploadPictureCell"
                                bundle: [NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"UploadPictureCellID"];
    
    //注册集合视图的头视图
    //[_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UploadAlbumPhotoHeadViewID"];

     //设置导航栏
     [self setNavigationBar];
    
     //移除导航控制器子视图控制器中的新建界面VC
     //避免pop时还进入到创建相册的界面
     [self removeBulidPhotoAlbumController];
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    //按钮的高度
    //[self resetUploadButton];

    //本地图片数组中存放都是未上传的图片
    //[self.localPhotos removeAllObjects];
    //[self.localPhotos addObjectsFromArray:self.unloadPhotos];

    //如果有未上传的图片，开始上传图片
//    if (_unloadPhotos.count>0) {
//        //存在未上传的图片
//        [self uploadLocalPhotos];
//    }

    //获取网络上的图片
    if(!_notNeedReload){
        [self getUploadedPhotos];

    }else{
        _notNeedReload = NO;
    }
    [self.collectionView reloadData];
}

- (void)resetUploadButton{
    //根据已有图片的个数决定上传图片s视图位置
    if ((self.localPhotos.count + self.haveUploadedPhotoArray.count) == 0) {
        self.noPicturesView.hidden = NO;
        _uploadBtn.hidden = NO;
        _uploadBtn_top.constant  = 250;
        _collectionView.hidden = YES;
        _completeBtn.hidden = YES;
    }else{
        self.noPicturesView.hidden = YES;
        self.noPicturesView.hidden = YES;
        _uploadBtn.hidden = YES;
        //_uploadBtn_top.constant  = 30;
        _collectionView.hidden = NO;
        _completeBtn.hidden = NO;
    }
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






//加载头部视图
//- (void)loadHeaderView
//{
//    if(_headView == nil){
//        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100)];
//        
//    }
// }




#pragma mark - UICollectionViewDataSource
//返回单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //正在上传的图片和为已经上传的图片
    return self.localPhotos.count + self.haveUploadedPhotoArray.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"UploadPictureCellID";
    UploadPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.progressView.hidden = YES;
        cell.progressLabel.hidden = YES;
        cell.cellType = @"localCell";
        cell.image= [UIImage imageNamed:@"activityAddImg"];
        return cell;
        
     }else if(indexPath.row!=0 && indexPath.row < self.localPhotos.count+1){
        //本地图片的数组里
         PhotoModel *model = self.localPhotos[indexPath.row-1];
         UIImage *image = model.image;
        cell.cellType = @"localCell";
        cell.image  = image;
        //当前image不在未上传图片数组中，说明此本地图片已经上传
        if([_unloadPhotos indexOfObject:image] ==NSNotFound) {
            cell.progressView.hidden = YES;
            cell.progressLabel.hidden = YES;
        }else{
            cell.progressLabel.hidden = NO;
            cell.progressView.hidden = NO;
            cell.progressView.hidden = YES;
            cell.progressLabel.hidden = YES;

        }
        return cell;

    }else if(indexPath.row <(self.localPhotos.count +self.haveUploadedPhotoArray.count+1)){
        cell.cellType = @"netCell";
        NSDictionary *dic  = self.haveUploadedPhotoArray[indexPath.row -_localPhotos.count-1];
        cell.imgUrlStr = dic[@"url"];
        cell.progressView.hidden = YES;
        cell.progressLabel.hidden = YES;
        return cell;
     }
    return cell;
 }


//调整间距：针对于collectionView的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     CGFloat imgWidth = (kDeviceWidth - 5 *5)/4;
    return CGSizeMake(imgWidth, imgWidth);
}



/*
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {kDeviceWidth,100};//+5
    return size;
}


//返回头视图，类似headerView和FootView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
     UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UploadAlbumPhotoHeadViewID" forIndexPath:indexPath];
    
    [reusableView addSubview:self.headView];
    return reusableView;
}
*/



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self uplodPhotosBtnClick:nil];
    }else if(indexPath.row!=0 && indexPath.row <self.localPhotos.count+1){
        //点击本地图片没反应
        
    }else{
        //点击网络的图片，进入图片浏览界面
        PhotoBrowseViewController *photoBrow = [[PhotoBrowseViewController alloc]initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
        
        NSInteger startIndex = indexPath.row - self.localPhotos.count-1;
        photoBrow.startWithIndex = startIndex;
        
        photoBrow.currentUid = self.currentUID;
        NSDictionary *currentDic= self.haveUploadedPhotoArray[startIndex];
        NSString *photoID = currentDic[@"photoId"];
        
        [photoBrow setDataFromPhotoId:photoID uid:self.currentUID withArray:self.haveUploadedPhotoArray];
        [self.navigationController pushViewController:photoBrow animated:YES];
    }
}


#pragma mark - SelectPhotoDelegate
- (void)getSelectedLocalPhotos:(NSArray *)photos{
    NSLog(@"seleted");
    NSInteger lastIndex = photos.count -1;
    //NSInteger startIndex = 0;
    NSMutableArray *unUploadphotos = [NSMutableArray array];
    for (NSInteger i = lastIndex;i>-1 ; i--) {
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        ALAsset *alasset = photos[i];
        CGImageRef posterImageRef= [[alasset defaultRepresentation] fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:posterImageRef];
        
        photoModel.image = image;
        photoModel.imgLocalUrl = [alasset valueForProperty:ALAssetPropertyAssetURL];
        //本地图片数组
        [self.localPhotos insertObject:photoModel atIndex:0];
       
        //将要上传的的图片
        [unUploadphotos addObject:photoModel];
        
        //加入本地图片的数组
        //[self.localPhotos insertObject:image atIndex:0];
        //加入未上传图片的数组
        //[self.unloadPhotos insertObject:image atIndex:0];
        //已经选取的图片的路径
        //[self.localPhotoUrls insertObject:[alasset valueForProperty:ALAssetPropertyAssetURL] atIndex:0];
        //[self.localPhotoUrlDic setObject:[alasset valueForProperty:ALAssetPropertyAssetURL] forKey:@(lastIndex)];
        //startIndex ++;
     }
    //上传未选中的图片
    [self uploadLocalPhotos:unUploadphotos];
    //从本地中取图片，并不会重新请求网络中的图片数据，而是直接加到了
    //本地数组中，在这里直接重置视图就行
    [self resetUploadButton];
}



#pragma mark - 事件点击
//点击上传，转到本地图片列表，选择图片
- (IBAction)uplodPhotosBtnClick:(UIButton *)sender {
    LocaPicturesViewController *localPicturesVC = [[LocaPicturesViewController alloc] initWithNibName:@"LocaPicturesViewController" bundle:nil];
    localPicturesVC.delegate = self;
    self.notNeedReload = YES;
    [self.navigationController pushViewController:localPicturesVC animated:YES];
}

//导航栏上的分享
- (void)rightBtnClick:(UIButton *)btn{
    
    if (_shareSheet == nil) {
        _shareSheet =[[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"推荐给QQ好友",@"推荐到微信",@"编辑相册",@"管理照片", nil];}
    [_shareSheet showInView:self.view];
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *shareString = @"";
    NSString *shareDesc = @"";
    //配置中分享相册文案和接口
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
    
    //配置分享用的图片
    UIImage *image;
    if(self.haveUploadedPhotoArray.count>0){
        //取出已经上传的相册中第一张图片
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.localPhotos.count+1 inSection:0];
        //如果是私密相册,要获取一张模糊处理的照片
        if (self.is_private) {
            NSDictionary *imgDic = self.haveUploadedPhotoArray[0];
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
            UploadPictureCell *cell = (UploadPictureCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
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
            shareString = PathShareAlbumQQ;
            //推荐给QQ好友
            NSString *shareTitle = @"相册分享";
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            NSString *shareURL = [NSString stringWithFormat:@"%@%@",shareString, self.albumID];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:shareDesc title:shareTitle imageData:imageData targetUrl:shareURL objectId:@"" withuseType:@""];
         }else if(buttonIndex == 1){
            //推荐到微信
            [self showWeiXinSheet];
        }else if(buttonIndex == 2){
            if(!self.albumID || (self.albumID.length ==0)){
                [LeafNotification showInController:self withText:@"无法获取当前相册信息,不可编辑"];
                return;
            }
            //编辑相册
            BulidPhotoAlbumController *buildphotoVC = [[BulidPhotoAlbumController alloc] initWithNibName:@"BulidPhotoAlbumController" bundle:nil];
            buildphotoVC.isEdit = YES;;
            buildphotoVC.albumDic = self.albumDic;
            buildphotoVC.albumID = self.albumID;
            [self.navigationController pushViewController:buildphotoVC animated:YES];
        }else if(buttonIndex == 3){
            //管理照片
            MokaPhotosViewController *photosVC = [[MokaPhotosViewController alloc] initWithNibName:@"MokaPhotosViewController" bundle:nil];
            photosVC.conditionType = @"deletePrivacyPhoto";
            photosVC.currentTitle = @"删除照片";
            //传入相册id
            photosVC.albumID = self.albumID;
            [self.navigationController pushViewController:photosVC animated:YES];
        }
    }else{
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



- (IBAction)completeBtnClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"操作完成" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    //[self doBackAction:nil];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self doBackAction:nil];
}

//覆写父类的返回方法
//如果是从新建界面进入，返回的时候不再显示新建的界面
- (void)doBackAction:(id)sender{
     [self.navigationController popViewControllerAnimated:YES];
}

//移除不需要再显示的视图控制器
- (void)removeBulidPhotoAlbumController{
    NSMutableArray *removeArr = @[].mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id controller = self.navigationController.childViewControllers[i];
        if ([controller isKindOfClass:[BulidPhotoAlbumController class]]) {
            [removeArr addObject:controller];
        }
    }
    
    NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
    for (int i=0; i<removeArr.count; i++) {
        id controller = removeArr[i];
        [tempArr removeObject:controller];
    }
    [self.navigationController setViewControllers:tempArr];
}


#pragma mark - 辅助方法
//使用更新后的相册信息设置当前用户对浏览照片的模糊设置
- (void)resetPrivacy{
    NSLog(@"%@",_albumDic);
    //获取私密性数据
    NSDictionary *openDic = _albumDic[@"setting"][@"open"];
    NSString *isPrivate = [openDic objectForKey:@"is_private"];
    if ([isPrivate isEqualToString:@"0"]) {
        _is_private = NO;
     }else{
        //有私密设置
        _is_private = YES;
     }
}


#pragma mark - 有关网络部分的操作
- (void)getUploadedPhotos{
     //获取相册详情
    if (self.albumID) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setObject:@"2" forKey:@"album_type"];
        [mdic setObject:self.albumID forKey:@"id"];
         NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];
         [AFNetwork getMokaDetail:params success:^(id data) {
            NSLog(@"%@",data);
            //移除原来的数据
            [self.localPhotos removeAllObjects];
            [self.haveUploadedPhotoArray removeAllObjects];
            self.albumDic = data[@"data"];
            [self resetPrivacy];
            NSArray *arr = data[@"data"][@"photos"];
            [self.haveUploadedPhotoArray addObjectsFromArray:arr];
            [self resetUploadButton];
            [self.collectionView reloadData];
         } failed:^(NSError *error) {
            
        }];
    }
}




/**
 *  功能 AFNetWorking带进度指示文件上传
 *  @param filePath 文件路径
 */
-(void)uploadLocalPhotos:(NSArray *)photos
{
    for (int i = 0; i< photos.count; i++) {
        PhotoModel *model = photos[i];
        UIImage *image = model.image;
        //第一步：压缩图片
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"第%d张图片大小:\n%.1luKB",i,(unsigned long)imageData.length/1024);
        //2M以下不压缩
        while (imageData.length/1024 > 2048) {
            imageData = UIImageJPEGRepresentation(image, 0.8);
            //self.unloadPhotos[i] = [UIImage imageWithData:imageData];
        }
        
        //第二步骤：服务器所需参数（非必须）
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        //0-表单上传  1-字节流上传
        [params setObject:@"0" forKey:@"uptype"];
        [params setObject:@"VEJQemdPdDd6ZEdhYWY1" forKey:@"key"];
        [params setObject:@"9" forKey:@"type"];
        [params setObject:self.albumID forKey:@"albumid"];
        //文件名
        //NSString *fileName=[self.localPhotoUrls[i] lastPathComponent];
        NSString *fileName = [model.imgLocalUrl lastPathComponent];
        //文件类型
        NSString *filePath = model.imgLocalUrl;
        NSString *mimeType=[SQCStringUtils getMIMETypeWithCAPIAtFilePath:filePath];
        //文件类型
        if (!mimeType) {
            mimeType = @"application/octet-stream";
        }
        
        AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
        requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        requestManager.requestSerializer.timeoutInterval=15.f;//请求超时45S
        
        NSString *pathAll = [NSString stringWithFormat:@"%@%@",DEFAULTURL,PathUploadPhoto];
        NSDictionary *paramsDic = [AFParamFormat formatupdateParams:params];
        NSMutableURLRequest *request = [requestManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:pathAll  parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:mimeType];
        } error:nil];
        
        AFHTTPRequestOperation *operation = [requestManager HTTPRequestOperationWithRequest:request
                                                                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                        //系统自带JSON解析
                                                                                        NSDictionary *resultJsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];

                                        //记录已经上传的图片
                                                                                        //[_unloadPhotos removeObject:image];
                                                                                //刷新单元格
//                                                                                       NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];                                            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                                                        //[_collectionView reloadData];
                                                                                        NSLog(@"上传成功--%@",resultJsonDic);                                                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                        NSLog(@"失败--%@",error);
                                                                                    }];
        
        [operation setUploadProgressBlock: ^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            float  progress=(float)totalBytesWritten / totalBytesExpectedToWrite;
            NSLog(@"第%d张图片上传进度 = %f",i,progress);
            //刷新单元格的上传进度
           // UploadPictureCell *cell = (UploadPictureCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            //cell.progressView_top.constant = (kDeviceWidth - 5 *5)/4 *progress;
            //cell.progressLabel.text = [NSString stringWithFormat:@"%0.f%%",progress *100];
            
         }];
        
        [request setTimeoutInterval:25.0f];
        [requestManager.operationQueue addOperation:operation];
    }
    //[self.haveUploadedPhotoArray removeAllObjects];
}






#pragma mark - set/get方法
/*
- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100)];
        UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 25, kDeviceWidth - 30 *2, 50)];
        [uploadBtn setTitle:@"上传图片" forState:UIControlStateNormal];
        uploadBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
        [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        uploadBtn.layer.cornerRadius = 5;
        uploadBtn.layer.masksToBounds= YES;
        [uploadBtn addTarget:self action:@selector(uplodPhotosBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:uploadBtn];
    }
    return _headView;
}
*/



//本地图片数组
- (NSMutableArray *)localPhotos{
    if (_localPhotos == nil) {
        _localPhotos = [NSMutableArray array];
    }
    return _localPhotos;
}

//本地图片链接数组
//- (NSMutableArray *)localPhotoUrls{
//    if (_localPhotoUrls == nil) {
//        _localPhotoUrls = [NSMutableArray array];
//    }
//    return _localPhotoUrls;
//}

//- (NSMutableDictionary *)localPhotoUrlDic{
//    if (_localPhotoUrlDic == nil) {
//        _localPhotoUrlDic = [NSMutableDictionary dictionary];
//    }
//    return _localPhotoUrlDic;
//
//}

//未上传图片数组
- (NSMutableArray *)unloadPhotos{
    if (_unloadPhotos == nil) {
        _unloadPhotos = [NSMutableArray array];
    }
    return _unloadPhotos;
}

//已经上传了图片数组
- (NSMutableArray *)haveUploadedPhotoArray{
    if (_haveUploadedPhotoArray == nil) {
        _haveUploadedPhotoArray = [NSMutableArray array];
    }
    return _haveUploadedPhotoArray;
}

- (NSDictionary *)albumDic{
    if (_albumDic== nil) {
        _albumDic = [NSDictionary dictionary];
    }
    return _albumDic;
}


@end
