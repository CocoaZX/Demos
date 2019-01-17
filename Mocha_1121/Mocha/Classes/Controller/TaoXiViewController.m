//
//  TaoXiViewController.m
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiViewController.h"
#import "PhotoAndDescriptionTableViewCell.h"
#import "PersonInforTableViewCell.h"
#import "ConnectTableViewCell.h"
#import "StartYuePaiViewController.h"
#import "BuildTaoXiViewController.h"
#import "MokaTaoXiHeadView.h"

#import "McNavigationViewController.h"

@interface TaoXiViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UINavigationBarDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSString *descriptionStr;
    UIView *alphaView;
    float _height;
}

//表头视图
@property(nonatomic,strong)MokaTaoXiHeadView *taoXiHeadrView;
//表视图底部距离其所在父视图的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewbottomtosupeView_height;


//关于套系的详情信息
@property(nonatomic,strong)NSDictionary *dataDic;

@end

@implementation TaoXiViewController
/*
 -(void)initWithDictionary:(NSDictionary *)dictionary{
    self.currentUid = getSafeString(dictionary[@"uid"]);
    [self setNavigationRightBtn];
    self.dic = [NSDictionary dictionaryWithDictionary:dictionary];
    //头视图数据
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 320)];
    self.tableView.tableHeaderView = headerView;
    _headerView = [TaoXiHeaderView getTaoXiHeaderView];
    _headerView.supCon = self;
    _headerView.frame = headerView.bounds;
    [headerView addSubview:_headerView];
    NSDictionary *content = dictionary[@"content"];
    if (!((NSNull *)content == [NSNull null])){
        [_headerView initWithDictionary:dictionary];
        descriptionStr = getSafeString(dictionary[@"content"][@"setintroduce"]);
    }
    _height = _headerView.bigImgView.frame.size.height;
   
    //立即预约
    self.bookBtn.layer.masksToBounds = YES;
    self.bookBtn.layer.cornerRadius = 15;
    self.bookBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSLog(@"%@\n%@",uid,self.currentUid);
    if ([self.currentUid isEqualToString:uid]) {
        _bookBtn.hidden = YES;
        _connectWid .constant= 0;

        
    }else{
        _bookBtn.hidden = NO;
        _connectWid.constant = kDeviceWidth;

    }
}
*/

#pragma mark - 视图生命周期及控件加载

- (void)viewDidLoad {
    [super viewDidLoad];
    descriptionStr = @"";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //设置tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //是否显示预约
    BOOL isAppearYuePai = UserDefaultGetBool(ConfigYuePai);
    if (isAppearYuePai) {
        _bookBtn.hidden = NO;
        _connectWid = 0;
    }else
    {
        _bookBtn.hidden = YES;
        _connectWid.constant = kDeviceWidth;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self getInformation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

//热门秀的专题图片跳转专题方法
-(void)initWithHotFeedsDictionary:(NSDictionary *)dictionary{
    self.currentUid = getSafeString(dictionary[@"publisher"][@"uid"]);
    NSLog(@"%@",dictionary);
    //设置导航栏
    [self setNavigationRightBtn];
//    self.dic = [NSDictionary dictionaryWithDictionary:dictionary];
    self.dic = dictionary;
    //根据当前是否是自己，调整tabblew的高度和底部视图的显示
    [self adjustView];
    //头视图数据
    CGFloat imgH = kDeviceWidth *TaoXiScale;
    CGFloat tempH = 55;
    NSString *locationStr = getSafeString(_dic[@"content"][@"setplace"]);
    if (!(locationStr.length>0)) {
        tempH = 0;
    }
    
    CGFloat headViewHeight = imgH +10 +20 +10 +20 +10+tempH;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, headViewHeight)];
    self.tableView.tableHeaderView = headerView;
    _taoXiHeadrView = [MokaTaoXiHeadView getMokaTaoXiHeaderView];
    _taoXiHeadrView.supVC = self;
    _taoXiHeadrView.frame = headerView.bounds;
    [headerView addSubview:_taoXiHeadrView];
    
    NSDictionary *content = dictionary[@"content"];
    NSLog(@"%@",content);
    if (!((NSNull *)content == [NSNull null])){
        [_taoXiHeadrView initWithDictionary:dictionary];
        descriptionStr = getSafeString(dictionary[@"content"][@"setintroduce"]);
    }
    _height = imgH;
    
    //立即预约
    self.bookBtn.layer.masksToBounds = YES;
    self.bookBtn.layer.cornerRadius = 15;
    self.bookBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
    
    
}

