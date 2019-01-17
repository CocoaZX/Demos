//
//  MokaCardManager.m
//  Mocha
//
//  Created by sun on 15/9/2.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "MokaCardManager.h"

@implementation MokaCardManager

+ (UIView *)getMokaCardWithType:(NSString *)type images:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    UIView *cardView = nil;
    if ([type isEqualToString:@"1"]) {
        //五图经典
        cardView = [self getCardOneViewImages:imagesArr buttons:buttonArr];
        
    }else if([type isEqualToString:@"2"])
    {   //经典六图
        cardView = [self getCardTwoViewImages:imagesArr buttons:buttonArr];

    }else if([type isEqualToString:@"3"])
    {   //九宫格
        cardView = [self getCardThreeViewImages:imagesArr buttons:buttonArr];

    }
    else if([type isEqualToString:@"4"])
    {   //十图
        cardView = [self getCardFourViewImages:imagesArr buttons:buttonArr];
 
    }else if ([type isEqualToString:@"5"]){
        //八图
        cardView = [self getCardFiveViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"6"]){
        //一加六
        cardView = [self getCardSixViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"7"]){
        //一加八
        cardView = [self getCardSevenViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"8"]){
        //新式六图
        cardView = [self getCardEightViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"9"]){
        //上三下三
        cardView = [self getCardNineViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"10"]){
        //新的右大五图
        cardView = [self getCardTenViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"14"]){
        //五图上大
        cardView = [self getCardTwelveViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"11"]){
        //七图中大
        cardView = [self getCardElevenViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"13"]){
        //五图右下二
        cardView = [self getCardThirteenViewImages:imagesArr buttons:buttonArr];
    }else if ([type isEqualToString:@"12"]){
        //简约七图
        cardView = [self getCardFourteenViewImages:imagesArr buttons:buttonArr];
    }
    
    return cardView;
}

//经典六图
+ (UIView *)getCardTwoViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    float contentHeight = kScreenWidth-100;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth/7*3 - 10 - 2, contentHeight-20)];
    leftView.backgroundColor = RGB(204, 204, 204);
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:leftView.bounds];
    leftImageView.contentMode = UIViewContentModeScaleToFill;
    leftImageView.clipsToBounds = YES;
    [leftView addSubview:leftImageView];
    [imagesArr addObject:leftImageView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:leftImageView.frame];
    [leftButton setTag:0];
    [leftButton setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [leftView addSubview:leftButton];
    [buttonArr addObject:leftButton];
    
    [contentView addSubview:leftView];
    
    float perWidth = (kScreenWidth )/7*4 - 8;
    float perHeight = (contentHeight-20 -2)/2;
    
    UIView *right_1_view = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width+10+2, 10, perWidth - 4, perHeight)];
    right_1_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_1_ImageView = [[UIImageView alloc] initWithFrame:right_1_view.bounds];
    right_1_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_1_ImageView.clipsToBounds = YES;
    [right_1_view addSubview:right_1_ImageView];
    [imagesArr addObject:right_1_ImageView];
    UIButton *right_1_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_1_Button setFrame:right_1_ImageView.frame];
    [right_1_Button setTag:1];
    [right_1_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_1_Button setTitle:@"" forState:UIControlStateNormal];
    [right_1_view addSubview:right_1_Button];
    [buttonArr addObject:right_1_Button];
    
    [contentView addSubview:right_1_view];
    
    float perThirdWidth = (perWidth-8)/3;
    
    UIView *right_2_view = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width+10+2, 2 + perHeight+10, perThirdWidth, perHeight)];
    right_2_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_2_ImageView = [[UIImageView alloc] initWithFrame:right_2_view.bounds];
    right_2_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_2_ImageView.clipsToBounds = YES;
    [right_2_view addSubview:right_2_ImageView];
    [imagesArr addObject:right_2_ImageView];
    UIButton *right_2_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_2_Button setFrame:right_2_ImageView.frame];
    [right_2_Button setTag:2];
    [right_2_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_2_Button setTitle:@"" forState:UIControlStateNormal];
    [right_2_view addSubview:right_2_Button];
    [buttonArr addObject:right_2_Button];
    
    [contentView addSubview:right_2_view];
    
    UIView *right_3_view = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width+10+2+perThirdWidth+2, 2+perHeight+10, perThirdWidth, perHeight)];
    right_3_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_3_ImageView = [[UIImageView alloc] initWithFrame:right_3_view.bounds];
    right_3_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_3_ImageView.clipsToBounds = YES;
    [right_3_view addSubview:right_3_ImageView];
    [imagesArr addObject:right_3_ImageView];
    UIButton *right_3_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_3_Button setFrame:right_3_ImageView.frame];
    [right_3_Button setTag:3];
    [right_3_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_3_Button setTitle:@"" forState:UIControlStateNormal];
    [right_3_view addSubview:right_3_Button];
    [buttonArr addObject:right_3_Button];
    
    [contentView addSubview:right_3_view];
    
    UIView *right_4_view = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width+10+2+perThirdWidth+2+perThirdWidth+2, 2+perHeight+10, perThirdWidth, perHeight)];
    right_4_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_4_ImageView = [[UIImageView alloc] initWithFrame:right_4_view.bounds];
    right_4_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_4_ImageView.clipsToBounds = YES;
    [right_4_view addSubview:right_4_ImageView];
    [imagesArr addObject:right_4_ImageView];
    UIButton *right_4_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_4_Button setFrame:right_4_ImageView.frame];
    [right_4_Button setTag:4];
    [right_4_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_4_Button setTitle:@"" forState:UIControlStateNormal];
    [right_4_view addSubview:right_4_Button];
    [buttonArr addObject:right_4_Button];
    
    [contentView addSubview:right_4_view];

    return contentView;
}

