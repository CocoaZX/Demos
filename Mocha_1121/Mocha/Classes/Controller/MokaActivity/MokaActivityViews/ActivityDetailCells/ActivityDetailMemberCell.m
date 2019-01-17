//
//  ActivityDetailMemberCell.m
//  Mocha
//
//  Created by zhoushuai on 16/2/17.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ActivityDetailMemberCell.h"
#import "NewMyPageViewController.h"
#import "NewActivityGroupNotSignViewController.h"
#import "ManageActivityViewController.h"

@implementation ActivityDetailMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self _initViews];
        _leftPadding = 20;
     }
    return  self;
}

//初始化视图组件
- (void)_initViews{
    //报名情况===============
    _baoMingView =  [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_baoMingView];
    
    //title
    _baoMingTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _baoMingTitleLabel.textAlignment = NSTextAlignmentCenter;
    _baoMingTitleLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
    _baoMingTitleLabel.font = [UIFont systemFontOfSize:16];
    [_baoMingView addSubview:_baoMingTitleLabel];
    //管理按钮
    _baoMingManagerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _baoMingManagerButton.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
    _baoMingManagerButton.layer.cornerRadius = 10;
    _baoMingManagerButton.layer.masksToBounds = YES;
     [_baoMingManagerButton setTitle:@"报名管理" forState:UIControlStateNormal];
    [_baoMingManagerButton setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
     _baoMingManagerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_baoMingView addSubview:_baoMingManagerButton];
    //头像视图
    _baoMingPersonView = [[UIView alloc] initWithFrame:CGRectZero];
    [_baoMingView addSubview:_baoMingPersonView];
    
    
    //群聊===============
    _qunLiaoControl = [[UIControl alloc] initWithFrame:CGRectZero];
    [self addSubview:_qunLiaoControl];
    //图标
    _qunLiaoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _qunLiaoImgView.image =[UIImage imageNamed:@"qunliao"];
    [_qunLiaoControl addSubview:_qunLiaoImgView];
    //群聊
    _qunLiaoTxtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _qunLiaoTxtLabel.text = @"群聊";
    [_qunLiaoControl addSubview:_qunLiaoTxtLabel];
    //显示群聊人数
    _qunLiaoCoutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _qunLiaoCoutLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
    _qunLiaoCoutLabel.textAlignment = NSTextAlignmentRight;
    [_qunLiaoControl addSubview:_qunLiaoCoutLabel];
    //进入群聊按钮
    _enterQunLiaoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _enterQunLiaoImgView.image = [UIImage imageNamed:@"oicon031"];
    [_qunLiaoControl addSubview:_enterQunLiaoImgView];
}


//数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic !=  dataDic) {
        _dataDic = dataDic;
        [self setNeedsLayout];
    }
}

#pragma mark 视图的设置
//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    //报名视图
    [self handle_baoMingView_new_more];
    //[self handle_baoMingView_new];
    
    //群聊
    [self handle_qunLiaoView];
 
}