//使用已有数据加载视图
-(void)initWithDictionary:(NSDictionary *)dictionary{
    self.currentUid = getSafeString(dictionary[@"uid"]);
    NSLog(@"%@",dictionary);
    //设置导航栏
    [self setNavigationRightBtn];
    self.dic = [NSDictionary dictionaryWithDictionary:dictionary];
    //根据当前是否是自己，调整tabblew的高度和底部视图的显示
    [self adjustView];
    //头视图数据
    CGFloat imgH = kDeviceWidth *TaoXiScale;
    CGFloat tempH = 55;
    NSString *locationStr = getSafeString(self.dic[@"content"][@"setplace"]);
    if (!(locationStr.length>0)) {
        tempH = 0;
    }
    CGFloat headViewHeight = imgH +10 +20 +10 +20 +10+tempH;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, headViewHeight)];
    self.tableView.tableHeaderView = headerView;
    _taoXiHeadrView = [MokaTaoXiHeadView getMokaTaoXiHeaderView];
    _taoXiHeadrView.supVC = self;
    _taoXiHeadrView.frame = headerView.bounds;
    [headerView addSubview:_taoXiHeadrView];
    
    NSDictionary *content = dictionary[@"content"];
    if (!((NSNull *)content == [NSNull null])){
        [_taoXiHeadrView initWithDictionary:dictionary];
        descriptionStr = getSafeString(dictionary[@"content"][@"setintroduce"]);
    }
    _height = imgH;
    
    //立即预约
    self.bookBtn.layer.masksToBounds = YES;
    self.bookBtn.layer.cornerRadius = 15;
    self.bookBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
}


//布局视图
- (void)adjustView{
    if ([self.currentUid isEqualToString:getCurrentUid()]) {
        //当前界面是自己
        self.tableViewbottomtosupeView_height.constant = 0;
         self.connectBtn.hidden = YES;
        self.liantianImg.hidden = YES;
        self.bookBtn.hidden = YES;
    }else{
        
    }
}

-(void)initWithHeader:(NSDictionary *)dictionary{
//    self.currentUid = getSafeString(dictionary[@"uid"]);
    NSLog(@"%@",dictionary);
    //设置导航栏
    [self setNavigationRightBtn];
    self.dic = [NSDictionary dictionaryWithDictionary:dictionary];
    //根据当前是否是自己，调整tabblew的高度和底部视图的显示
    [self adjustView];
    //头视图数据
    CGFloat imgH = kDeviceWidth *TaoXiScale;
    CGFloat tempH = 55;
    NSString *locationStr = getSafeString(self.dic[@"content"][@"setplace"]);
    if (!(locationStr.length>0)) {
        tempH = 0;
    }
    CGFloat headViewHeight = imgH +10 +20 +10 +20 +10+tempH;

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, headViewHeight)];
    self.tableView.tableHeaderView = headerView;
    _taoXiHeadrView = [MokaTaoXiHeadView getMokaTaoXiHeaderView];
    _taoXiHeadrView.supVC = self;
    _taoXiHeadrView.frame = headerView.bounds;
    [headerView addSubview:_taoXiHeadrView];
    
    NSDictionary *content = dictionary[@"content"];
    if (!((NSNull *)content == [NSNull null])){
        [_taoXiHeadrView initWithDictionary:dictionary];
        descriptionStr = getSafeString(dictionary[@"content"][@"setintroduce"]);
    }
    _height = imgH;
    
    //立即预约
    self.bookBtn.layer.masksToBounds = YES;
    self.bookBtn.layer.cornerRadius = 15;
    self.bookBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeOrangeColor];

}



