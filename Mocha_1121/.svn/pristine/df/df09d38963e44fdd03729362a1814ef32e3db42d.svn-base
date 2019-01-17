//
//  NewActivityDetailHeaderView.m
//  Mocha
//
//  Created by sun on 15/8/25.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewActivityDetailHeaderView.h"
#import "NewActivityGroupNotSignViewController.h"
#import "ChatViewController.h"
#import "ManageActivityViewController.h"
@implementation NewActivityDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)initViewWithData:(NSDictionary *)diction
{
    
    self.dataDiction = diction;
    
    [self getFirstView:self.dataDiction];
    
    [self getSecondView:self.dataDiction];
    
    [self getThirdView:self.dataDiction];
    
    [self getFourthView:self.dataDiction];
    
    [self getFifthView:self.dataDiction];
    
    [self getSixthView:self.dataDiction];
    
    [self getSeventhView:self.dataDiction];
}

- (void)getFirstView:(NSDictionary *)diction
{
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    id imgArr = diction[@"img"];
    if (![imgArr isKindOfClass:[NSArray class]]) {
        imgArr = @[].mutableCopy;
    }
    NSMutableArray *imageURLs = imgArr;
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:[imageURLs count]];
    for (int i = 0; i < [imageURLs count]; i++)
    {
        NSInteger wid = kScreenWidth * 2;
        NSInteger hei = (NSInteger)230 * 2;
        NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
        NSString *url = [NSString stringWithFormat:@"%@%@",imageURLs[i],jpg];
        
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"" image:url tag:i];
        [itemArray addObject:item];
    }
    
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:firstView.bounds delegate:self imageItems:itemArray isAuto:NO isDisappear:YES];

    [bannerView scrollToIndex:0];
    [firstView addSubview:bannerView];
    
    self.imagesView.frame = firstView.frame;
    [self.imagesView addSubview:firstView];
    if (imageURLs.count==0) {
        self.imagesView.frame = CGRectMake(0, 0, 0, 0);
    }
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{

}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(NSInteger)index
{

}

- (void)setSecondViewText:(NSDictionary *)diction
{
    self.info_title.text = getSafeString(diction[@"title"]);
    self.info_feiyong.text = [NSString stringWithFormat:@"%@元/天",getSafeString(diction[@"payment"])];
    self.info_peopleNumber.text = [NSString stringWithFormat:@"%@人",getSafeString(diction[@"number"])];
    self.info_time.text = [NSString stringWithFormat:@"%@至%@",getSafeString(diction[@"startdate"]),getSafeString(diction[@"enddate"])];
    NSString *province = getSafeString(diction[@"provinceName"]);
    NSString *city = getSafeString(diction[@"cityName"]);
    NSString *activityArea = [NSString stringWithFormat:@"%@%@%@",province,city,getSafeString(diction[@"address"])];
    self.info_address.text = activityArea;
    self.info_sex.text = getSafeString(diction[@"sex"]);
    self.info_baomingjiezhi.text = [NSString stringWithFormat:@"%@",getSafeString(diction[@"last_enrol_date"])];
    self.info_name.text = getSafeString(diction[@"publisher"][@"nickname"]);
    self.info_renzhengType.text = getSafeString(diction[@"publisher"][@"user_type"]);
    self.info_shenfen.text = getSafeString(diction[@"user_type"]);
    NSString *headerUrl = getSafeString([NSString stringWithFormat:@"%@",diction[@"publisher"][@"head_pic"]]);
    [self.info_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"head60"]];

    [self.info_submitButton setTitle:getSafeString(self.dataDiction[@"statusName"]) forState:UIControlStateNormal];

    NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"optionCode"])];
    if ([optionCode isEqualToString:@"1"]) { //立即报名
        [self.info_submitButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    }else if([optionCode isEqualToString:@"2"]) //评价活动
    {
        [self.info_submitButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];

    }else if([optionCode isEqualToString:@"-1"]) //已报名 不可点击
    {
        [self.info_submitButton setBackgroundColor:[UIColor lightGrayColor]];

    }else
    {
        [self.info_submitButton setBackgroundColor:RGB(157, 198, 83)];

    }
    self.huodongqunliao.layer.cornerRadius = 5;
}

