//
//  WorkExpView.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkExpView : UIView

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@property (nonatomic, assign) float selfHeight;

- (void)setWorkExpString:(NSString *)content;


+ (WorkExpView *)getWorkExpView;

@end