//五图经典
+ (UIView *)getCardOneViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    float contentHeight = kScreenWidth - 90;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth/2-10-1, contentHeight-20)];
    leftView.backgroundColor = RGB(204, 204, 204);
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:leftView.bounds];
    leftImageView.contentMode = UIViewContentModeScaleToFill;
    leftImageView.clipsToBounds = YES;
    [leftView addSubview:leftImageView];
    [imagesArr addObject:leftImageView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:leftImageView.frame];
    [leftButton setTag:0];
    [leftButton setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [leftView addSubview:leftButton];
    [buttonArr addObject:leftButton];
    
    [contentView addSubview:leftView];
    
    float perWidth = (kScreenWidth/2-2-10)/2;
    float perHeight = (contentHeight-22)/2;
    
    UIView *right_1_view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2+1, 10, perWidth, perHeight)];
    right_1_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_1_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, perWidth, perHeight)];
    right_1_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_1_ImageView.clipsToBounds = YES;
    [right_1_view addSubview:right_1_ImageView];
    [imagesArr addObject:right_1_ImageView];
    UIButton *right_1_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_1_Button setFrame:right_1_ImageView.frame];
    [right_1_Button setTag:1];
    [right_1_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_1_Button setTitle:@"" forState:UIControlStateNormal];
    [right_1_view addSubview:right_1_Button];
    [buttonArr addObject:right_1_Button];
    
    [contentView addSubview:right_1_view];
    
    UIView *right_2_view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2+1+perWidth+2, 10, perWidth, perHeight)];
    right_2_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_2_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, perWidth, perHeight)];
    right_2_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_2_ImageView.clipsToBounds = YES;
    [right_2_view addSubview:right_2_ImageView];
    [imagesArr addObject:right_2_ImageView];
    UIButton *right_2_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_2_Button setFrame:right_2_ImageView.frame];
    [right_2_Button setTag:2];
    [right_2_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_2_Button setTitle:@"" forState:UIControlStateNormal];
    [right_2_view addSubview:right_2_Button];
    [buttonArr addObject:right_2_Button];
    
    [contentView addSubview:right_2_view];
    
    UIView *right_3_view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2+1, 10+perHeight+2, perWidth, perHeight)];
    right_3_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_3_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, perWidth, perHeight)];
    right_3_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_3_ImageView.clipsToBounds = YES;
    [right_3_view addSubview:right_3_ImageView];
    [imagesArr addObject:right_3_ImageView];
    UIButton *right_3_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_3_Button setFrame:right_3_ImageView.frame];
    [right_3_Button setTag:3];
    [right_3_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_3_Button setTitle:@"" forState:UIControlStateNormal];
    [right_3_view addSubview:right_3_Button];
    [buttonArr addObject:right_3_Button];
    
    [contentView addSubview:right_3_view];
    
    UIView *right_4_view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2+1+perWidth+2, 10+perHeight+2, perWidth, perHeight)];
    right_4_view.backgroundColor = RGB(204, 204, 204);
    UIImageView *right_4_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, perWidth, perHeight)];
    right_4_ImageView.contentMode = UIViewContentModeScaleToFill;
    right_4_ImageView.clipsToBounds = YES;
    [right_4_view addSubview:right_4_ImageView];
    [imagesArr addObject:right_4_ImageView];
    UIButton *right_4_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_4_Button setFrame:right_4_ImageView.frame];
    [right_4_Button setTag:4];
    [right_4_Button setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [right_4_Button setTitle:@"" forState:UIControlStateNormal];
    [right_4_view addSubview:right_4_Button];
    [buttonArr addObject:right_4_Button];
    
    [contentView addSubview:right_4_view];
    
    return contentView;
}