- (void)getSecondView:(NSDictionary *)diction
{
    [self setSecondViewText:diction];

    self.informationView.frame = CGRectMake(0, self.imagesView.frame.size.height, kScreenWidth, self.informationView.frame.size.height);
    self.info_title.frame = CGRectMake(15, 0, kScreenWidth-30, 41);
    self.info_firstLine.frame = CGRectMake(0, 40, kScreenWidth, 0.5);
    self.info_feiyong.frame = CGRectMake(86, 49, kScreenWidth-100, 21);
    self.info_feiyong.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    self.info_peopleNumber.frame = CGRectMake(86, 78, kScreenWidth-100, 21);
    self.info_time.frame = CGRectMake(86, 107, kScreenWidth-100, 21);
    self.info_address.frame = CGRectMake(86, 130, kScreenWidth-100, 34);
    self.info_sex.frame = CGRectMake(86, 171, kScreenWidth-100, 21);
    self.info_baomingjiezhi.frame = CGRectMake(86, 229, kScreenWidth-100, 21);
    float perH = 35;
    self.info_shenfen.frame = CGRectMake(86, 200, kScreenWidth-100, 21);
    self.info_secondLine.frame = CGRectMake(0, 226+perH, kScreenWidth, 0.5);
    self.info_headerImageView.layer.cornerRadius = 18.5;
    self.info_fabuButton.frame = CGRectMake(8, 233+perH, 275, 34);
    self.info_fabuArrow.frame = CGRectMake(kScreenWidth-30, 236+perH, 30, 30);
    NSString *nameString = self.info_name.text;
    float nameWidth = [SQCStringUtils getTxtLength:nameString font:15 limit:200];
    self.info_name.frame = CGRectMake(131, 239+perH, nameWidth, 21);
    self.info_renzhengType.layer.cornerRadius = 5;
    NSString *renzhengString = self.info_renzhengType.text;
    float renzhengWidth = [SQCStringUtils getTxtLength:renzhengString font:14 limit:100];
    self.info_renzhengType.frame = CGRectMake(self.info_name.frame.origin.x+nameWidth+10, 240+perH, renzhengWidth, 21);
    self.info_submitButton.frame = CGRectMake(0, 276, kScreenWidth, 0);
    self.info_submitButton.hidden = YES;
    NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    NSString *actId = [NSString stringWithFormat:@"%@",self.dataDiction[@"publisher"][@"uid"]];
    NSString *vip = [NSString stringWithFormat:@"%@",self.dataDiction[@"publisher"][@"vip"]];
    if ([vip isEqualToString:@"1"]) {
        self.jiaVView.hidden = NO;
    }else
    {
        self.jiaVView.hidden = YES;

    }
    if ([uid isEqualToString:actId]) {
//        self.info_submitButton.frame = CGRectMake(0, 276, kScreenWidth, 0);
//        self.info_submitButton.hidden = YES;
//        self.informationView.frame = CGRectMake(0, self.imagesView.frame.size.height, kScreenWidth, self.informationView.frame.size.height-47);

    }
    self.info_submitButton.frame = CGRectMake(0, 276, kScreenWidth, 0);
    self.info_submitButton.hidden = YES;
    self.informationView.frame = CGRectMake(0, self.imagesView.frame.size.height, kScreenWidth, self.informationView.frame.size.height-27);

}

