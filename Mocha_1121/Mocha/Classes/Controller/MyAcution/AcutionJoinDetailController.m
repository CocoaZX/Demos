//
//  AcutionJoinDetailController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "AcutionJoinDetailController.h"
#import "AcutionPublishSuccessController.h"
#import "AcutionInfoView.h"


@interface AcutionJoinDetailController ()

@property (weak, nonatomic) IBOutlet AcutionInfoView *acutionInfoView;
@property (weak, nonatomic) IBOutlet UILabel *acutionNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *deadLineTimeLabel;

@end

@implementation AcutionJoinDetailController


#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MyAuction", nil);;
    //设置数据
    [self resetViews];
}


- (void)resetViews{
    //设置竞拍信息
    _acutionInfoView.dataDic = _acutionDic;
    
    //竞拍码
    NSString *code = getSafeString(_acutionDic[@"code"]) ;
    _acutionNumberLabel.text = code;
    
    //有效期
    //_deadLineTimeLabel.text =   _acutionDic[@"end_time"];
}



//发送竞拍码
//私信消息
- (IBAction)sendAcutionNumberBtnClick:(UIButton *)sender {
    
    /*
    NSMutableDictionary *chatDic = [NSMutableDictionary dictionary];
    //竞拍码
    NSString *auctionNum = _acutionDic[@"code"];
    NSString *textMessage = [NSString stringWithFormat:@"竞拍验证码：%@",auctionNum];
    //对方id
    NSString *chatId = _acutionDic[@"publisher"][@"uid"];
    
    [chatDic setObject:getCurrentUid() forKey:@"from"];
    [chatDic setObject:chatId forKey:@"target"];
    
    [chatDic setObject:textMessage forKey:@"msg"];
    
    [ChatManager sendDaShangSuccessMessage:chatDic];
    */
    //进入私信
    [self sixinMethod:nil];

}


- (void)sixinMethod:(UIButton *)sender
{
    //对方id
    NSString *chatId = _acutionDic[@"publisher"][@"uid"];
    //发送竞拍码的消息内容
    NSString *auctionNum = _acutionDic[@"code"];
    NSString *textMessage = [NSString stringWithFormat:@"%@",auctionNum];

    //新创建聊天界面，进行如下步骤
    #ifdef HXRelease
        //异步登陆账号
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[ChatManager sharedInstance].hxName password:@"123456"
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             
             if (loginInfo && !error) {
                 //获取群组列表
                 [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                 
                 //设置是否自动登录
                 [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                 
                 //将2.1.0版本旧版的coredata数据导入新的数据库
                 EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                 if (!error) {
                     error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                 }
                 
                 //发送自动登陆状态通知
                 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             }
             else
             {
                 NSLog(@"登陆错误%@",error.description);
             }
         } onQueue:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *fromHeaderURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
            ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:chatId conversationType:eConversationTypeChat];
            chatController.preparedTxt = textMessage;
            chatController.fromHeaderURL = getSafeString(fromHeaderURL);
           //chatController.toHeaderURL = getSafeString(self.currentHeaderURL);
           [self.navigationController pushViewController:chatController animated:YES];
        });
#else
        McChatRoomViewController *chatVC = [[McChatRoomViewController alloc] initWithOtherUserId:_thisUid isReadMsg:NO];
        chatVC.headPic = self.headerURL;
        chatVC.title = self.userName;
        [self.navigationController pushViewController:chatVC animated:YES];
#endif
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }
 @end
