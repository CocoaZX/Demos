//
//  NewMokaCardTableViewCell.m
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewMokaCardTableViewCell.h"
#import "MyMokaCardViewController.h"
#import "BuildMokaCardViewController.h"
#import "AlbumListViewController.h"
#import "AlbumDetailViewController.h"
#import "PhotoBrowseViewController.h"
#import "BuildAlbumViewController.h"

#import "MyMokaTableViewCell.h"
#import "BuildDetailViewController.h"

@interface NewMokaCardTableViewCell ()
{
    NSString *informationStr;
    NSString *_isModel;
    NSString *sanWeiStr;
    NSString *nameStr;
    NSString *mokaStr;
}
@property (nonatomic , strong)NSMutableArray* sequnceArr;

@property (weak, nonatomic) IBOutlet UILabel *defaultView;

@property (nonatomic , assign)BOOL hiddenButton;
@end

@implementation NewMokaCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//当前索引
-(void)setIndexpath:(NSIndexPath *)indexpath{
    if (_indexpath != indexpath) {
        _indexpath  = indexpath;
        [self setNeedsLayout];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



#pragma mark - 视图布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    //顶部分割线
    if (!_topFengeXianLabel) {
        _topFengeXianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
        _topFengeXianLabel.hidden = NO;
        _topFengeXianLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
        [self addSubview:_topFengeXianLabel];
    }
  
        _topFengeXianLabel.hidden = NO;

    

    self.titleView.frame = CGRectMake(kScreenWidth/2-50, 13, 100, 21);
    self.titleBottomView.frame = CGRectMake(kScreenWidth/2-30, 35, 60, 2);
    self.numberBack.frame = CGRectMake(kScreenWidth-50, 13, 25, 25);
    //    self.rightArrow.frame = CGRectMake(kScreenWidth-20, 15, 18, 18);
    self.nocardLabel.frame = CGRectMake(kScreenWidth/2-75, 130, 150, 21);
    self.numberBack.clipsToBounds = YES;
    self.numberBack.layer.cornerRadius = 12.5;
    self.numberBack.backgroundColor = [UIColor colorWithRed:244/256.0 green:84/256.0 blue:96/256.0 alpha:1.0];
    self.clickButton.frame = CGRectMake(20, self.cardDetailView.top + 30, 35, 20);
    NSString *currentUid = [NSString stringWithFormat:@"%@",self.dataDiction[@"uid"]];
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([currentUid isEqualToString:uid]) {
    
    }else
    {
        //self.nocardLabel.text = @"";
        self.rightArrow.hidden = YES;
        self.numberBack.hidden = YES;
        self.clickButton.enabled = NO;
        
        NSString *number = [NSString stringWithFormat:@"%@",self.dataDiction[@"albumcount"]];
        if (![number isEqualToString:@"0"]) {
            self.numberBack.hidden = NO;
            self.rightArrow.hidden = NO;
            self.clickButton.enabled = YES;
        }
    }
    
    NSString *isNeedToAppear = self.dataDiction[@"isNeedToAppear"];
    int y = 0;
    
    //    if (self.hiddenTitleView) {
    //        y = -40;
    //        self.clickButton.hidden = YES;
    //        self.numberBack.hidden = YES;
    //        self.rightArrow.hidden = YES;
    //        self.titleView.hidden = YES;
    //        self.titleBottomView.hidden = YES;
    //
    //    }else {
    //        self.clickButton.hidden = NO;
    //        self.numberBack.hidden = NO;
    //        self.rightArrow.hidden = NO;
    //        self.titleView.hidden = NO;
    //        self.titleBottomView.hidden = NO;
    //
    //    }
    if ([isNeedToAppear isEqualToString:@"1"]) {
        self.cardView.frame = CGRectMake(0, 50+y, kScreenWidth-0, self.cardDetailView.frame.size.height);
    }else
    {
        self.cardView.frame = CGRectMake(10, 50+y, kScreenWidth-20, 310);
        [self bringSubviewToFront:self.buildButton];
        
        self.cardView.backgroundColor = [UIColor clearColor];
    }
    

    if (_hiddenFootView) {
        self.logoImageView.hidden = YES;
        self.informationLabel.hidden = YES;
        self.SharedButton.hidden = YES;
        self.DownloadButton.hidden = YES;
        self.clickButton.hidden = YES;
    }else{
        //设置informationlable和logoImgView
        CGSize informationSize;
        if (kDeviceWidth <400) {
            self.informationLabel.font = [UIFont systemFontOfSize:13];
            informationSize = [informationStr sizeWithFont:[UIFont systemFontOfSize:13]];
         }else{
            self.informationLabel.font = [UIFont systemFontOfSize:14];
            informationSize = [informationStr sizeWithFont:[UIFont systemFontOfSize:14]];
         }
        if (informationSize.width + 75 > kDeviceWidth) {
            self.informationLabel.font = [UIFont systemFontOfSize:10];
            informationSize = [informationStr sizeWithFont:[UIFont systemFontOfSize:10]];
             self.informationLabel.numberOfLines = 0;
        }
        //下载和分享的按钮位置设置
        self.DownloadButton.frame = CGRectMake(kDeviceWidth - kDeviceWidth/4-20,self.cardDetailView.top + 20 , 45, 35);
        [self.DownloadButton setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
        self.SharedButton.frame = CGRectMake(kDeviceWidth - kDeviceWidth/8-10, self.cardDetailView.top + 20 , 45, 35);
        [self.SharedButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];

        
        //模卡号和信息位置
        _informationLabel.frame = CGRectMake(10, _cardView.bottom, informationSize.width, informationSize.height);
        [self.logoImageView setFrame:CGRectMake(kDeviceWidth - self.informationLabel.frame.size.height *114/30 - kDeviceWidth/32 , _cardView.bottom, self.informationLabel.frame.size.height *114/30, self.informationLabel.frame.size.height)];
        
    }
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        if (!_hiddenButton) {
            self.SharedButton.hidden = NO;
            self.DownloadButton.hidden = NO;
            self.informationLabel.hidden = NO;
            self.logoImageView.hidden = NO;
        }else{
            self.logoImageView.hidden = YES;
            self.informationLabel.hidden = YES;
            self.SharedButton.hidden = YES;
            self.DownloadButton.hidden = YES;
        }
    }else
    {
        self.SharedButton.hidden = YES;
        self.DownloadButton.hidden = YES;

    }
    self.introduceLab.hidden = YES;
}




- (void)initViewWithData:(NSDictionary *)diction
{
    if (_indexpath.section == 0 && _indexpath.row == 0) {
        _topFengeXianLabel.hidden = YES;
    }else{
        _topFengeXianLabel.hidden = NO;
    }
    
    BOOL isMaster ;
    isMaster = [diction[@"isMaster"] boolValue];
    self.dataDiction = diction;
    NSString *isNeedToAppear = diction[@"isNeedToAppear"];
    _isModel = diction[@"isModel"];
    //注意无影集的字典没有多给数据
    if ([isNeedToAppear isEqualToString:@"1"]) {
        self.numberBack.text = diction[@"albumcount"];
        NSLog(@"%@",self.numberBack.text);
        if ([_isModel isEqualToString:@"1"] && isMaster) {
            self.mokaListDic = [NSDictionary dictionaryWithDictionary:diction[@"mokaListDic"]];
        }
    }
    //模特
    if (!_hiddenFootView) {
        nameStr = self.supCon.navigationItem.title;
        informationStr = [NSString stringWithFormat:@"%@  %@cm  %@kg  %@",nameStr,diction[@"height"],diction[@"weight"],diction[@"sanwei"]];
        sanWeiStr = [NSString stringWithFormat:@"身高:%@cm  体重:%@kg  三围:%@",diction[@"height"],diction[@"weight"],diction[@"sanwei"]];
        self.informationLabel.text = informationStr;
        mokaStr = [NSString stringWithFormat:@"MOKA号: %@",diction[@"mokaNumber"]];
//        self.MOKANumLab.text = [NSString stringWithFormat:@"%@ MOKA号:%@",nameStr,diction[@"mokaNumber"]];
    }
    
    
    if ([isNeedToAppear isEqualToString:@"1"]) {
        self.cardView.backgroundColor = [UIColor whiteColor];
        if ([_isModel isEqualToString:@"1"]) {
            //模特
            NSString *cardType = diction[@"cardType"];
            self.titleView.text = NSLocalizedString(@"Mocard", nil);
            [self.titleView removeFromSuperview];
            [self.titleBottomView removeFromSuperview];
            [self.numberBack removeFromSuperview];
            [self.DetilButton removeFromSuperview];
            self.rightArrow.frame = CGRectMake(55,self.cardDetailView.top + 30, 18, 18);
            //获取模卡
            if (self.cardDetailView) {
                [self.cardDetailView removeFromSuperview];
            }
            [self.imgViewArray removeAllObjects];
            [self.buttonArray removeAllObjects];
            
            UIView *mokaView = [MokaCardManager getMokaCardWithType:cardType images:self.imgViewArray buttons:self.buttonArray];
            if (mokaView == nil) {
                _defaultView.hidden = NO;
                _hiddenButton = YES;
            }else{
                _defaultView.hidden = YES;
                _hiddenButton = NO;
            }
            self.cardDetailView = mokaView;
            [self.cardView addSubview:mokaView];
            
            [self resetButtonTarget];
            
            [self resetImgViewURL];
            
        }else
        {
            //目前模特和摄影师都界面调为一样的了
            //所以下面的方法不会调用了
            //摄影师等
            self.DownloadButton.hidden = YES;
            self.SharedButton.hidden = YES;
            self.frame = CGRectMake(0, 0, kDeviceWidth, self.frame.size.height - 40);
            [self.logoImageView removeFromSuperview];
            [self.informationLabel removeFromSuperview];
            self.rightArrow.frame = CGRectMake(kScreenWidth-20, 15, 18, 18);
            self.titleView.text = @"摄影集";
            [self.SharedButton removeFromSuperview];
            [self.DownloadButton removeFromSuperview];
            [self addSubview:self.rightArrow];
            self.albumArray = [NSMutableArray array];
            for (id obj in diction[@"albums"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    if (![obj[@"albumType"] isEqualToString:@"3"]) {
                        [self.albumArray addObject:obj];
                    }
                }
            }
            
            if (self.cardDetailView) {
                [self.cardDetailView removeFromSuperview];
            }
            if (self.albumArray.count==1) {
                [self addSheYingViewOne];
                
            }else if (self.albumArray.count==2) {
                [self addSheYingViewTwo];
                
            }else if (self.albumArray.count==3) {
                [self addSheYingView];
                
            }
        }
        
        
    }else//无影集
    {
        //        self.cardView.backgroundColor = [UIColor lightGrayColor];
        self.cardView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.cardView.layer.borderWidth = 0.5;
        NSString *uid = [NSString stringWithFormat:@"%@",[[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]];
        NSString *thisUid = diction[@"uid"];
        self.hiddenFootView = YES;
        [self.rightArrow removeFromSuperview];
        [self.clickButton removeFromSuperview];
        [self.numberBack removeFromSuperview];
        [self.SharedButton removeFromSuperview];
        [self.DownloadButton removeFromSuperview];
        [self.logoImageView removeFromSuperview];
        [self.informationLabel removeFromSuperview];
        self.nocardLabel.hidden = NO;
        if ([_isModel isEqualToString:@"1"]) {
            [self.titleView removeFromSuperview];
            [self.titleBottomView removeFromSuperview];
            if ([uid isEqualToString:thisUid]) {
                //[self.buildButton setUserInteractionEnabled:YES];
                self.nocardLabel.text = @"+创建模卡";
                //self.titleView.text = @"模卡";
            }
            
            //进入对方的个人主页，没有任何作品，给出的提示
            if (![uid isEqualToString:thisUid]) {
                //self.nocardLabel.text = @"还没上传模卡哟~";
                self.nocardLabel.text = @"还没上传作品哟~";
                //                [self.buildButton setUserInteractionEnabled:NO];
            }
        }else
        {
            if ([uid isEqualToString:thisUid]) {
                //                [self.buildButton setUserInteractionEnabled:YES];
                self.nocardLabel.text = @"+创建摄影集";
                self.titleView.text = @"摄影集";
            }
            if (![uid isEqualToString:thisUid]) {
                self.nocardLabel.text = @"还没上传作品哟~";
                self.titleView.text = @"摄影集";
                //                [self.buildButton setUserInteractionEnabled:NO];
            }
        }
    }
}

//-(void)addMeasurView{
//    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo-icon"]];
//    logoView.frame = CGRectMake(kDeviceWidth - 100, 10, 100 ,50);
//    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.highFloat - 50, kDeviceWidth, 50)];
//    self.nameLabel = [[UILabel alloc]init];
//    self.highLabel = [[UILabel alloc]init];
//    self.weightLabel = [[UILabel alloc]init];
//    self.MeasurLabel = [[UILabel alloc]init];
//    self.nameLabel.frame = CGRectMake(8, 10, 20, 30);
//    self.nameLabel.text = @"name";
//    self.highLabel.text = @"170cm";
//    self.weightLabel.text = @"50kg";
//    self.MeasurLabel.text = @"98/69/90";
//    self.highLabel.frame = CGRectMake(30, 10, 25, 25);
//    self.weightLabel.frame = CGRectMake(80, 15, 40, 35);
//    self.MeasurLabel.frame = CGRectMake(150, 20, 80, 35);
//    [self.footView addSubview:logoView];
//    [self.footView addSubview:self.nameLabel];
//    [self.footView addSubview:self.highLabel];
//    [self.footView addSubview:self.weightLabel];
//    [self.footView addSubview:self.MeasurLabel];
//
//    [self addSubview:self.footView];
//}

- (void)addSheYingViewOne
{
    float CellHeight = 310;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CellHeight)];
    self.cardDetailView = backView;
    NSString *leftUrl = @"";
    NSString *title = @"";
    
    if (self.albumArray.count>0) {
        NSDictionary *dic = self.albumArray[0];
        title = [NSString stringWithFormat:@"%@",dic[@"title"]];
        NSString *cover = [NSString stringWithFormat:@"%@",dic[@"cover"]];
        if ([cover isEqualToString:@"0"]) {
            
        }else
        {
            NSArray *photos = dic[@"photos"];
            for (int i=0; i<photos.count; i++) {
                NSDictionary *diction = photos[i];
                NSString *photoid = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
                if ([cover isEqualToString:photoid]) {
                    leftUrl = [NSString stringWithFormat:@"%@",diction[@"url"]];
                }
            }
        }
    }
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CellHeight)];
    leftImgView.backgroundColor = [UIColor lightGrayColor];
    leftImgView.clipsToBounds = YES;
    leftImgView.contentMode = UIViewContentModeScaleAspectFill;
    leftUrl = [NSString stringWithFormat:@"%@%@",leftUrl,[CommonUtils imageStringWithWidth:kDeviceWidth height:leftImgView.height]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:leftUrl];
    if (image) {
        leftImgView.image = image;
    }else{
    [leftImgView sd_setImageWithURL:[NSURL URLWithString:leftUrl]];
    }
    self.leftImgV = leftImgView;
    [backView addSubview:leftImgView];
    if (leftUrl.length>0) {
        
    }else
    {
        UIImageView *leftImgView_temp = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, 53, 38)];
        leftImgView_temp.backgroundColor = [UIColor clearColor];
        leftImgView_temp.center = leftImgView.center;
        leftImgView_temp.image = [UIImage imageNamed:@"nopic-ablum"];
        leftImgView_temp.clipsToBounds = YES;
        if (title.length>0) {
            
        }else
        {
            [backView addSubview:leftImgView_temp];
            
        }
    }
    
    
    float width = [SQCStringUtils getTxtLength:title font:15 limit:kScreenWidth];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width+10, 30)];
    leftLabel.text = title;
    if (title.length==0) {
        leftLabel.hidden = YES;
    }
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    leftLabel.layer.borderWidth = 1;
    leftLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.center = CGPointMake(kScreenWidth/2, CellHeight/2);
    [backView addSubview:leftLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:leftImgView.frame];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leftButton];
    
    [self.cardView addSubview:backView];
    
}

