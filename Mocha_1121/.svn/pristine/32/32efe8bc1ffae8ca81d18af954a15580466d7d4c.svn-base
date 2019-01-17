//
//  MCJingpaiCommitView.m
//  Mocha
//
//  Created by TanJian on 16/4/26.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJingpaiCommitView.h"

@interface MCJingpaiCommitView ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)NSString *commitStr;
@property(nonatomic,assign)BOOL isNeedComment;

@end

@implementation MCJingpaiCommitView

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-54, kDeviceWidth, 54)];
        _contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *img = [[UIImageView alloc]initWithFrame:_contentView.bounds];
        img.image = [UIImage imageNamed:@"commentBackImg"];
        [_contentView addSubview:img];
    }
    return _contentView;
}

-(void)layoutSubviews{
    
    _isNeedComment = YES;
    self.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc]initWithFrame:self.frame];
    backView.alpha = 0.6;
    backView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(justCloseView)];
    [backView addGestureRecognizer:recognizer];
    [self addSubview:backView];
    
    float scale = kDeviceWidth/375;
    UITextField *commitField = [[UITextField alloc]initWithFrame:CGRectMake(25, 12,250*scale, 30)];
    if (!_replyName) {
        commitField.placeholder = @"请输入内容,不超过140字";
    }else{
        commitField.placeholder = [NSString stringWithFormat:@"回复@%@",_replyName];
    }
    
    commitField.font = [UIFont systemFontOfSize:13];
    commitField.textColor = [UIColor lightGrayColor];
    commitField.delegate = self;
    self.commitField = commitField;
    [self.contentView addSubview:commitField];
    UIButton *commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-80*scale, 0, 80*scale, 54)];
    [commitBtn setImage:[UIImage imageNamed: @"sendCommentButton"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(doCommit) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commitBtn];
    [self addSubview:_contentView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    [commitField becomeFirstResponder];

}

//计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    
    float keyboardH = [self keyboardEndingFrameHeight:notification.userInfo];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, kDeviceHeight-54-keyboardH, kDeviceWidth, 54);
    }];
    
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    [self closeView];
    
}

-(void)doCommit{
    [self.commitField endEditing:YES];
    [self sendCommit];
    
}

-(void)justCloseView{
    _isNeedComment = NO;
    [self closeView];
}

-(void)closeView{
    [self removeFromSuperview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    
    if (!_isNeedComment) {
        return;
    }
    self.commitStr = textField.text;
    
    //判断评论是否符合标准
    NSInteger n = _commitStr.length;
    int l = 0;
    int a = 0;
    int b = 0;
    unichar c;
    
    for(int i = 0; i < n;i++){
        c = [_commitStr characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    float strLen = l+(int)ceilf((float)(a+b)/2.0);
    if (strLen<1) {
        [LeafNotification showInController:self.superVC withText:@"请输入文字"];
        return;
    }else if(strLen>140){
        [LeafNotification showInController:self.superVC withText:@"字数超过最大字数限制"];
        return;
    }else{
        NSLog(@"评论内容正确");
    }
    
}

-(void)sendCommit{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];

    NSDictionary *params = [AFParamFormat formatCommentActionParams:self.model.auction_id userId:uid content:self.commitStr object_type:@"15"];
    NSLog(@"%@",params);
    
    
    if ([_commitField.placeholder rangeOfString:@"回复@"].length) {
        NSString *commentStr = [NSString stringWithFormat:@"%@ %@",_commitField.placeholder,_commitField.text];
        commentStr = [commentStr substringFromIndex:2];
        _commitField.text = commentStr;
        params = [AFParamFormat formatCommentActionParams:self.model.auction_id userId:uid content:_commitField.text replyID:_replyID object_type:@"15"];
    }
    NSLog(@"%@",params);
    [AFNetwork commentsAdd:params success:^(id data){

        if ([data[@"status"] integerValue] == kRight) {
            
            [LeafNotification showInController:self.superVC withText:data[@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAuctionCommitController" object:nil];
            });
            
            
        }else{
            [LeafNotification showInController:self.superVC withText:data[@"msg"]];
            
        }
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self animated:YES];
        [LeafNotification showInController:self.superVC withText:@"网络错误"];
    }];
}

@end



