//
//  PhotoDetailView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/18.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "PhotoDetailView.h"
#import "MCAnimForVideo.h"

@interface PhotoDetailView ()

@property (nonatomic,assign) BOOL isAddHeight;
@property (nonatomic,strong) UILabel *plusLable;
@property (nonatomic,strong) UIImageView *goodsImage;
@property (nonatomic,strong) MCAnimForVideo *loadingView;
//大图片数组
@property (nonatomic,strong) NSArray *bigImgArr;

@end

@implementation PhotoDetailView


- (void)addRewardUsersHeaderImage:(NSArray *)array
{
    
    [self.rewardHeaderMoreButton removeFromSuperview];
    for (int i=0; i<self.shangHeaderArray.count; i++) {
        UIImageView *imgView = self.shangHeaderArray[i];
        [imgView removeFromSuperview];
    }
    [self.shangHeaderArray removeAllObjects];
    
    float x = 0;
    float y = 30;
    float w = 25;
    float h = 25;
    int space = 7;
    NSUInteger count = (kScreenWidth-85-20)/(w+space);
    if (count>array.count) {
        count = array.count;
    }
    
    for (NSUInteger i=0; i<count; i++) {
        x = i*(w+space);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        NSString *urlString = array[i][@"head_pic"];
        NSInteger wid = CGRectGetWidth(imgView.frame) * 2;
        NSInteger hei = CGRectGetHeight(imgView.frame) * 2;
        NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
        NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
        imgView.layer.cornerRadius = 3;
        imgView.clipsToBounds = YES;
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        [self.shangHeaderArray addObject:imgView];
        [self.shangListView addSubview:imgView];
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame = imgView.frame;
        imgBtn.tag = [array[i][@"id"] integerValue];
        [imgBtn addTarget:self action:@selector(doLookPersonnal:) forControlEvents:UIControlEventTouchUpInside];
        [self.shangListView addSubview:imgBtn];
    }
    
    x = count*(w+space);
    
    UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberBtn setBackgroundColor:[UIColor grayColor]];
    [numberBtn setTintColor:[UIColor whiteColor]];
    [numberBtn setTitle:self.modelView.totalRewardUser forState:UIControlStateNormal];
    numberBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    numberBtn.layer.cornerRadius = 3;
    [numberBtn setFrame:CGRectMake(x, y, w, h)];
    if (array.count==0) {
        self.shangListView.hidden = YES;
    }else
    {
        [self.shangListView addSubview:numberBtn];
        self.rewardHeaderMoreButton = numberBtn;
        self.shangListView.hidden = NO;
        
    }
    
    
    
    NSString *moneyTitle = [NSString  stringWithFormat:@"￥%@ ",self.modelView.totalReward];
    
    float moneywidth = [SQCStringUtils getTxtLength:moneyTitle font:13 limit:100];
    
    UILabel *labelMon = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, moneywidth+7, 15)];
    labelMon.font = [UIFont systemFontOfSize:12.0];
    labelMon.text = moneyTitle;
    labelMon.layer.cornerRadius = 2;
    labelMon.clipsToBounds = YES;
    labelMon.textAlignment = NSTextAlignmentCenter;
    labelMon.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    labelMon.textColor = [UIColor whiteColor];
    labelMon.minimumScaleFactor = 0.5;
    
    //原有的送红包显示金额的label
//    [self.shangListView addSubview:labelMon];
    
}

