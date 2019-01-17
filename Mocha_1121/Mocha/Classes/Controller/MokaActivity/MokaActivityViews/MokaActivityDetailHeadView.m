//
//  MokaActivityDetailHeadView.m
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaActivityDetailHeadView.h"
#import "UIButton+AFNetworking.h"
#import "NewActivityGroupNotSignViewController.h"
#import "ChatViewController.h"
#import "ManageActivityViewController.h"

@implementation MokaActivityDetailHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
        _leftPadding = 20;
    }
    return self;
}

//初始化视图组件
- (void)_initViews{
    self.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
    //第一部分:发布人的信息===============
    _publisherInfoView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_publisherInfoView];
    //发起人：
    _faqiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _faqiLabel.text = @"发起人:";
    _faqiLabel.font = [UIFont boldSystemFontOfSize:14];
    [_publisherInfoView addSubview:_faqiLabel];
    //发起人头像按钮
    _publisherHeaderBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _publisherHeaderBtn.layer.cornerRadius = 20;
    _publisherHeaderBtn.layer.masksToBounds = YES;
    [_publisherInfoView addSubview:_publisherHeaderBtn];
    //发起人昵称
    _publisherNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _publisherNameLabel.text = @"";
    _publisherNameLabel.font  = [UIFont systemFontOfSize:14];
    _publisherNameLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    [_publisherInfoView addSubview:_publisherNameLabel];
    //联系发起人视图
    _contactView = [[UIControl alloc] initWithFrame:CGRectZero];
    [_contactView addTarget:self action:@selector(contactActivityManager:) forControlEvents:UIControlEventTouchUpInside];
    _contactView.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
    _contactView.layer.cornerRadius = 10;
    _contactView.layer.masksToBounds =YES;
    [_publisherInfoView addSubview:_contactView];
    //联系图标
    _contactImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _contactImgView.image = [UIImage imageNamed:@"contact"];
    [_contactView addSubview:_contactImgView];
    //联系
    _contactTxtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contactTxtLabel.textAlignment = NSTextAlignmentCenter;
    _contactTxtLabel.font = [UIFont systemFontOfSize:15];
    _contactTxtLabel.text = @"联系";
    [_contactView addSubview:_contactTxtLabel];
    //一条分割线
    _lineLabelOne = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineLabelOne.backgroundColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    [_publisherInfoView addSubview:_lineLabelOne];
    
     //显示活动标题===============
    _activityInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_publisherInfoView addSubview:_activityInfoLabel];
    
    
    //第二部分：费用信息===============
    _zhongChouView = [[UIView alloc] initWithFrame:CGRectZero];
    _zhongChouView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_zhongChouView];
    //众筹图标
    _zhongchouImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _zhongchouImgView.image = [UIImage imageNamed:@"qianIcon"];
    [_zhongChouView addSubview:_zhongchouImgView];
    //费用文字提示
    _zhongChouTxtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _zhongChouTxtLabel.font = [UIFont boldSystemFontOfSize:15];
    _zhongChouTxtLabel.textAlignment = NSTextAlignmentLeft;
    _zhongChouTxtLabel.text = @"众筹金额";
    [_zhongChouView addSubview:_zhongChouTxtLabel];
    _zhongChouTxtLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    _zhongChouTxtLabel.font = [UIFont boldSystemFontOfSize:15];
    //显示费用金额
    _zhongChouFeeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _zhongChouFeeLabel.font = [UIFont systemFontOfSize:15];
    _zhongChouFeeLabel.textAlignment = NSTextAlignmentRight;
    [_zhongChouView addSubview:_zhongChouFeeLabel];
     
     //第三部分:活动简介===============
    _activityDeatialLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _activityDeatialLabel.numberOfLines = 0;
    _activityDeatialLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    _activityDeatialLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_activityDeatialLabel];
    
    //第四部分部分：其他信息的显示:时间地点============
    _extendInfoView = [[UILabel alloc] initWithFrame:CGRectZero];
    //起止时间
    [self addSubview:_extendInfoView];
    _timeLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    [_extendInfoView addSubview:_timeLabel];
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //地址
    _addressLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    [_extendInfoView addSubview:_addressLabel];
    
}