//九宫格
+ (UIView *)getCardThreeViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    float contentHeight = kScreenWidth;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    
    float perButtonWidth = (kScreenWidth-22)/3;
    float perButtonHeight = perButtonWidth;
    if (kScreenWidth==320) {
        
    }else if(kScreenWidth==375)
    {
        
        
    }else
    {
    
        
    }
    
    
    for (int i=0; i<9; i++) {
        int col = i/3;
        int row = i%3;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10+(perButtonWidth+2)*row, 10+(perButtonHeight+2)*col, perButtonWidth, perButtonHeight)];
        leftView.backgroundColor = RGB(204, 204, 204);
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, perButtonWidth, perButtonHeight)];
        leftImageView.contentMode = UIViewContentModeScaleToFill;
        leftImageView.clipsToBounds = YES;
        [leftView addSubview:leftImageView];
        [imagesArr addObject:leftImageView];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:leftImageView.frame];
        [leftButton setTag:i];
        [leftButton setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftView addSubview:leftButton];
        [buttonArr addObject:leftButton];
        [contentView addSubview:leftView];

    }
    

    
    return contentView;
}

+ (UIView *)getCardFourViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    float contentHeight = kScreenWidth-70;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth/7*3-2, contentHeight-20)];
    leftView.backgroundColor = RGB(204, 204, 204);
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:leftView.bounds];
    leftImageView.contentMode = UIViewContentModeScaleToFill;
    leftImageView.clipsToBounds = YES;
    [leftView addSubview:leftImageView];
    [imagesArr addObject:leftImageView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:leftImageView.frame];
    [leftButton setTag:0];
    [leftButton setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [leftView addSubview:leftButton];
    [buttonArr addObject:leftButton];
    
    [contentView addSubview:leftView];
    
    float perButtonWidth = (kScreenWidth/7*4-22)/3;
    float perButtonHeight = (contentHeight-24)/3;
    
    for (int i=0; i<9; i++) {
        int col = i/3;
        int row = i%3;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(2+leftImageView.frame.size.width+10+(perButtonWidth+2)*row, 10+(perButtonHeight + 2)*col, perButtonWidth, perButtonHeight)];
        leftView.backgroundColor = RGB(204, 204, 204);
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:leftView.bounds];
        leftImageView.contentMode = UIViewContentModeScaleToFill;
        leftImageView.clipsToBounds = YES;
        [leftView addSubview:leftImageView];
        [imagesArr addObject:leftImageView];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:leftImageView.frame];
        [leftButton setTag:i+1];
        [leftButton setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftView addSubview:leftButton];
        [buttonArr addObject:leftButton];
        [contentView addSubview:leftView];
        
    }

     
    return contentView;
}