- (void)addUsersHeaderImage:(NSArray *)array
{
    [self.headerMoreButton removeFromSuperview];
    
    for (int i=0; i<self.headerArray.count; i++) {
        UIImageView *imgView = self.headerArray[i];
        [imgView removeFromSuperview];
    }
    [self.headerArray removeAllObjects];
    
    float x = 0;
    float y = 8;
    float w = 25;
    float h = 25;
    int space = 7;
    //按屏幕算count
    NSUInteger count = (kScreenWidth - 20)/(w+space);

    if (count>array.count) {
        count = array.count;
    }
    
    for (NSUInteger i=0; i<array.count; i++) {
//        x = i*(w+space);
        x = i*(w+space) - ((i / count) * count*(w+space));
        y = (i / count)* 30 + 8;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        NSString *urlString = array[i][@"head_pic"];
        NSInteger wid = CGRectGetWidth(imgView.frame) * 2;
        NSInteger hei = CGRectGetHeight(imgView.frame) * 2;
        NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
        NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
        imgView.layer.cornerRadius = 3;
        imgView.clipsToBounds = YES;
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        [self.headerArray addObject:imgView];
        [self.headerListView addSubview:imgView];
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame = imgView.frame;
        imgBtn.tag = [array[i][@"id"] integerValue];
        [imgBtn addTarget:self action:@selector(doLookPersonnal:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerListView addSubview:imgBtn];
    }
    NSUInteger trueCount = (kScreenWidth - 20)/(w+space);
    x = array.count*(w+space) - ((array.count / trueCount) * trueCount*(w+space));
    y = (array.count + 1)/trueCount * 30 + 8;
    if ((array.count + 1) % trueCount == 0) {
        y = (array.count)/trueCount * 30 + 8;
    }
    UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberBtn setBackgroundColor:[UIColor grayColor]];
    [numberBtn setTintColor:[UIColor whiteColor]];
    [numberBtn setTitle:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:array.count]] forState:UIControlStateNormal];
    numberBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    numberBtn.layer.cornerRadius = 3;
    [numberBtn setFrame:CGRectMake(x, y, w, h)];
    if (array.count==0) {
        self.headerListView.hidden = YES;
    }else
    {
        [self.headerListView addSubview:numberBtn];
        self.headerMoreButton = numberBtn;
        self.headerListView.hidden = NO;
    }
    
//    for (NSUInteger i=0; i<array.count; i++) {
//        x = i*(w+space);
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//        NSString *urlString = array[i][@"head_pic"];
//        NSInteger wid = CGRectGetWidth(imgView.frame) * 2;
//        NSInteger hei = CGRectGetHeight(imgView.frame) * 2;
//        NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
//        NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
//        imgView.layer.cornerRadius = 3;
//        imgView.clipsToBounds = YES;
//        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
//        [self.headerArray addObject:imgView];
//        [self.headerListView addSubview:imgView];
//        
//        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        imgBtn.frame = imgView.frame;
//        imgBtn.tag = [array[i][@"id"] integerValue];
//        [imgBtn addTarget:self action:@selector(doLookPersonnal:) forControlEvents:UIControlEventTouchUpInside];
//        [self.headerListView addSubview:imgBtn];
//    }
//    
//    x = count*(w+space);
//    
//    UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [numberBtn setBackgroundColor:[UIColor grayColor]];
//    [numberBtn setTintColor:[UIColor whiteColor]];
//    [numberBtn setTitle:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:array.count]] forState:UIControlStateNormal];
//    numberBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    numberBtn.layer.cornerRadius = 3;
//    [numberBtn setFrame:CGRectMake(x, y, w, h)];
//    if (array.count==0) {
//        self.headerListView.hidden = YES;
//    }else
//    {
//        [self.headerListView addSubview:numberBtn];
//        self.headerMoreButton = numberBtn;
//        self.headerListView.hidden = NO;
//    }

}

