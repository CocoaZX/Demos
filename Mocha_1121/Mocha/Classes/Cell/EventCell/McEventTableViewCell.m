//
//  EventTableViewCell.m
//  Mocha
//
//  Created by renningning on 15-3-19.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McEventTableViewCell.h"
#import "ReadPlistFile.h"
#import "McBottomView.h"

@interface McEventTableViewCell()
{
    BOOL isLike;
    BOOL isSignUp;
    
    McBottomView *barsView;
    NSUInteger type;
    
    UIImageView *vImageView;
    UILabel *vLabel;
}

@end

@implementation McEventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McEventTableViewCell" owner:nil options:nil];
        self = nibs[0];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        allAreaInfoArray = [ReadPlistFile readAreaArray];
        roleTypeDict = [ReadPlistFile getRoleTypes];
        type = 0;
        [self initSubViews];
        [self loadClickView];
    }
    return self;
}

- (void)initSubViews
{
    [bgHImageView setBackgroundColor:[UIColor colorForHex:kLikeWhiteColor]];
    
    iconImageView.layer.cornerRadius = 20;
    iconImageView.layer.masksToBounds = YES;
    nameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    typeLabel.textColor = [UIColor colorForHex:kLikeGreenDarkColor];
    companyLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    publishTimeLab.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    
    infoLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    
    moneyLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    eventTimeLab.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    areaLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    numberLab.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    
    lineImageView.backgroundColor = [UIColor colorForHex:kLikeLineColor];
    lineImageView2.backgroundColor = [UIColor colorForHex:kLikeLineColor];
    infoLineView.backgroundColor = [UIColor colorForHex:kLikeLineColor];
    
    divisionImageView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaV"]];
    vImageView.frame = CGRectMake(38, 37, 20, 20);
    [self addSubview:vImageView];
    
    vLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    vLabel.textColor = [UIColor colorForHex:kLikeGreenDarkColor];
    vLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:vLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Action

- (IBAction)doTapClick:(id)sender
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpPersonCenter:)]) {
        [self.cellDelegate doJumpPersonCenter:self.itemDict];
    }
}

- (void)setShowType:(NSUInteger)_type
{
    type = _type;
}

- (void)setLookIconHidden:(BOOL)isHidden
{
    lookImageView.hidden = isHidden;
}

