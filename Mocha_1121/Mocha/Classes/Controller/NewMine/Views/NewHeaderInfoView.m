//
//  NewHeaderInfoView.m
//  Mocha
//
//  Created by sunqichao on 15/8/30.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewHeaderInfoView.h"
#import "WatchedViewController.h"
#import "FansViewController.h"
#import "NewMyPageViewController.h"
#import "NewTimeLineViewController.h"
#import "McMyFeedListViewController.h"
#import "McRenZhengViewController.h"
#import "McPersonalDataViewController.h"
#import "ReadPlistFile.h"

@implementation NewHeaderInfoView


#pragma mark - 使用数据初始化
//请求网络之后的刷新方法

-(void)awakeFromNib{
    
    _MyPage.text = NSLocalizedString(@"myPage", nil);
    
}


- (void)initViewWithData:(NSDictionary *)diction withDic:(NSDictionary *)dataDic{
    self.dataDic = dataDic;
    [self setDataWithDic:diction];
    [self resetViewsFrame];
}

//- (void)initViewWithData:(NSDictionary *)diction
//{
//    [self setDataWithDic:diction];
//    [self resetViewsFrame];
//}


- (void)setDataWithDic:(NSDictionary *)diction
{
    NSString *headerURL = [NSString stringWithFormat:@"%@",getSafeString(diction[@"headerUrl"])];
    headerURL = [NSString stringWithFormat:@"%@%@",headerURL,[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
    NSString *name = [NSString stringWithFormat:@"%@",getSafeString(diction[@"name"])];
    NSString *sex = [NSString stringWithFormat:@"%@",getSafeString(diction[@"sex"])];
    if ([sex isEqualToString:@"    男"]) {
        self.sexImageView.image = [UIImage imageNamed:@"gender_boy"];
    }else 
    {
        self.sexImageView.image = [UIImage imageNamed:@"gender_girl"];

    }
    NSString *mote = [NSString stringWithFormat:@"%@",getSafeString(diction[@"userType"])];
    NSString *dongtai = [NSString stringWithFormat:@"%@",getSafeString(diction[@"dongtai"])];
    NSString *guanzhu = [NSString stringWithFormat:@"%@",getSafeString(diction[@"guanzhu"])];
    NSString *fensi = [NSString stringWithFormat:@"%@",getSafeString(diction[@"fensi"])];
    NSString *newFansCount = getSafeString(diction[@"newFansCount"]);
    //如果和原来设置的头像链接不同，说明已经更换了头像
    //就使用新数据重新设置头像,会刷新闪动一下
    //本地存在的头像路径
    NSString *tempImgURLString = [NSString stringWithFormat:@"%@",self.headImgURLString];
    if (![headerURL isEqualToString:tempImgURLString] ||(self.headImgURLString.length == 0)){
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    if (![newFansCount isEqualToString:@"0"]) {
        self.redImageView.hidden = NO;
    }else{
        self.redImageView.hidden = YES;
    }
    self.nameLabel.text = name;
    self.sexLabel.text = sex;
    self.userTypeLabel.text = mote;
    self.dongtaiNumLabel.text = dongtai;
    self.guanzhuNumLabel.text = guanzhu;
    self.fensiNumLabel.text = fensi;
    self.MyPage.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
    //地址
    self.addressLabel.text = diction[@"address"];

}



//设置头视图:这是使用本地数据
- (void)initHeadViewWithMokaValue{
    NSDictionary *userDic = [USER_DEFAULT objectForKey:MOKA_USER_VALUE];
    self.dataDic = userDic;
    NSString *headerURL = [NSString stringWithFormat:@"%@%@",getSafeString(userDic[@"head_pic"]),[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
    
    NSString *name = [NSString stringWithFormat:@"%@",getSafeString(userDic[@"nickname"])];
    
    NSString *sex  = userDic[@"sex"];
    
    if ([sex isEqualToString:@"1"]) {
        sex = @"    男";
    }else{
        sex = @"    女";
    }
    
    //性别标识
    if ([sex isEqualToString:@"男"]) {
        self.sexImageView.image = [UIImage imageNamed:@"gender_boy"];
    }else
    {
        self.sexImageView.image = [UIImage imageNamed:@"gender_girl"];
        
    }
    NSString *mote = [NSString stringWithFormat:@"%@",getSafeString(userDic[@"type"])];
    
    //头像
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@""]];
    
    //保存头像地址
    //这里首先设置了头像，等到请求到数据对象之后，
    //如果和这里的头像地址相同就不再更新，如果不同会重新设置头像
    self.headImgURLString = headerURL;
    //昵称
    self.nameLabel.text = name;
    //性别
    self.sexLabel.text = sex;
    //身份
    NSDictionary *dic  = [ReadPlistFile getRoleTypes];
    self.userTypeLabel.text = [dic objectForKey:mote];
    
    [self resetViewsFrame];
    
}



#pragma mark - 视图布局
- (void)layoutSubviews{
    [super layoutSubviews];
}

//视图位置布局
- (void)resetViewsFrame{
    //头像
    self.headerImageView.layer.cornerRadius = 40;
    
    CGFloat nameWidth = [SQCStringUtils getCustomWidthWithText:self.nameLabel.text viewHeight:21 textSize:15];
    //昵称
    self.nameLabel.frame = CGRectMake(108, 28, nameWidth, 21);
    self.sexImageView.frame = CGRectMake(self.nameLabel.right +10, 33, 12, 12);

    self.sexLabel.frame = CGRectMake(108, 65, 32, 17);
    
    //身份类型
    CGFloat userTypeWidth = [SQCStringUtils getCustomWidthWithText:self.userTypeLabel.text viewHeight:21 textSize:13];
    self.userTypeLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom +5, userTypeWidth, 21);
    self.addressLabel.frame = CGRectMake(self.userTypeLabel.right +10, self.nameLabel.bottom +5, 150, 21);
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
    
    //调整认证视图
    self.renZhengView.frame = CGRectMake(15, 85,70 , 21);
    self.renzhengbgImgView.frame = self.renZhengView.bounds;
    self.renzhengbgImgView.userInteractionEnabled = YES;
    self.renzhengImgView.frame = CGRectMake(0, 1.5, 19, 19);
    self.renzhengInfoLabel.frame = CGRectMake(20, 1, 45, 19);
    self.renzhengInfoLabel.adjustsFontSizeToFitWidth = YES;
    self.renzhengBtn.frame = CGRectMake(10, 15, 80, 80);
    NSString *auid = self.dataDic[@"authentication"];
    NSInteger status = [auid integerValue];
    switch (status) {
        case -1://未认证
        {
            self.renZhengView.hidden = NO;
            self.renzhengBtn.hidden = NO;
            self.renzhengImgView.image = [UIImage imageNamed:@"renzhengState_fail"];
            self.renzhengMarkImgView.hidden = YES;
            self.renzhengInfoLabel.text = @"立即认证";
            self.renzhengInfoLabel.textColor = [UIColor lightGrayColor];
        
             break;
        }
        case 0://审核中
        {
            self.renZhengView.hidden = NO;
            self.renzhengBtn.hidden =  NO;
            self.renzhengImgView.image = [UIImage imageNamed:@"renzhengState_fail"];
            self.renzhengMarkImgView.hidden = YES;
            self.renzhengInfoLabel.text = @"审核中";
            self.renzhengInfoLabel.textColor = [CommonUtils colorFromHexString:@"#ffd86a"];
             break;
        }
            
        case -2://认证失败
        {
            self.renZhengView.hidden = NO;
            self.renzhengBtn.hidden = NO;
            self.renzhengImgView.image = [UIImage imageNamed:@"renzhengState_fail"];
            self.renzhengMarkImgView.hidden = YES;
             break;
        }
            
        default://审核成功
        {
            self.renZhengView.hidden = YES;
            self.renzhengBtn.hidden = YES;
            self.renzhengMarkImgView.hidden = NO;
            self.renzhengImgView.image = [UIImage imageNamed:@"renzhengState_success"];
             break;
        }
    }
    
    if(!self.renZhengView.hidden){
        [self bringSubviewToFront:self.renzhengBtn];
    }

    
    self.dongtaiLabel.frame = CGRectMake(kScreenWidth-107, 33, 42, 21);
    self.dongtaiNumLabel.frame = CGRectMake(kScreenWidth-107, 11, 42, 21);
    self.dongtaiButton.frame = CGRectMake(kScreenWidth-107, 11, 42, 47);
    self.guanzhuLabel.frame = CGRectMake(kScreenWidth-57, 33, 42, 21);
    self.guanzhuNumLabel.frame = CGRectMake(kScreenWidth-57, 11, 42, 21);
    self.guanzhuButton.frame = CGRectMake(kScreenWidth-57, 11, 42, 47);
    self.fensiLabel.frame = CGRectMake(kScreenWidth-7, 33, 42, 21);
    self.fensiNumLabel.frame = CGRectMake(kScreenWidth-7, 11, 42, 21);
    self.redImageView.frame = CGRectMake(kScreenWidth - 33, 33, 10, 10);
    self.redImageView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    self.redImageView.layer.cornerRadius = 5;
    self.redImageView.clipsToBounds = YES;

    self.fensiButton.frame = CGRectMake(kScreenWidth-7, 11, 42, 47);
    self.headerClickButton.frame = CGRectMake(0, 0, kScreenWidth, 110);
    self.arrowImgView.frame = CGRectMake(kScreenWidth-30, 45, 20, 20);
    self.MyPage.frame = CGRectMake(kDeviceWidth - 90, 40, 60, 30);
}





#pragma mark - 事件点击
//手势点击头视图，进入到编辑自己资料的界面
- (IBAction)gotoMyPageMethod:(id)sender {
    NSLog(@"gotoDongTaiMethod");
    //又改回来了 进入我的模卡界面
    NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
    
    //修改后：进入编辑资料的界面
    //    McPersonalDataViewController *personalVC = [[McPersonalDataViewController alloc] init];
    //    personalVC.personalData = self.personalData;
    //    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    //    [self.supCon.navigationController pushViewController:personalVC animated:YES];
}


- (IBAction)gotoDongTaiMethod:(id)sender {
    return;

    NSLog(@"gotoDongTaiMethod");
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];

//    NewTimeLineViewController *newMyPage = [[NewTimeLineViewController alloc] initWithNibName:@"NewTimeLineViewController" bundle:[NSBundle mainBundle]];
//    newMyPage.uid= uid;
//    newMyPage.currentTitle = userName;
//    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
//
//    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
    McMyFeedListViewController *newMyPage = [[McMyFeedListViewController alloc] init];
    newMyPage.currentUid = uid;
    newMyPage.currentTitle = userName;
    newMyPage.isPersonDongTai = YES;
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
    
}


- (IBAction)gotoGuanZhuMethod:(id)sender {
    return;
    NSLog(@"gotoGuanZhuMethod");
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];

    WatchedViewController *watch = [[WatchedViewController alloc] initWithNibName:@"WatchedViewController" bundle:[NSBundle mainBundle]];
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    [watch setWatchedDataWithUid:uid];
    watch.isAllowDelete = YES;
    NSString *titleStr = NSLocalizedString(@"me", nil);;
    
    watch.selfTitle = titleStr;
    [self.supCon.navigationController pushViewController:watch animated:YES];
    
}