- (void)addSheYingViewTwo
{
    float CellHeight = 310;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CellHeight)];
    self.cardDetailView = backView;
    NSString *leftUrl = @"";
    NSString *title = @"";
    
    if (self.albumArray.count>0) {
        NSDictionary *dic = self.albumArray[0];
        title = [NSString stringWithFormat:@"%@",dic[@"title"]];
        NSString *cover = [NSString stringWithFormat:@"%@",dic[@"cover"]];
        if ([cover isEqualToString:@"0"]) {
            
        }else
        {
            NSArray *photos = dic[@"photos"];
            for (int i=0; i<photos.count; i++) {
                NSDictionary *diction = photos[i];
                NSString *photoid = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
                if ([cover isEqualToString:photoid]) {
                    leftUrl = [NSString stringWithFormat:@"%@",diction[@"url"]];
                }
            }
        }
    }
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, CellHeight)];
    leftImgView.backgroundColor = [UIColor lightGrayColor];
    leftImgView.clipsToBounds = YES;
    leftImgView.contentMode = UIViewContentModeScaleAspectFill;
    [leftImgView sd_setImageWithURL:[NSURL URLWithString:leftUrl]];
    self.leftImgV = leftImgView;
    [backView addSubview:leftImgView];
    if (leftUrl.length>0) {
        
    }else
    {
        UIImageView *leftImgView_temp = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, 53, 38)];
        leftImgView_temp.backgroundColor = [UIColor clearColor];
        leftImgView_temp.center = leftImgView.center;
        leftImgView_temp.image = [UIImage imageNamed:@"nopic-ablum"];
        leftImgView_temp.clipsToBounds = YES;
        [backView addSubview:leftImgView_temp];
    }
    
    
    float width = [SQCStringUtils getTxtLength:title font:15 limit:kScreenWidth/2];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width+10, 30)];
    leftLabel.text = title;
    if (title.length==0) {
        leftLabel.hidden = YES;
    }
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    leftLabel.layer.borderWidth = 1;
    leftLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.center = CGPointMake(kScreenWidth/4, CellHeight/2);
    [backView addSubview:leftLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:leftImgView.frame];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leftButton];
    
    NSString *rightOneUrl = @"";
    NSString *title2 = @"";
    
    if (self.albumArray.count>1) {
        NSDictionary *dic = self.albumArray[1];
        title2 = [NSString stringWithFormat:@"%@",dic[@"title"]];
        NSString *cover = [NSString stringWithFormat:@"%@",dic[@"cover"]];
        if ([cover isEqualToString:@"0"]) {
            
        }else
        {
            NSArray *photos = dic[@"photos"];
            for (int i=0; i<photos.count; i++) {
                NSDictionary *diction = photos[i];
                NSString *photoid = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
                if ([cover isEqualToString:photoid]) {
                    rightOneUrl = [NSString stringWithFormat:@"%@",diction[@"url"]];
                }
            }
        }
    }
    
    UIImageView *rightOne = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, CellHeight)];
    rightOne.backgroundColor = [UIColor lightGrayColor];
    rightOne.contentMode = UIViewContentModeScaleAspectFill;
    rightOne.clipsToBounds = YES;
    [rightOne sd_setImageWithURL:[NSURL URLWithString:rightOneUrl]];
    self.rightOneImgV = rightOne;
    [backView addSubview:rightOne];
    
    if (rightOneUrl.length>0) {
        
    }else
    {
        UIImageView *rightOne_temp = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, 53, 38)];
        rightOne_temp.backgroundColor = [UIColor clearColor];
        rightOne_temp.center = rightOne.center;
        rightOne_temp.image = [UIImage imageNamed:@"nopic-ablum"];
        rightOne_temp.clipsToBounds = YES;
        [backView addSubview:rightOne_temp];
    }
    
    
    float width2 = [SQCStringUtils getTxtLength:title2 font:15 limit:kScreenWidth/2];
    UILabel *rightOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width2+10, 30)];
    rightOneLabel.text = title2;
    if (title2.length==0) {
        rightOneLabel.hidden = YES;
    }
    rightOneLabel.textColor = [UIColor whiteColor];
    rightOneLabel.font = [UIFont systemFontOfSize:15];
    rightOneLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    rightOneLabel.layer.borderWidth = 1;
    rightOneLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    rightOneLabel.textAlignment = NSTextAlignmentCenter;
    rightOneLabel.center = CGPointMake(kScreenWidth/4*3, CellHeight/2);
    [backView addSubview:rightOneLabel];
    
    UIButton *rightOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightOneButton setFrame:rightOne.frame];
    [rightOneButton addTarget:self action:@selector(rightOneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:rightOneButton];
    
    [self.cardView addSubview:backView];
    
}