//publisher  userlist
- (void)setItemValueWithDict:(NSDictionary *)itemDict publisherKey:(NSString *)key
{
    self.itemDict = itemDict;
//    key = @"publisher";
    if ([key isEqualToString:@"userlist"]) {
        NSString *iconUrl = itemDict[key][0][@"head_pic"];
        NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
        NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head.png"]];
        nameLabel.text = itemDict[key][0][@"nickname"];
        [nameLabel sizeToFit];
        
        NSString *provinceId = itemDict[key][0][@"province"];
        NSString *cityId = itemDict[key][0][@"city"];
        NSString *province = @"";
        NSString *city = @"";
        for (NSDictionary *dicts in allAreaInfoArray) {
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
        
        
        companyLabel.text = [NSString stringWithFormat:@"%@%@",province,city];
        

        typeLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, nameLabel.frame.origin.y, 120, 20);
        
        typeLabel.text = [NSString stringWithFormat:@"|%@",roleTypeDict[itemDict[key][0][@"type"]]];
        NSString *authentication = itemDict[key][0][@"authentication"];
        if ([authentication intValue]>0) {
            vImageView.hidden = NO;
            typeLabel.text = [NSString stringWithFormat:@"|认证%@",roleTypeDict[itemDict[key][0][@"type"]]];
            
        }else
        {
            vImageView.hidden = YES;
            
        }
        publishTimeLab.text = [CommonUtils dateTimeIntervalString:itemDict[@"createline"]];
        
        NSString *logoUrl = itemDict[@"img"];
        infoLabel.text = itemDict[@"content"];
        
        if ([logoUrl length] > 0) {
            float height = kScreenWidth * [itemDict[@"height"] floatValue]/[itemDict[@"width"] floatValue];
            NSString *jpgL = [CommonUtils imageStringWithWidth:kScreenWidth * 2 height:height * 2];
            NSString *urlLogo = [NSString stringWithFormat:@"%@%@",logoUrl,jpgL];
            
            logoImageView.frame = CGRectMake(0, 66, CGRectGetWidth(self.frame), height);
            
            [logoImageView sd_setImageWithURL:[NSURL URLWithString:urlLogo] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
            if(type == 1){
                infoLabel.numberOfLines = 0;
                CGSize size = [CommonUtils sizeFromText:infoLabel.text textFont:kFont16 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
                infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, size.height);
            }
            else{
                infoLabel.numberOfLines = 1;
                infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, 21);
            }
        }
        else{
            logoImageView.frame = CGRectMake(0, 66, CGRectGetWidth(self.frame), 0);
            infoLabel.numberOfLines = 0;
            CGSize size = [CommonUtils sizeFromText:infoLabel.text textFont:kFont16 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
            infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, size.height);
        }
        
        
        //
        infoView.frame = CGRectMake(0, CGRectGetMaxY(infoLabel.frame) + 5, CGRectGetWidth(self.frame), infoView.frame.size.height);
        
        moneyLabel.text = [NSString stringWithFormat:@"%@元/天",itemDict[@"payment"]];
        
        NSString *startDate = [CommonUtils formatDate:@"YYYY-MM-dd" string:itemDict[@"startdate"]];
        NSString *endDate = [CommonUtils formatDate:@"YYYY-MM-dd" string:itemDict[@"enddate"]];
        eventTimeLab.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
        
        
        NSString *provinceId2 = itemDict[@"province"];
        NSString *cityId2 = itemDict[@"city"];
        NSString *province2 = @"";
        NSString *city2 = @"";
        for (NSDictionary *dicts in allAreaInfoArray) {
            if ([dicts[@"id"] integerValue] == [provinceId2 integerValue]) {
                province2 = dicts[@"name"];
                NSArray *citys = dicts[@"citys"];
                for (NSDictionary *cityDict in citys) {
                    if ([cityDict[@"id"] integerValue] == [cityId2 integerValue]) {
                        city2 = cityDict[@"name"];
                    }
                }
            }
        }
        
        areaLabel.text = [NSString stringWithFormat:@"%@%@%@",province2,city2,itemDict[@"address"]];
        
        numberLab.text = [NSString stringWithFormat:@"人数：%@",itemDict[@"number"]];
        
        signNumLabel.text = itemDict[@"signcount"];
        commetNumLabel.text = @"";
        likeNumLabel.text = @"";
        
        isLike = [itemDict[@"islike"] boolValue];
        isSignUp = [itemDict[@"issignup"] boolValue];
        
        
        [barsView setLabel:itemDict[@"likecount"] index:0];
        [barsView setLabel:itemDict[@"commentscount"] index:1];
        [barsView setLabel:itemDict[@"signcount"] index:2];
        
        float width = (kScreenWidth )/3;
        float height = 40;
        
        if (type == 0) {
            [barsView setAllLabel:NO];
            [barsView setAllButtonEnabled:NO];
            McBottomBarItem *item1 = [[McBottomBarItem alloc] initWithFrame:CGRectMake(1, 0, width, height) Image:@"oicon_comment" title:@"留言"];
            item1.clickButton.tag = 1001;
            [item1 clickAddTarget:self action:@selector(doClickTouchUp:)];
            [barsView replaceBarItem:item1 atIndex:1];
            
        }
        else if(type == 1){
            [barsView setAllLabel:YES];
            [barsView setAllButtonEnabled:YES];
            if (isLike) {
                [barsView setImage:@"toolBar1_h" index:0];
//                [barsView setTitleColor:[UIColor colorForHex:kLikeRedColor] index:0];
                
            }
            else{
                [barsView setImage:@"toolBar1_n" index:0];
//                [barsView setTitleColor:[UIColor colorForHex:kLikeGrayColor] index:0];
                
            }
            if (isSignUp) {
                [barsView setTitleColor:[UIColor colorForHex:kLikeRedColor] index:2];
                [barsView setTitle:@"取消" index:2];
            }
            else{
                [barsView setTitleColor:[UIColor colorForHex:kLikeGrayColor] index:2];
                [barsView setTitle:@"报名" index:2];
            }
            
            [barsView setImage:@"toolBar5" index:1];
            
            
            McBottomBarItem *item3 = [[McBottomBarItem alloc] initWithFrame:CGRectMake(2, 0, width, height) Image:@"toolBar5" title:@"分享"];
            item3.clickButton.tag = 1003;
            [item3 clickAddTarget:self action:@selector(doClickTouchUp:)];
            [barsView replaceBarItem:item3 atIndex:1];
        }
        
        
        NSArray *users = itemDict[@"signuplist"];
        if (type == 0) {
            [barsView setAllButtonEnabled:NO];
            [barsView setHidden:NO];
            divisionImageView.hidden = YES;
            signupUsersView.hidden = YES;
            clickView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame), CGRectGetWidth(self.frame), 40);
        }
        else{
            [barsView setAllButtonEnabled:YES];
            [barsView setHidden:NO];
            [self setSignUpUsers:users getHeight:NO];
            divisionImageView.hidden = NO;
            clickView.frame = CGRectMake(0, CGRectGetMaxY(signupUsersView.frame), CGRectGetWidth(self.frame), 40);
            divisionImageView.frame = CGRectMake(0, CGRectGetMaxY(clickView.frame), CGRectGetWidth(self.frame), 5);
            
        }
    }else
    {
        NSString *iconUrl = itemDict[key][@"head_pic"];
        NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
        NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head.png"]];
        nameLabel.text = itemDict[key][@"nickname"];
        [nameLabel sizeToFit];
        
        NSString *provinceId = itemDict[key][@"province"];
        NSString *cityId = itemDict[key][@"city"];
        NSString *province = @"";
        NSString *city = @"";
        for (NSDictionary *dicts in allAreaInfoArray) {
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
        
        companyLabel.text = [NSString stringWithFormat:@"%@%@",province,city];

        typeLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, nameLabel.frame.origin.y, 120, 20);
        typeLabel.text = [NSString stringWithFormat:@"|%@",roleTypeDict[itemDict[key][@"type"]]];
        
        NSString *authentication = itemDict[key][@"authentication"];
        if ([authentication intValue]>0) {
            vImageView.hidden = NO;
            typeLabel.text = [NSString stringWithFormat:@"|认证%@",roleTypeDict[itemDict[key][@"type"]]];

        }else
        {
            vImageView.hidden = YES;
            
        }
        
        publishTimeLab.text = [CommonUtils dateTimeIntervalString:itemDict[@"createline"]];
        
        NSString *logoUrl = itemDict[@"img"];
        infoLabel.text = itemDict[@"content"];
        
        if ([logoUrl length] > 0) {
            float height = kScreenWidth * [itemDict[@"height"] floatValue]/[itemDict[@"width"] floatValue];
            NSString *jpgL = [CommonUtils imageStringWithWidth:kScreenWidth * 2 height:height * 2];
            NSString *urlLogo = [NSString stringWithFormat:@"%@%@",logoUrl,jpgL];
            
            logoImageView.frame = CGRectMake(0, 66, CGRectGetWidth(self.frame), 50);
            
            [logoImageView sd_setImageWithURL:[NSURL URLWithString:urlLogo] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
            
            if(type == 1){
                infoLabel.numberOfLines = 0;
                CGSize size = [CommonUtils sizeFromText:infoLabel.text textFont:kFont16 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
                infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, size.height);
            }
            else{
                infoLabel.numberOfLines = 1;
                infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, 21);
            }
        }
        else{
            logoImageView.frame = CGRectMake(0, 66, CGRectGetWidth(self.frame), 0);
            infoLabel.numberOfLines = 0;
            CGSize size = [CommonUtils sizeFromText:infoLabel.text textFont:kFont16 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
            infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, size.height);
        }
        
        
        //
        infoView.frame = CGRectMake(0, CGRectGetMaxY(infoLabel.frame) + 5, CGRectGetWidth(self.frame), infoView.frame.size.height);
        
        moneyLabel.text = [NSString stringWithFormat:@"%@元/天",itemDict[@"payment"]];
        
        NSString *startDate = [CommonUtils formatDate:@"YYYY-MM-dd" string:itemDict[@"startdate"]];
        NSString *endDate = [CommonUtils formatDate:@"YYYY-MM-dd" string:itemDict[@"enddate"]];
        eventTimeLab.text = [NSString stringWithFormat:@"%@至%@",startDate,endDate];
        
        if ([itemDict[@"status"] integerValue] == 3) {
            lookImageView.hidden = NO;
            [lookImageView setImage:[UIImage imageNamed:@"event009"]];
        }
        else if ([itemDict[@"status"] integerValue] == 0){
            lookImageView.hidden = NO;
            [lookImageView setImage:[UIImage imageNamed:@"event008"]];
        }
        else {
            lookImageView.hidden = YES;
        }
        
        NSString *provinceId2 = itemDict[@"province"];
        NSString *cityId2 = itemDict[@"city"];
        NSString *province2 = @"";
        NSString *city2 = @"";
        for (NSDictionary *dicts in allAreaInfoArray) {
            if ([dicts[@"id"] integerValue] == [provinceId2 integerValue]) {
                province2 = dicts[@"name"];
                NSArray *citys = dicts[@"citys"];
                for (NSDictionary *cityDict in citys) {
                    if ([cityDict[@"id"] integerValue] == [cityId2 integerValue]) {
                        city2 = cityDict[@"name"];
                    }
                }
            }
        }
        
        areaLabel.text = [NSString stringWithFormat:@"%@%@%@",province2,city2,itemDict[@"address"]];
        
        numberLab.text = [NSString stringWithFormat:@"人数：%@",itemDict[@"number"]];
        
        signNumLabel.text = itemDict[@"signcount"];
        commetNumLabel.text = @"";
        likeNumLabel.text = @"";
        
        isLike = [itemDict[@"islike"] boolValue];
        isSignUp = [itemDict[@"issignup"] boolValue];
        
        
        [barsView setLabel:itemDict[@"likecount"] index:0];
        [barsView setLabel:itemDict[@"commentscount"] index:1];
        [barsView setLabel:itemDict[@"signcount"] index:2];
        
        float width = (kScreenWidth -0)/3;
        float height = 40;
        
        if (type == 0) {
            [barsView setAllLabel:NO];
            [barsView setAllButtonEnabled:NO];
            McBottomBarItem *item1 = [[McBottomBarItem alloc] initWithFrame:CGRectMake(1, 0, width, height) Image:@"oicon_comment" title:@"留言"];
            item1.clickButton.tag = 1001;
            [item1 clickAddTarget:self action:@selector(doClickTouchUp:)];
            [barsView replaceBarItem:item1 atIndex:1];
            
        }
        else if (type == 1) {
            [barsView setAllLabel:YES];
            [barsView setAllButtonEnabled:YES];
            if (isLike) {
                [barsView setImage:@"toolBar1_h" index:0];
//                [barsView setTitleColor:[UIColor colorForHex:kLikeRedColor] index:0];
                
            }
            else{
                [barsView setImage:@"toolBar1_n" index:0];
//                [barsView setTitleColor:[UIColor colorForHex:kLikeGrayColor] index:0];
                
            }
            
            if (isSignUp) {
                [barsView setTitleColor:[UIColor colorForHex:kLikeRedColor] index:2];
                [barsView setTitle:@"取消" index:2];
            }
            else{
                [barsView setTitleColor:[UIColor colorForHex:kLikeGrayColor] index:2];
                [barsView setTitle:@"报名" index:2];
            }
            
            [barsView setImage:@"toolBar5" index:1];
            
            McBottomBarItem *item3 = [[McBottomBarItem alloc] initWithFrame:CGRectMake(2, 0, width, height) Image:@"toolBar5" title:@"分享"];
            item3.clickButton.tag = 1003;
            [item3 clickAddTarget:self action:@selector(doClickTouchUp:)];
            [barsView replaceBarItem:item3 atIndex:1];
        }
        
        
        NSArray *users = itemDict[@"signuplist"];
        if (type == 0) {
            [barsView setAllButtonEnabled:NO];
            [barsView setHidden:NO];
            divisionImageView.hidden = YES;
            signupUsersView.hidden = YES;
            clickView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame), CGRectGetWidth(self.frame), 40);
        }
        else{
            [barsView setAllButtonEnabled:YES];
            [barsView setHidden:NO];
            [self setSignUpUsers:users getHeight:NO];
            divisionImageView.hidden = NO;
            clickView.frame = CGRectMake(0, CGRectGetMaxY(signupUsersView.frame), CGRectGetWidth(self.frame), 40);
            divisionImageView.frame = CGRectMake(0, CGRectGetMaxY(clickView.frame), CGRectGetWidth(self.frame), 5);
            
        }
    }
    [barsView setAllButtonEnabled:YES];

}