//八图
+ (UIView *)getCardFiveViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr{
    float contentHeight = kScreenWidth - 80;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    float perButtonWidth = (kScreenWidth - 12 - 10)/4;
    float perButtonHeight = (contentHeight - 16 - 4)/2;
    for (int i = 0 ; i < 8; i ++) {
        int row = i % 4;
        int col = i / 4;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10+(perButtonWidth+2)*row, 10+(perButtonHeight+2)*col, perButtonWidth, perButtonHeight)];
        leftView.backgroundColor = RGB(204, 204, 204);
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, perButtonWidth, perButtonHeight)];
        leftImageView.contentMode = UIViewContentModeScaleToFill;
        leftImageView.clipsToBounds = YES;
        [leftView addSubview:leftImageView];
        [imagesArr addObject:leftImageView];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:leftImageView.frame];
        [leftButton setTag:i];
        [leftButton setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftView addSubview:leftButton];
        [buttonArr addObject:leftButton];
        [contentView addSubview:leftView];
    }
    return contentView;
}

// 一加六
+ (UIView *)getCardSixViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    //创建展示视图
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    //左视图
    float leftWidth = kScreenWidth / 8 * 3 - 14;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, leftWidth, contentHeight - 20)];
    leftView.backgroundColor = RGB(204, 204, 204);
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:leftView.bounds];
    leftImageView.contentMode = UIViewContentModeScaleToFill;
    leftImageView.clipsToBounds = YES;
    [leftView addSubview:leftImageView];
    [imagesArr addObject:leftImageView];
    UIButton *leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBut setFrame:leftImageView.bounds];
    [leftBut setTag:0];
    [leftBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [leftView addSubview:leftBut];
    [buttonArr addObject:leftBut];
    [contentView addSubview:leftView];
    
    //六个小视图
    float rightWidth = (kScreenWidth / 8 * 5 - 10)/3;
    float rightHeight = (contentHeight - 20 - 2) / 2;
    for (int i = 1 ; i < 7; i ++) {
        int row = (i - 1) % 3;
        int col = (i - 1) / 3;
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(leftWidth + 2 + 10 + row * (rightWidth + 2), 10 + (rightHeight + 2)*col, rightWidth, rightHeight)];
        rightView.backgroundColor = RGB(204, 204, 204);
        UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:rightView.bounds];
        rightImageView.contentMode = UIViewContentModeScaleToFill;
        rightImageView.clipsToBounds = YES;
        [rightView addSubview:rightImageView];
        [imagesArr addObject:rightImageView];
        UIButton * rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBut setFrame:rightImageView.bounds];
        [rightBut setTag:i];
        [rightBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [rightView addSubview:rightBut];
        [buttonArr addObject:rightBut];
        [contentView addSubview:rightView];
    }
    return contentView;
}

