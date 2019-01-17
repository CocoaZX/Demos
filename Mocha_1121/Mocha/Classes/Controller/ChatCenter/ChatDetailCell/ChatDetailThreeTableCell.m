//
//  ChatDetailThreeTableCell.m
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "ChatDetailThreeTableCell.h"
#import "ChatDeleteMemberController.h"

@implementation ChatDetailThreeTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化组件
        [self _initViews];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}


//创建视图
- (void)_initViews{

    //大标题
    _infoLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth - 10, 20)];
    [self.contentView addSubview:_infoLabel];
    
    //显示成员头像的视图
    _memberView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_memberView];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        _groupID = [dataDic objectForKey:@"groupId"];
        _memberArr = [dataDic objectForKey:@"members"];
        
        if (_memberArr.count>0) {
            NSString *idd = [_memberArr[0] objectForKey:@"id"];
            NSString *uid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
            if ([uid isEqualToString:idd]) {
                _isOwner = YES;
            }else{
                _isOwner = NO;
            }
        }
        [self setNeedsLayout];
    }
}


//对视图进行重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    _infoLabel.text = [NSString stringWithFormat:@"群聊成员(%ld)",(unsigned long)[_memberArr count]];
    
    //清空原来的头像
    NSArray *subViews = [_memberView subviews];
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }

    //计算每个头像的大小
    CGFloat cellwidth = (kDeviceWidth-(10*6))/5;
    //成员个数
    int  count  = (int)_memberArr.count;
    
    //如果是群主，显示踢人的按键
    if (_isOwner) {
        count ++;
    }
    
    //计算行数
    int row = 0;
    int col = 0;
    if ((count % 5) == 0) {
        row = count/5;
    }else{
        row = count/5 +1;
    }
    _memberView.frame = CGRectMake(0, 30, kDeviceWidth,row * (cellwidth + 10)+10);

    //显示头像
    row = 0;
    col = 0;
    for (int i = 0; i<count; i++) {
        //当前行
        if ((i%5) ==0) {
            row ++;
        }
        //当前列
        col = i%5;
        
        //成员视图
        UIControl *memberCtrl = [[UIControl alloc] initWithFrame:CGRectMake(col *(cellwidth + 10) +10, (row-1) *(cellwidth +10)+10, cellwidth, cellwidth)];
        memberCtrl.tag = i +100;
        [memberCtrl addTarget:self action:@selector(memberCtrlAction:)forControlEvents:UIControlEventTouchUpInside];
        
        //多加了个踢人按钮，
        if(i == _memberArr.count){
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cellwidth -20, cellwidth -20)];
            bottomLabel.layer.borderColor = [[CommonUtils colorFromHexString:kLikeLightGrayColor] CGColor];
            bottomLabel.layer.borderWidth = 1;
            [memberCtrl addSubview:bottomLabel];
            
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+5, (cellwidth -20-5)/2, cellwidth-20-10, 5)];
            lineLabel.backgroundColor= [CommonUtils colorFromHexString:kLikeLightGrayColor];
            [memberCtrl addSubview:lineLabel];
            [_memberView addSubview:memberCtrl];
            return;
        }

        //取出数据
        NSDictionary *memberData = _memberArr[i];
        //头像
        UIImageView *headerView
        = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, cellwidth -20, cellwidth -20)];
        [memberCtrl addSubview:headerView];
        
       NSString *headerURLString = [NSString stringWithFormat:@"%@%@",[memberData objectForKey:@"head_pic"],[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
        [headerView sd_setImageWithURL:[NSURL URLWithString:headerURLString]];
        headerView.tag = 100;
        
        //昵称
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, cellwidth -20, cellwidth, 20)];
        nameLable.tag = 101;
        nameLable.text = [memberData objectForKey:@"nickname"];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont systemFontOfSize:12];
        nameLable.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        [memberCtrl addSubview:nameLable];
        [_memberView addSubview:memberCtrl];
    }
}

//进入个人主页
- (void)memberCtrlAction:(UIControl *)control{
    if (_isOwner) {
        if((control.tag -100) ==_memberArr.count){
            if(_memberArr.count ==1){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"还没有其他成员，不能执行删除" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                return;
            }
            //选择踢人
            ChatDeleteMemberController *chatDeleteVC = [[ChatDeleteMemberController alloc] init];
            chatDeleteVC.dataDic = _dataDic;
            [self.chatDetailGroupVC.navigationController pushViewController:chatDeleteVC animated:YES];
               return;
        }
    }
    
    //进入个人主页
    NSDictionary *dic  = _memberArr[control.tag - 100];
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    
    newMyPage.currentTitle = [dic objectForKey:@"nickname"];
    newMyPage.currentUid = [dic objectForKey:@"id"];
    [self.chatDetailGroupVC.navigationController pushViewController:newMyPage animated:YES];
}

@end
