//
//  MCJingpaiCommitView.h
//  Mocha
//
//  Created by TanJian on 16/4/26.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJingpaiDetailModel.h"

@interface MCJingpaiCommitView : UIView

@property (nonatomic,strong)UIViewController *superVC;
@property (nonatomic,strong)MCJingpaiDetailModel *model;
//@property (nonatomic,strong)void (^myBlock)();
@property(nonatomic,strong)UITextField *commitField;

@property(nonatomic,copy) NSString *replyID;
@property(nonatomic,copy) NSString *replyName;

@end