//一加八
+ (UIView *)getCardSevenViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    //创建展示视图
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    //左视图
    float leftWidth = kScreenWidth / 3 - 14;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, leftWidth, contentHeight - 20)];
    leftView.backgroundColor = RGB(204, 204, 204);
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:leftView.bounds];
    leftImageView.contentMode = UIViewContentModeScaleToFill;
    leftImageView.clipsToBounds = YES;
    [leftView addSubview:leftImageView];
    [imagesArr addObject:leftImageView];
    UIButton *leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBut setFrame:leftImageView.bounds];
    [leftBut setTag:0];
    [leftBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [leftView addSubview:leftBut];
    [buttonArr addObject:leftBut];
    [contentView addSubview:leftView];
    
    //八个小视图
    float rightWidth = (kScreenWidth / 3 * 2 - 14)/4;
    float rightHeight = (contentHeight - 20 - 2) / 2;
    for (int i = 1 ; i < 9; i ++) {
        int row = (i - 1) % 4;
        int col = (i - 1) / 4;
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(leftWidth + 2 + 10 + row * (rightWidth + 2), 10 + (rightHeight + 2)*col, rightWidth, rightHeight)];
        rightView.backgroundColor = RGB(204, 204, 204);
        UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:rightView.bounds];
        rightImageView.contentMode = UIViewContentModeScaleToFill;
        rightImageView.clipsToBounds = YES;
        [rightView addSubview:rightImageView];
        [imagesArr addObject:rightImageView];
        UIButton * rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBut setFrame:rightImageView.bounds];
        [rightBut setTag:i];
        [rightBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [rightView addSubview:rightBut];
        [buttonArr addObject:rightBut];
        [contentView addSubview:rightView];
    }
    return contentView;
}

//新式六图
+ (UIView *)getCardEightViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    //创建展示视图
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    //左视图
    float
    ViewHeight = (contentHeight - 20 - 4)/2;
    float leftViewWidth = kScreenWidth * 9 /20 - 12;
    for (int i = 0 ; i < 1; i ++) {
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10 , 10 + i * (ViewHeight + 2), leftViewWidth, ViewHeight)];
        leftView.backgroundColor = RGB(204, 204, 204);
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:leftView.bounds];
        leftImageView.contentMode = UIViewContentModeScaleToFill;
        leftImageView.clipsToBounds = YES;
        [leftView addSubview:leftImageView];
        [imagesArr addObject:leftImageView];
        UIButton *leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBut setFrame:leftImageView.bounds];
        [leftBut setTag:i];
        [leftBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftView addSubview:leftBut];
        [buttonArr addObject:leftBut];
        [contentView addSubview:leftView];
    }
    
    //右视图
    float rightViewWidth = (kScreenWidth * 11 / 20 - 10)/2;
    for (int i = 0; i < 2; i ++) {
        int row = i % 2;
        int col = i / 2;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(12 + leftViewWidth + row * (rightViewWidth + 2), 10 + col *(ViewHeight + 2), rightViewWidth, ViewHeight)];
        rightView.backgroundColor = RGB(204, 204, 204);
        UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:rightView.bounds];
        [rightImageView setContentMode:UIViewContentModeScaleToFill];
        [rightImageView setClipsToBounds:YES];
        [rightView addSubview:rightImageView];
        [imagesArr addObject:rightImageView];
        UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [rightBut setTag:i + 1];
        [rightBut setFrame:rightImageView.bounds];
        [rightView addSubview:rightBut];
        [contentView addSubview:rightView];
        [buttonArr addObject:rightBut];
    }
    
    for (int i = 1 ; i < 2; i ++) {
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10 , 10 + i * (ViewHeight + 2), leftViewWidth, ViewHeight)];
        leftView.backgroundColor = RGB(204, 204, 204);
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:leftView.bounds];
        leftImageView.contentMode = UIViewContentModeScaleToFill;
        leftImageView.clipsToBounds = YES;
        [leftView addSubview:leftImageView];
        [imagesArr addObject:leftImageView];
        UIButton *leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBut setFrame:leftImageView.bounds];
        [leftBut setTag:i*3];
        [leftBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftView addSubview:leftBut];
        [buttonArr addObject:leftBut];
        [contentView addSubview:leftView];
    }
    
    for (int i = 2; i < 4; i ++) {
        int row = i % 2;
        int col = i / 2;
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(12 + leftViewWidth + row * (rightViewWidth + 2), 10 + col *(ViewHeight + 2), rightViewWidth, ViewHeight)];
        rightView.backgroundColor = RGB(204, 204, 204);
        UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:rightView.bounds];
        [rightImageView setContentMode:UIViewContentModeScaleToFill];
        [rightImageView setClipsToBounds:YES];
        [rightView addSubview:rightImageView];
        [imagesArr addObject:rightImageView];
        UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [rightBut setTag:i + 2];
        [rightBut setFrame:rightImageView.bounds];
        [rightView addSubview:rightBut];
        [contentView addSubview:rightView];
        [buttonArr addObject:rightBut];
    }

    return contentView;
}