- (void)handle_baoMingView_new_more{
    NSArray *signuplist = _dataDic[@"signuplist"];
    //0个人参加活动
    if (signuplist.count == 0) {
        //不需要执行以下，直接返回
        _baoMingView.hidden = YES;
        _baoMingView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
        return;
    }
    _baoMingView.hidden = NO;

    _baoMingView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
    //提示文字
    _baoMingTitleLabel.frame = CGRectMake(_leftPadding, 5, 180, 30);
    _baoMingTitleLabel.textAlignment = NSTextAlignmentLeft;
    _baoMingTitleLabel.text = [NSString  stringWithFormat:@"%ld人报名",(unsigned long)signuplist.count];
    
    //当前不是管理员,隐藏管理按钮
    NSString *actId = [NSString stringWithFormat:@"%@",_dataDic[@"publisher"][@"uid"]];
    if (![getCurrentUid() isEqualToString:actId]) {
        _baoMingManagerButton.hidden = YES;
    }else{
        _baoMingManagerButton.hidden = NO;
        //管理报名按钮
        CGFloat buttonWidth = 90;
        _baoMingManagerButton.frame = CGRectMake(kScreenWidth - _leftPadding - buttonWidth, 5, buttonWidth, 30);
        [_baoMingManagerButton addTarget:self action:@selector(baoMingManageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //清空原来的头像
    for (UIView *view in _baoMingPersonView.subviews){
        [view removeFromSuperview];
    }
    
    //显示加入者的头像
    float imgWidth = (kScreenWidth-_leftPadding *2)/9;
    if (signuplist.count>0 && signuplist.count<10) {
        _baoMingPersonView.frame = CGRectMake(0,40, kScreenWidth, imgWidth);
    }
    
    if (signuplist.count>9) {
        _baoMingPersonView.frame = CGRectMake(0, 40, kScreenWidth, imgWidth *2);
    }
    
    
    //创建头像按钮需要的头像链接
    NSMutableArray *baomingArray = @[].mutableCopy;
    if ([signuplist isKindOfClass:[NSArray class]]) {
        for (int i=0; i<signuplist.count; i++) {
            NSDictionary *diction = signuplist[i];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSString *headerURL = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
                [baomingArray addObject:headerURL];
            }
        }
    }
    
    //最多显示18个
    int appearCount = (int)baomingArray.count;
    if (appearCount>18) {
        appearCount = 18;
    }
    
    if (0<appearCount && appearCount<10) {
        //左边间距
        //CGFloat leftPadding = (kDeviceWidth - 20 -imgWidth*appearCount)/2;
        //布局头像
        for (int i = 0 ; i<appearCount; i++) {
            //头像
            UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(_leftPadding+5+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            avatarImg.clipsToBounds = YES;
            avatarImg.layer.cornerRadius = (imgWidth-10)/2;
            avatarImg.layer.masksToBounds = YES;
            NSString *imgUrlString = [NSString stringWithFormat:@"%@%@",getSafeString(baomingArray[i]),[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
            [avatarImg sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"unloadHead"]];
            [_baoMingPersonView addSubview:avatarImg];
            //按钮
            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [clickBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
            [clickBtn setFrame:CGRectMake(_leftPadding+5+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            [clickBtn setTag:i];
            [_baoMingPersonView addSubview:clickBtn];
        }
    }else{
        for (int i=0; i<appearCount; i++) {
            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [clickBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
            [clickBtn setFrame:CGRectMake(_leftPadding +5 +imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            [clickBtn setTag:i];
            
            UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(_leftPadding + 5 +imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            if (i>8) {
                avatarImg.frame = CGRectMake(_leftPadding +5+imgWidth*(i-9), imgWidth, imgWidth-10, imgWidth-10);
                [clickBtn setFrame:CGRectMake(_leftPadding +5+imgWidth*(i-9), imgWidth, imgWidth-10, imgWidth-10)];
            }
            avatarImg.clipsToBounds = YES;
            avatarImg.layer.cornerRadius = (imgWidth-10)/2;
            avatarImg.layer.masksToBounds = YES;
            [avatarImg sd_setImageWithURL:[NSURL URLWithString:baomingArray[i]] placeholderImage:[UIImage imageNamed:@""]];
            [_baoMingPersonView addSubview:avatarImg];
            [_baoMingPersonView addSubview:clickBtn];
        }
    }
    //确定报名视图的大小
    _baoMingView.frame = CGRectMake(0, 0, kDeviceWidth, 40+_baoMingPersonView.height);
}




- (void)handle_baoMingView_new{
    NSArray *signuplist = _dataDic[@"signuplist"];
    _baoMingView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
    //提示文字
    _baoMingTitleLabel.frame = CGRectMake(_leftPadding, 5, 180, 30);
    _baoMingTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    //管理报名按钮
    CGFloat buttonWidth = 90;
    _baoMingManagerButton.frame = CGRectMake(kScreenWidth - _leftPadding - buttonWidth, 5, buttonWidth, 30);
    _baoMingManagerButton.layer.cornerRadius = 10;
    _baoMingManagerButton.layer.masksToBounds = YES;
    [_baoMingManagerButton addTarget:self action:@selector(baoMingManageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //显示已经报名的人数
    if (signuplist.count>0) {
        _baoMingTitleLabel.text = [NSString  stringWithFormat:@"%ld人报名",(unsigned long)signuplist.count];
    }else{
        _baoMingTitleLabel.text = @"快来报名吧";
    }
    
    
    //当前不是管理员,隐藏管理按钮
    NSString *actId = [NSString stringWithFormat:@"%@",_dataDic[@"publisher"][@"uid"]];
    if (![getCurrentUid() isEqualToString:actId]) {
        _baoMingManagerButton.hidden = YES;
    }else{
        _baoMingManagerButton.hidden = NO;
        if(signuplist.count == 0){
            _baoMingTitleLabel.text = @"还没有人报名哦";
        }
    }
    
    //0个人参加活动
    if (signuplist.count == 0) {
        //不需要执行以下，直接返回
        _baoMingView.frame = CGRectMake(0, 0, kDeviceWidth, 40);
        return;
    }
    
    //存在成员
    //清空原来的头像
    for (UIView *view in _baoMingPersonView.subviews){
        [view removeFromSuperview];
    }
    
    //显示加入者的头像
    float imgWidth = (kScreenWidth-_leftPadding *2)/9;
    if (signuplist.count>0 && signuplist.count<9) {
        _baoMingPersonView.frame = CGRectMake(0,40, kScreenWidth, imgWidth);
    }
    
    if (signuplist.count>9) {
        _baoMingPersonView.frame = CGRectMake(0, 40, kScreenWidth, imgWidth *2);
    }
    
    
    //创建头像按钮需要的头像链接
    NSMutableArray *baomingArray = @[].mutableCopy;
    if ([signuplist isKindOfClass:[NSArray class]]) {
        for (int i=0; i<signuplist.count; i++) {
            NSDictionary *diction = signuplist[i];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSString *headerURL = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
                [baomingArray addObject:headerURL];
            }
        }
    }
    
    //最多显示18个
    int appearCount = (int)baomingArray.count;
    if (appearCount>18) {
        appearCount = 18;
    }
    
    if (0<appearCount && appearCount<9) {
        //左边间距
        //CGFloat leftPadding = (kDeviceWidth - 20 -imgWidth*appearCount)/2;
        //布局头像
        for (int i = 0 ; i<appearCount; i++) {
            //头像
            UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(_leftPadding+5+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            avatarImg.clipsToBounds = YES;
            avatarImg.layer.cornerRadius = (imgWidth-10)/2;
            avatarImg.layer.masksToBounds = YES;
            NSString *imgUrlString = [NSString stringWithFormat:@"%@%@",getSafeString(baomingArray[i]),[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
            [avatarImg sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"unloadHead"]];
            [_baoMingPersonView addSubview:avatarImg];
            //按钮
            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [clickBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
            [clickBtn setFrame:CGRectMake(_leftPadding+5+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            [clickBtn setTag:i];
            [_baoMingPersonView addSubview:clickBtn];
        }
    }else{
        for (int i=0; i<appearCount; i++) {
            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [clickBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
            [clickBtn setFrame:CGRectMake(_leftPadding +5 +imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            [clickBtn setTag:i];
            
            UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(_leftPadding + 5 +imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            if (i>8) {
                avatarImg.frame = CGRectMake(_leftPadding +5+imgWidth*(i-9), imgWidth, imgWidth-10, imgWidth-10);
                [clickBtn setFrame:CGRectMake(_leftPadding +5+imgWidth*(i-9), imgWidth, imgWidth-10, imgWidth-10)];
            }
            avatarImg.clipsToBounds = YES;
            avatarImg.layer.cornerRadius = (imgWidth-10)/2;
            avatarImg.layer.masksToBounds = YES;
            [avatarImg sd_setImageWithURL:[NSURL URLWithString:baomingArray[i]] placeholderImage:[UIImage imageNamed:@""]];
            [_baoMingPersonView addSubview:avatarImg];
            [_baoMingPersonView addSubview:clickBtn];
        }
    }
    //确定报名视图的大小
    _baoMingView.frame = CGRectMake(0, 0, kDeviceWidth, 40+_baoMingPersonView.height);
    
}






//显示报名的视图
- (void)handle_baoMingView{
    //参加活动人员数组
    NSArray *signuplist = _dataDic[@"signuplist"];
    _baoMingView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
     //提示文字
    _baoMingTitleLabel.frame = CGRectMake((kDeviceWidth -_leftPadding -180)/2, 5, 180, 30);
    //管理报名按钮
    _baoMingManagerButton.frame = CGRectMake(kScreenWidth -_leftPadding-80, 5, 80, 30);
    [_baoMingManagerButton addTarget:self action:@selector(baoMingManageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //显示已经报名的人数
    if (signuplist.count>0) {
        _baoMingTitleLabel.text = [NSString  stringWithFormat:@"%ld人已报名",(unsigned long)signuplist.count];
    }else{
        _baoMingTitleLabel.text = @"快来报名吧";
    }
    
    
    //当前不是管理员,隐藏管理按钮
    NSString *actId = [NSString stringWithFormat:@"%@",_dataDic[@"publisher"][@"uid"]];
    if (![getCurrentUid() isEqualToString:actId]) {
        _baoMingManagerButton.hidden = YES;
    }else{
        _baoMingManagerButton.hidden = NO;
        if(signuplist.count == 0){
            _baoMingTitleLabel.text = @"还没有人报名哦";
        }
    }
    
    //0
    if (signuplist.count == 0) {
        //不需要执行以下，直接返回
        _baoMingView.frame = CGRectMake(0, 0, kDeviceWidth, 40);
        return;
    }
    
    //清空原来的头像
    for (UIView *view in _baoMingPersonView.subviews){
        [view removeFromSuperview];
    }
    
    //显示加入者的头像
    float imgWidth = (kScreenWidth-20)/9;
    if (signuplist.count>0 && signuplist.count<9) {
        _baoMingPersonView.frame = CGRectMake(0,40, kScreenWidth, imgWidth);
    }
    
    if (signuplist.count>9) {
        _baoMingPersonView.frame = CGRectMake(0, 40, kScreenWidth, imgWidth *2);
    }
    
    
    //创建头像按钮需要的头像链接
    NSMutableArray *baomingArray = @[].mutableCopy;
    if ([signuplist isKindOfClass:[NSArray class]]) {
        for (int i=0; i<signuplist.count; i++) {
            NSDictionary *diction = signuplist[i];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSString *headerURL = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
                [baomingArray addObject:headerURL];
            }
        }
    }
    
    //最多显示18个
    int appearCount = (int)baomingArray.count;
    if (appearCount>18) {
        appearCount = 18;
    }
    
    if (0<appearCount && appearCount<9) {
        //左边间距
        CGFloat leftPadding = (kDeviceWidth - 20 -imgWidth*appearCount)/2;
        //布局头像
        for (int i = 0 ; i<appearCount; i++) {
            //头像
            UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(10+leftPadding+5+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            
            avatarImg.clipsToBounds = YES;
            avatarImg.layer.cornerRadius = (imgWidth-10)/2;
            NSString *imgUrlString = [NSString stringWithFormat:@"%@%@",getSafeString(baomingArray[i]),[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
            [avatarImg sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"unloadHead"]];
            
            [_baoMingPersonView addSubview:avatarImg];
            //按钮
            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [clickBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
            [clickBtn setFrame:CGRectMake(10+leftPadding+5+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            [clickBtn setTag:i];
            [_baoMingPersonView addSubview:clickBtn];
            
        }
    }else{
        for (int i=0; i<appearCount; i++) {
            UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [clickBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
            [clickBtn setFrame:CGRectMake(15+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            [clickBtn setTag:i];
            
            UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(15+imgWidth*i, 0, imgWidth-10, imgWidth-10)];
            if (i>8) {
                avatarImg.frame = CGRectMake(15+imgWidth*(i-9), imgWidth, imgWidth-10, imgWidth-10);
                [clickBtn setFrame:CGRectMake(15+imgWidth*(i-9), imgWidth, imgWidth-10, imgWidth-10)];
            }
            avatarImg.clipsToBounds = YES;
            avatarImg.layer.cornerRadius = (imgWidth-10)/2;
            [avatarImg sd_setImageWithURL:[NSURL URLWithString:baomingArray[i]] placeholderImage:[UIImage imageNamed:@""]];
            [_baoMingPersonView addSubview:avatarImg];
            [_baoMingPersonView addSubview:clickBtn];
        }
    }
     //确定报名视图的大小
    _baoMingView.frame = CGRectMake(0, 0, kDeviceWidth, 40+_baoMingPersonView.height);
    
}

//设置群聊视图
- (void)handle_qunLiaoView{
    _qunLiaoControl.frame = CGRectMake(0, _baoMingView.bottom, kDeviceWidth, 50);
    _qunLiaoImgView.frame = CGRectMake(_leftPadding,15, 20, 20);
    _qunLiaoTxtLabel.frame = CGRectMake(_qunLiaoImgView.right +10, 10, 100, 30);
    
    //人数，靠右
    _qunLiaoCoutLabel.frame = CGRectMake(kDeviceWidth -_leftPadding - 25 -150, 10, 150, 30);
    //_qunLiaoCoutLabel.text = [NSString stringWithFormat:@"%ld人已参加",getSafeString([_dataDic[@"signuplist"] count])];
     _qunLiaoCoutLabel.text = [NSString  stringWithFormat:@"%ld人已参加",(unsigned long)[_dataDic[@"signuplist"] count]];
 
    //箭头
    _enterQunLiaoImgView.frame = CGRectMake(kDeviceWidth -_leftPadding -25 ,12.5, 25, 25);
    
    //进入群聊
    [_qunLiaoControl addTarget:self action:@selector(enterQunLiao:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 响应事件的处理
//点击头像
 - (void)clickHead:(UIButton *)sender
 {
     NSArray *signuplist = _dataDic[@"signuplist"];
     int index = (int)sender.tag;
     
     if (signuplist.count>index) {
     NSDictionary *dic = signuplist[index];
     NSString *userName = dic[@"nickname"];
     NSString *uid =  dic[@"uid"];
     
     NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
     newMyPage.currentTitle = userName;
     newMyPage.currentUid = uid;
     
     [self.superVC.customTabBarController hidesTabBar:YES animated:NO];
     [self.superVC.navigationController pushViewController:newMyPage animated:YES];
 }
 
 }



 //进入群聊
 - (void)enterQunLiao:(UIControl *)ctrl{
     //活动发布者的id
     NSString *actId = [NSString stringWithFormat:@"%@",_dataDic[@"publisher"][@"uid"]];
     //操作码
     NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(_dataDic[@"optionCode"])];
     //状态名称
     NSString *statusName = [NSString stringWithFormat:@"%@",getSafeString(_dataDic[@"statusName"])];
     
     if ([actId isEqualToString:getCurrentUid()]) {
         //当前是管理员，判定待审核状态不能进入聊天界面
         if ([statusName isEqualToString:@"待审核"]) {
             [LeafNotification showInController:self.superVC withText:@"活动待审核，群聊未开启"];
             return;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             //NSString *groupId = @"1440722708409";
             //99487865582387776
             NSString *groupId = [NSString stringWithFormat:@"%@",getSafeString(_dataDic[@"chart_id"])];
             NSString *title = [NSString stringWithFormat:@"%@",getSafeString(_dataDic[@"title"])];
             ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupId isGroup:YES];
             chatController.title = title;
             [self.superVC.customTabBarController hidesTabBar:YES animated:NO];
             [self.superVC.navigationController pushViewController:chatController animated:YES];
         });
     }else
     {
         //当前不是管理员
         if ([optionCode isEqualToString:@"-1"]) {
             //活动过期
             [LeafNotification showInController:self.superVC withText:_dataDic[@"statusName"]];
             return;
         }else if ([optionCode isEqualToString:@"1"]||[optionCode isEqualToString:@"3"]) { //报名
             NewActivityGroupNotSignViewController *talk = [[NewActivityGroupNotSignViewController alloc] initWithNibName:@"NewActivityGroupNotSignViewController" bundle:[NSBundle mainBundle]];
             talk.eventId = [NSString stringWithFormat:@"%@",_dataDic[@"id"]];
             talk.chatId = [NSString stringWithFormat:@"%@",_dataDic[@"chart_id"]];
             talk.chatTitle = [NSString stringWithFormat:@"%@",_dataDic[@"title"]];
             //给定活动类型
             talk.typeNum = self.typeNum;
             talk.dataDic = self.dataDic;
             [self.superVC.customTabBarController hidesTabBar:YES animated:NO];
             [self.superVC.navigationController pushViewController:talk animated:YES];
         }else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //    NSString *groupId = @"1440722708409";
                 NSString *chatEnable = [NSString stringWithFormat:@"%@",getSafeString(_dataDic[@"chatEnable"])];
                 if ([chatEnable isEqualToString:@"1"]) {
                     NSString *groupId = [NSString stringWithFormat:@"%@",getSafeString(_dataDic[@"chart_id"])];
                     NSString *title = [NSString stringWithFormat:@"%@",getSafeString(_dataDic[@"title"])];
                     
                     ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupId isGroup:YES];
                     chatController.title = title;
                     [self.superVC.navigationController pushViewController:chatController animated:YES];
                 }else{
                     
                 }
             });
         }
     }
 }
 
 
 
//报名管理
- (void)baoMingManageClick:(UIButton *)btn{
    NSLog(@"baomingGuangli");
    ManageActivityViewController *manage = [[ManageActivityViewController alloc] initWithNibName:@"ManageActivityViewController" bundle:[NSBundle mainBundle]];
    NSString *eventId = getSafeString(_dataDic[@"id"]);
    manage.eventId = eventId;
    [self.superVC.navigationController pushViewController:manage animated:YES];
}


//返回单元格高度
+ (CGFloat)getActivityDetailMemberCellHeight:(NSDictionary *)dataDic{
    CGFloat leftPadding = 20;
    //报名详情的高度
    NSArray *signuplist = dataDic[@"signuplist"];
    if (signuplist.count == 0) {
        return  50;
    }else{
        //显示加入者的头像
        float imgWidth = (kScreenWidth- leftPadding *2 )/9;
        
        if (signuplist.count>0 && signuplist.count<10) {
            return 40 + imgWidth +5 +50;
         }
        if (signuplist.count>9) {
            return 40 + imgWidth*2 +5 +50;
         }
    }
    return 0;
}


@end