- (void)addSheYingView
{
    float CellHeight = 310;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CellHeight)];
    self.cardDetailView = backView;
    NSString *leftUrl = @"";
    NSString *title = @"";
    
    if (self.albumArray.count>0) {
        NSDictionary *dic = self.albumArray[0];
        title = [NSString stringWithFormat:@"%@",dic[@"title"]];
        NSString *cover = [NSString stringWithFormat:@"%@",dic[@"cover"]];
        if ([cover isEqualToString:@"0"]) {
            
        }else
        {
            NSArray *photos = dic[@"photos"];
            for (int i=0; i<photos.count; i++) {
                NSDictionary *diction = photos[i];
                NSString *photoid = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
                if ([cover isEqualToString:photoid]) {
                    leftUrl = [NSString stringWithFormat:@"%@",diction[@"url"]];
                }
            }
        }
    }
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, CellHeight)];
    leftImgView.backgroundColor = [UIColor lightGrayColor];
    leftImgView.clipsToBounds = YES;
    leftImgView.contentMode = UIViewContentModeScaleAspectFill;
    [leftImgView sd_setImageWithURL:[NSURL URLWithString:leftUrl]];
    self.leftImgV = leftImgView;
    [backView addSubview:leftImgView];
    if (leftUrl.length>0) {
        
    }else
    {
        UIImageView *leftImgView_temp = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, 53, 38)];
        leftImgView_temp.backgroundColor = [UIColor clearColor];
        leftImgView_temp.center = leftImgView.center;
        leftImgView_temp.image = [UIImage imageNamed:@"nopic-ablum"];
        leftImgView_temp.clipsToBounds = YES;
        [backView addSubview:leftImgView_temp];
    }
    
    
    float width = [SQCStringUtils getTxtLength:title font:15 limit:kScreenWidth/2];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width+10, 30)];
    leftLabel.text = title;
    if (title.length==0) {
        leftLabel.hidden = YES;
    }
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    leftLabel.layer.borderWidth = 1;
    leftLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.center = CGPointMake(kScreenWidth/4, CellHeight/2);
    [backView addSubview:leftLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:leftImgView.frame];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leftButton];
    
    NSString *rightOneUrl = @"";
    NSString *title2 = @"";
    
    if (self.albumArray.count>1) {
        NSDictionary *dic = self.albumArray[1];
        title2 = [NSString stringWithFormat:@"%@",dic[@"title"]];
        NSString *cover = [NSString stringWithFormat:@"%@",dic[@"cover"]];
        if ([cover isEqualToString:@"0"]) {
            
        }else
        {
            NSArray *photos = dic[@"photos"];
            for (int i=0; i<photos.count; i++) {
                NSDictionary *diction = photos[i];
                NSString *photoid = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
                if ([cover isEqualToString:photoid]) {
                    rightOneUrl = [NSString stringWithFormat:@"%@",diction[@"url"]];
                }
            }
        }
    }
    
    UIImageView *rightOne = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, CellHeight/2)];
    rightOne.backgroundColor = [UIColor lightGrayColor];
    rightOne.contentMode = UIViewContentModeScaleAspectFill;
    rightOne.clipsToBounds = YES;
    [rightOne sd_setImageWithURL:[NSURL URLWithString:rightOneUrl]];
    self.rightOneImgV = rightOne;
    [backView addSubview:rightOne];
    
    if (rightOneUrl.length>0) {
        
    }else
    {
        UIImageView *rightOne_temp = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, 53, 38)];
        rightOne_temp.backgroundColor = [UIColor clearColor];
        rightOne_temp.center = rightOne.center;
        rightOne_temp.image = [UIImage imageNamed:@"nopic-ablum"];
        rightOne_temp.clipsToBounds = YES;
        [backView addSubview:rightOne_temp];
    }
    
    
    float width2 = [SQCStringUtils getTxtLength:title2 font:15 limit:kScreenWidth/2];
    UILabel *rightOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width2+10, 30)];
    rightOneLabel.text = title2;
    if (title2.length==0) {
        rightOneLabel.hidden = YES;
    }
    rightOneLabel.textColor = [UIColor whiteColor];
    rightOneLabel.font = [UIFont systemFontOfSize:15];
    rightOneLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    rightOneLabel.layer.borderWidth = 1;
    rightOneLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    rightOneLabel.textAlignment = NSTextAlignmentCenter;
    rightOneLabel.center = CGPointMake(kScreenWidth/4*3, CellHeight/4);
    [backView addSubview:rightOneLabel];
    
    UIButton *rightOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightOneButton setFrame:rightOne.frame];
    [rightOneButton addTarget:self action:@selector(rightOneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:rightOneButton];
    
    NSString *rightTwoUrl = @"";
    NSString *title3 = @"";
    if (self.albumArray.count>2) {
        NSDictionary *dic = self.albumArray[2];
        title3 = [NSString stringWithFormat:@"%@",dic[@"title"]];
        NSString *cover = [NSString stringWithFormat:@"%@",dic[@"cover"]];
        if ([cover isEqualToString:@"0"]) {
            
        }else
        {
            NSArray *photos = dic[@"photos"];
            for (int i=0; i<photos.count; i++) {
                NSDictionary *diction = photos[i];
                NSString *photoid = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
                if ([cover isEqualToString:photoid]) {
                    rightTwoUrl = [NSString stringWithFormat:@"%@",diction[@"url"]];
                }
            }
        }
    }
    
    UIImageView *rightTwo = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, CellHeight/2, kScreenWidth/2, CellHeight/2)];
    rightTwo.backgroundColor = [UIColor lightGrayColor];
    rightTwo.contentMode = UIViewContentModeScaleAspectFill;
    rightTwo.clipsToBounds = YES;
    [rightTwo sd_setImageWithURL:[NSURL URLWithString:rightTwoUrl]];
    self.rightTwoImgV = rightTwo;
    [backView addSubview:rightTwo];
    
    if (rightTwoUrl.length>0) {
        
    }else
    {
        UIImageView *rightTwo_temp = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, 53, 38)];
        rightTwo_temp.backgroundColor = [UIColor clearColor];
        rightTwo_temp.center = rightTwo.center;
        rightTwo_temp.image = [UIImage imageNamed:@"nopic-ablum"];
        rightTwo_temp.clipsToBounds = YES;
        [backView addSubview:rightTwo_temp];
    }
    
    float width3 = [SQCStringUtils getTxtLength:title3 font:15 limit:kScreenWidth/2];
    UILabel *rightTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width3+10, 30)];
    rightTwoLabel.text = title3;
    if (title3.length==0) {
        rightTwoLabel.hidden = YES;
    }
    rightTwoLabel.textColor = [UIColor whiteColor];
    rightTwoLabel.font = [UIFont systemFontOfSize:15];
    rightTwoLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    rightTwoLabel.layer.borderWidth = 1;
    rightTwoLabel.backgroundColor = RGBA(0, 0, 0, 0.4);
    rightTwoLabel.textAlignment = NSTextAlignmentCenter;
    rightTwoLabel.center = CGPointMake(kScreenWidth/4*3, CellHeight/4*3);
    [backView addSubview:rightTwoLabel];
    
    UIButton *rightTwoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightTwoButton setFrame:rightTwo.frame];
    [rightTwoButton addTarget:self action:@selector(rightTwoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:rightTwoButton];
    
    [self.cardView addSubview:backView];
}