- (void)getThirdView:(NSDictionary *)diction
{
    
    NSString *number = [NSString stringWithFormat:@"%@",getSafeString(diction[@"chart_id"])];
    self.talk_peopleNumber.text = [NSString stringWithFormat:@"%@人",getSafeString(diction[@"signcount"])];
    self.talk_peopleNumber.layer.cornerRadius = 3;
    self.talkView.frame = CGRectMake(0,self.informationView.frame.origin.y+self.informationView.frame.size.height+10, kScreenWidth, self.talkView.frame.size.height);
    self.talk_peopleNumber.frame = CGRectMake(115, 19, 50, 21);
    self.talk_firstLine.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    self.talk_arrowImageView.frame = CGRectMake(kScreenWidth-30, 15, 30, 30);
    self.talk_secondLine.frame = CGRectMake(0, 58.5, kScreenWidth, 0.5);
//    if ([number isEqualToString:@""]) {
//        self.talkView.frame = CGRectMake(0,self.informationView.frame.origin.y+self.informationView.frame.size.height+10, kScreenWidth, 0);
//        self.talkView.hidden = YES;
//    }
}



- (void)getFourthView:(NSDictionary *)diction
{
    
    self.deacriptionView.frame = CGRectMake(0,self.talkView.frame.origin.y+self.talkView.frame.size.height, kScreenWidth, self.deacriptionView.frame.size.height);
    
}

- (void)setFifthViewText:(NSDictionary *)diction
{
    self.desc_jianjie.text = getSafeString(diction[@"content"]);
    
    self.desc_baomingrenshu.text = getSafeString(diction[@"signcount"]);
    
    NSMutableArray *baomingArray = @[].mutableCopy;

    NSArray *signuplist = self.dataDiction[@"signuplist"];
    if ([signuplist isKindOfClass:[NSArray class]]) {
        for (int i=0; i<signuplist.count; i++) {
            NSDictionary *diction = signuplist[i];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSString *headerURL = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
                [baomingArray addObject:headerURL];
            }
        }
    }
    
    int appearCount = (int)baomingArray.count;
    if (appearCount>18) {
        appearCount = 18;
    }
    float imgWidth = (kScreenWidth-20)/9;

    for (int i=0; i<appearCount; i++) {
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clickBtn addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
        [clickBtn setFrame:CGRectMake(15+imgWidth*i, 15, imgWidth-10, imgWidth-10)];
        [clickBtn setTag:i];
        UIImageView *avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(15+imgWidth*i, 15, imgWidth-10, imgWidth-10)];
        if (i>8) {
            avatarImg.frame = CGRectMake(15+imgWidth*(i-9), 15+imgWidth, imgWidth-10, imgWidth-10);
            [clickBtn setFrame:CGRectMake(15+imgWidth*(i-9), 15+imgWidth, imgWidth-10, imgWidth-10)];

        }
        avatarImg.clipsToBounds = YES;
        avatarImg.layer.cornerRadius = (imgWidth-10)/2;
        [avatarImg sd_setImageWithURL:[NSURL URLWithString:baomingArray[i]] placeholderImage:[UIImage imageNamed:@""]];
        [self.desc_headImagesView addSubview:avatarImg];
        [self.desc_headImagesView addSubview:clickBtn];
        
    }
    
}