//数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic !=  dataDic) {
        _dataDic = dataDic;
        //判断活动类型
        NSString *type = _dataDic[@"type"];
        if ([type isEqualToString:@"4"]||[type isEqualToString:@"1"]) {
            _typeNum = 1;
        }else if([type isEqualToString:@"5"]){
            _typeNum = 2;
        }else if([type isEqualToString:@"6"]){
            _typeNum = 3;
        }
         [self initViewWithData];
     }
}


#pragma mark - 新数据重新布局视图
- (void)initViewWithData{
    self.width = kDeviceWidth;
    
    //第一行：发布人信息
    [self handle_publisherInfoView];
    
    //第二行：活动信息,放在了发布人信息的视图上
    //[self handle_activityInfo];
    
    //第三行：众筹视图——>显示所有活动类型的费用
    [self handle_zhongChou_new];
    
    //第四行：活动简介
    [self handle_activityDeatilInfo];
    
    //第五行：显示时间和地点
    [self handle_extendInfoView];
    
    //确定头视图的frame
    self.frame = CGRectMake(0, 0, kDeviceWidth, _extendInfoView.bottom +5);
}


- (void)handle_publisherInfoView{
    _publisherInfoView.frame = CGRectMake(0, 0, self.width , 60);
    _publisherInfoView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
    //发起人
    _faqiLabel.frame = CGRectMake(_leftPadding, 15, 60, 30);
    //发起人头像
    _publisherHeaderBtn.frame = CGRectMake(_faqiLabel.right +5, 10, 40,40);
    [_publisherHeaderBtn addTarget:self action:@selector(gotoPersonalPage:) forControlEvents:UIControlEventTouchUpInside];
    //发起人头像链接
    NSString *publisherHeadImgStr = _dataDic[@"publisher"][@"head_pic"];
    NSString *jpg = [CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2];
    NSString *url = [NSString stringWithFormat:@"%@%@",publisherHeadImgStr,jpg];
   [_publisherHeaderBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"unloadHead"]];
    //发起人昵称
    _publisherNameLabel.frame = CGRectMake(_publisherHeaderBtn.right +5, 15, self.width -(_publisherHeaderBtn.right +5) -100, 30);
    _publisherNameLabel.text = _dataDic[@"publisher"][@"nickname"];
    
    NSString *managerId =  _dataDic[@"publisher"][@"uid"];
    if ([managerId isEqualToString:(getCurrentUid())]) {
        _contactView.hidden = YES;
    }else{
        _contactView.hidden = NO;
//        _contactView.frame = CGRectMake(_publisherInfoView.width -90 -_leftPadding, 15, 90, 30);
//        _contactView.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
//        _contactImgView.frame = CGRectMake(8, 5, 20, 20);
//        _contactTxtLabel.frame = CGRectMake(_contactImgView.right+2, 7.5, 55, 15);
//        _contactTxtLabel.text = @"联系ta";
        
        _contactView.frame = CGRectMake(_publisherInfoView.width -_leftPadding -64, 15, 64, 30);
        //_contactImgView.frame = CGRectMake(8, 5, 20, 20);
        _contactTxtLabel.frame = CGRectMake(8, 7.5, 48, 15);
        _contactTxtLabel.text = @"联 系";

    }
    
    _lineLabelOne.frame = CGRectMake(_leftPadding,60,kDeviceWidth -_leftPadding *2, 0.3);
    //活动信息
    [self handle_activityInfo];

}