- (void)leftButtonClick:(id)sender
{
    NSLog(@"leftButtonClick");
    if (self.albumArray.count>0) {
        NSDictionary *diction = self.albumArray[0];
        NSString *nameString = [NSString stringWithFormat:@"%@",diction[@"title"]];
        NSString *albumid = [NSString stringWithFormat:@"%@",diction[@"albumId"]];
        AlbumDetailViewController *detail = [[AlbumDetailViewController alloc] initWithNibName:@"AlbumDetailViewController" bundle:[NSBundle mainBundle]];
        detail.currentTitle = nameString;
        detail.albumid = albumid;
        detail.currentUid = self.dataDiction[@"uid"];
        [self.supCon.navigationController pushViewController:detail animated:YES];
    }
}

- (void)rightOneButtonClick:(id)sender
{
    NSLog(@"rightOneButtonClick");
    if (self.albumArray.count>1) {
        NSDictionary *diction = self.albumArray[1];
        NSString *nameString = [NSString stringWithFormat:@"%@",diction[@"title"]];
        NSString *albumid = [NSString stringWithFormat:@"%@",diction[@"albumId"]];
        AlbumDetailViewController *detail = [[AlbumDetailViewController alloc] initWithNibName:@"AlbumDetailViewController" bundle:[NSBundle mainBundle]];
        detail.currentTitle = nameString;
        detail.albumid = albumid;
        detail.currentUid = self.dataDiction[@"uid"];
        [self.supCon.navigationController pushViewController:detail animated:YES];
    }
    
}

