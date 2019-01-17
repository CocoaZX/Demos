//
//  BuildTaoXiHeaderView.h
//  Mocha
//
//  Created by XIANPP on 16/2/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildTaoXiViewController.h"

@interface BuildTaoXiHeaderView : UIView

@property (nonatomic , strong)UIImageView *coverImageView;

-(void)initWithDictionary:(NSDictionary *)dic;

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic , weak)BuildTaoXiViewController *supCon;

@property (nonatomic , copy)NSString *coverurl;

@end