- (void)loadClickView
{
    float width = (kScreenWidth)/3;
    float height = 40;
    
    barsView = [[McBottomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    
    McBottomBarItem *item = [[McBottomBarItem alloc] initWithFrame:CGRectMake(0, 0, width, height) Image:@"toolBar1_n" title:@"点赞"];
    item.clickButton.tag = 1000;
    [item clickAddTarget:self action:@selector(doClickTouchUp:)];
    McBottomBarItem *item1 = [[McBottomBarItem alloc] initWithFrame:CGRectMake(1, 0, width, height) Image:@"oicon_comment" title:@"留言"];
    item1.clickButton.tag = 1001;
    [item1 clickAddTarget:self action:@selector(doClickTouchUp:)];
    McBottomBarItem *item2 = [[McBottomBarItem alloc] initWithFrame:CGRectMake(2, 0, width, height) Image:@"oicon_signup" title:@"报名"];
    item2.clickButton.tag = 1002;
    [item2 clickAddTarget:self action:@selector(doClickTouchUp:)];
    
    
    
    NSArray *barItems = @[item,item1,item2];
    
    [barsView setItems:barItems];
    
    [clickView addSubview:barsView];
}

- (float)setSignUpUsers:(NSArray *)users getHeight:(BOOL)isGet
{
    if ([users count] > 0) {
        float hei = 40;
        if (isGet) {
            signupUsersView.hidden = NO;
            signupUsersView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame) + 5, kScreenWidth, hei);
            return hei + 10;
        }
        
        float x = 8;
        float y = 5;
        float w = 30;
        
        int i = 0;
        float orginX = 0;
        float originY = 0;
        for (NSDictionary *dict in users) {
            NSString *headpic = dict[@"head_pic"];
            NSString *jpgL = [CommonUtils imageStringWithWidth:30 * 2 height:30 * 2];
            NSString *urlLogo = [NSString stringWithFormat:@"%@%@",headpic,jpgL];
            orginX = (x + w) * i + x;
            originY = y;
            if (orginX < kScreenWidth - 100) {
                UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(orginX, y, 30, 30)];
                [headView setImageWithURL:[NSURL URLWithString:urlLogo] placeholderImage:[UIImage imageNamed:@"head.png"] completed:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [signupUsersView addSubview:headView];
                
                i++;
            }
            else{
                break;
            }
        }
//        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(orginX + 40, originY, 30, 30)];
//        [numLabel setBackgroundColor:[UIColor colorForHex:kLikeGrayColor]];
//        [numLabel setTextColor:[UIColor whiteColor]];
//        numLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[users count]]];
//        numLabel.textAlignment = NSTextAlignmentCenter;
//        [signupUsersView addSubview:numLabel];
        
        float ox = orginX + 40;
        if (orginX >= kScreenWidth - 100) {
            ox = orginX;
        }
        UIButton *_signListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signListBtn.frame = CGRectMake(ox, originY, 50, 30);
        [_signListBtn setTitle:@"报名管理" forState:UIControlStateNormal];//报名名单
        [_signListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signListBtn.titleLabel.font = kFont10;
        _signListBtn.layer.cornerRadius = 10;
        _signListBtn.backgroundColor = [UIColor colorForHex:kLikeRedColor];
        [_signListBtn addTarget:self action:@selector(doShowSignList:) forControlEvents:UIControlEventTouchUpInside];
        [signupUsersView addSubview:_signListBtn];
        
        signupUsersView.hidden = NO;
        signupUsersView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame) + 5, kScreenWidth, hei);
        return hei + 10;
    }
    signupUsersView.hidden = YES;
    signupUsersView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame) + 0, CGRectGetWidth(self.frame), 0);
    return 5;
}

