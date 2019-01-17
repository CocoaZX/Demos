//
//  DynamicWebViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/25.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DynamicWebViewController.h"
#import "OpenMemberViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSONKit.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "MokaPhotosViewController.h"
#import "DynamicAlbumsViewController.h"

@interface DynamicWebViewController ()<UIActionSheetDelegate>

@property (nonatomic,strong) NSURL *url;

//中间变量参数参数
//js交互：动态模卡类型参数
@property (copy, nonatomic) NSString *dynamicType;
//js交互：动态模卡音乐ID参数
@property (copy, nonatomic) NSString *backMusicId;


//视图组件
@property(nonatomic,strong)UIActionSheet *shareSheet;
@property(nonatomic,strong)UIActionSheet *weiXinSheet;
//右上角按钮
@property(nonatomic,strong)UIButton *rightButton;
//进度动态模卡
@property(nonatomic,strong)UIView *bottomView;

//动态模卡的信息字典
@property(nonatomic,strong)NSDictionary *albumDic;

@end

@implementation DynamicWebViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"动态制作";
    self.hidesBottomBarWhenPushed = YES;
    [self setNavigationBar];
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self.linkUrl, NULL, NULL,  kCFStringEncodingUTF8 ));
    self.url = [NSURL URLWithString:encodedString];
    //self.url = [NSURL URLWithString:testURL];
    
    
    //默认参数
    self.dynamicType = @"";
    self.backMusicId = @"";
    //加载创建动态模卡的网页
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    
    //去掉中间的视图控制器
    [self deleteUnusedVCForback];
    //是否显示进入到动态模卡列表的按钮
    if ([self.fromVCName isEqualToString:@"createDynamic"]) {
        [self.view addSubview:self.bottomView];
        [self.view bringSubviewToFront:self.bottomView];
    }
    
}

//设置导航栏
- (void)setNavigationBar{
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    if([self.conditionType isEqualToString:@"showDynamic"]){
        [_rightButton setTitle:@"分享" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(showShareAction) forControlEvents:UIControlEventTouchUpInside];
    }else if([self.conditionType isEqualToString:@"createDynamic"]){
        [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(requesetForBuildDynamicMOKA) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //打开音乐
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:@"yinpin.play()"];


}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
 }


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    
}

#pragma mark - UiWebview Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
    NSLog(@"完成html");

    //当前网页的标题
    NSString *titleStr = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = titleStr;
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
    __weak typeof (self) vc = self;
    /*
    context[@"chooseDynamicMOKAMusic"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
            NSString *string = getSafeString(obj);
            NSDictionary *jsonDiction = [string objectFromJSONString];
            //音乐参数
            NSString *dynamicMusicId = getSafeString(jsonDiction[@"musicId"]);
            vc.backMusicId = dynamicMusicId;
          }
    };
    */
    
    
    context[@"chooseDynamicMOKAType"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
            NSString *string = getSafeString(obj);
            NSDictionary *jsonDiction = [string objectFromJSONString];
            //模板参数
            NSString *dynamicType = getSafeString(jsonDiction[@"dynamicType"]);
            vc.dynamicType = dynamicType;
            vc.backMusicId =dynamicType;
          }
    };
    
    [self communicateWithJS:context withVC:self];

    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}



#pragma mark - 事件处理
- (void)buildDynamicAlbumSuccess{
    //已经创建了视图控制器，移除中间选择图片的视图控制器
    self.rightButton.hidden = YES;
    UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:@"制作动态模卡成功，确定查看" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [AlertView show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //查看动态模卡
        //制作动态模卡的界面
        DynamicWebViewController *dynamicWebVC = [[DynamicWebViewController alloc] initWithNibName:@"DynamicWebViewController" bundle:nil];
        dynamicWebVC.conditionType = @"showDynamic";
        dynamicWebVC.fromVCName = @"createDynamic";
        dynamicWebVC.currentUid = getCurrentUid();
        dynamicWebVC.dynamicDic = self.albumDic;
        //设置链接
        NSString *webUrl = [USER_DEFAULT objectForKey:@"webUrl"];
        NSString *dynamicUrl = [NSString stringWithFormat:@"%@/dynamic/detail?id=%@&album_type=4",webUrl, self.albumDic[@"albumId"]];
        dynamicWebVC.linkUrl = dynamicUrl;
        NSLog(@"-------%@",dynamicUrl);
        [self.navigationController pushViewController:dynamicWebVC animated:YES];
    }
    
}