//上三下三
+ (UIView *)getCardNineViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr
{
    //创建展示视图
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    float bigWidth = (kScreenWidth - 22)/2;
    float height = (contentHeight - 24 ) / 2;
    for (int i = 0; i < 1; i ++) {
        UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(10 + i * (bigWidth + 2), 10 + (height + 2)*i, bigWidth, height)];
        bigView.backgroundColor = RGB(204, 204, 204);
        UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:bigView.bounds];
        bigImageView.contentMode = UIViewContentModeScaleToFill;
        bigImageView.clipsToBounds = YES;
        [bigView addSubview:bigImageView];
        [imagesArr addObject:bigImageView];
        UIButton *bigBut = [UIButton buttonWithType:UIButtonTypeCustom];
        bigBut.frame = bigView.bounds;
        [bigBut setTag:i * 5];
        [bigBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [bigView addSubview:bigBut];
        [contentView addSubview:bigView];
        [buttonArr addObject:bigBut];
    }
    
    float smallWidth = (bigWidth - 2)/2;
    for (int i = 0; i < 4; i ++) {
        int row = 1 - i / 2;
        int row_2 = i / 2;
        int col = i % 2;
        UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(10 + (bigWidth + 2) * row + (smallWidth + 2) * col, 10 + (height + 2) *row_2, smallWidth, height)];
        smallView.backgroundColor = RGB(204, 204, 204);
        UIImageView *smallImageView = [[UIImageView alloc]initWithFrame:smallView.bounds];
        smallImageView.contentMode = UIViewContentModeScaleToFill;
        smallImageView.clipsToBounds = YES;
        [smallView addSubview:smallImageView];
        [imagesArr addObject:smallImageView];
        UIButton *smallBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [smallBut setFrame:smallView.bounds];
        smallBut.tag = 1 +i;
        [smallBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [smallView addSubview:smallBut];
        [contentView addSubview:smallView];
        [buttonArr addObject:smallBut];
    }
    
    for (int i = 1; i < 2; i ++) {
        UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(10 + i * (bigWidth + 2), 10 + (height + 2)*i, bigWidth, height)];
        bigView.backgroundColor = RGB(204, 204, 204);
        UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:bigView.bounds];
        bigImageView.contentMode = UIViewContentModeScaleToFill;
        bigImageView.clipsToBounds = YES;
        [bigView addSubview:bigImageView];
        [imagesArr addObject:bigImageView];
        UIButton *bigBut = [UIButton buttonWithType:UIButtonTypeCustom];
        bigBut.frame = bigView.bounds;
        [bigBut setTag:i * 5];
        [bigBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [bigView addSubview:bigBut];
        [contentView addSubview:bigView];
        [buttonArr addObject:bigBut];
    }
    
    return contentView;
}

