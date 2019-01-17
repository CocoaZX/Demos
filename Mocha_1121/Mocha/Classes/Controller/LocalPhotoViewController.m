//
//  LocalPhotoViewController.m
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import "LocalPhotoViewController.h"
#import "AssetHelper.h"
@interface LocalPhotoViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

//小于9.0的系统使用普通缩略图
@property(nonatomic,assign)BOOL needThumbnail;

@end

@implementation LocalPhotoViewController{
    ALAssetsLibrary *library;
    UIBarButtonItem *btnDone;
    NSMutableArray *selectPhotoNames;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //低于9.0系统的使用普通缩略图
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version <9.0) {
        _needThumbnail = YES;
    }else{
        _needThumbnail = NO;
    }
    
    
    if(self.selectPhotos==nil)
    {
        self.selectPhotos=[[NSMutableArray alloc] init];
        selectPhotoNames=[[NSMutableArray alloc] init];
    }else{
        selectPhotoNames=[[NSMutableArray alloc] init];
        for (ALAsset *asset in self.selectPhotos ) {
            //NSLog(@"%@",[asset valueForProperty:ALAssetPropertyAssetURL]);
            [selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
        }
        self.lbAlert.text=[NSString stringWithFormat:@"已经选择%lu张照片", self.existCount +(unsigned long)self.selectPhotos.count];
    }
    
    self.collection.dataSource=self;
    self.collection.delegate=self;
    [self.collection registerNib:[UINib nibWithNibName:@"LocalPhotoCell" bundle:nil]  forCellWithReuseIdentifier:@"photocell"];
    //取消
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    rightItem.tintColor = [CommonUtils colorFromHexString:kLikeRedColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([group numberOfAssets] > 0)
        {
            [self showPhoto:group];
        }
        else
        {
            NSLog(@"读取相册完毕");
            //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [[AssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock                                    failureBlock:nil];
    
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - collectionView代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"photocell";
    LocalPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    // load the asset for this cell

    ALAsset *asset=self.photos[indexPath.row];
    CGImageRef thumbnailImageRef;
    if(_needThumbnail){
         thumbnailImageRef = [asset thumbnail];
    }else{
        thumbnailImageRef = [asset aspectRatioThumbnail];
    }
    
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    cell.image = thumbnail;
    //[cell.img setImage:thumbnail];

    
//    ALAsset *asset=self.photos[indexPath.row];
//    ALAssetRepresentation *presentation = [asset defaultRepresentation];
//    [presentation scale];
//    CGImageRef imgref = [presentation fullResolutionImage];
//    UIImage *image = [UIImage imageWithCGImage:imgref];
//    [cell.img setImage:image];
    
    
    NSString *url=[asset valueForProperty:ALAssetPropertyAssetURL];
    [cell.btnSelect setHidden:[selectPhotoNames indexOfObject:url]==NSNotFound];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LocalPhotoCell *cell=(LocalPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell.btnSelect.hidden)
    {
        //添加新的图片
        if((self.existCount +self.selectPhotos.count)>9){
            [LeafNotification showInController:self withText:@"选择图片的个数达到上限，不能再选择"];
            return;
        }
//        if (self.maxSelectCount!=0) {
//            if (self.existCount+self.selectPhotos.count>=self.maxSelectCount) {
//                [LeafNotification showInController:self withText:@"选择图片的个数达到上限，不能再选择"];
//                return;
//
//            }
//        }
        
        [cell.btnSelect setHidden:NO];
        ALAsset *asset=self.photos[indexPath.row];
        [self.selectPhotos addObject:asset];
        [selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }else{
        [cell.btnSelect setHidden:YES];
        ALAsset *asset=self.photos[indexPath.row];
        NSString *str1=[asset valueForProperty:ALAssetPropertyAssetURL];

        for (ALAsset *a in self.selectPhotos) {
            NSLog(@"%@-----%@",[asset valueForProperty:ALAssetPropertyAssetURL],[a valueForProperty:ALAssetPropertyAssetURL]);
            NSString *str2=[a valueForProperty:ALAssetPropertyAssetURL];
            if([str1 isEqual:str2])
                {
                    [self.selectPhotos removeObject:a];
                    break;
                }
        }
        
        [selectPhotoNames removeObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }
    
    if(self.selectPhotos.count==0)
    {
        self.lbAlert.text=@"请选择照片";
    }
    else{
        self.lbAlert.text=[NSString stringWithFormat:@"已经选择%lu张照片",(unsigned long)self.selectPhotos.count];
    }
}


//返回单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (kDeviceWidth -10 -4*2)/3;
    return  CGSizeMake(width, width);
}

////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(-30,0, 0, 0);
//}
//



#pragma mark - 传递图片数据
- (IBAction)btnConfirm:(id)sender {
    
    if ([self.selectPhotoDelegate respondsToSelector:@selector(getSelectedPhoto:)]) {
        [self.selectPhotoDelegate getSelectedPhoto:self.selectPhotos];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) showPhoto:(ALAssetsGroup *)album
{
    if(album!=nil)
    {
        if(self.currentAlbum==nil||![[self.currentAlbum valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[album valueForProperty:ALAssetsGroupPropertyName]])
        {
            self.currentAlbum=album;
            if (!self.photos) {
                _photos = [[NSMutableArray alloc] init];
            } else {
                [self.photos removeAllObjects];
                
            }
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [self.photos addObject:result];
                }else{
                }
            };
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [self.currentAlbum setAssetsFilter:onlyPhotosFilter];
            [self.currentAlbum enumerateAssetsUsingBlock:assetsEnumerationBlock];
            self.title = [self.currentAlbum valueForProperty:ALAssetsGroupPropertyName];
            [self.collection reloadData];
        }
    }
}
-(void)selectAlbum:(ALAssetsGroup *)album{
    [self showPhoto:album];
}
@end
