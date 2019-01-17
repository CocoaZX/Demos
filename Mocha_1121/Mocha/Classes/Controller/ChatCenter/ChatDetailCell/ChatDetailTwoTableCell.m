//
//  ChatDetailTwoTableCell.m
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "ChatDetailTwoTableCell.h"

@implementation ChatDetailTwoTableCell
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
 }


//创建视图
- (void)_initViews{
    _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth -60, 10, 50, 40)];
    _switchView.on = YES;
    [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchView];
    
}


//设置groupID
- (void)setGroupID:(NSString *)groupID{
    if (_groupID != groupID) {
        _groupID = groupID;
        [self setNeedsLayout];
    }
}



//视图布局
- (void)layoutSubviews{
    [super layoutSubviews];
    //默认是不开启免打扰模式
    BOOL turb = NO;
   // 不接收apns的群组id
    NSArray *ignoredGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    NSLog(@"不接受apns的群组id:%@",ignoredGroupIds);
    for (NSString *str in ignoredGroupIds) {
        if ([str isEqualToString:_groupID]) {
            turb = YES;
            break;
        }
    }
    if (turb) {
        //显示免打扰开启
        _switchView.on = YES;
    }else{
        //显示免打扰不开启
        _switchView.on = NO;
    }
}


//触发开关
- (void)switchAction:(UISwitch *)switchUI{

    if(switchUI.on) {
        [[[EaseMob sharedInstance] chatManager]asyncIgnoreGroupPushNotification:_groupID isIgnore:YES];
        [LeafNotification showInController:_chatGropupVC withText:@"您开启了该群的消息免打扰模式"];
    }else {
        [[[EaseMob sharedInstance] chatManager]asyncIgnoreGroupPushNotification:_groupID isIgnore:NO];
        [LeafNotification showInController:_chatGropupVC withText:@"您关闭该群的消息免打扰模式"];
    }
}

//请求数据调整群消息设置
//弃用方法
/*
- (void)switchReceiveMessage:(NSString *)type{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setValue:_groupID forKey:@"groupid"];
    NSDictionary *param = [AFParamFormat formatEventListParams:dict];
    [AFNetwork noturbGroupMessage:param success:^(id data) {
        [LeafNotification showInController:_chatGropupVC withText:[data objectForKey:@"msg"]];
        
    } failed:^(NSError *error) {
        [LeafNotification showInController:_chatGropupVC withText:@"操作失败"];
    }];
}
 */
@end