//五图右大
+ (UIView *)getCardTenViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr{
    //创建展示视图
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    float rightWidth = (kScreenWidth - 22)/11.f * 7.f;
    float rightHeight = contentHeight - 20;
    float leftBigWidth = (kScreenWidth - 22)/11.f * 4.f;
    float leftHeight = (contentHeight - 24) / 3;
    float leftSmallWidth = (leftBigWidth - 2)/2;
    //左大1
    for (int i = 0; i < 1; i ++) {
        UIView *leftBigView = [[UIView alloc]initWithFrame:CGRectMake(10, 10 + i * (leftHeight * 2 + 4), leftBigWidth, leftHeight)];
        leftBigView.backgroundColor = RGB(204, 204, 204);
        UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:leftBigView.bounds];
        bigImageView.contentMode = UIViewContentModeScaleToFill;
        bigImageView.clipsToBounds = YES;
        [leftBigView addSubview:bigImageView];
        [imagesArr addObject:bigImageView];
        UIButton *bigBut = [UIButton buttonWithType:UIButtonTypeCustom];
        bigBut.frame = leftBigView.bounds;
        [bigBut setTag:i];
        [bigBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftBigView addSubview:bigBut];
        [contentView addSubview:leftBigView];
        [buttonArr addObject:bigBut];
    }
    //左小
    for (int i = 0; i < 2; i ++) {
        UIView *leftSmallView = [[UIView alloc]initWithFrame:CGRectMake(10 + i * (leftSmallWidth + 2), 12 + leftHeight, leftSmallWidth, leftHeight)];
        leftSmallView.backgroundColor = RGB(204, 204, 204);
        UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:leftSmallView.bounds];
        bigImageView.contentMode = UIViewContentModeScaleToFill;
        bigImageView.clipsToBounds = YES;
        [leftSmallView addSubview:bigImageView];
        [imagesArr addObject:bigImageView];
        UIButton *bigBut = [UIButton buttonWithType:UIButtonTypeCustom];
        bigBut.frame = leftSmallView.bounds;
        [bigBut setTag:1 + i];
        [bigBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftSmallView addSubview:bigBut];
        [contentView addSubview:leftSmallView];
        [buttonArr addObject:bigBut];

    }
    //左大2
    for (int i = 1; i < 2; i ++) {
        UIView *leftBigView = [[UIView alloc]initWithFrame:CGRectMake(10, 10 + i * (leftHeight * 2 + 4), leftBigWidth, leftHeight)];
        leftBigView.backgroundColor = RGB(204, 204, 204);
        UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:leftBigView.bounds];
        bigImageView.contentMode = UIViewContentModeScaleToFill;
        bigImageView.clipsToBounds = YES;
        [leftBigView addSubview:bigImageView];
        [imagesArr addObject:bigImageView];
        UIButton *bigBut = [UIButton buttonWithType:UIButtonTypeCustom];
        bigBut.frame = leftBigView.bounds;
        [bigBut setTag:3];
        [bigBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [leftBigView addSubview:bigBut];
        [contentView addSubview:leftBigView];
        [buttonArr addObject:bigBut];
    }
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(10 + 2 + leftBigWidth, 10, rightWidth, rightHeight)];
    rightView.backgroundColor = RGB(204, 204, 204);
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:rightView.bounds];
    rightImageView.contentMode = UIViewContentModeScaleToFill;
    rightImageView.clipsToBounds = YES;
    [rightView addSubview:rightImageView];
    [imagesArr addObject:rightImageView];
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = rightImageView.bounds;
    [rightBut setTag:4];
    [rightBut setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    [rightView addSubview:rightBut];
    [contentView addSubview:rightView];
    [buttonArr addObject:rightBut];
    
    return contentView;
}

