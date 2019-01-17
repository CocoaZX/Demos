//
//  MCHotHeaderView.h
//  Mocha
//
//  Created by TanJian on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCHotJingpaiModel.h"

@interface MCHotHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mokaJingpaiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *jingpaiCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jingpaiState;

@property (nonatomic,strong)MCHotJingpaiModel *model;



-(void)setupUIWith:(NSDictionary *)dict withCount:(int)count withBannerImgUrl:(NSString *)url;


@end
