//
//  McSeachShowCollectionViewController.h
//  Mocha
//
//  Created by renningning on 14-12-18.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McSeachShowCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableDictionary *paramsDictionary;
@property (nonatomic, retain) NSString *lastIndex;

- (void)setController;

@end
