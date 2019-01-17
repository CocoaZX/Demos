//
//  PersonInforView.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonInforViewDelegate <NSObject>

- (void)didSelectedInfo:(NSString *)stringtitle infoStatus:(NSInteger)status;

@end

@interface PersonInforView : UIView

@property (nonatomic, assign) id<PersonInforViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *personalInfView;

@property (weak, nonatomic) IBOutlet UILabel *workStyleLal;

@property (weak, nonatomic) IBOutlet UILabel *personalInfoLabel;

@property (weak, nonatomic) IBOutlet UIView *workStyleView;

@property (nonatomic, assign) float selfHeight;

@property (nonatomic, strong) NSArray *infoStatusArr;

- (void)setDataArray:(NSArray *)dataArray;

+ (PersonInforView *)getPersonInforView;

@end
