//
//  PictureView.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInforView.h"
#import "WorkStyleView.h"
#import "WorkExpView.h"

@protocol AppearPhotoBrowseDelegate <NSObject>

@optional
- (void)AppearPhotoBrowseWith:(int)index;

- (void)doJumpEditVC:(NSInteger)status;

@end

@interface PictureView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) id<AppearPhotoBrowseDelegate>delegate;

@property (nonatomic, strong) PersonInforView *informationView;

@property (nonatomic, strong) WorkStyleView *workStyleView;

@property (nonatomic, strong) WorkExpView *workExpView;

@property (nonatomic, strong) PersonInforView *workTagsView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *pictureArray;

@property (nonatomic, assign) float currentHeight;

@property (nonatomic, strong) UIImageView *lineView3;

@property (nonatomic, strong) UIImageView *lineView1;

@property (nonatomic, strong) UIImageView *lineView2;

@property (nonatomic, assign) BOOL isCurrentUser;

- (void)initViews;

- (void)resetViewFrame;

- (void)resetViewData:(NSDictionary *)diction;

- (float)getPictureHeight;

+ (PictureView *)getPictureView;


@end