//跳过中间上传图片的视图控制器直接返回
- (void)deleteUnusedVCForback{
    NSMutableArray *removeArr = @[].mutableCopy;
    if([self.conditionType isEqualToString:@"showDynamic"]){
        //如果当前是展示动态模卡的界面
        for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
            id controller = self.navigationController.childViewControllers[i];
            if ([controller isKindOfClass:[MokaPhotosViewController class]]) {
                //移除选择照片的操作
                [removeArr addObject:controller];
            }else if([controller isKindOfClass:[DynamicWebViewController class]]) {
                //if([self.conditionType isEqualToString:@"showDynamic"]){
                    //如果当前界面是展示动态模卡的界面
                    //而且是从制作界面跳转过来的
                    //移除动态模卡制作的界面
                    DynamicWebViewController *dynamicVC = (DynamicWebViewController *)controller;
                    if([dynamicVC.conditionType isEqualToString:@"createDynamic"]){
                        [removeArr addObject:controller];
                    }
               // }
            }
        }
    }
    
    NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
    for (int i=0; i<removeArr.count; i++) {
        id controller = removeArr[i];
        [tempArr removeObject:controller];
    }
    [self.navigationController setViewControllers:tempArr];
    
}



- (void)enterDynamicListVC{
    //进入动态模卡列表，关闭音乐
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:@"yinpin.pause()"];
    
    DynamicAlbumsViewController *dynamicAlbumsVC = [[DynamicAlbumsViewController alloc] init];
    dynamicAlbumsVC.currentUid = self.currentUid;
    [self.navigationController pushViewController:dynamicAlbumsVC animated:YES];
}






#pragma mark 分享
-(void)showShareAction{
    NSLog(@"shareInformationMethod");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",nil];
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //配置中分享动态模卡的文案
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    NSString *shareDesc = getSafeString([descriptionDic objectForKey:@"shareDynamicAlbumDesc"]);
    if (shareDesc.length == 0) {
        shareDesc = @"分享动态模卡";
    }
    
    UIImage *coverImg = self.dynamicCoverImg;
    if (coverImg == nil) {
        NSString *coverImgStr = getSafeString(_dynamicDic[@"cover_url"]);
        if (coverImgStr.length != 0) {
            NSString *imgJpg = [CommonUtils imageStringWithWidth:100*2 height:100*2];
            NSString *imgCompleteurl = [NSString stringWithFormat:@"%@%@",coverImgStr,imgJpg];
            coverImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgCompleteurl]]];
        }
     }
    if (!coverImg) {
        coverImg = [UIImage imageNamed:@"AppIcon40x40"];
    }

    switch (buttonIndex) {
        case 0:
        {
            //朋友圈
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            NSString *shareTitle = @"动态模卡分享";
             NSString *shareURL = [NSString stringWithFormat:@"dynamic/detail?id=%@&album_type=4",self.dynamicDic[@"albumId"]];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendWeiXInLinkContentTitle:shareTitle desc:shareDesc header:coverImg URL:shareURL uid:self.currentUid withuseType:@""];
         }
            break;
        case 1:
        {
            //微信
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            NSString *shareTitle = @"动态模卡分享";
            NSString *shareURL = [NSString stringWithFormat:@"dynamic/detail?id=%@&album_type=4",self.dynamicDic[@"albumId"]];

            [(AppDelegate *)[UIApplication sharedApplication].delegate sendWeiXInLinkContentTitle:shareTitle desc:shareDesc header:coverImg URL:shareURL uid:self.currentUid withuseType:@""];
        }
            break;
            
        case 2:
        {
            //QQ
            NSString *shareTitle = @"动态模卡分享";
            NSData *imageData = UIImageJPEGRepresentation(coverImg, 1);

            NSString *shareURL = [NSString stringWithFormat:@"dynamic/detail?id=%@&album_type=4",self.dynamicDic[@"albumId"]];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:shareDesc title:shareTitle imageData:imageData targetUrl:shareURL objectId:@"" withuseType:@""];
        }
            break;
        default:
            break;
    }
}