- (void)rightTwoButtonClick:(id)sender
{
    NSLog(@"rightTwoButtonClick");
    if (self.albumArray.count>2) {
        NSDictionary *diction = self.albumArray[2];
        NSString *nameString = [NSString stringWithFormat:@"%@",diction[@"title"]];
        NSString *albumid = [NSString stringWithFormat:@"%@",diction[@"albumId"]];
        AlbumDetailViewController *detail = [[AlbumDetailViewController alloc] initWithNibName:@"AlbumDetailViewController" bundle:[NSBundle mainBundle]];
        detail.currentTitle = nameString;
        detail.albumid = albumid;
        detail.currentUid = self.dataDiction[@"uid"];
        [self.supCon.navigationController pushViewController:detail animated:YES];
    }
    
}

- (void)resetButtonTarget
{
    for (int i=0; i<self.buttonArray.count; i++) {
        UIButton *btn = self.buttonArray[i];
        [btn addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
}

- (void)resetImgViewURL
{
    [self.sequnceArr removeAllObjects];
    NSArray *imagesArr = self.dataDiction[@"imagesArr"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dic = imagesArr[i];
        NSString *sequence = [NSString stringWithFormat:@"%@",dic[@"sequence"]];
        [self.sequnceArr addObject:[NSNumber numberWithUnsignedInt:[sequence intValue]]];
//        NSLog(@"%@",self.sequnceArr);
        if (self.imgViewArray.count>[sequence intValue]) {
            UIImageView *imgView = self.imgViewArray[[sequence intValue]];
            NSString *cardType = self.dataDiction[@"cardType"];
            NSString *urlString = dic[@"url"];
            if ([cardType isEqualToString:@"3"]) {
                NSInteger wid = (NSInteger)((kScreenWidth-30)/3)*2;
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:wid];
                urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
            }else{
                //                if (i>1) {
                //                    NSLog(@"hahahahahah  %d",i);
                //                    NSInteger wid = (NSInteger)(imgView.frame.size.width)*2;
                //                    NSInteger hei = (NSInteger)(imgView.frame.size.height)*2;
                //                    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                //                    urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
                //                }
                NSInteger wid = (NSInteger)(imgView.frame.size.width)*2;
                NSInteger hei = (NSInteger)(imgView.frame.size.height)*2;
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
//                NSLog(@"%@",urlString);
            }
            
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        }
        
    }
    
}


#pragma mark -
- (void)clickCamera:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    NSArray *imagesArr = self.dataDiction[@"imagesArr"];
    
    if ([self isInTheArrayWithIndex:(int)sender.tag]) {
        NSString *uid = self.currentUid;
        PhotoBrowseViewController *photo = [[PhotoBrowseViewController alloc] initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
        int startIndex = 0;
        //确定真实点击的图片,如果不同就加1,即中间跳过
        for (int i = 0; i < sender.tag; i ++) {
            int j = [self.sequnceArr[i - startIndex] intValue];
            
            if (j != i) {
                startIndex ++;
            }
        }
        photo.startWithIndex = sender.tag - startIndex;
//        if (sender.tag>=imagesArr.count) {
//            photo.startWithIndex = imagesArr.count-1;
//            
//        }else
//        {
//            photo.startWithIndex = sender.tag;
//            
//        }
        photo.currentUid = uid;
        //        [photo setDataFromPhotoId:[self getThePhotoIDWithTag:sender.tag] uid:uid];
  
        
        
        [photo setDataFromPhotoId:[self getThePhotoIDWithTag:sender.tag] uid:uid withArray:imagesArr];
        //        [photo setDataFromYingJiWithUid:uid andArray:imagesArr.mutableCopy];
        [self.supCon.navigationController pushViewController:photo animated:YES];
    }
    
}

- (int)getTheIndexWithTag:(int)tag
{
    int index = 0;
    NSArray *imagesArr = self.dataDiction[@"imagesArr"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dition = imagesArr[i];
        NSString *squence = [NSString stringWithFormat:@"%@",dition[@"sequence"]];
        int dicSqu = [squence intValue];
        if (tag==dicSqu) {
            index = i;
        }
    }
    return index;
}

- (NSString *)getThePhotoIDWithTag:(int)tag
{
    NSString *photoId = @"";
    NSArray *imagesArr = self.dataDiction[@"imagesArr"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dition = imagesArr[i];
        NSString *squence = [NSString stringWithFormat:@"%@",dition[@"sequence"]];
        int dicSqu = [squence intValue];
        if (tag==dicSqu) {
            photoId = [NSString stringWithFormat:@"%@",dition[@"photoId"]];
        }
    }
    return photoId;
}

- (BOOL)isInTheArrayWithIndex:(int)index
{
    BOOL isIn = NO;
    NSArray *imagesArr = self.dataDiction[@"imagesArr"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dition = imagesArr[i];
        NSString *squence = [NSString stringWithFormat:@"%@",dition[@"sequence"]];
        int dicSqu = [squence intValue];
        if (index==dicSqu) {
            isIn = YES;
        }
    }
    return isIn;
}



- (IBAction)BuildMcCard:(id)sender {
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (!isBangDing) {
            //显示绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return;
        }
    }else{
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.supCon];
        return;
    }

    if (self.nocardLabel.text.length<7) {
        if ([_isModel isEqualToString:@"1"]) {
            BuildMokaCardViewController *moka = [[BuildMokaCardViewController alloc] initWithNibName:@"BuildMokaCardViewController" bundle:[NSBundle mainBundle]];
            [self.supCon.navigationController pushViewController:moka animated:YES];
        }else{
            BuildAlbumViewController *moka = [[BuildAlbumViewController alloc] initWithNibName:@"BuildAlbumViewController" bundle:[NSBundle mainBundle]];
            [self.supCon.navigationController pushViewController:moka animated:YES];
        }
    }
}