//七图中大
+ (UIView *)getCardElevenViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr{
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    float smallWidth = (kScreenWidth - 24) / 6;
    float bigWidth = (kScreenWidth - 24) / 3 * 2;
    float smallHeight = (contentHeight - 24) / 3;
    float bigHeight = contentHeight - 20;
    for (int i = 0; i < 3; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10 + i * (2 + smallHeight), smallWidth, smallHeight)];
        view.backgroundColor = RGB(204, 204, 204);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        [imagesArr addObject:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [contentView addSubview:view];
        [buttonArr addObject:btn];
    }
    
    for (int i = 0; i < 1; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(12 + smallWidth, 10 , bigWidth, bigHeight)];
        view.backgroundColor = RGB(204, 204, 204);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        [imagesArr addObject:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn setTag:3];
        [btn setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [contentView addSubview:view];
        [buttonArr addObject:btn];
    }
    
    for (int i = 0; i < 3; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(14 + smallWidth + bigWidth, 10 + i * (2 + smallHeight), smallWidth, smallHeight)];
        view.backgroundColor = RGB(204, 204, 204);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        [imagesArr addObject:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn setTag:i + 4];
        [btn setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [contentView addSubview:view];
        [buttonArr addObject:btn];
    }
    return contentView;
}
//五图上大
+ (UIView *)getCardTwelveViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr{
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    float bigHeight = (contentHeight - 22) / 9 * 7;
    float smallHeight = (contentHeight - 22) / 9 * 2;
    float bigWidth = kScreenWidth - 20;
    float smallWidth = (kScreenWidth - 26) / 4;
    for (int i = 0; i < 1; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10 , bigWidth, bigHeight)];
        view.backgroundColor = RGB(204, 204, 204);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        [imagesArr addObject:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn setTag:0];
        [btn setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [contentView addSubview:view];
        [buttonArr addObject:btn];
    }
    
    for (int i = 0; i < 4; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10 + i * (2 + smallWidth), 10 + 2 +bigHeight , smallWidth, smallHeight)];
        view.backgroundColor = RGB(204, 204, 204);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        [imagesArr addObject:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn setTag:1 + i];
        [btn setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [contentView addSubview:view];
        [buttonArr addObject:btn];
    }
    return contentView;
}

//五图右下二
+ (UIView *)getCardThirteenViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr{
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    float height = (contentHeight - 22) / 3;
    float width = (kScreenWidth - 24) / 5;
    for (int i = 0; i < 5; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, width * 2, height * 2)];
        if (i == 0) {
            
            }
        else if(i == 1){
            view.frame = CGRectMake(10 + width * 2 + 2, 10, width * 3 + 2, height * 2);
            }
        else if (i == 2 || i == 3){
            view.frame = CGRectMake(10 + (i - 2) * (1+width) * 2, 10 + 2 +height * 2, width *2, height);
            }
        else if(i == 4){
            view.frame = CGRectMake(10 + 4 + width * 4, height * 2 + 2 + 10, width, height);
            }
        view.backgroundColor = RGB(204, 204, 204);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        [imagesArr addObject:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [contentView addSubview:view];
        [buttonArr addObject:btn];

    }
    
    return contentView;
}
//对称图
+ (UIView *)getCardFourteenViewImages:(NSMutableArray *)imagesArr buttons:(NSMutableArray *)buttonArr{
    float contentHeight = kScreenWidth - 100;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, contentHeight)];
    float width = (kScreenWidth - 24) / 5;
    float height = (contentHeight - 20) / 3;
    for (int i = 0; i < 7; i ++) {
        UIView *view = [[UIView alloc]init];
        switch (i) {
            case 0:
                view.frame = CGRectMake(10, 10, width * 2, height * 2);
                break;
            case 1:
                view.frame = CGRectMake(10 + 2 + width * 2 , 10, width * 2, height);
                break;
            case 2:
                view.frame = CGRectMake(14 + width * 4, 10, width , height);
                break;
            case 3:
                view.frame = CGRectMake(10, 12 + height * 2, width * 2, height);
                break;
            case 4:
                view.frame = CGRectMake(12 + width * 2, 12 + height, width * 2, height * 2);
                break;
            case 5:
                view.frame = CGRectMake(14 + width * 4, 12 + height, width , height);
                break;
            case 6:
                view.frame = CGRectMake(14 + width * 4, 14 + height * 2, width , height - 2);
                break;
            default:
                break;
        }
        view.backgroundColor = RGB(204, 204, 204);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        [imagesArr addObject:imageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
        [view addSubview:btn];
        [contentView addSubview:view];
        [buttonArr addObject:btn];
        
    }
    
    return contentView;
}
@end
