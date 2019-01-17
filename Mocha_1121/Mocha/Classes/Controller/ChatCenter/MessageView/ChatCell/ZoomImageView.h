//
//  ZoomImageView.h
//  ZSTest
//
//  Created by zhoushuai on 16/3/21.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import <UIKit/UIKit.h>


//代理方法：当zoomImgView切换大小图时，其代理要执行的方法
@protocol ChangeForZoomImgViewDelegate <NSObject>

- (void)ChangeForZoomImgView:(NSDictionary *)userInfo;

@end

//#import "DDProgressView.h"

@interface ZoomImageView : UIImageView<UIScrollViewDelegate,UIActionSheetDelegate>

{
    //显示的滑动视图
    UIScrollView *_scrollView;
    
    //用与显示大图的链接
    NSString *_originalUrlString;
    //用于显示大图的image
    UIImage *_bigImage;
    
    //添加手势
    UITapGestureRecognizer *_tap;
    //用于显示的放大后的视图
    UIImageView *_fullImgView;
    //显示进度
    UIActivityIndicatorView *_activityView;
}

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,assign)id<ChangeForZoomImgViewDelegate> delegate;


@property(nonatomic,strong)NSDictionary *userInfoDic;
//消息体
@property (nonatomic, strong) MessageModel *model;

//弹出显示窗
@property(nonatomic,strong)UIActionSheet *shareSheet;
@property(nonatomic,strong)UIActionSheet *weiXinSheet;

@property (strong, nonatomic) MBProgressHUD *hud;

//使用链接
- (void)addTapActionZoomInImgViewWithOriginalUrlString:(NSString *)urlString;


//使用图片
- (void)addTapActionZoomInImgViewWithOriginalImage:(UIImage *)image;


@end