//- (IBAction)makeACard:(id)sender {
//    NSLog(@"makeACard");
//    NSString *currentUid = [NSString stringWithFormat:@"%@",self.dataDiction[@"uid"]];
//    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
//    if ([currentUid isEqualToString:uid]) {
//
//
//    }else
//    {
//        return;
//
//    }
//    NSString *isModel = self.dataDiction[@"isModel"];
////    NSString *nameString = self.currentUserName;
//
//    if ([isModel isEqualToString:@"1"]) {
//        BuildMokaCardViewController *moka = [[BuildMokaCardViewController alloc] initWithNibName:@"BuildMokaCardViewController" bundle:[NSBundle mainBundle]];
//        [self.supCon.navigationController pushViewController:moka animated:YES];
//    }else
//    {
//        BuildAlbumViewController *moka = [[BuildAlbumViewController alloc] initWithNibName:@"BuildAlbumViewController" bundle:[NSBundle mainBundle]];
//        [self.supCon.navigationController pushViewController:moka animated:YES];
//    }
//

//}


- (IBAction)clickMokaMethod:(id)sender {
    
//    NSString *cuid = self.currentUid;
//    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
//    NSDictionary *params = [AFParamFormat formatGetUserMokaListParams:cuid];
//    

    NSString *nameString = self.currentUserName;
    
    if ([_isModel isEqualToString:@"1"]) {
        //        MyMokaCardViewController *moka = [[MyMokaCardViewController alloc] initWithNibName:@"MyMokaCardViewController" bundle:[NSBundle mainBundle]];
        //        moka.currentTitle = nameString;
        //        moka.currentUid = self.dataDiction[@"uid"];
        //        [self.supCon.navigationController pushViewController:moka animated:YES];
        
        
        NSString *style = [NSString stringWithFormat:@"%@",self.mokaListDic[@"style"]];
        NSString *albumId = [NSString stringWithFormat:@"%@",self.mokaListDic[@"albumId"]];
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if ([self.currentUid isEqualToString:uid]) {
            BuildDetailViewController *newActivity = [[BuildDetailViewController alloc] initWithNibName:@"BuildDetailViewController" bundle:[NSBundle mainBundle]];
            newActivity.albumid = albumId;
            newActivity.mokaType = style;
            newActivity.isEditing = YES;
            
            [self.supCon.navigationController pushViewController:newActivity animated:YES];
        }
        
    }else
    {
        AlbumListViewController *list = [[AlbumListViewController alloc] initWithNibName:@"AlbumListViewController" bundle:[NSBundle mainBundle]];
        list.currentUid = self.dataDiction[@"uid"];
        list.currentName = nameString;
        [self.supCon.navigationController pushViewController:list animated:YES];
        
    }
    
}