#pragma mark - 使用数据重置表头视图上的视图
- (void)reSetDetailViewFrameWithDetailModel:(PersonPageDetailViewModel *)detailModel
{
    //设置头像、昵称和时间
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[detailModel getCutHeaderURLWithView:self.headerImageView]] placeholderImage:[UIImage imageNamed:@""]];
    self.headerImageView.layer.cornerRadius = 17;
    self.headerImageView.clipsToBounds = YES;
    self.userName.text = detailModel.headerName;
    self.userDesc.text = detailModel.timeString;
    
    //浏览量
    self.liulanNumber.text = detailModel.view_number;
    
    //动态文字
    _titleLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
    self.titleLabel.text = detailModel.titleString;
    //NSLog(@"%@",detailModel.themeString);
    if ([detailModel.object_type isEqualToString:@"0"] || [detailModel.object_type isEqualToString:@"(null)"]) {
        self.titleLabel.text = @"";
    }

    
    //是否是视频，获取封面图片
    NSString *str = detailModel.contentImageURL;
    if ([detailModel.object_type isEqualToString:@"11"]) {
        if (!self.playVideoButton) {
            self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        [self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];

        [self.playVideoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
        [self addSubview:self.playVideoButton];
        [self bringSubviewToFront:self.playVideoButton];
        //视图头像封面
        str = detailModel.coverImageUrl;
        str = [NSString stringWithFormat:@"%@%@",str,[CommonUtils imageStringWithWidth:kDeviceWidth*2 postfix:YES]];
        [self.player setShouldAutoplay:NO];
    }else{
        str = [NSString stringWithFormat:@"%@%@",str,[CommonUtils imageStringWithWidth:kDeviceWidth*2 postfix:YES]];
    }
    //设置封面图片
    [self.contentImageView setImageWithURL:[NSURL URLWithString:str] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    self.userID = [NSString stringWithFormat:@"%@",detailModel.userId];
    
    if (self.titleLabel.text.length) {
        self.liulanNumber.top = self.liulanNumber.top + 8;
        self.liulanImage.top = self.liulanImage.top + 8;
    }
    self.timeLabel.text = @"";
    self.modelView = detailModel;
    
    //本人是否点过赞
    if ([detailModel.islike isEqualToString:@"1"]) {
        [self.likeButton setImage:[UIImage imageNamed:@"zannew2"] forState:UIControlStateNormal];
         [self.likeButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    }else
    {
        [self.likeButton setImage:[UIImage imageNamed:@"zangray"] forState:UIControlStateNormal];
         [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    //本人是否喜欢
    if ([detailModel.isfavorite isEqualToString:@"1"]) {
        [self.privateButton setImage:[UIImage imageNamed:@"unCollection"] forState:UIControlStateNormal];
        [self.privateButton setBackgroundImage:[UIImage imageNamed:@"cellButtonRed"] forState:UIControlStateNormal];
        [self.privateButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    }else
    {
        [self.privateButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [self.privateButton setBackgroundImage:[UIImage imageNamed:@"cellButtonGray"] forState:UIControlStateNormal];
        [self.privateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    
    NSString *width = [NSString stringWithFormat:@"%@",detailModel.photoDic[@"width"]];
    NSString *height = [NSString stringWithFormat:@"%@",detailModel.photoDic[@"height"]];
    
    float imgH = (kScreenWidth/[width intValue])*[height intValue];
    CGRect conFrame = self.contentImageView.frame;
    float thisHeight = imgH+55;

    float lineY = 72;
    float bottomH = 160;
    float themeY = 53;
    
    /*
    if (YES) {
        themeY = themeY-25;
        bottomH = bottomH -25;
        lineY = lineY-25;
    }
    
    if (YES) {
        themeY = themeY-25;
        bottomH = bottomH -25;
        lineY = lineY;
    }
    */
    
    //不知道上面的代码是干嘛的，用下面的代码代替
    bottomH = 110;
    lineY = 47;
    themeY= 3;
    
    
    //修改礼物点击bug引入的值
    float tempHight = 0;
    if (detailModel.likeusers.count == 0)
    {
        bottomH = bottomH -40;
        
    }else if(detailModel.likeusers.count > 11)
    {
        NSUInteger count = (kScreenWidth - 20)/32;
        NSInteger likeCount = detailModel.likeusers.count;
        tempHight = likeCount/count*30;
        
    }else{
        
    }
    
    bottomH = bottomH +40;
    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (isAppearShang) {

        
    }else
    {
        bottomH = bottomH - 40;

    }
    
    
    if (detailModel.likeusers.count==0)
    {
        thisHeight = thisHeight+bottomH;
        
    }else
    {
        thisHeight = thisHeight+bottomH;
        
    }
    
    
    
    int newYSpace = -50;
    self.frame = CGRectMake(0, 0, kScreenWidth, thisHeight+3);
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 55);
    self.titleLabel.frame = CGRectMake(15,themeY + 50, kDeviceWidth - 25, 15);
    float title_H = 0;
    
    if (self.titleLabel.text) {
        CGSize titleSize = [CommonUtils sizeFromText:self.titleLabel.text textFont:[UIFont systemFontOfSize:16] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 25, MAXFLOAT)];
        title_H = 15;
        if (titleSize.height > 15) {
            title_H = titleSize.height;
            CGRect titleRect = self.titleLabel.frame;
            titleRect.size.height = title_H;
            self.titleLabel.frame = titleRect;
        }
     }
    self.contentImageView.frame = CGRectMake(conFrame.origin.x, conFrame.origin.y + self.titleLabel.bottom - self.titleLabel.top + 5, kScreenWidth, imgH);
    [self.playVideoButton setFrame:self.contentImageView.frame];
    
    //底部视图
    self.bottomView.frame = CGRectMake(0, conFrame.origin.y+imgH + self.titleLabel.bottom - self.titleLabel.top + 5, kScreenWidth, bottomH+tempHight);
    
    self.tagsLabel.frame = CGRectMake(15, 14, 242, 21);
    self.timeLabel.frame = CGRectMake(kScreenWidth-130, 14, 120, 21);
    self.backLine.frame = CGRectMake(10, lineY, kScreenWidth-20, 3);
    self.likeButton.frame = CGRectMake(kScreenWidth-70, lineY+ 20 +newYSpace, 60, 26);
    self.privateButton.frame = CGRectMake(83, lineY+14, 60, 26);

    self.shangListView.frame = CGRectMake(15, lineY+52+newYSpace+40, kScreenWidth-85, 58);
    
    self.shangButton.frame = CGRectMake(kScreenWidth-80, lineY+52+newYSpace+45+8, 80, 46);
    
    self.headerListView.frame = CGRectMake(15, lineY+52+newYSpace, kScreenWidth-15, 36);
    float w = 25;
    int space = 7;
    
    //赞人数
    if (detailModel.likeusers.count==0) {
        self.isAddHeight = NO;
        self.headerListView.frame = CGRectMake(15, lineY+48, kScreenWidth-15, 0);
        self.shangListView.frame = CGRectMake(15, lineY+52+newYSpace+5, kScreenWidth-85, 58);
        self.shangButton.frame = CGRectMake(kScreenWidth-80, lineY+52+newYSpace+9+4, 80, 46);
        UIImageView *viewSec = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height + title_H , kScreenWidth-20, 3)];
        
        viewSec.image = [UIImage imageNamed:@"backLine"];
        [self addSubview:viewSec];

    }else
    {
        self.isAddHeight = YES;
        NSUInteger count = (kScreenWidth - 20)/(w+space);
        NSUInteger line = detailModel.likeusers.count/count;
        float likeHeight = line * 30 + 36;
        self.headerListView.frame = CGRectMake(15, lineY + 52 + newYSpace, kDeviceWidth - 15, likeHeight);
        
        self.shangListView.frame = CGRectMake(15, lineY + 52 + newYSpace +CGRectGetMaxY(self.headerListView.frame) - 40, kScreenWidth-85, 58);
        
        self.shangButton.frame = CGRectMake(kScreenWidth - 80, lineY + 52 + newYSpace + CGRectGetMaxY(self.headerListView.frame) + 9 + 4 - 46, 80, 46);
        
        [self addUsersHeaderImage:detailModel.likeusers];
        UIImageView *viewSec = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-3 + title_H + CGRectGetMaxY(self.headerListView.frame) - CGRectGetMinY(self.headerListView.frame) - 30, kScreenWidth-20, 3)];
        
        viewSec.image = [UIImage imageNamed:@"backLine"];
        [self addSubview:viewSec];
    }
    
    UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 65, 20)];
    labelNum.font = [UIFont systemFontOfSize:12.0];
    
    labelNum.text = [NSString  stringWithFormat:@"%@人送礼物",detailModel.goodsUserCount];
    labelNum.textColor = [UIColor lightGrayColor];
    labelNum.minimumScaleFactor = 0.5;
    [self.shangListView addSubview:labelNum];
    
    //赏人数
    if (detailModel.goodsUserCount == 0) {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 250, 20)];
        labelNum.font = [UIFont systemFontOfSize:12.0];
        labelNum.text = @"还没有人送礼物哦,成为第一个送礼物的人吧～";
        labelNum.textColor = [UIColor lightGrayColor];
        labelNum.minimumScaleFactor = 0.5;
        [self.shangListView addSubview:labelNum];
    }else
    {   //添加打赏上部 分隔条
        if (detailModel.likeusers.count) {
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(- 5, 1, kScreenWidth-20, 3)];
            view.image = [UIImage imageNamed:@"backLine"];
            [self.shangListView addSubview:view];
        }
        [self addRewardUsersHeaderImage:detailModel.rewardUsers];
    }
    
