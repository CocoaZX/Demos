//
//  MCMainFieryHeaderView.h
//  Mocha
//
//  Created by TanJian on 16/5/20.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMainFieryViewController.h"

@interface MCMainFieryHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *seprateline;
@property (weak, nonatomic) IBOutlet UIView *modelTitleLine;
@property (weak, nonatomic) IBOutlet UILabel *modelTitleLable;
@property (weak, nonatomic) IBOutlet UIButton *firstModelHead;
@property (weak, nonatomic) IBOutlet UIButton *secondModelHead;
@property (weak, nonatomic) IBOutlet UIButton *thirdModelHead;
@property (weak, nonatomic) IBOutlet UIButton *fouthModelHead;
@property (weak, nonatomic) IBOutlet UIButton *fifthModelHead;
@property (weak, nonatomic) IBOutlet UIButton *sixthModelHead;

@property (weak, nonatomic) IBOutlet UIView *grapherTitleLine;
@property (weak, nonatomic) IBOutlet UILabel *grapherTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstGrapherHead;
@property (weak, nonatomic) IBOutlet UIButton *secondGrapherHead;
@property (weak, nonatomic) IBOutlet UIButton *thirdGrapherHead;
@property (weak, nonatomic) IBOutlet UIButton *fouthGrapherHead;
@property (weak, nonatomic) IBOutlet UIButton *fifthGrapherHead;
@property (weak, nonatomic) IBOutlet UIButton *sixthGrapherHead;
@property (weak, nonatomic) IBOutlet UIView *bigSeprateLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//头像图片
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;
@property (weak, nonatomic) IBOutlet UIImageView *fouthImg;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImg;
@property (weak, nonatomic) IBOutlet UIImageView *sixthImg;
@property (weak, nonatomic) IBOutlet UIImageView *firstGImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondGImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdGImg;
@property (weak, nonatomic) IBOutlet UIImageView *fouthGImg;
@property (weak, nonatomic) IBOutlet UIImageView *fifthGimg;
@property (weak, nonatomic) IBOutlet UIImageView *sixthGImg;





//头视图跳转用数组
@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) MCMainFieryViewController *superVC;

-(void)setupUIWithData:(NSArray *)dataArr;



@end






