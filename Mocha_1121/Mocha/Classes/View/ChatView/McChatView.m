//
//  McChatView.m
//  Mocha
//
//  Created by renningning on 14-12-12.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McChatView.h"

@interface McChatView()

@property (nonatomic, retain) UITextField *textField;

@end

@implementation McChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)_init
{
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_bgImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_bgImageView];
    
    _textField = [[UITextField alloc] init];
    
    
}

@end