//    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (isAppearShang) {

        self.shangButton.hidden = NO;
        self.shangListView.hidden = NO;
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if ([self.userID isEqualToString:uid]) {
            self.shangButton.hidden = YES;
        }else
        {
            self.shangButton.hidden = NO;
            
        }
    }else
    {
        self.shangButton.hidden = YES;
        self.shangListView.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewForAnimation:) name:@"photoDetailViewAnimation" object:nil];
    
}

//通知加1动画
-(void)viewForAnimation:(NSNotification *)text{
    
    //动画期间界面禁用
    self.userInteractionEnabled = NO;
    //+1效果
    float lableX = self.shangButton.frame.origin.x+30;
    float lableY = self.bottomView.frame.origin.y+self.shangButton.frame.origin.y;
    _plusLable = [[UILabel alloc]initWithFrame:CGRectMake(lableX, lableY, 40, 25)];

    _plusLable.text = @"+1";
    _plusLable.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    _plusLable.alpha = 0;
    
    [self addSubview:_plusLable];
    
    //1.取到选择礼物显示到view上
    NSString *dataStr = text.userInfo[@"imgData"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:dataStr];
    UIImage *image = [[UIImage alloc]initWithData:data];
    _goodsImage = [[UIImageView alloc]initWithImage:image];
    [_goodsImage sizeToFit];
    _goodsImage.center = CGPointMake(kDeviceWidth*0.5, kDeviceHeight*0.5*1.2);
    
    [self addSubview:_goodsImage];
    
    //购物车动画
    self.goodsImage.hidden = NO;
    
    //2.抛物线动画
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CAKeyframeAnimation *goodsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPoint startP = CGPointMake(kDeviceWidth*0.5, kDeviceHeight*0.5*1.2);
    CGPoint endP = self.plusLable.center;
    
    CGPathMoveToPoint(thePath, NULL, startP.x, startP.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 30, 200, endP.x-10, endP.y+10);
    
    goodsAnimation.path = thePath;
    
    //图片缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.1];
    scaleAnimation.autoreverses = NO;
    
    group.animations = @[scaleAnimation,goodsAnimation];
    group.duration = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_goodsImage.layer addAnimation:group forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            
            //礼物加1动画效果
            self.plusLable.alpha = 1;
            [UIView animateWithDuration:1 animations:^{
                _plusLable.alpha = 0;
                _goodsImage.alpha = 0;
                _plusLable.center = CGPointMake(self.plusLable.center.x, self.plusLable.center.y - 25);
                
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.userInteractionEnabled = YES;
                [_goodsImage removeFromSuperview];
                [_plusLable removeFromSuperview];
                
                //动画执行完发通知刷新detailController数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDetailContrller" object:nil];
                
                
            });
        });
        
    });
    
}