- (float)getContentViewHeightWithDict:(NSDictionary *)itemDict
{
    NSString *content = itemDict[@"content"];
    if ([itemDict[@"img"] length] > 0) {
//        float height = kScreenWidth * [itemDict[@"height"] floatValue]/[itemDict[@"width"] floatValue];
        logoImageView.frame = CGRectMake(0, 66, CGRectGetWidth(self.frame), 50);
        
        if (type == 1) {
            infoLabel.numberOfLines = 0;
            CGSize size = [CommonUtils sizeFromText:content textFont:kFont16 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
            infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, size.height);
        }
        else{
            infoLabel.numberOfLines = 1;
            infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, 21);
        }
    }
    else{
        logoImageView.frame = CGRectMake(0, 66, CGRectGetWidth(self.frame), 0);
        infoLabel.numberOfLines = 0;
        CGSize size = [CommonUtils sizeFromText:content textFont:kFont16 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
        infoLabel.frame = CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 5, kScreenWidth - 40, size.height);
    }
    
    infoView.frame = CGRectMake(0, CGRectGetMaxY(infoLabel.frame), CGRectGetWidth(self.frame), infoView.frame.size.height);
//    CGRect lineFrame = infoLineView.frame;
//    lineFrame.size.height = 0.5;
//    infoLineView.frame = lineFrame;
    
    float h = 0;
    if (type == 0) {
        clickView.frame = CGRectMake(0, CGRectGetMaxY(infoView.frame), kScreenWidth, 40);
        h = 42;
    }
    else{
        h = [self setSignUpUsers:itemDict[@"signuplist"] getHeight:YES];
        clickView.frame = CGRectMake(0, CGRectGetMaxY(signupUsersView.frame), kScreenWidth, 40);
        divisionImageView.frame = CGRectMake(0, CGRectGetMaxY(clickView.frame), kScreenWidth, 5);
        h += 45;
    }
    