- (void)clickHead:(UIButton *)sender
{
    NSArray *signuplist = self.dataDiction[@"signuplist"];
    int index = (int)sender.tag;
    if (signuplist.count>index) {
        NSDictionary *dic = signuplist[index];
        
        NSString *userName = dic[@"nickname"];
        NSString *uid =  dic[@"uid"];
        
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.currentTitle = userName;
        newMyPage.currentUid = uid;
        [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
        
        [self.supCon.navigationController pushViewController:newMyPage animated:YES];
        
    }
    
}

- (void)getFifthView:(NSDictionary *)diction
{
    [self setFifthViewText:diction];
    
    NSArray *signuplist = self.dataDiction[@"signuplist"];

    self.activityDescView.frame = CGRectMake(0,self.deacriptionView.frame.origin.y+self.deacriptionView.frame.size.height, kScreenWidth, self.activityDescView.frame.size.height);
    self.desc_firstLline.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    float jianjieHeight = [SQCStringUtils getStringHeight:self.desc_jianjie.text width:kScreenWidth-10 font:14];
    self.desc_jianjie.frame = CGRectMake(15, 10, kScreenWidth-30, jianjieHeight);
    self.desc_secondLine.frame = CGRectMake(0, self.desc_jianjie.frame.origin.y+self.desc_jianjie.frame.size.height+20, kScreenWidth, 0.5);
    self.desc_baomingrenshu.frame = CGRectMake(92, self.desc_secondLine.frame.origin.y+9, 38, 24);
    
    self.desc_baomingTitle.frame = CGRectMake(135, self.desc_secondLine.frame.origin.y+11, 51, 21);
    self.desc_baomingButton.frame = CGRectMake(kScreenWidth-70, self.desc_secondLine.frame.origin.y+6, 60, 30);
    NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    NSString *actId = [NSString stringWithFormat:@"%@",self.dataDiction[@"publisher"][@"uid"]];
    if (![uid isEqualToString:actId]) {
        self.desc_baomingrenshu.frame = CGRectMake(92, self.desc_secondLine.frame.origin.y+9, 38, 0);
        self.desc_baomingrenshu.hidden = YES;
        self.desc_baomingTitle.text = @"快来报名吧";
        if (signuplist.count>0) {
            self.desc_baomingTitle.text = [NSString stringWithFormat:@"%lu人报名",(unsigned long)signuplist.count];

        }
        self.desc_baomingTitle.frame = CGRectMake(135, self.desc_secondLine.frame.origin.y+9, 100, 21);
        self.desc_baomingTitle.center = CGPointMake(kScreenWidth/2, self.desc_secondLine.frame.origin.y+9+10);
        self.desc_baomingButton.hidden = YES;
    }
    self.desc_thirdLine.frame = CGRectMake(0, self.desc_baomingTitle.frame.origin.y+self.desc_baomingTitle.frame.size.height+10, kScreenWidth, 0.5);
    self.desc_headImagesView.frame = CGRectMake(0, self.desc_thirdLine.frame.origin.y+1, kScreenWidth, 90);

    if (signuplist.count<9) {
        self.desc_headImagesView.frame = CGRectMake(0, self.desc_thirdLine.frame.origin.y+1, kScreenWidth, 45);
        
    }
    if (signuplist.count==0) {
        self.desc_headImagesView.frame = CGRectMake(0, self.desc_thirdLine.frame.origin.y+1, kScreenWidth, 0);
        
    }
    self.activityDescView.frame = CGRectMake(0,self.deacriptionView.frame.origin.y+self.deacriptionView.frame.size.height, kScreenWidth, self.desc_headImagesView.frame.size.height+self.desc_headImagesView.frame.origin.y+10);
    
    
}

- (void)getSixthView:(NSDictionary *)diction
{
    self.commentTitleView.frame = CGRectMake(0,self.activityDescView.frame.origin.y+self.activityDescView.frame.size.height, kScreenWidth, self.commentTitleView.frame.size.height);
    self.com_leaveMessage.frame = CGRectMake(kScreenWidth-70, 3, 60, 30);
    self.com_leaveMessageImageView.frame = CGRectMake(kScreenWidth-85, 12, 12, 12);
    self.com_firstLine.frame = CGRectMake(0, 35.5, kScreenWidth, 0.5);
}

- (void)getSeventhView:(NSDictionary *)diction
{
    self.clickCommentView.frame = CGRectMake(0,self.commentTitleView.frame.origin.y+self.commentTitleView.frame.size.height, kScreenWidth, self.clickCommentView.frame.size.height);
    
    
    self.frame = CGRectMake(0, 0, kScreenWidth, self.commentTitleView.frame.origin.y+self.commentTitleView.frame.size.height+44);
}

#pragma mark - uialertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==1) {

        NSString *eventId = getSafeString(self.dataDiction[@"id"]);
        NSDictionary *params = [AFParamFormat formatEventSignUpParams:eventId];
        [AFNetwork eventSignUp:params success:^(id data){
            if ([data[@"status"] integerValue] == kRight) {
                [LeafNotification showInController:self.supCon withText:data[@"msg"]];
                
            }else
            {
                [LeafNotification showInController:self.supCon withText:data[@"msg"]];
            }
        }failed:^(NSError *error){
            
        }];
    }
}