- (void)handle_activityInfo{
  //  NSString *_activityInfoStr = @"";
//    if (_isTongGao) {
//        //通告：标题 +费用
////        if([_dataDic[@"payment"] isEqualToString:@"面议"]){
////            _activityInfoStr = [NSString stringWithFormat:@"%@, 费用面议",_dataDic[@"title"]];
////        }else{
////            _activityInfoStr = [NSString stringWithFormat:@"%@, %@元",_dataDic[@"title"],_dataDic[@"payment"]];
////        }
//        _activityInfoStr =_dataDic[@"title"];
//    }else{
//        //众筹：标题
//        _activityInfoStr = [NSString stringWithFormat:@"%@",_dataDic[@"title"]];
//    }
    
    NSString *_activityInfoStr = _dataDic[@"title"];
    CGFloat activityInfoHeight = [SQCStringUtils getCustomHeightWithText:_activityInfoStr viewWidth:kDeviceWidth -_leftPadding *2 textSize:18];
    
    if (activityInfoHeight<50) {
        activityInfoHeight = 50;
    }else{
       activityInfoHeight = activityInfoHeight +10;
    }
    _activityInfoLabel.frame = CGRectMake(_leftPadding, _publisherInfoView.bottom +5,kDeviceWidth-_leftPadding *2 , activityInfoHeight);
    _activityInfoLabel.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
    _activityInfoLabel.text = _activityInfoStr;
    _activityInfoLabel.font = [UIFont boldSystemFontOfSize:18];
    
    _publisherInfoView.frame = CGRectMake(0, 0, kDeviceWidth, 70 + activityInfoHeight);
}


/*
-(void)handle_zhongChou{
    if (!_isTongGao) {
        _zhongChouView.backgroundColor = [UIColor whiteColor];
        //如果是众筹
        _zhongChouView.hidden = NO;
        _zhongChouView.frame = CGRectMake(0, _activityInfoLabel.bottom, kDeviceWidth, 60);
        //图标
        _zhongchouImgView.frame = CGRectMake(_leftPadding, 20, 20, 20);
        //文字
        _zhongChouTxtLabel.frame = CGRectMake(_zhongchouImgView.right +10, 15, 100, 30);
        _zhongChouFeeLabel.frame = CGRectMake(_zhongChouView.width -100 -_leftPadding, 15, 100, 30);
        _zhongChouFeeLabel.text = [NSString stringWithFormat:@"%@元/人",_dataDic[@"payment"]];
    }else{
        _zhongChouView.hidden = YES;
    }
}
 
*/

//新需求：通告也要显示金额,原来显示众筹金额的视图页要显示通告的金额
-(void)handle_zhongChou_new{
    //如果是众筹
    _zhongChouView.hidden = NO;
    _zhongChouView.frame = CGRectMake(0, _activityInfoLabel.bottom, kDeviceWidth, 50);
    //图标
    _zhongchouImgView.frame = CGRectMake(_leftPadding, 15, 20, 20);
    //文字
    _zhongChouTxtLabel.frame = CGRectMake(_zhongchouImgView.right +10, 10, 100, 30);
    _zhongChouFeeLabel.frame = CGRectMake(_zhongChouView.width -100 -_leftPadding, 10, 100, 30);
    
    //显示金额
    switch (_typeNum) {
        case 1:
        {
            _zhongChouTxtLabel.text = @"活动金额";
            break;
        }
        case 2:
        {
            _zhongChouTxtLabel.text = @"众筹金额";
            break;
        }
        case 3:
        {
            _zhongChouTxtLabel.text = @"活动金额";
            break;
        }
        default:
            break;
    }
    //显示金额
    _zhongChouFeeLabel.text = _dataDic[@"payment"];
    
 }




- (void)handle_activityDeatilInfo{
    NSString *activityDeatilInfo = _dataDic[@"content"];
    CGFloat activityDeatilHeight = [SQCStringUtils getCustomHeightWithText:activityDeatilInfo viewWidth:kDeviceWidth- _leftPadding *2 textSize:15];
    _activityDeatialLabel.text= activityDeatilInfo;
    activityDeatilHeight = activityDeatilHeight +5;
    
//    if (_isTongGao) {
//        _activityDeatialLabel.frame = CGRectMake(_leftPadding,_activityInfoLabel.bottom+5, kDeviceWidth -_leftPadding *2, activityDeatilHeight);
//    }else{
//        _activityDeatialLabel.frame = CGRectMake(_leftPadding,_zhongChouView.bottom +5, kDeviceWidth -_leftPadding *2, activityDeatilHeight);
//    }
    _activityDeatialLabel.frame = CGRectMake(_leftPadding,_zhongChouView.bottom +5, kDeviceWidth -_leftPadding *2, activityDeatilHeight);
}


