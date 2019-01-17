//
//  BuildAlbumViewController.m
//  Mocha
//
//  Created by sun on 15/9/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "BuildAlbumViewController.h"
#import "AlbumDetailViewController.h"


@interface BuildAlbumViewController ()

@property (weak, nonatomic) IBOutlet UITextField *contentTexfield;

@property (nonatomic , strong) NSDictionary *titleTextLimitDic;

@end

@implementation BuildAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新建摄影集";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(editPersonalData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    [self getRule_fontlimit];
}

#pragma mark - getRule_fontlimit
-(void)getRule_fontlimit{
    NSDictionary *rule_fontlimit = [USER_DEFAULT valueForKey:@"rule_fontlimit"];
    _titleTextLimitDic = [NSDictionary dictionary];
    if (rule_fontlimit) {
        if (rule_fontlimit[@"album_title"]) {
            _titleTextLimitDic = rule_fontlimit[@"album_title"];
        }
    }
    if (_titleTextLimitDic[@"max"] == nil) {
        [_titleTextLimitDic setValue:[NSNumber numberWithInt:10] forKey:@"max"];
        [_titleTextLimitDic setValue:[NSNumber numberWithInt:1] forKey:@"min"];
    }
    _contentTexfield.placeholder = [NSString stringWithFormat:@"%@个字以上,%@个字以内",_titleTextLimitDic[@"min"],_titleTextLimitDic[@"max"]];
}

- (void)editPersonalData
{
       NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if (uid) {
            BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
            if (!isBangDing) {
                //显示绑定
                [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
                return;
            }
        }else{
            //显示登陆
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            return;
        }

    if (self.contentTexfield.text.length<[_titleTextLimitDic[@"min"] intValue]||self.contentTexfield.text.length>[_titleTextLimitDic[@"max"] intValue]) {
        [LeafNotification showInController:self withText:[NSString stringWithFormat:@"%@个字以上,%@个字以内",_titleTextLimitDic[@"min"],_titleTextLimitDic[@"max"]]];
        return;
    }
    NSString *album_type = @"2"; // 1模特卡、2相册
    NSString *title = self.contentTexfield.text;
    NSString *style = @"0"; //样式:0无（用于相册）,1五图经典,2新式五图,3经典九图,4经典十图
    NSString *description = @"description";
    
    NSDictionary *params = [AFParamFormat formatCreateMokaParams:@{@"album_type":album_type,@"style":style,@"title":title,@"description":description}];
    [AFNetwork createAlbum:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            
            AlbumDetailViewController *newActivity = [[AlbumDetailViewController alloc] initWithNibName:@"AlbumDetailViewController" bundle:[NSBundle mainBundle]];
            newActivity.albumid = [NSString stringWithFormat:@"%@",data[@"data"][@"albumId"]];
            newActivity.currentTitle = [NSString stringWithFormat:@"%@",data[@"data"][@"title"]];
            newActivity.currentUid = [NSString stringWithFormat:@"%@",data[@"data"][@"authorId"]];
            
            [self.navigationController pushViewController:newActivity animated:YES];
            for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
                id controller = self.navigationController.childViewControllers[i];
                if ([controller isKindOfClass:[BuildAlbumViewController class]]) {
                    NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
                    [tempArr removeObject:controller];
                    [self.navigationController setViewControllers:tempArr];
                }
            }
            
        }
        else {
            [LeafNotification showInController:self withText:data[@"msg"]];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"请先注册手机号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertV show];
        }
        
        
    }failed:^(NSError *error){
        
      [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
 
    }];
    
}



@end