-(void)setNavigationRightBtn{
    self.navigationItem.title = @"专题";
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(0, 0, 30, 30)];
//    [shareBtn setFrame:CGRectMake(0, 0, 25, 24)];
    [shareBtn setFrame:CGRectMake(0, 7, 45, 30)];

    [shareBtn setImage:[UIImage imageNamed:@"mokafenxiang"] forState:UIControlStateNormal];
    
    [shareBtn setTitle:@"推荐" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [editBtn setImage:[UIImage imageNamed:@"editPerson"] forState:UIControlStateNormal];
    
    [editBtn addTarget:self action:@selector(editInformationMethod) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn addTarget:self action:@selector(shareInformationMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem *sharItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSLog(@"%@\n%@",uid,self.currentUid);
    
    //是否显示编辑按钮
    if ([self.currentUid isEqualToString:uid]) {
        self.navigationItem.rightBarButtonItems = @[sharItem,editItem];
        
    }else{
        self.navigationItem.rightBarButtonItems = @[sharItem];
    }
    
}



#pragma mark - 获取数据
- (void)getInformation{
    NSString *cuid = self.dic[@"albumId"];
    //获取套系详情
    if (cuid) {
         NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setObject:@"3" forKey:@"album_type"];
        [mdic setObject:cuid forKey:@"id"];
        NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];
        [AFNetwork getMokaDetail:params success:^(id data) {
            NSLog(@"%@",data[@"data"]);
            self.dataDic = (NSDictionary *)data[@"data"];
            self.dataSourceArr = _dataDic[@"photos"];
            
            //若是热门秀跳转专题
            if (_isHotFeedsTaoxi || _isHomePage) {
                [self initWithHotFeedsDictionary:data[@"data"]];
                @try {
                    self.dic = @{@"albumId":self.dataDic[@"albumId"],@"title":self.dataDic[@"content"][@"setname"],@"content":self.dataDic[@"content"],@"nickname":self.dataDic[@"publisher"][@"nickname"],@"headerURL":self.dataDic[@"publisher"][@"head_pic"],@"uid":self.dataDic[@"publisher"][@"uid"]};
                    
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                }
            
            
            
            [self.tableView reloadData];
        } failed:^(NSError *error) {
            
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)editInformationMethod{
    NSLog(@"editInformationMethod");
    //编辑套系
    BuildTaoXiViewController *buildTXC = [[BuildTaoXiViewController alloc]init];
    [buildTXC initWithDictionary:self.dataDic.copy];
    buildTXC.isEdit = YES;
    [self.navigationController pushViewController:buildTXC animated:YES];
}

-(void)shareInformationMethod{
    NSLog(@"shareInformationMethod");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",nil];
    [actionSheet showInView:self.view];
}




#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"navigationDelegate\n\n\n");
    if (viewController == self) {
        //        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBar.tintColor = nil;
    }
}



#pragma mark - tableViewDelegateDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
            //picture description
        case 1:
            return self.dataSourceArr.count;
            break;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
            //total description
        case 0:
        {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descriptionCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            NSString *taoxiDesc = getSafeString(_dic[@"content"][@"setintroduce"]);
            cell.textLabel.text = taoxiDesc;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
            return cell;
        }
            break;
            //picture description
        case 1:
        {
            PhotoAndDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoAndDescriptionTableViewCell"];
            if (!cell) {
                cell = [PhotoAndDescriptionTableViewCell getPhotoAndDescriptionTableViewCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backLabel.hidden = YES;
                cell.deleteBtn.hidden = YES;
                cell.descriptionTxtView.userInteractionEnabled = NO;
                cell.defaultLabel.hidden = YES;
            }
            cell.cellType = @"netCell";
            cell.dataDic = self.dataSourceArr[indexPath.row];
            //[cell initWithDictionary:self.dataSourceArr[indexPath.row]];
            return cell;
            
        }
            break;
            //person information
        case 2:
        {
            PersonInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInforTableViewCell"];
            if (!cell) {
                cell = [PersonInforTableViewCell getPersonInforTableViewCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.supCon = self;
            [cell initWithDictionary:self.dic];
            return cell;
        }
            break;
        /*
            //contact
        case 3:
        {
            ConnectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConnectTableViewCell"];
            if (!cell) {
                cell = [ConnectTableViewCell getConnectTableViewCell];
            }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
         */
        default:
            break;
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
             NSString *taoxiDescription = getSafeString(_dic[@"content"][@"setintroduce"]);
            if (taoxiDescription.length >0) {
                
                return [CommonUtils sizeFromText:taoxiDescription textFont:[UIFont systemFontOfSize:16] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth, MAXFLOAT)].height+20;
            }else{
                //空字符串
                return 20;
            }

            break;
        }
        case 1:
            return [PhotoAndDescriptionTableViewCell getCellHeightWithDictionary:self.dataSourceArr[indexPath.row]];
            break;
        case 2:
            return 200;
            break;
            
        case 3:
            return 50;
            break;
        default:
            break;
    }
    return 20;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 15;
            break;
            
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark - 事件处理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            //朋友圈
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            NSString *shareURL = getSafeString(self.dic[@"albumId"]);
            NSString *title = getSafeString(self.dic[@"title"]);
            NSString *discription = getSafeString(self.dic[@"content"][@"setintroduce"]);
            UIImage *headerImg = self.taoXiHeadrView.bigImgView.image;
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:title desc:discription header:headerImg URL:shareURL uid:shareURL isTaoXi:YES];
        }
            break;
        case 1:
        {
            //微信
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            NSString *shareURL = getSafeString(self.dic[@"albumId"]);
            NSString *title = getSafeString(self.dic[@"title"]);
            NSString *discription = getSafeString(self.dic[@"content"][@"setintroduce"]);
            UIImage *headerImg = self.taoXiHeadrView.bigImgView.image;
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:title desc:discription header:headerImg URL:shareURL uid:shareURL isTaoXi:YES];
            
        }
            break;
            
        case 2:
        {   //QQ
            UIImage *image = self.taoXiHeadrView.bigImgView.image;
            NSString *shareURL = getSafeString(self.dic[@"albumId"]);
            NSString *title = getSafeString(self.dic[@"title"]);
            NSString *discription = getSafeString(self.dic[@"content"][@"setintroduce"]);
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            if (!imageData) {
                imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:discription title:title imageData:imageData targetUrl:@"u" objectId:shareURL isTaoXi:YES];
            
            
        }
            break;
        default:
            break;
    }
}