//    [self setNeedsDisplay];
    return CGRectGetMaxY(infoView.frame) + h;
}

#pragma mark Action
- (void)doShowSignList:(id)sender
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doShowSignUpList:)]) {
        [self.cellDelegate doShowSignUpList:_itemDict[@"id"]];
    }
}

- (void)doClickTouchUp:(id)sender
{
    McBottomBarItem *barItem = (McBottomBarItem *)sender;

    if (type == 0) {
        if (barItem.tag == 1000) {
            if (![GlogalState isLogin]) {
                if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpDetail:)]) {
                    [self.cellDelegate doJumpDetail:_itemDict];
                }
            }else
            {
                if (!isLike) {
                    [self addLike];
                }
                else{
                    [self cancelLike];
                }
            }
            
        }else
        {
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpDetail:)]) {
                [self.cellDelegate doJumpDetail:_itemDict];
            }

        }
        return;
    }
//    NSLog(@"event: %ld",barItem.tag);
    if (barItem.tag == 1000) {
        if (!isLike) {
            [self addLike];
        }
        else{
            [self cancelLike];
        }
        
    }
    if (barItem.tag == 1002) {
        
    }
    if (barItem.tag == 1003) {
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doShareTo:)]) {
            [self.cellDelegate doShareTo:_itemDict];
        }
    }
    if (barItem.tag == 1002) {
        if (!isSignUp) {
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"你确认要报名吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertV show];
//            [self signupEvent];
        }
        else{
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"你确认要取消报名吗" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"确定", nil];
            alertV.tag = 10016;
            [alertV show];
//            [self cancelSignupEvent];
        }
    }
}