- (void)handle_extendInfoView{
    _extendInfoView.frame = CGRectMake(0, _activityDeatialLabel.bottom +5, kDeviceWidth, 45);
    _timeLabel.frame = CGRectMake(_leftPadding, 0, kDeviceWidth -_leftPadding *2, 20);
    _addressLabel.frame = CGRectMake(_leftPadding, 25, kDeviceWidth -_leftPadding *2, 20);
    
    NSString *startDate =[_dataDic[@"startdate"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString *enddate =[ _dataDic[@"enddate"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    _timeLabel.text = [NSString stringWithFormat:@"时间：%@ - %@",startDate,enddate];
    
    NSString *province= _dataDic[@"provinceName"];
    NSString *city = _dataDic[@"cityName"];
    if(city.length == 0){
        city = @"";
    }
    if ([province isEqualToString:city]) {
        _addressLabel.text = [NSString stringWithFormat:@"地点：%@",province];
    }else{
        _addressLabel.text = [NSString stringWithFormat:@"地点：%@ %@",province,city];
    }
}


#pragma mark - 事件点击处理
- (void)gotoPersonalPage:(UIButton *)btn {
    
    NSString *userName = _dataDic[@"publisher"][@"nickname"];
    NSString *uid = [NSString stringWithFormat:@"%@",_dataDic[@"publisher"][@"uid"]];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    [self.superVC.customTabBarController hidesTabBar:YES animated:NO];
    [self.superVC.navigationController pushViewController:newMyPage animated:YES];
}




//联系群主
- (void)contactActivityManager:(UIControl *)ctrl
{
    //取出私信的字段
    NSString *status = _dataDic[@"status"];
    NSInteger statusNum = [status integerValue];
    NSString *msg = _dataDic[@"messageEnable"][@"msg"];
//    NSInteger statusNum = 0;
//    NSString *msg = @"test";
    switch (statusNum) {
        case  kRight:
        {
            //0可以私信
#ifdef HXRelease
            //异步登陆账号
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[ChatManager sharedInstance].hxName password:@"123456"
                                                              completion:
             ^(NSDictionary *loginInfo, EMError *error) {
                 
                 if (loginInfo && !error) {
                     //获取群组列表
                     [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                     
                     //设置是否自动登录
                     [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                     
                     //将2.1.0版本旧版的coredata数据导入新的数据库
                     EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                     if (!error) {
                         error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                     }
                     
                     //发送自动登陆状态通知
                     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                 }
                 else
                 {
                 }
             } onQueue:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *fromHeaderURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
                ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:_dataDic[@"publisher"][@"uid"] conversationType:eConversationTypeChat];
                chatController.title = getSafeString(_dataDic[@"publisher"][@"nickname"]);
                 chatController.fromHeaderURL = getSafeString(fromHeaderURL);
                chatController.toHeaderURL = getSafeString(_dataDic[@"publisher"][@"uid"] );
                [self.superVC.navigationController pushViewController:chatController animated:YES];
            });
#else
            McChatRoomViewController *chatVC = [[McChatRoomViewController alloc] initWithOtherUserId:_thisUid isReadMsg:NO];
            chatVC.headPic = self.headerURL;
            chatVC.title = self.userName;
            [self.navigationController pushViewController:chatVC animated:YES];
#endif
            break;
        }
        case kReLogin:
        {
            //需要登陆
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.superVC];
            break;
        }
        case  6218:
        {   //需要绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            break;
        }
        case  1:
        {
            //提示不能私信
            [LeafNotification showInController:self.superVC withText:msg];
            break;
        }
        default:
            break;
    }
}



@end
