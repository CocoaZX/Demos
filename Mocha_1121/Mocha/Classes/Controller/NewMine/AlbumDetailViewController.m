//
//  AlbumDetailViewController.m
//  Mocha
//
//  Created by sun on 15/9/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "PhotoBrowseViewController.h"
#import "JSONKit.h"

@interface AlbumDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSDictionary *dataDiction;
@property (strong, nonatomic) NSMutableArray *pictureArray;
@property (assign, nonatomic) BOOL isCurrentUser;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL isCanDelete;
@property (strong, nonatomic) UIButton *bottomButton;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) NSMutableArray *editArray;

@end

@implementation AlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.currentTitle;
    self.pictureArray = @[].mutableCopy;
    self.editArray = @[].mutableCopy;
    self.isCurrentUser = YES;
    self.isEditing = NO;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.collectionView];
    [self getMokaDetailData];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(editMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = button;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    
    UIButton *buttonSubmit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSubmit setFrame:CGRectMake(10.0f, kScreenHeight-120, kScreenWidth-20, 50.0f)];
    [buttonSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSubmit setTitle:@"删除" forState:UIControlStateNormal];
    buttonSubmit.backgroundColor = [UIColor lightGrayColor];
    buttonSubmit.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [buttonSubmit addTarget:self action:@selector(deleteMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomButton = buttonSubmit;
    
    
    if ([uid isEqualToString:self.currentUid]) {
        self.navigationItem.rightBarButtonItem = buttonItem;
        
    }else
    {
        
    }
}

- (void)editMethod:(id)sender
{
    NSLog(@"editMethod");
    if (self.isEditing) {
        self.isEditing = NO;
        self.bottomButton.hidden = YES;
        [self.editArray removeAllObjects];
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.collectionView reloadData];

    }else
    {
        self.isEditing = YES;
        self.isCanDelete = NO;
        self.bottomButton.backgroundColor = [UIColor lightGrayColor];
        self.bottomButton.enabled = NO;
        self.bottomButton.hidden = NO;
        [self.view addSubview:self.bottomButton];
        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];

    }
    
}

- (NSString*)JSONStringWithDic:(NSArray *)diction
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:diction
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (void)deleteMethod:(id)sender
{
    NSLog(@"deleteMethod");
    if (self.editArray.count>0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableArray *photoIdArr = @[].mutableCopy;
        for (int i=0; i<self.editArray.count; i++) {
            NSString *indexE = self.editArray[i];
            NSDictionary *diction = self.pictureArray[[indexE intValue]-1];
            NSString *photoId = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
            [photoIdArr addObject:photoId];

        }
        NSString *photoJson = [self JSONStringWithDic:photoIdArr];

        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"albumid":self.albumid,@"photoids":photoJson}];
        [AFNetwork getMokaDelete:params success:^(id data){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([data[@"status"] integerValue] == kRight) {
                [LeafNotification showInController:self withText:data[@"msg"]];

                self.isEditing = NO;
                self.bottomButton.hidden = YES;
                [self.editArray removeAllObjects];
                [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
                [self getMokaDetailData];
                [self.collectionView reloadData];
            }
            else if([data[@"status"] integerValue] == kReLogin){
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
            
            
        }failed:^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
           [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
            
        }];
    }else
    {
        [LeafNotification showInController:self withText:@"请选择图片"];

    }
    
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    
}

- (void)getMokaDetailData
{
    
    NSString *cuid = self.albumid;
    
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid}];
    [AFNetwork getMokaDetail:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            self.dataDiction = data[@"data"];
            if (![self.dataDiction[@"albumType"] isEqualToString:@"3"]) {
                self.pictureArray = [NSMutableArray arrayWithArray:self.dataDiction[@"photos"]];
                [self.collectionView reloadData];
            }
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        
     [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}


#pragma mark UICollectionViewDelegate UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int count = 0;
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([uid isEqualToString:self.currentUid]) {
        count = (int)self.pictureArray.count+1;
        
    }else
    {
        count = (int)self.pictureArray.count;
        
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([uid isEqualToString:self.currentUid]) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth)/3, (kScreenWidth)/3)];
        if (indexPath.row==0) {
            imageV.backgroundColor = [UIColor lightGrayColor];
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            UIImageView *shiimgview = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth)/3/2/2, (kScreenWidth)/3/2/2, (kScreenWidth)/3/2, (kScreenWidth)/3/2)];
            shiimgview.image = [UIImage imageNamed:@"picture-add"];
            
            [imageV addSubview:shiimgview];
        }else
        {
            NSString *urlString = self.pictureArray[indexPath.row-1][@"url"];
            if (urlString) {
                NSInteger wid = CGRectGetWidth(imageV.frame) * 2;
                NSInteger hei = CGRectGetHeight(imageV.frame) * 2;
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
                [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
                NSLog(@"%@",url);
            }
        }
        if (self.isEditing) {
            for (int i=0; i<self.editArray.count; i++) {
                NSString *indexE = self.editArray[i];
                if (indexPath.row==[indexE intValue]) {
                    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth)/3, (kScreenWidth)/3)];
                    imageV2.image = [UIImage imageNamed:@"deleteTemplete"];
                    [imageV addSubview:imageV2];
                }
            }
            
        }
        [cell.contentView addSubview:imageV];
        
        
    }else
    {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth)/3, (kScreenWidth)/3)];
        NSString *urlString = self.pictureArray[indexPath.row][@"url"];
        if (urlString) {
            NSInteger wid = CGRectGetWidth(imageV.frame) * 2;
            NSInteger hei = CGRectGetHeight(imageV.frame) * 2;
            NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
            NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
            [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
            NSLog(@"%@",url);
        }
        
        [cell.contentView addSubview:imageV];
        
        
    }

    
    
    return cell;
}