- (void)addLike
{
    NSString *eid = _itemDict[@"id"];
    NSDictionary *parmas = [AFParamFormat formatEventLikeParams:eid];
    [AFNetwork eventLike:parmas success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            isLike = YES;
//            [barsView setTitleColor:[UIColor colorForHex:kLikeRedColor] index:0];
            [barsView setImage:@"toolBar1_h" index:0];
            NSString *number = [[barsView.buttonItems[0] infoLabel] text];
            if (number.length>0) {
                int likeNum = [number intValue]+1;
                [barsView setLabel:[NSString stringWithFormat:@"%d",likeNum] index:0];

            }
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:@"点赞成功" isReload:YES];
            }
        }
        else{
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:data[@"msg"] isReload:NO];
            }
        }
    }failed:^(NSError *error){
        
    }];
}

- (void)cancelLike
{
    NSString *eid = _itemDict[@"id"];
    NSDictionary *parmas = [AFParamFormat formatEventLikeParams:eid];
    [AFNetwork eventcancelLike:parmas success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            isLike = NO;
//            [barsView setTitleColor:[UIColor colorForHex:kLikeGrayColor] index:0];
            [barsView setImage:@"toolBar1_n" index:0];
            NSString *number = [[barsView.buttonItems[0] infoLabel] text];
            if (number.length>0) {
                int likeNum = [number intValue]-1;
                if (likeNum<0) {
                    likeNum=0;
                }
                [barsView setLabel:[NSString stringWithFormat:@"%d",likeNum] index:0];
                
            }
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:@"取消点赞成功" isReload:NO];
            }
        }
        else{
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:data[@"msg"] isReload:NO];
            }
        }
            
    }failed:^(NSError *error){
        
    }];
}

