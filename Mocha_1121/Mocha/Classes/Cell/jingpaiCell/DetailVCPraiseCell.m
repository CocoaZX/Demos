//
//  DetailVCPraiseCell.m
//  Mocha
//
//  Created by TanJian on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DetailVCPraiseCell.h"
#import "NewMyPageViewController.h"

#define kHeadWidth 30

@interface DetailVCPraiseCell ()

@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation DetailVCPraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)init{
    
    return [[NSBundle mainBundle]loadNibNamed:@"DetailVCPraiseCell" owner:self options:nil].lastObject;
    
}

-(void)setupUI:(NSArray *)array{
    
    int kcount = (kDeviceWidth-40)/(kHeadWidth+5);
    self.dataArr = array;
    NSInteger currentCount = array.count;
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%ld人点赞",(long)currentCount];
    
    for (int i = 0; i<currentCount; i++) {
        
        float imgX = i%kcount*(kHeadWidth+5)+20;
        float imgY = i/kcount*(kHeadWidth+5) + self.praiseCountLabel.bottom+4;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imgX,imgY, kHeadWidth, kHeadWidth)];
        NSDictionary *dict = array[i];
        
        [imageView setImageWithURL:[NSURL URLWithString:dict[@"head_pic"]?dict[@"head_pic"]:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        imageView.layer.cornerRadius = imageView.width*0.5;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        
        UIButton *headerBtn = [[UIButton alloc]init];
        headerBtn.frame = imageView.frame;
        headerBtn.tag = i;
        [self addSubview:headerBtn];
        [headerBtn addTarget:self action:@selector(jumpToPersonalPage:) forControlEvents:UIControlEventTouchUpInside];
    }
}


+(float)getHeightWithArr:(NSArray *)array{
    
    int kcount = (kDeviceWidth-40)/(kHeadWidth+5);
    NSInteger currentCount = array.count;
    float labelH = 34;
    float praiseViewH = 5+(currentCount/kcount+1)*(kHeadWidth+5);
    return labelH+praiseViewH;
}


-(void)jumpToPersonalPage:(UIButton *)sender{
    NSLog(@"跳转个人页面");
    
    NSInteger i = sender.tag;
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    
    newMyPage.currentUid = self.dataArr[i][@"id"];
    [self.superVC.navigationController pushViewController:newMyPage animated:YES];
}

@end
