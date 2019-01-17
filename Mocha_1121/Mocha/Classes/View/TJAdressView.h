//
//  TJAdressView.h
//  TJAdressDemo
//
//  Created by TanJian on 16/5/18.
//  Copyright © 2016年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McMainController.h"

@interface TJAdressView : UIView

@property(nonatomic,strong)NSMutableArray *provinceDataArr;
@property(nonatomic,strong)NSMutableArray *cityDataArr;

@property(nonatomic,strong)NSString *currentAdr;

@property(nonatomic,assign)CGPoint positionPoint;

@property (nonatomic,strong)UIViewController *superVC;

-(void)setupUI;
@end