- (void)signupEvent
{
    NSString *eid = _itemDict[@"id"];
    NSDictionary *params = [AFParamFormat formatEventSignUpParams:eid];
    [AFNetwork eventSignUp:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            isSignUp = YES;
            [barsView setTitleColor:[UIColor colorForHex:kLikeRedColor] index:2];
            [barsView setTitle:@"取消" index:2];
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:@"报名成功" isReload:NO];
            }
        }
        else{
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:data[@"msg"] isReload:NO];
            }
        }
    }failed:^(NSError *error){
        
    }];
}

- (void)cancelSignupEvent
{
    NSString *eid = _itemDict[@"id"];
    NSDictionary *params = [AFParamFormat formatEventCancelSignParams:eid];
    [AFNetwork eventCancelSign:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            isSignUp = NO;
            [barsView setTitleColor:[UIColor colorForHex:kLikeGrayColor] index:2];
            [barsView setTitle:@"报名" index:2];
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:@"取消报名成功" isReload:NO];
            }
            
        }
        else{
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                [self.cellDelegate actionDone:data[@"msg"] isReload:NO];
            }
        }
    }failed:^(NSError *error){
        
    }];
}

#pragma mark
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10016){
        if (buttonIndex == 1) {
            [self cancelSignupEvent];
        }
    }
    else{
        if (buttonIndex == 1) {
            [self signupEvent];
        }
    }
    
}


@end