//元素框的大小,指定区的内边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {5,0,5,5};
    return top;
}



//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake((kDeviceWidth - 30)/3,(kDeviceWidth - 30)/3 + 3);
            break;
        case 1:
            return CGSizeMake(kDeviceWidth,60);
            break;
        case 2:
            return CGSizeMake(kDeviceWidth,60);
            break;
        default:
            break;
    }
    return CGSizeZero;
}





//选择
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing) {
        if (indexPath.row==0) {
            
        }else
        {
            self.isCanDelete = YES;
            self.bottomButton.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
            self.bottomButton.enabled = YES;
            NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            BOOL isCanAdd = YES;
            for (int i=0; i<self.editArray.count; i++) {
                NSString *oldInde = self.editArray[i];
                if ([oldInde isEqualToString:indexStr]) {
                    isCanAdd = NO;

                }
            }
            if (isCanAdd) {
                [self.editArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

            }else
            {
                [self.editArray removeObject:indexStr];
            }
            [self.collectionView reloadData];
            
        }
        
    }else
    {
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if ([uid isEqualToString:self.currentUid]) {
            NSLog(@"index.row:%ld",(long)indexPath.row);
            if (indexPath.row==0) {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                     destructiveButtonTitle:nil
                                        
                                                          otherButtonTitles:@"相机", @"从手机相册中选择", nil];
                [sheet showInView:self.view];
            }else
            {
                NSString *uid = self.currentUid;
                if (uid) {
                    NSString *photoId = self.pictureArray[indexPath.row-1][@"photoId"];
                    
                    PhotoBrowseViewController *photo = [[PhotoBrowseViewController alloc] initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
                    photo.startWithIndex = 0;
                    photo.currentUid = uid;
                    [photo setDataFromPhotoId:photoId uid:uid];

                    [self.navigationController pushViewController:photo animated:YES];
                }else
                {
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                    
                }
            }
        }else
        {
            NSString *uid = self.currentUid;
            if (uid) {
                NSString *photoId = self.pictureArray[indexPath.row][@"photoId"];

                PhotoBrowseViewController *photo = [[PhotoBrowseViewController alloc] initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
                if (indexPath.row>=self.pictureArray.count) {
                    photo.startWithIndex = self.pictureArray.count-1;
                    
                }else
                {
                    photo.startWithIndex = indexPath.row;
                    
                }
                photo.currentUid = uid;
//                [photo setDataFromPhotoId:photoId uid:uid];
                [photo setDataFromPhotoId:photoId uid:uid withArray:self.pictureArray];

                UserDefaultSetBool(YES, @"isHiddenTabbar");
                [USER_DEFAULT synchronize];

                [self.navigationController pushViewController:photo animated:YES];
            }else
            {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                
            }
        }

    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0) {
        [self takePhoto];
    }else if(buttonIndex==1)
    {
        [self takePicture];
    }
    
}
#pragma mark photo
- (void)takePicture
{
    [SingleData shareSingleData].currnetImageType = 2;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"sorry, no photo library is unavailable.");
        return;
    }
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
- (void)takePhoto
{
    [SingleData shareSingleData].currnetImageType = 2;
    
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //获取用户编辑之后的图像
        UIImage* editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];//不可编辑的
        UIImage *image = editedImage;
        if (image.imageOrientation==UIImageOrientationRight) {
            image = [image imageRotatedByDegrees:90];
            
        }
        BOOL isAviary = UserDefaultGetBool(@"isUseAviary");
        if (isAviary) {
            
        }else
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *uid = @"";
            uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            
            UIImage *uploadImage = image;
            if (uploadImage) {
                
//                NSData *imageData = UIImageJPEGRepresentation(uploadImage, 0.3);
                NSData *imageData = UIImageJPEGRepresentation(uploadImage, 1.0);
                NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
                //    //2M以下不压缩
                if (imageData.length/1024 > 1024 * 5) {
                    imageData = UIImageJPEGRepresentation(uploadImage, 0.3);
                }
                while (imageData.length/1024 > 2048) {
                    imageData = UIImageJPEGRepresentation(uploadImage, 0.6);
                    uploadImage = [UIImage imageWithData:imageData];
                }

                NSString *sequence = @"";
                if (self.pictureArray.count>0) {
                    NSDictionary *dic = self.pictureArray[self.pictureArray.count-1];
                    NSString *lastSeq = [NSString stringWithFormat:@"%@",dic[@"sequence"]];
                    sequence = [NSString stringWithFormat:@"%d",[lastSeq intValue]+1];
                    
                }
                
                
                NSDictionary *dict = [AFParamFormat formatPostMokaUploadParams:uid tags:@"" title:@"" type:2 sequence:sequence albumid:self.albumid file:@"file"];
                [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
                    NSLog(@"uploadPhoto:%@ test SVN",data);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    
                    NSDictionary *diction = (NSDictionary *)data;
                    NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
                    if ([str isEqualToString:@"0"]) {
                        [self getMokaDetailData];
                        
                        
                    }else{
                        [LeafNotification showInController:self withText:diction[@"msg"]];
                        
                    }
                    
                }failed:^(NSError *error){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                }];
            }
        }
    
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //创建ALAssetsLibrary对象并将视频保存到媒体库
        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                NSLog(@"captured video saved with no error.");
            }else
            {
                NSLog(@"error occured while saving the video:%@", error);
            }
        }];
    }
    
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
}
 
@end
