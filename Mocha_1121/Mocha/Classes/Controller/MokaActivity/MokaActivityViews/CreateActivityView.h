//
//  CreateActivityView.h
//  Mocha
//
//  Created by zhoushuai on 15/12/16.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义一个block块
typedef void(^UICtrlBlock)(UIControl *control);
@interface CreateActivityView : UIControl

//执行代码块
@property (nonatomic,copy)UICtrlBlock ctrlBlock;

//自定义初始化方法
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
          DetailTxt:(NSString *)detailTxt
            bgImage:(NSString *)imageName withBlock:(UICtrlBlock)block;
@end
