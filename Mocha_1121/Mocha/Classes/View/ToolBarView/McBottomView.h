//
//  McBottomView.h
//  Mocha
//
//  Created by renningning on 15-4-9.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McButton : UIButton

@end




@interface McBottomBarItem : UIView

@property (nonatomic, retain) UIImageView *iconImageview;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UIButton * clickButton;

- (id)initWithFrame:(CGRect)frame Image:(NSString *)image title:(NSString *)title;

- (void)clickAddTarget:(id)target action:(SEL)action;


@end



@interface McBottomView : UIView

@property (nonatomic ,retain) NSArray *buttonItems;

- (void)setItems:(NSArray *)items;

- (void)setImage:(NSString *)str index:(NSUInteger)index;

- (void)setTitle:(NSString *)title index:(NSUInteger)index;

- (void)setTitleColor:(UIColor *)color index:(NSUInteger)index;

- (void)setItemBackgroundColor:(UIColor *)color index:(NSUInteger)index;

- (void)setLabel:(NSString *)string index:(NSUInteger)index;

- (void)setAllLabel:(BOOL)hidden;

- (void)setAllButtonEnabled:(BOOL)isEnabled;

- (void)replaceBarItem:(McBottomBarItem *)item atIndex:(NSUInteger)index;

@end
