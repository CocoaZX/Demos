//
//  LocalPhotoViewController.h
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LocalPhotoCell.h"
@class ViewController;
@protocol SelectPhotoDelegate<NSObject>
-(void)getSelectedPhoto:(NSMutableArray *)photos;
@end
@interface LocalPhotoViewController : McBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
- (IBAction)btnConfirm:(id)sender;

@property (nonatomic,retain) id<SelectPhotoDelegate> selectPhotoDelegate;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) ALAssetsGroup *currentAlbum;
@property (nonatomic, strong) NSMutableArray *selectPhotos;

//修改或者新建的时候已经有的图片个数
@property(nonatomic,assign)NSInteger existCount;
@property(nonatomic,assign)NSInteger maxSelectCount;
@end
