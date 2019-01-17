//
//  McFooterView.h
//  Mocha
//
//  Created by renningning on 14-12-10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class McFooterView;

@protocol McFooterViewDelegate <NSObject>

@optional
- (void)footerView:(McFooterView *)tabBar didSelectIndex:(NSInteger)index;

- (void)footerView:(McFooterView *)tabBar didNotSelectIndex:(NSInteger)index;

@end

@interface McFooterButton : UIButton

@end

@interface McFooterView : UIView

@property (nonatomic, retain) UIImageView               *backgroundView;
@property (nonatomic, assign) id<McFooterViewDelegate>  delegate;
@property (nonatomic, retain) NSMutableArray            *buttons;
@property (nonatomic, retain) NSMutableArray            *labels;

@property (nonatomic, retain) NSMutableArray            *signNums;

- (id)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titleArray buttonImages:(NSArray *)imageArray;

- (void)selectFooterAtIndex:(NSInteger)index;
- (void)removeFooterAtIndex:(NSInteger)index;
- (void)insertFooterWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
//all ground
- (void)setBackgroundImage:(UIImage *)img color:(UIColor *)color;

- (NSInteger)getCurrentNumAtIndex:(NSInteger)index;

- (void)setNumsAtLabels:(NSArray *)numArray;

- (void)setNum:(NSString *)numstring atIndex:(NSInteger)index;

- (void)addNumAtIndex:(NSInteger)index;

- (void)minusNumAtIndex:(NSInteger)index;

- (void)setStatus:(BOOL)status atIndex:(NSInteger)index;

- (void)setHidden:(BOOL)hidden atIndex:(NSInteger)index;

@end