- (IBAction)submitMethod:(id)sender {
    NSLog(@"submitMethod");
    NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"optionCode"])];
    if ([optionCode isEqualToString:@"1"]) { //立即报名
        [[[UIAlertView alloc] initWithTitle:@"" message:@"确定报名?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        return;
        
    
    }else if([optionCode isEqualToString:@"2"]) //评价活动
    {
        
        
        
    }else if([optionCode isEqualToString:@"-1"]) //已报名 不可点击
    {

        
    }else
    {

        
    }
    
}

- (IBAction)baomingGuangli:(id)sender {
    NSLog(@"baomingGuangli");
    ManageActivityViewController *manage = [[ManageActivityViewController alloc] initWithNibName:@"ManageActivityViewController" bundle:[NSBundle mainBundle]];
    NSString *eventId = getSafeString(self.dataDiction[@"id"]);
    manage.eventId = eventId;
    [self.supCon.navigationController pushViewController:manage animated:YES];
    
}

- (IBAction)woyaoLiuYan:(id)sender {
    NSLog(@"woyaoLiuYan");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appearCommentView" object:nil userInfo:@{@"replay":@"0"}];
}

- (IBAction)gotoActivityTalk:(id)sender {
    NSLog(@"gotoActivityTalk");

    

    NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    NSString *actId = [NSString stringWithFormat:@"%@",self.dataDiction[@"publisher"][@"uid"]];
    if ([uid isEqualToString:actId]) {
        
        NSString *statusName = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"statusName"])];
        if ([statusName isEqualToString:@"待审核"]) {

            [LeafNotification showInController:self.supCon withText:@"活动待审核，群聊未开启"];
            
            return;
         }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //    NSString *groupId = @"1440722708409";
            //99487865582387776
            NSString *groupId = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"chart_id"])];
            NSString *title = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"title"])];
            
            ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupId isGroup:YES];
            chatController.title = title;
            [self.supCon.navigationController pushViewController:chatController animated:YES];
            
        });
    }else
    {
        NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"optionCode"])];

        if ([optionCode isEqualToString:@"-1"]) { //立即报名
            
            return;
            
            
        }
        if ([optionCode isEqualToString:@"1"]) { //立即报名
            NewActivityGroupNotSignViewController *talk = [[NewActivityGroupNotSignViewController alloc] initWithNibName:@"NewActivityGroupNotSignViewController" bundle:[NSBundle mainBundle]];
            talk.eventId = [NSString stringWithFormat:@"%@",self.dataDiction[@"id"]];
            talk.chatId = [NSString stringWithFormat:@"%@",self.dataDiction[@"chart_id"]];
            talk.chatTitle = [NSString stringWithFormat:@"%@",self.dataDiction[@"title"]];

            [self.supCon.navigationController pushViewController:talk animated:YES];
            
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //    NSString *groupId = @"1440722708409";
                NSString *chatEnable = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"chatEnable"])];
                if ([chatEnable isEqualToString:@"1"]) {
                    NSString *groupId = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"chart_id"])];
                    NSString *title = [NSString stringWithFormat:@"%@",getSafeString(self.dataDiction[@"title"])];
                    
                    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupId isGroup:YES];
                    chatController.title = title;
                    [self.supCon.navigationController pushViewController:chatController animated:YES];
                }
               
                
            });
            
            
        }

    
    }
    
    
}

- (IBAction)gotoPersonalPage:(id)sender {
    

    NSString *userName = self.dataDiction[@"publisher"][@"nickname"];
    NSString *uid = [NSString stringWithFormat:@"%@",self.dataDiction[@"publisher"][@"uid"]];

    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    
    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
}



+ (NewActivityDetailHeaderView *)getNewActivityDetailHeaderView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewActivityDetailHeaderView" owner:self options:nil];
    NewActivityDetailHeaderView *cell = array[0];
    
    return cell;
    
}


- (float)getViewHeight
{
    return self.frame.size.height;
}


@end