#pragma mark - 点击下载按钮
- (IBAction)DownloadButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;
    //获取准备好的视图
    UIView *preparedMokaView = [self getPreparedMokaView];
    [self.supCon downloadMcWithImage:[self snapshot:preparedMokaView] width:preparedMokaView.width height:preparedMokaView.height withButton:btn];
}


//截图前首先重置模卡视图
-(UIView *)getPreparedMokaView{
    //重新创建一个父视图
    UIView *preparedMokaView = [[UIView alloc] initWithFrame:CGRectZero];
    //从xib中获取视图:图片视图和信息视图
    UIView *pictureView = (UIView *)[self.contentView viewWithTag:100];
    UILabel *informationLab = (UILabel *)[self.contentView viewWithTag:101];
    //复制视图
    NSData * pictureViewData = [NSKeyedArchiver archivedDataWithRootObject:pictureView];
    UIView* copyPictureView = [NSKeyedUnarchiver unarchiveObjectWithData:pictureViewData];
    copyPictureView.frame = CGRectMake(0, 0, copyPictureView.width, copyPictureView.height);
    
    //三围信息
    NSData * informationLabelData= [NSKeyedArchiver archivedDataWithRootObject:informationLab];
    UILabel* copyInformationLable = [NSKeyedUnarchiver unarchiveObjectWithData:informationLabelData];
    copyInformationLable.textColor = [UIColor blackColor];
    copyInformationLable.text = sanWeiStr;
    copyInformationLable.font = [UIFont systemFontOfSize:8];
    copyInformationLable.frame = CGRectMake(10, copyPictureView.bottom + 12 , self.width, self.informationLabel.height);
    
    //名字信息
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, copyPictureView.bottom - 3, self.width, self.informationLabel.height)];
    nameLabel.text = nameStr;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:11];
    
    //介绍