- (IBAction)connectAction:(id)sender {
    NSString *fromHeaderURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:self.currentUid conversationType:eConversationTypeChat];
    //摄影师名字
    chatController.title = getSafeString(self.dic[@"nickname"]);
    
    chatController.fromHeaderURL = getSafeString(fromHeaderURL);
    //摄影师头像
    chatController.toHeaderURL = getSafeString(self.dic[@"headerURL"]);
    [self.navigationController pushViewController:chatController animated:YES];
}


- (IBAction)bookAction:(id)sender {
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (isBangDing) {
            StartYuePaiViewController *yuepai = [[StartYuePaiViewController alloc] initWithNibName:@"StartYuePaiViewController" bundle:[NSBundle mainBundle]];
            yuepai.receiveUid = self.currentUid;
            yuepai.receiveName = getSafeString(self.dic[@"nickname"]);
            yuepai.receiveHeader = getSafeString(self.dic[@"headerURL"]);
            yuepai.taoXiName = getSafeString(self.dic[@"title"]);
            yuepai.isTaoxi = YES;
            yuepai.price = getSafeString(self.dic[@"content"][@"setprice"]);
            yuepai.moneyTextfield.userInteractionEnabled = NO;
            yuepai.taoXiID = getSafeString(self.dic[@"albumId"]);
            [self.navigationController pushViewController:yuepai animated:YES];
            
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            
        }
        
        
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
    }
}


#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollImage];
}
    
    
- (void)scrollImage {

    CGFloat offsetY = self.tableView.contentOffset.y
    ;
    if (offsetY <0) {
        CGFloat imgViewHeight = kDeviceWidth *TaoXiScale;
        CGFloat newHeight = imgViewHeight - offsetY;
        CGFloat newWidth = kDeviceWidth *(newHeight/imgViewHeight);
        self.taoXiHeadrView.bigImgView.frame = CGRectMake((kDeviceWidth -newWidth)/2, offsetY, newWidth, newHeight);
//=======
//    CGPoint offset = self.tableView.contentOffset;
//    CGFloat y_offset = offset.y;
//    if (y_offset < 0) {
//        CGRect rect = self.headerView.bigImgView.frame;
//        rect.origin.y = 0 + y_offset ;
//        rect.origin.x = 0 + y_offset / 2;
//        rect.size.height = _height - y_offset;
//        rect.size.width = kDeviceWidth - y_offset;
//        //专题头视图不随滑动而改变
////        self.headerView.bigImgView.frame = rect;
//>>>>>>> .r640
    }
}



#pragma mark - 获取视图get
-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (NSDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSDictionary dictionary];
    }
    return _dataDic;
}



@end
