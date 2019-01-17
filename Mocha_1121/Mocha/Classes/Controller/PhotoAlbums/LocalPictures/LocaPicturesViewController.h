//
//  LocaPicturesViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@protocol ChooseLoaclPhotos <NSObject>

- (void)getSelectedLocalPhotos:(NSArray *)array;

@end


@interface LocaPicturesViewController : McBaseViewController
//从上个界面进入时，已经选中的图片
@property(nonatomic,assign)NSInteger existCount;
//最大可以选择的图片
@property(nonatomic,assign)NSInteger maxSelectCount;


@property(nonatomic,assign)id<ChooseLoaclPhotos> delegate;

@end
