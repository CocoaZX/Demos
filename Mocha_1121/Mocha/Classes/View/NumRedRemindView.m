//
//  NumRedRemindView.m
//  Mocha
//
//  Created by renningning on 14-11-20.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "NumRedRemindView.h"

#define minBtnSize 40
#define interval 5
#define labHeignt 20

@interface NumRedRemindView()

@property (nonatomic, retain) UIButton *bgBtn;
@property (nonatomic, retain) UILabel *numLab;

@end

@implementation NumRedRemindView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithColor:(UIColor *)bgColor
{
    return [self initWithColor:bgColor delegate:nil];
}

- (id)initWithColor:(UIColor *)bgColor delegate:(id<NumRedRemindViewDelegate>)delegate
{
    return [self initWithColor:bgColor num:0 canDelete:NO delegate:nil];
}

- (id)initWithColor:(UIColor *)bgColor num:(NSInteger)num
          canDelete:(BOOL)canDelete
           delegate:(id<NumRedRemindViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = bgColor;
        btn.frame = CGRectMake(0, 0, minBtnSize, minBtnSize);
        [btn.layer setCornerRadius:btn.frame.size.width/2];
        if (canDelete) {
            [btn addTarget:self action:@selector(doClearNum:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.bgBtn = btn;
        [self addSubview:_bgBtn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(interval, (minBtnSize - labHeignt)/2, minBtnSize - interval*2, labHeignt)];
        [lab setFont:[UIFont systemFontOfSize:14]];
        [lab setBackgroundColor:[UIColor clearColor]];
        self.numLab = lab;
        [self addSubview:_numLab];
    }
    return self;
}


- (void)doClearNum:(id)sender
{
    [self setHidden:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(doClearInView)]) {
        [self.delegate doClearInView];
    }
}

@end