#pragma mark - 网络处理

//创建动态模卡
- (void)requesetForBuildDynamicMOKA{
    if ([self prepareForCreateDynamic] == nil) {
        return;
    }
    NSDictionary *params = [AFParamFormat formatCreateMokaParams:[self prepareForCreateDynamic]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //请求网络创建相册
    [AFNetwork createAlbum:params success:^(id data){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            //数据请求成功之后就进入照片界面
            self.albumDic = data[@"data"];
            [self buildDynamicAlbumSuccess];
          }
        else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}




//创建动态模卡判断参数正确性，返回请求参数字典
- (NSDictionary *)prepareForCreateDynamic{
    //新建动态moka
    //    json串{"open":{"is_private":"1","visit_coin":"8"},"dynamic":{"back_music":"","photo_ids_list":""}}0：公开，1：私有,当时私密相册时，可以没有dynamic字段，当时动态模卡时，可以没有open字段
    //判断登陆和绑定
    if (getCurrentUid()) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (!isBangDing) {
            //显示绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return nil;
        }
    }else{
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return nil;
    }
    
    //设置普通请求参数
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:@"4" forKey:@"album_type"];
    
    NSMutableDictionary *settingDic = [NSMutableDictionary dictionary];
    //设置私密性参数
    NSMutableDictionary *privacyDic = [NSMutableDictionary dictionary];
    [privacyDic setObject:@"0" forKey:@"is_private"];
    [privacyDic setObject:@"0" forKey:@"visit_coin"];
    [settingDic setObject:privacyDic forKey:@"open"];
    //NSString *openString = [SQCStringUtils JSONStringWithDic:openDic];
    
    //动态模卡数据参数
    NSMutableDictionary *dynamicDic = [NSMutableDictionary dictionary];
    [dynamicDic setObject:self.photoIds forKey:@"photo_ids_list"];
    [dynamicDic setObject:self.backMusicId forKey:@"back_music"];
    //动态模卡模板类型
    [dynamicDic setObject:self.dynamicType forKey:@"template"];
    //NSString *dynamicDicString = [SQCStringUtils JSONStringWithDic:dynamicDic];
    [settingDic setObject:dynamicDic forKey:@"dynamic"];
    NSString *settingDicJson = [SQCStringUtils JSONStringWithDic:settingDic];
    [diction setObject:settingDicJson forKey:@"setting"];
    
    return diction;
}







#pragma mark - set/get方法
- (NSDictionary *)albumDic{
    if (_albumDic == nil) {
        _albumDic = [NSDictionary dictionary];
    }
    return _albumDic;
}

//获取动态模卡
- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight -64 -50, kDeviceWidth, 50)];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.5;
        //按钮进入动态模卡列表
        UIButton *enterDynamicListBtn = [[UIButton alloc] initWithFrame:_bottomView.bounds];
        enterDynamicListBtn.backgroundColor = [UIColor clearColor];
        [enterDynamicListBtn setTitle:@"查看动态模卡列表" forState:UIControlStateNormal];
        [enterDynamicListBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
        [enterDynamicListBtn addTarget:self action:@selector(enterDynamicListVC) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:enterDynamicListBtn];
    }
    return _bottomView;
}





@end