//    UILabel *introduceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, copyPictureView.bottom + 12, self.width - 24 - 15, self.informationLabel.height)];
//    introduceLab.textColor = [UIColor blackColor];
//    introduceLab.text = [NSString stringWithFormat:@"登录MOKA可获得更多信息"];
//    introduceLab.font = [UIFont systemFontOfSize:8];
//    introduceLab.textAlignment = NSTextAlignmentRight;
    
    //MOKA
    UILabel *MOKALab = [[UILabel alloc]initWithFrame:CGRectMake(0, copyPictureView.bottom + 5, self.width - 24 - 15, self.informationLabel.height)];
    MOKALab.text = mokaStr;
    MOKALab.textColor = [UIColor blackColor];
    MOKALab.textAlignment = NSTextAlignmentRight;
    MOKALab.font = [UIFont boldSystemFontOfSize:11];
    
    
    //创建图标视图
    UIImageView *logoIconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 10 - 24, copyPictureView.bottom, 24, 24)];
    logoIconView.image = [UIImage imageNamed:@"MOKAIcon"];

    //组合成新视图
    [preparedMokaView addSubview:copyPictureView];
    [preparedMokaView addSubview:copyInformationLable];
    [preparedMokaView addSubview:logoIconView];
    [preparedMokaView addSubview:nameLabel];
//    [preparedMokaView addSubview:introduceLab];
    [preparedMokaView addSubview:MOKALab];
    
    //重新设置模卡视图的大小：底部增加了15个高度
    preparedMokaView.frame = CGRectMake(0, 0,copyPictureView.width, copyPictureView.height +copyInformationLable.height + 15);
    preparedMokaView.backgroundColor = [UIColor whiteColor];
    return preparedMokaView;
}



//截图视图
- (UIImage *)snapshot:(UIView *)view
{
    //创建画布
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    //绘制图片
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    //从当前画布得到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭画布,很占内存
    UIGraphicsEndImageContext();
    
    
    return image;
    
}

#pragma mark - 点击分享
- (IBAction)SharedButton:(id)sender {
    //    [self.clickButton removeFromSuperview];
    //    UIView *cellView = [[sender superview] superview];
    //    [self.SharedButton removeFromSuperview];
    //    [self.rightArrow removeFromSuperview];
    //    [self.DownloadButton removeFromSuperview];
    //    [self.supCon sharedMcWithImage:[self snapshot:cellView] width:cellView.frame.size.width height:cellView.frame.size.height];
    //    [self.contentView addSubview:self.SharedButton];
    //    [self.contentView addSubview:self.DownloadButton];
    //    [self.contentView addSubview:self.clickButton];
    //    [self.contentView addSubview:self.rightArrow];
    UIView *preparedMokaView = [self getPreparedMokaView];
    [self.supCon sharedMcWithImage:[self snapshot:preparedMokaView] width:preparedMokaView.width height:preparedMokaView.height];
}



#pragma mark - 类方法获取cell
+ (NewMokaCardTableViewCell *)getNewMokaCardTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewMokaCardTableViewCell" owner:self options:nil];
    NewMokaCardTableViewCell *cell = array[0];
    cell.imgViewArray = @[].mutableCopy;
    cell.buttonArray = @[].mutableCopy;
    
    return cell;
}


- (IBAction)DetilButton:(id)sender {
    [self clickMokaMethod:sender];
}

-(NSMutableArray *)sequnceArr{
    if (!_sequnceArr) {
        _sequnceArr = [NSMutableArray array];
    }
    return _sequnceArr;
}
-(NSMutableArray *)albumArray{
    if (!_albumArray) {
        _albumArray = [NSMutableArray array];
    }
    return _albumArray;
}

@end
