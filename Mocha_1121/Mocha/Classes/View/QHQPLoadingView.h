//
//  QHQPLoadingView.h
//  QuickPay
//
//  Created by lvjianxiong on 14-7-1.
//  Copyright (c) 2014年 lvjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHQPLoadingView : UIView

/**在页面中显示**/
- (void)showInView:(UIView *)view withMessage:(NSString *)msg alpha:(float)alpha;
- (void)showInView:(UIView *)view withMessage:(NSString *)msg;

/**从view上面移走**/
- (void)removeSelfFromSuperView:(id)sender;


@end
