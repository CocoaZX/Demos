//
//  recommendCell.m
//  Mocha
//
//  Created by TanJian on 16/5/20.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "recommendCell.h"
#import "McMyFeedListViewController.h"
#import "StartYuePaiViewController.h"
#import "NewLoginViewController.h"
#import "DaShangGoodsView.h"

@interface recommendCell ()

@property (nonatomic,strong)NSArray *goodsImgArr;
@property (nonatomic,strong)NSArray *goodsLabelArr;
@property (nonatomic,strong)NSDictionary *dataDict;

@property (nonatomic,strong)DaShangGoodsView *dashang;
@property (nonatomic,strong)UIImageView *goodsImage;
@property (nonatomic,assign)CGPoint currentPoint;


@end

@implementation recommendCell


#pragma mark 本xib的礼物图片和数量lable直接设置的为hidden

-(instancetype)init{
    return [[NSBundle mainBundle]loadNibNamed:@"recommendCell" owner:self options:nil].lastObject;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _personGoodLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    _bottomView.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    _seprateLine.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    
    

}

+(float)getHeight{
    float topH = 26;
    float imgH = kDeviceWidth*3/8;
    float goodsLabelH = 22;
    float goodsImgH = kDeviceWidth/8-14;
    float goodsCountH = 16;
    float bottomViewH = 40+8;
    
    return topH+imgH+goodsImgH+goodsLabelH+goodsCountH+bottomViewH;
}

-(void)setupUIWithDict:(NSDictionary *)dict{
    
    self.dataDict = dict;
    
    [UIColor colorForHex:kLikeRedColor];
    for (UIImageView *imgView in self.goodsImgArr) {
        imgView.hidden = YES;
    }
    
    for (UILabel *countLabel in self.goodsLabelArr) {
        countLabel.hidden = YES;
    }
    
    float imgW = kDeviceWidth*7/36;
    float imgH = kDeviceWidth/4;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",getSafeString(dict[@"photoInfo"][@"url"]),[CommonUtils imageStringWithWidth:imgW * 2 height:imgH * 2]];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    
    _descriptionLabel.text = dict[@"hot_desc"];
    
    NSArray *goodsArr = dict[@"goods"];
    float width = (kDeviceWidth-180)/8;
    NSString *jpg = [CommonUtils PngImageStringWithWidth:width*2  height:width*2 ];
    if (goodsArr) {
        for (int i = 0; i<goodsArr.count; i++) {
            UIImageView *goodsImg = _goodsImgArr[i];
            goodsImg.hidden = NO;
            NSString *url = [NSString stringWithFormat:@"%@%@",goodsArr[i][@"vgoods_img"],jpg];
            [goodsImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head60"]];
            
            UILabel  *goodsLabel = _goodsLabelArr[i];
            goodsLabel.hidden = NO;
            NSString *countStr = [NSString stringWithFormat:@"x%@",getSafeString(goodsArr[i][@"total"])];

            goodsLabel.text = countStr;
            
        }
    }
    
    
    //模特或者摄影师改变底部条的颜色
    NSString *type = getSafeString(dict[@"type"]);
    if ([type isEqualToString:@"1"]) {
        //模特
        _bottomView.backgroundColor = [UIColor colorForHex:kLikeRedColor];
        
    }else{
        //摄影师和其他
        _bottomView.backgroundColor = [UIColor colorForHex:kLikeGreenLightColor];
    }
  
    
}


//添加通知
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vGoodsAnimation:) name:@"mainFieryGoodsAnimation" object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//打赏礼物
-(void)addDashangView{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    //未登录直接跳转登陆
    if (!uid) {
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        
        NewLoginViewController *loginVC = [[NewLoginViewController alloc]initWithNibName:[NSString stringWithFormat:@"NewLoginViewController"] bundle:nil];
        [self.superVC.superNVC pushViewController:loginVC animated:YES];
        
        return;
    }
    
    NSString *targetUid = getSafeString(_dataDict[@"uid"]);

    self.dashang= [[DaShangGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dashang.superNVC = self.superVC.superNVC;
    self.dashang.currentPhotoId = getSafeString(_dataDict[@"photoInfo"][@"photoid"]);
    self.dashang.animationType = @"dashangWithNoAnimation";
    self.dashang.dashangType = @"6";
    self.dashang.targetUid = targetUid;
    
    
    [self.dashang setUpviews];
    [self.dashang addToWindow];
    
}


//通知调用动画
-(void)vGoodsAnimation:(NSNotification *)text{
    //动画期间礼物按钮不能点击
    self.userInteractionEnabled = NO;
    [_goodsImage removeFromSuperview];
    
    //购物车动画
    //1.取到选择礼物显示到view上
    NSString *dataStr = text.userInfo[@"imgData"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:dataStr];
    UIImage *image = [[UIImage alloc]initWithData:data];
    
    _goodsImage.image = image;
    self.goodsImage.hidden = NO;
    [_goodsImage sizeToFit];
    _goodsImage.center = self.contentView.center;
    
    [self addSubview:_goodsImage];
    
    //2.抛物线动画
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CAKeyframeAnimation *goodsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPoint startP = self.contentView.center;
    CGPoint endP = _imgView.center;
    
    CGPathMoveToPoint(thePath, NULL, startP.x, startP.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 200, 200, endP.x, endP.y);
    
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

            [UIView animateWithDuration:0.8 animations:^{

                _goodsImage.alpha = 0;
                
            }];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.userInteractionEnabled = YES;
                [_goodsImage removeFromSuperview];
                
                [self removeNotification];
            });
        });
        
    });
    
}


- (IBAction)shangMethod:(UIButton *)sender {
    NSLog(@"打赏");
    
    _goodsImage = [[UIImageView alloc]init];
    
    [self addNotification];
    [self addDashangView];
    
}

- (IBAction)yueMethod:(UIButton *)sender {
    
    NSLog(@"约拍");
    //跳转约拍
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    //未登录直接跳转登陆
    if (!uid) {
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        
        NewLoginViewController *loginVC = [[NewLoginViewController alloc]initWithNibName:[NSString stringWithFormat:@"NewLoginViewController"] bundle:nil];
        [self.superVC.superNVC pushViewController:loginVC animated:YES];
        
        return;
    }

    BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
    if (isBangDing) {
        StartYuePaiViewController *yuepai = [[StartYuePaiViewController alloc] initWithNibName:@"StartYuePaiViewController" bundle:[NSBundle mainBundle]];
        yuepai.receiveUid = getSafeString(_dataDict[@"uid"]);
        yuepai.receiveName = getSafeString(_dataDict[@"nickname"]);
        yuepai.receiveHeader = getSafeString(_dataDict[@"head_pic"]);
        [self.superVC.superNVC pushViewController:yuepai animated:YES];
        
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
        
    }

    
}




-(NSArray *)goodsImgArr{
    if (!_goodsImgArr) {
        _goodsImgArr = @[_oneGoodsImg,_twoGoodsImg,_threeGoodsImg,_fourGoodsImg,_fiveGoodsImg,_sixGoodsImg,_sevenGoodsImg,_eightGoodsImg];
    }
    return _goodsImgArr;
}

-(NSArray *)goodsLabelArr{
    if (!_goodsLabelArr) {
        _goodsLabelArr = @[_oneGoodsLabel,_twoGoodsLabel,_threeGoodsLabel,_fourGoodsLabel,_fiveGoodsLabel,_sixGoodsLabel,_sevenGoodsLabel,_eightGoodsLabel];
    }
    return _goodsLabelArr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



@end