- (VideoMaskView *)player_maskview
{
    if (!_player_maskview) {
        _player_maskview = [[VideoMaskView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_player_maskview initViews];
    }
    return _player_maskview;
}


+ (PhotoDetailView *)getPhotoDetailView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PhotoDetailView" owner:self options:nil];
    PhotoDetailView *view = array[0];
    view.headerArray = @[].mutableCopy;
    view.shangHeaderArray = @[].mutableCopy;
    return view;
    
}

- (void)doLookPersonnal:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(doLikeUsersToPersonCenter:)]){
        [self.delegate doLikeUsersToPersonCenter:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:btn.tag]]];
    }
}

#ifdef TencentRelease
#pragma mark play
- (MPMoviePlayerController *)player
{
    if (!_player) {
        _player = [[MPMoviePlayerController alloc] init];
    }
    return _player;
}

- (void)playVideoMethod:(UIButton *)sender
{
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.playVideoButton.hidden = YES;

    NSString *videoURL = getSafeString(self.modelView.tagString);
    
    NSLog(@"%@",videoURL);
    self.player.contentURL = [NSURL URLWithString:videoURL];
    self.player.view.frame = self.contentImageView.frame;
    self.player.view.backgroundColor = [UIColor blueColor];
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.repeatMode = MPMovieRepeatModeNone;

    //加载动画
    [self.loadingView removeFromSuperview];
    self.loadingView = [[MCAnimForVideo alloc]init];
    self.loadingView.frame = CGRectMake(CGRectGetWidth(self.player.view.frame)*0.40,CGRectGetHeight(self.player.view.frame)*0.42, 45, 45);
    self.loadingView.center = self.player.view.center;
    self.loadingView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.loadingView];
    
    
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStates) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatesExist) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatesDone) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayOrDisplay) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
   
    
    
    
    
}

