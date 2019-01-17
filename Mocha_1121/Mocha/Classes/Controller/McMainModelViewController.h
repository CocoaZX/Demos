//
//  McMainModelViewController.h
//  Mocha
//
//  Created by zhoushuai on 15/11/10.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMcMainViewController.h"
@interface McMainModelViewController : BaseMcMainViewController

@property(nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic,assign)BOOL isFirstLoadHeaderData;
@property (nonatomic,assign)BOOL isFirstLoadImagsData;
@end
