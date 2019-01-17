//
//  JingPaiUploadView.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/21.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JingPaiUploadView.h"

@implementation JingPaiUploadView

- (UIView *)addButtonBaseView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.itemHeight, self.itemHeight)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 10.0f;
    
    return view;
}

- (UIImageView *)addButtonBaseImageViewWithImage:(NSString *)image
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.itemHeight, self.itemHeight)];
    imageview.image = [UIImage imageNamed:image];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.clipsToBounds = YES;
    imageview.layer.cornerRadius = 10.0f;
    
    return imageview;
}

- (UIButton *)addButtonBaseClickButton
{
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickButton setFrame:CGRectMake(0, 0, self.itemHeight, self.itemHeight)];
    [clickButton setClipsToBounds:YES];
    [clickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return clickButton;
}


#pragma mark - 创建视图
- (void)getTypeOneButtonViewWithIndex:(int)index
{
    UIView *view = [self addButtonBaseView];
    UIImageView *imgView = [self addButtonBaseImageViewWithImage:@""];
    [view addSubview:imgView];
    self.imgView = imgView;
    UIButton *click = [self addButtonBaseClickButton];
    click.tag = index;
    self.clickButton = click;
    if (kScreenWidth==320) {
        [click setImageEdgeInsets:UIEdgeInsetsMake(-14, 23, 0, 0)];
        [click setTitleEdgeInsets:UIEdgeInsetsMake(37, -15, 0, 0)];
        click.titleLabel.font = [UIFont systemFontOfSize:14];
    }else if(kScreenWidth==375)
    {
        [click setImageEdgeInsets:UIEdgeInsetsMake(-14, 30, 0, 0)];
        [click setTitleEdgeInsets:UIEdgeInsetsMake(44, -15, 0, 0)];
        click.titleLabel.font = [UIFont systemFontOfSize:15];
        
    }else
    {
        [click setImageEdgeInsets:UIEdgeInsetsMake(-14, 35, 0, 0)];
        [click setTitleEdgeInsets:UIEdgeInsetsMake(50, -15, 0, 0)];
    }
    
    [click setImage:[UIImage imageNamed:@"jingpan_add"] forState:UIControlStateNormal];
    [click setTitle:@"视频" forState:UIControlStateNormal];
    [view addSubview:click];
    [self addSubview:view];
}


- (void)getTypeTwoButtonViewWithIndex:(int)index
{
    UIView *view = [self addButtonBaseView];
    UIButton *click = [self addButtonBaseClickButton];
    click.tag = index;
    self.clickButton = click;

    if (kScreenWidth==320) {
        [click setImageEdgeInsets:UIEdgeInsetsMake(-14, 23, 0, 0)];
        [click setTitleEdgeInsets:UIEdgeInsetsMake(37, -15, 0, 0)];
        click.titleLabel.font = [UIFont systemFontOfSize:14];
    }else if(kScreenWidth==375)
    {
        [click setImageEdgeInsets:UIEdgeInsetsMake(-14, 30, 0, 0)];
        [click setTitleEdgeInsets:UIEdgeInsetsMake(44, -15, 0, 0)];
        click.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }else
    {
        [click setImageEdgeInsets:UIEdgeInsetsMake(-14, 35, 0, 0)];
        [click setTitleEdgeInsets:UIEdgeInsetsMake(50, -15, 0, 0)];
    }
    [click setImage:[UIImage imageNamed:@"jingpan_add"] forState:UIControlStateNormal];
    [click setTitle:@"图片" forState:UIControlStateNormal];
    [view addSubview:click];
    [self addSubview:view];
}

- (void)getTypeThreeButtonViewWithImage:(NSString *)image WithIndex:(int)index
{
    UIView *view = [self addButtonBaseView];
    UIImageView *imgView = [self addButtonBaseImageViewWithImage:@"Icon-60.png"];
    [view addSubview:imgView];
    self.imgView = imgView;

    UIButton *click = [self addButtonBaseClickButton];
    click.tag = index;
    self.clickButton = click;

    [click setImage:[UIImage imageNamed:@"jingpai_delete"] forState:UIControlStateNormal];
    [click setBackgroundColor:[UIColor clearColor]];
    [click setFrame:CGRectMake(self.itemHeight-25, 0, 25, 25)];
    [view addSubview:click];
    [self addSubview:view];
}

- (void)getTypeFourButtonViewWithImage:(NSString *)image WithIndex:(int)index
{
    UIView *view = [self addButtonBaseView];
    UIImageView *imgView = [self addButtonBaseImageViewWithImage:@""];
    [view addSubview:imgView];
    self.imgView = imgView;

    UIButton *click = [self addButtonBaseClickButton];
    click.tag = index;
    self.clickButton = click;

    [click setImage:[UIImage imageNamed:@"jingpai_delete"] forState:UIControlStateNormal];
    [click setBackgroundColor:[UIColor clearColor]];
    [click setFrame:CGRectMake(self.itemHeight-25, 0, 25, 25)];
    [view addSubview:click];
    [self addSubview:view];
}

@end
