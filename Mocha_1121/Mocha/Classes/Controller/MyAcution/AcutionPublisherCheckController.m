//
//  AcutionPublisherCheckController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "AcutionPublisherCheckController.h"

#import "AcutionPublishSuccessController.h"

#import "AcutionInfoView.h"

@interface AcutionPublisherCheckController ()<UITextFieldDelegate>

@end

@implementation AcutionPublisherCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞拍详情";
    self.acutionInfoView.dataDic = self.acutionDic;
    
    //输入框
    self.auctionNumTextField.returnKeyType = UIReturnKeyDone;
    self.auctionNumTextField.delegate  =self;
}


#pragma mark - 事件点击
- (IBAction)yanzhengBtnClick:(id)sender {
    
    NSString *auctionNumber = _auctionNumTextField.text;
    if (auctionNumber.length == 0) {
        [LeafNotification showInController:self withText:@"请输入竞拍验证码"];
        return;
    }

    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setObject:auctionNumber forKey:@"code"];
    [mdic setObject:_acutionDic[@"auction_id"] forKey:@"auctionId"];
    NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //网络请求
    [AFNetwork postRequeatDataParams:params path:PathPostForSendAuctionNumber success:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            //进入竞拍成功的界面
            AcutionPublishSuccessController *vc = [[AcutionPublishSuccessController alloc] initWithNibName:@"AcutionPublishSuccessController" bundle:nil];
            vc.acutionDic = self.acutionDic;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string] == YES)
    {
        [_auctionNumTextField resignFirstResponder];
    }
    
    return YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

@end