- (IBAction)gotoFenSiMethod:(id)sender {
    return;
    NSLog(@"gotoFenSiMethod");
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];

    FansViewController *fans = [[FansViewController alloc] init];
    [fans setFansDataWithUid:uid];
    fans.selfTitle = NSLocalizedString(@"me", nil);;
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    [self.supCon.navigationController pushViewController:fans animated:YES];
    
}


#pragma mark - get视图
+ (NewHeaderInfoView *)getNewHeaderInfoView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewHeaderInfoView" owner:self options:nil];
    NewHeaderInfoView *cell = array[0];

    return cell;
}



//请求个人数据,数据是用于跳转到编辑界面时所用
- (void)loadPersonalData
{
    //准备数据
    NSDictionary *sexDict;
    NSDictionary *jobDict;
    NSArray *areaArray;
    NSDictionary *hairDict;
    NSDictionary *majorDict;
    NSDictionary *workTagDict;
    NSDictionary *figureTagDict;
    NSDictionary *feetDict;
    //读取数据
    sexDict = [ReadPlistFile readSex];
    
    areaArray = [ReadPlistFile readAreaArray];
    
//    workTagDict = [ReadPlistFile readWorkTags];
//    
//    figureTagDict = [ReadPlistFile readWorkStyles];
//    
//    hairDict = [ReadPlistFile readHairs];
//    
//    jobDict = [ReadPlistFile readProfession];
//    
//    majorDict = [ReadPlistFile readMajor];
//    
//    feetDict = [ReadPlistFile readFeets];

    NSDictionary *dataDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if (!_personalData) {
        _personalData = [[McPersonalData alloc] init];
    }
    _personalData.nickName = dataDict[@"nickname"];
    _personalData.headUrl = dataDict[@"head_pic"];
    NSString *sexStr = dataDict[@"sex"];
    
    if ([sexStr intValue] == 1) {
        _personalData.sex = @"男";
    }
    else if([sexStr intValue] == 2){
        _personalData.sex = @"女";
    }
    else{
        _personalData.sex = @"";
    }
    _personalData.authentication = dataDict[@"authentication"];
    _personalData.job = [jobDict valueForKey:dataDict[@"job"]];
    _personalData.major = [majorDict valueForKey:dataDict[@"major"]];
    _personalData.height = dataDict[@"height"];
    _personalData.weight = dataDict[@"weight"];
    
    _personalData.age = [dataDict[@"birth"] isEqualToString:@"0000-00-00"]?@"":dataDict[@"birth"];
    
    NSString *provinceId = dataDict[@"province"];
    NSString *cityId = dataDict[@"city"];
    NSString *province = @"";
    NSString *city = @"";
    for (NSDictionary *dicts in areaArray) {
        if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
            province = dicts[@"name"];
            NSArray *citys = dicts[@"citys"];
            for (NSDictionary *cityDict in citys) {
                if ([cityDict[@"id"] integerValue] == [cityId integerValue]) {
                    city = cityDict[@"name"];
                }
            }
        }
    }
    _personalData.area = [NSString stringWithFormat:@"%@%@",getSafeString(dataDict[@"provinceName"]) ,getSafeString(dataDict[@"cityName"])];
    
    _personalData.bust = dataDict[@"bust"];
    _personalData.waist = dataDict[@"waist"];
    _personalData.hips = dataDict[@"hipline"];
    
    _personalData.measurements = [dataDict[@"bust"] integerValue]> 0?[NSString stringWithFormat:@"%@-%@-%@",dataDict[@"bust"],dataDict[@"waist"],dataDict[@"hipline"]]:@"";
    
    _personalData.hair = [[hairDict allKeysForObject:dataDict[@"hair"]] firstObject];
    _personalData.feetCode = [[feetDict allKeysForObject:dataDict[@"foot"]] firstObject];
    _personalData.signName = dataDict[@"mark"];
    _personalData.leg = dataDict[@"leg"];
    
    NSArray *workArr = [dataDict[@"worktags"] componentsSeparatedByString:@","];
    NSMutableString *workStr = [NSMutableString stringWithString:@""];
    for (NSString *key in workArr) {
        [workStr appendString:[NSString stringWithFormat:@"%@ ",workTagDict[key]?workTagDict[key]:@""]];
    }
    
    NSArray *figureArr = [dataDict[@"workstyle"] componentsSeparatedByString:@","];
    NSMutableString *figureStr = [NSMutableString stringWithString:@""];
    for (NSString *key in figureArr) {
        [figureStr appendString:[NSString stringWithFormat:@"%@ ",figureTagDict[key]?figureTagDict[key]:@""]];
    }
    
    if ([figureStr isEqualToString:@" "]) {
        figureStr = [NSMutableString stringWithString:@""];
    }
    if ([workStr isEqualToString:@" "]) {
        workStr = [NSMutableString stringWithString:@""];
    }
    
    _personalData.figureLabel = figureStr;
    _personalData.workExperience = dataDict[@"workhistory"];
    _personalData.introduction = dataDict[@"introduction"];
    _personalData.workPlace = dataDict[@"studio"];
    _personalData.workLabel = workStr;
    _personalData.desiredSalary = dataDict[@"payment"];
}


//认证
- (IBAction)renzhengBtnClick:(id)sender {
    
    NSString *auid = self.dataDic[@"authentication"];
    NSInteger status = [auid integerValue];
    if (status == -1 || status == -2) {
        McRenZhengViewController *renzheng = [[McRenZhengViewController alloc] initWithNibName:@"McRenZhengViewController" bundle:[NSBundle mainBundle]];
         [self.supCon.navigationController pushViewController:renzheng animated:YES];
    }

}




@end
