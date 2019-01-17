//
//  QHQPLoadingView.m
//  QuickPay
//
//  Created by lvjianxiong on 14-7-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "QHQPLoadingView.h"

@interface QHQPLoadingView()
{
    UILabel * _activityLabel;
    UIActivityIndicatorView * _activityIndicator;
    UIView * _activityView;
}
@end

@implementation QHQPLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView * activityView = [[UIView alloc] initWithFrame:CGRectMake(110.0f, 150.0f, 100.0f, 100.0f)];
        [[activityView layer] setCornerRadius:8.0f];
        _activityView = activityView;
        _activityView.backgroundColor = [UIColor blackColor];
        _activityView.alpha = 0.6;
        [self addSubview:_activityView];
        
        
        UILabel * activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100,22)];
        activityLabel.backgroundColor = [UIColor clearColor];
        activityLabel.text = @"";
        activityLabel.font = [UIFont systemFontOfSize:14];
        activityLabel.textAlignment = NSTextAlignmentCenter;
        activityLabel.textColor = [UIColor whiteColor];
        _activityLabel = activityLabel;
        [_activityView addSubview:_activityLabel];
        
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = CGRectMake(40, 40, 20, 20);//15, 30,
        _activityIndicator = activityIndicator;
        [_activityView addSubview:activityIndicator];
        
        _activityIndicator.center = CGPointMake(50,50);
        
        
    }
    return self;
}

/**在页面中显示**/
- (void)showInView:(UIView *)view withMessage:(NSString *)msg
{
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    float y = 0;
    if (![view isKindOfClass:UIWindow.class]) {
        y = 32;
    }
    self.frame = CGRectMake(0.0f, 0.0f, width, height);
    
    
    //    CGSize  nameSize = [msg sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200.0f, 22.0f) lineBreakMode:UILineBreakModeWordWrap];
    CGSize nameSize = [msg boundingRectWithSize:CGSizeMake(200, 22) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size;
    if (nameSize.width < 100.0f) {
        nameSize.width = 100.0f;
    }
    
    //110,190,100
    
    float wid = nameSize.width;
    float hei = 100;
    float orightY = (height-100.0f)/2.0f-y;
    if (height < 100) {
        orightY = 0;
        wid = height * 2;
        hei = height;
    }
    _activityView.frame = CGRectMake((width-wid)/2.0f, orightY, wid, hei);
    _activityIndicator.frame = CGRectMake((wid-20.0f)/2.0f, 30.0f, 20.0f, 20.0f);
    
    _activityLabel.frame = CGRectMake(5.0f, 70.0f, wid - 10, 22.0f);
    if (msg) {
        _activityLabel.text = msg;
    }
    //self.activityView.center = view.center;
    if (![self superview]) {
        [view addSubview:self];
    }
    [_activityIndicator startAnimating];
}

- (void)showInView:(UIView *)view withMessage:(NSString *)msg alpha:(float)alpha
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = alpha;
    _activityView.backgroundColor = [UIColor clearColor];
    
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    float y = 0;
    if (![view isKindOfClass:UIWindow.class]) {
        y = 32;
    }
    self.frame = CGRectMake(0.0f, 0.0f, width, height);
    
    
    //    CGSize  nameSize = [msg sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200.0f, 22.0f) lineBreakMode:UILineBreakModeWordWrap];
    CGSize nameSize = [msg boundingRectWithSize:CGSizeMake(200, 22) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size;
    if (nameSize.width < 100.0f) {
        nameSize.width = 100.0f;
    }
    
    //110,190,100
    
    float wid = nameSize.width;
    float hei = 100;
    float orightY = (height-100.0f)/2.0f-y;
    if (height < 100) {
        orightY = 0;
        wid = height * 2;
        hei = height;
    }
    _activityView.frame = CGRectMake((width-wid)/2.0f, orightY, wid, hei);
    _activityIndicator.frame = CGRectMake((wid-20.0f)/2.0f, 30.0f, 20.0f, 20.0f);
    
    _activityLabel.frame = CGRectMake(5.0f, 70.0f, wid - 10, 22.0f);
    if (msg) {
        _activityLabel.text = msg;
    }
    //self.activityView.center = view.center;
    if (![self superview]) {
        [view addSubview:self];
    }
    [_activityIndicator startAnimating];
}


/**从view上面移走**/
- (void)removeSelfFromSuperView:(id)sender
{
    if ([self superview]) {
        [self performSelectorOnMainThread:@selector(removeFromSuperview) withObject:Nil waitUntilDone:TRUE];
    }
    [_activityIndicator stopAnimating];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
