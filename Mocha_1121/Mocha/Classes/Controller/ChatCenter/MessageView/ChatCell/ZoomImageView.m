//
//  ZoomImageView.m
//  ZSTest
//
//  Created by zhoushuai on 16/3/21.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import "ZoomImageView.h"
@implementation ZoomImageView

#pragma mark 添加放大视图的手势
//为视图添加点击放大操作
//使用图片链接：
- (void)addTapActionZoomInImgViewWithOriginalUrlString:(NSString *)urlString{
    //开启imgView接收点击
    self.userInteractionEnabled = YES;
    if (urlString != nil) {
        _originalUrlString = urlString;
    }
    //创建一个可以响应的手势:点击放大图片
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInImgView:)];
    [self addGestureRecognizer:_tap];
}


//使用原图
- (void)addTapActionZoomInImgViewWithOriginalImage:(UIImage *)image{
    self.userInteractionEnabled = YES;
//    if (image != nil) {
//        _bigImage = image;
//    }
    NSString *localPath = _model.message == nil ? _model.localPath : [[_model.message.messageBodies firstObject] localPath];
    if (localPath && localPath.length > 0) {
        _bigImage= [UIImage imageWithContentsOfFile:localPath];
    }
    if (_bigImage == nil) {
        _bigImage = self.image;
    }
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInImgView:)];
    [self addGestureRecognizer:_tap];
}


//点击了按钮，放大图片
- (void)zoomInImgView:(UITapGestureRecognizer *)tap{
    //1.如果本身就没有图片就直接什么也不做
    if(self.image == nil){
        return;
    }
    //2.继续响应点击事件，创建可显示的大图
    [self _initViews];
    
    //调用代理：改变视图
//    if([_delegate respondsToSelector:@selector(ChangeForZoomImgView:)]){
//        [_delegate ChangeForZoomImgView:_userInfoDic];
//    }
    //使用通知:通知代理
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeForZoomImgView" object:_userInfoDic];
    
    if (_originalUrlString.length>0) {
        if (_activityView == nil) {
            _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((kDeviceWidth -100)/2, (kDeviceHeight -100)/2, 100, 100)];
            _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [self.window addSubview:_activityView];
        }
        _activityView.hidden = YES;
        [_activityView stopAnimating];
    }

    
    //3.给_fullImgView设置frame
    //放大图片是从原图位置开始的
    //首先找到原图相对于窗口的frame
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    _fullImgView.frame = rect;
    //实现图片方法，使用的动画
    //执行消失动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //获取放大后的高度
        CGFloat height = kDeviceWidth/(self.image.size.width/self.image.size.height);
        _fullImgView.backgroundColor = [UIColor blackColor];
        //图片足够大的话从坐标00,开始显示
        //图片横向比较大的话，由于设置了自适应显示模式，会依照宽度自适应显示在中间
        _fullImgView.frame =CGRectMake(0, 0, kDeviceWidth, MAX(height, kDeviceHeight));
        _fullImgView.contentMode = UIViewContentModeScaleAspectFit;
        //设置滑动视图内容大小
        _scrollView.contentSize = CGSizeMake(kDeviceWidth , height);
     } completion:^(BOOL finished) {
         if (_model.imageRemoteURL) {
             _activityView.hidden = NO;
             [_activityView startAnimating];
             [_fullImgView sd_setImageWithURL:_model.imageRemoteURL placeholderImage:_bigImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                 //
             } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     [_activityView removeFromSuperview];
                     [_activityView stopAnimating];
                     _activityView = nil;
             }];
             
          }else{
             _fullImgView.image = _bigImage;
         }
     }];
}


//初始化放大的视图和ImgView
- (void)_initViews{
    //如果还没有滑动视图就先创建
    if(_scrollView ==nil){
        //设置滑动视图的显示尺寸
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
        _scrollView.delegate = self;
        //在滑动视图上添加可以缩小的手势
        UITapGestureRecognizer *forSmalltap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutImgView:)];
        [_scrollView addGestureRecognizer:forSmalltap];
    }
    [self.window addSubview:_scrollView];
    
    //创建显示的放大视图
    if (_fullImgView == nil) {
        _fullImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImgView.userInteractionEnabled = YES;
        //首先是将原图赋值给当前的大图imgView
        _fullImgView.image = _bigImage;
        //设置图片的显示模式
        //【特】默认图片是铺满全屏的，这是不需要的
        _fullImgView.contentMode = self.contentMode;
        //添加到滑动视图上
        [_scrollView addSubview:_fullImgView];
        
        //长按手势(长按3秒之后会触发响应)
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        //设置长按的最短时间
        longPressGesture.minimumPressDuration = 0.5;
        [_fullImgView addGestureRecognizer: longPressGesture];

        
    }
}

//添加缩小的手势
- (void)zoomOutImgView:(UITapGestureRecognizer *)tap{
    //[_ddProgressView removeFromSuperview];
    //_ddProgressView.hidden = nil;
    [UIView animateWithDuration:0.2 animations:^{
        //缩小视图
        _fullImgView.frame = [self convertRect:self.bounds toView:self.window];
        _scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [_fullImgView removeFromSuperview];
        _fullImgView = nil;
        [_scrollView removeFromSuperview];
        _scrollView =nil;
    }];
}
 

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _fullImgView;
}


//长按手势的响应处理
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
    }else if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束长按");
        [self shareMethod];
    }
}

#pragma mark - 分享
- (void)shareMethod
{
    if (_shareSheet == nil) {
    
        _shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"推荐给QQ好友",@"推荐到微信",@"保存图片", nil];
   }
    
    [_shareSheet showInView:self.window];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImage *image = _bigImage;
    
    if (actionSheet == self.shareSheet) {
        if(buttonIndex  == 0){
            //推荐给QQ好友
            NSData *imageData = UIImagePNGRepresentation(image);
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQWithImageDataReallyData:imageData previewImage:image title:@"分享" description:nil];
        }else if(buttonIndex == 1){
            //推荐到微信
            [self showWeiXinSheet];
            
        }else if(buttonIndex == 2){
            //保存图片
            [self savePhotoToPhone];
            
        }else if(buttonIndex == 3){
            //
        }
    }else{
        //分享到微信或者朋友圈
        if(buttonIndex == 0){
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"分享"];//rnadd shareURL:nil
        }else if(buttonIndex == 1){
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"分享"];
        }
    }
}

- (void)showWeiXinSheet{
    
    if (_weiXinSheet == nil) {
        _weiXinSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"朋友圈", @"微信好友", nil];
    }
    [_weiXinSheet showInView:self.window];
}


- (void)savePhotoToPhone
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在保存...";
    self.hud.removeFromSuperViewOnHide = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         UIImageWriteToSavedPhotosAlbum(_bigImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
}


// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    self.hud.detailsLabelText = msg;
   [self.hud hide:YES afterDelay:1.0];
}



@end