- (void)didChangeStates
{
    NSLog(@"did change ");
    
    switch (self.player.loadState) {
        case MPMovieLoadStatePlayable:
//            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            [self.loadingView removeFromSuperview];
            [self addSubview:self.player.view];

            break;
            
        default:
            break;
    }
    
    switch (self.player.playbackState) {
        case MPMoviePlaybackStateStopped:
            NSLog(@"MPMoviePlaybackStateStopped");
            
            break;
        case MPMoviePlaybackStatePlaying:
            NSLog(@"MPMoviePlaybackStatePlaying");
            [self.loadingView removeFromSuperview];
            [self addSubview:self.player.view];
            break;

        case MPMoviePlaybackStatePaused:
            NSLog(@"MPMoviePlaybackStatePaused");
            
            break;
            
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"MPMoviePlaybackStateInterrupted");
            
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"MPMoviePlaybackStateSeekingForward");
            
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"MPMoviePlaybackStateSeekingBackward");
            
            break;
        default:
            break;
    }
}

- (void)didChangeStatesExist
{
//    NSLog(@"didChangeStatesExist ");
    
}

- (void)didPlayOrDisplay{
//    NSLog(@"didPlayOrDisplay");
}

- (void)didChangeStatesDone
{
//    NSLog(@"didChangeStatesDone ");
    [self removePlayer];
    
}

- (void)removePlayer
{
    [self.player stop];
    self.playVideoButton.hidden = NO;
    [self.loadingView removeFromSuperview];
    [self.player.view removeFromSuperview];
//    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#else



#endif

@end
