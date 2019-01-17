//
//  McSettingViewController.m
//  Mocha
//
//  Created by renningning on 14-11-20.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McSettingViewController.h"
#import "McPersonalDataViewController.h"
#import "McNewAboutViewController.h"
#import "McCallBackViewController.h"
#import "McSiXinSettingViewController.h"
#import "RenZhengViewController.h"
#import "McSetAccountViewController.h"
#import "McNewFeedBackViewController.h"
#import "TuijianTableViewCell.h"
#import "JSONKit.h"
#import "ReadPlistFile.h"
#import "McPersonalData.h"
#import "MBProgressHUD.h"
#import "McRenZhengViewController.h"

@interface McSettingViewController () <UITableViewDataSource,
                                        UITableViewDelegate,
                                        UIAlertViewDelegate>
{
    NSArray *sectionArray;
    NSArray *sectionSiXinArray;
    NSArray *sectionFirstArray;
    NSArray *sectionSecondArray;
    NSArray *sectionThirdArray;
 
    UIImageView *headImageView;
    UILabel *userNameLab;
    UILabel *introLab;
    
    NSDictionary *sexDict;
    NSDictionary *jobDict;
    NSArray *areaArray;
    NSDictionary *hairDict;
    NSDictionary *majorDict;
    NSDictionary *workTagDict;
    NSDictionary *figureTagDict;
    NSDictionary *feetDict;
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) UIView *footerView;

@property (nonatomic, strong) McPersonalData *personalData;

//缓存大小
@property (nonatomic,assign)CGFloat cacheSize;


//调整组的索引，便于隐藏相关的单元格隐藏
@property(nonatomic,assign)BOOL showSiXin;
@property(nonatomic,assign)NSInteger sec0;
@property(nonatomic,assign)NSInteger sec1;
@property(nonatomic,assign)NSInteger sec2;
@property(nonatomic,assign)NSInteger sec3;
@property(nonatomic,assign)NSInteger sec4;

//弹出提示是否确定退出登陆
@property(nonatomic,strong)UIAlertView *logoutAlertView;


@end

@implementation McSettingViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"setting", nil);
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 120)];
    self.headerView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self.view addSubview:_headerView];
    
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 10);

    //不用
    //[self layoutSubViewsInHeadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (CGRectGetHeight(self.view.bounds) - 64) ) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = _headerView;
//    self.tableView.tableFooterView = _footerView;
    self.tableView.scrollEnabled = YES;
    [self.view addSubview:_tableView];
    
    sectionArray = @[@"资质认证"];
    sectionSiXinArray = @[@"私信权限"];
    sectionFirstArray = @[@"编辑资料",@"账号管理",@"清理缓存"];//@"账号安全设置",
    sectionSecondArray = @[@"我的推荐",@"意见反馈",@"关于MOKA"];
    sectionThirdArray = @[@"退出登录"];
    //[self loadArrayWithFile];
    
    _showSiXin = [USER_DEFAULT boolForKey:ConfigShang];
    /*
     if (_showSiXin) {
        _sec0 = 0;
        _sec1 = 1;
        _sec2 = 2;
        _sec3 = 3;
        _sec4 = 4;
    }else{
        _sec0 = 0;
        _sec1 = 999;
        _sec2 = 1;
        _sec3 = 2;
        _sec4 = 3;
    }
    */
    
    //需求更改：不再显示资质认证
    if (_showSiXin) {
        _sec0 = 888;
        _sec1 = 0;
        _sec2 = 1;
        _sec3 = 2;
        _sec4 = 3;
    }else{
        _sec0 = 888;
        _sec1 = 999;
        _sec2 = 0;
        _sec3 = 1;
        _sec4 = 2;
    }

    [self loadPersonalData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHeaderData];
    //计算缓存
    [self countCacheSize];
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 加载资源
- (void)loadArrayWithFile
{
    sexDict = [ReadPlistFile readSex];
    
    areaArray = [ReadPlistFile readAreaArray];
    
    //    workTagDict = [ReadPlistFile readWorkTags];
    //    figureTagDict = [ReadPlistFile readWorkStyles];
    //
    //    hairDict = [ReadPlistFile readHairs];
    //
    //    jobDict = [ReadPlistFile readProfession];
    //
    //    majorDict = [ReadPlistFile readMajor];
    //
    //    feetDict = [ReadPlistFile readFeets];
    //
}

- (void)loadPersonalData
{
    NSDictionary *dataDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if (!_personalData) {
        _personalData = [[McPersonalData alloc] init];
    }
    _personalData.nickName = dataDict[@"nickname"];
    _personalData.headUrl = dataDict[@"head_pic"];
    NSString *sexStr = dataDict[@"sex"];
    
    if ([sexStr intValue] == 1) {
        _personalData.sex = @"男";
    }
    else if([sexStr intValue] == 2){
        _personalData.sex = @"女";
    }
    else{
        _personalData.sex = @"";
    }
    _personalData.authentication = dataDict[@"authentication"];
    _personalData.job = [jobDict valueForKey:dataDict[@"job"]];
    _personalData.major = [majorDict valueForKey:dataDict[@"major"]];
    _personalData.height = dataDict[@"height"];
    _personalData.weight = dataDict[@"weight"];
    
    _personalData.age = [dataDict[@"birth"] isEqualToString:@"0000-00-00"]?@"":dataDict[@"birth"];
    
    NSString *provinceId = dataDict[@"province"];
    NSString *cityId = dataDict[@"city"];
    NSString *province = @"";
    NSString *city = @"";
    for (NSDictionary *dicts in areaArray) {
        if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
            province = dicts[@"name"];
            NSArray *citys = dicts[@"citys"];
            for (NSDictionary *cityDict in citys) {
                if ([cityDict[@"id"] integerValue] == [cityId integerValue]) {
                    city = cityDict[@"name"];
                }
            }
        }
    }
    _personalData.area = [NSString stringWithFormat:@"%@%@",getSafeString(dataDict[@"provinceName"]) ,getSafeString(dataDict[@"cityName"])];
    
    _personalData.bust = dataDict[@"bust"];
    _personalData.waist = dataDict[@"waist"];
    _personalData.hips = dataDict[@"hipline"];
    
    _personalData.measurements = [dataDict[@"bust"] integerValue]> 0?[NSString stringWithFormat:@"%@-%@-%@",dataDict[@"bust"],dataDict[@"waist"],dataDict[@"hipline"]]:@"";
    
    _personalData.hair = [[hairDict allKeysForObject:dataDict[@"hair"]] firstObject];
    _personalData.feetCode = [[feetDict allKeysForObject:dataDict[@"foot"]] firstObject];
    _personalData.signName = dataDict[@"mark"];
    _personalData.leg = dataDict[@"leg"];
    
    NSArray *workArr = [dataDict[@"worktags"] componentsSeparatedByString:@","];
    NSMutableString *workStr = [NSMutableString stringWithString:@""];
    for (NSString *key in workArr) {
        [workStr appendString:[NSString stringWithFormat:@"%@ ",workTagDict[key]?workTagDict[key]:@""]];
    }
    
    NSArray *figureArr = [dataDict[@"workstyle"] componentsSeparatedByString:@","];
    NSMutableString *figureStr = [NSMutableString stringWithString:@""];
    for (NSString *key in figureArr) {
        [figureStr appendString:[NSString stringWithFormat:@"%@ ",figureTagDict[key]?figureTagDict[key]:@""]];
    }
    
    if ([figureStr isEqualToString:@" "]) {
        figureStr = [NSMutableString stringWithString:@""];
    }
    if ([workStr isEqualToString:@" "]) {
        workStr = [NSMutableString stringWithString:@""];
    }
    
    _personalData.figureLabel = figureStr;
    _personalData.workExperience = dataDict[@"workhistory"];
    _personalData.introduction = dataDict[@"introduction"];
    _personalData.workPlace = dataDict[@"studio"];
    _personalData.workLabel = workStr;
    _personalData.desiredSalary = dataDict[@"payment"];
    
}

-(void)setHeaderData
{
    NSInteger wid = CGRectGetWidth(headImageView.frame) * 2;
    NSInteger hei = CGRectGetHeight(headImageView.frame) * 2;
    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
    NSString *url = [NSString stringWithFormat:@"%@%@",_personalData.headUrl,jpg];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head60"]];
    [userNameLab setText:_personalData.nickName];
    [introLab setText:_personalData.area];
}




#pragma mark UITableViewDataSource UITableViewDelegate
//返回组的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (_showSiXin) {
        return 4;
        //return 5;
    }else{
        return 3;
        //return 4;
    }
    
    
}

//返回每组的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _sec0) {
        return [sectionArray count];
    }
    else if (section == _sec1){
        
        return [sectionSiXinArray count];
        
    }else if (section == _sec2){
        
        return [sectionFirstArray count];
        
    }else if (section == _sec3){
        
        return [sectionSecondArray count];
        
    }else if(section == _sec4){
        return [sectionThirdArray count];
        
    }
    
    return 0;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 NSString *identifer = @"settingCellID";
 SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
 if (cell == nil) {
 cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil][0];
 }
 
 NSInteger section = indexPath.section;
 if (section == 0) {
 //资质认证
 cell.showRenzheng = YES;
 cell.showDetail = NO;
 cell.titleLabel.text = [sectionArray objectAtIndex:indexPath.row];
 
 }else{
 cell.showRenzheng = NO;
 if (section == 1) {
 //私信认证
 cell.showDetail = NO;
 cell.titleLabel.text = [sectionSiXinArray objectAtIndex:indexPath.row];
 }else if(section  == 2){
 //编辑资料、账号管理、清理缓存
 cell.titleLabel.text = [sectionFirstArray objectAtIndex:indexPath.row];
 if (indexPath.row == 2) {
 cell.showDetail = YES;
 NSString *cacheTxt = [NSString stringWithFormat:@"%.1fM",_cacheSize];
 cell.detailLab.text =cacheTxt;
 }else{
 cell.showDetail = NO;
 }
 }else if(section == 3){
 //我的推荐、意见反馈、关于moka
 cell.titleLabel.text = [sectionSecondArray objectAtIndex:indexPath.row];
 if(indexPath.row == 0){
 NSString *number = [NSString stringWithFormat:@"%@",[[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"inviteNumber"]];
 if ([number isEqualToString:@"(null)"]) {
 number = @"0";
 }
 cell.showDetail = YES;
 cell.detailLab.text = [NSString stringWithFormat:@"%@人",number];
 }else{
 cell.showDetail = NO;
 }
 }
 }
 return cell;
 
 }
 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //清理缓存
    if (indexPath.section==_sec2 && indexPath.row == 2) {
        NSString *CellID = @"Cell";
        //通过id来获取可复用的单元格
        TuijianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //如果没有获取到可用的单元格，就从xib中获取一个自定义的单元格
        if (cell ==nil) {
            //使用xib方法
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TuijianTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.nameLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        cell.numberLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        NSString *cacheTxt = [NSString stringWithFormat:@"%.1fM",_cacheSize];
        cell.numberLabel.text =cacheTxt;
        cell.nameLabel.text = @"清理缓存";
        return cell;
    }
    
    
    if (indexPath.section==_sec3 && indexPath.row == 0) {
        NSString *cellID = @"Cell";
        //通过id来获取可复用的单元格
        TuijianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        //如果没有获取到可用的单元格，就从xib中获取一个自定义的单元格M
        if (cell ==nil) {
            //使用xib方法
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TuijianTableViewCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        NSString *number = [NSString stringWithFormat:@"%@",[[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"inviteNumber"]];
        if ([number isEqualToString:@"(null)"]) {
            number = @"0";
        }
        cell.numberLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        cell.nameLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        cell.numberLabel.text = [NSString stringWithFormat:@"%@人",number];
        return cell;
    }
    
    
    NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    if (indexPath.section == _sec0) {
        //资质认证单元格
        NSString *auid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"authentication"];
        UIImageView *imgView = [cell viewWithTag:111];
        if(imgView == nil){
            imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imgView.tag = 111;
            [cell addSubview:imgView];
        }

        if ([auid isEqualToString:@"-2"]||[auid isEqualToString:@"-1"]||[auid isEqualToString:@"0"]) {
          
            //    UIImage *image_arrow = [UIImage imageNamed:@"redArrow"];
            //            UIImageView *imgView_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-25, 16, 10, 16)];
            //            imgView_arrow.image = image_arrow;
            //            [cell addSubview:imgView_arrow];
            //            cell.accessoryType = UITableViewCellAccessoryNone;
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            cell.backgroundColor = [UIColor colorWithRed:251/255.0 green:217/255.0 blue:220/255.0 alpha:1.0];
            
            UIImage *image = [UIImage imageNamed:@"notRenZhengImage"];
            imgView.frame = CGRectMake(88, 12.5, 18, 24);
            imgView.image = image;
            imgView.clipsToBounds = YES;
            cell.textLabel.text = [sectionArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            UIImage *image = [UIImage imageNamed:@"hadRenZheng"];
            imgView.frame = CGRectMake(85, 15.5, 18, 18);
            imgView.image = image;
            imgView.clipsToBounds = YES;
            
            cell.textLabel.text = [sectionArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
    }else if(indexPath.section == _sec1){
        cell.textLabel.text = [sectionSiXinArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section == _sec2){
        if (indexPath.row == 2) {
            
        }else{
            cell.textLabel.text = [sectionFirstArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if(indexPath.section == _sec3){
        cell.textLabel.text = [sectionSecondArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == _sec4)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, 5, kDeviceWidth - 40, 40)];
        [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showSigOut) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setBorderColor:[UIColor colorForHex:kLikeRedColor].CGColor];
        [btn.layer setBorderWidth:1.0];
        [btn.layer setCornerRadius:20.0];
        [btn.layer setMasksToBounds:YES];
        [cell addSubview:btn];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
    
    return cell;
}



//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 50;
}





- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _sec0) {
        //        return 40;
        return 0;
        
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == _sec0){
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        isBangDing = YES;
        if (isBangDing) {
            NSLog(@"ren zheng");

            McRenZhengViewController *renzheng = [[McRenZhengViewController alloc] initWithNibName:@"McRenZhengViewController" bundle:[NSBundle mainBundle]];

//            RenZhengViewController *renzheng = [[RenZhengViewController alloc] initWithNibName:@"RenZhengViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:renzheng animated:YES];
            
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            
        }
        
        
    }else if(indexPath.section == _sec1){
        //私信权限
        McSiXinSettingViewController *siXinSettingVC = [[McSiXinSettingViewController alloc] initWithNibName:@"McSiXinSettingViewController" bundle:nil];
        [self.navigationController pushViewController:siXinSettingVC animated:YES];
        return;
        
    }else if (indexPath.section == _sec2){
        switch (indexPath.row) {
            case 0:
            {
                McPersonalDataViewController *personalVC = [[McPersonalDataViewController alloc] init];
                personalVC.personalData = self.personalData;
                [self.navigationController pushViewController:personalVC animated:YES];
            }
                break;
            case 1:
            {
                McSetAccountViewController *setVC = [[McSetAccountViewController alloc] init];
                [self.navigationController pushViewController:setVC animated:YES];
            }
                break;
            case 2:
            {
                
                //清理缓存
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                [PhotoEngine clearAllPhotoData];
                [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DEFAULTURL]]];
                //                [self performSelector:@selector(showClearCrash) withObject:nil afterDelay:1.0];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabelText = @"清理成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.0];
                _cacheSize = 0;
                [_tableView reloadData];
                
            }
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == _sec3){
        switch (indexPath.row) {
            case 2:{
                //关于
                McNewAboutViewController *setVC = [[McNewAboutViewController alloc] init];
                [self.navigationController pushViewController:setVC animated:YES];
            }
                break;
            case 1:{
                //意见反馈
//                McCallBackViewController *setVC = [[McCallBackViewController alloc] init];
                McNewFeedBackViewController *setVC = [[McNewFeedBackViewController alloc] initWithNibName:@"McNewFeedBackViewController" bundle:[NSBundle mainBundle]];

                [self.navigationController pushViewController:setVC animated:YES];
                break;
            }
            case 0:{
                //我的推荐
                break;
            }
        }
    }
    else if (indexPath.section == _sec4){
        [self showSigOut];
    }
}



#pragma mark - private- 未使用
- (void)layoutSubViewsInHeadView
{
    float plshX = 15;
    float plshY = 10;
    float viewWidth = self.view.frame.size.width;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, plshY, viewWidth, _headerView.frame.size.height - plshY *2)];
    [bgView setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    [_headerView addSubview:bgView];
    
    plshY += 10;
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(plshX, plshY, 70, 70)];
    [headImageView setImage:[UIImage imageNamed:@"head60"]];
    [headImageView.layer setCornerRadius:headImageCornerRadius];
    [headImageView.layer setMasksToBounds:YES];
    [_headerView addSubview:headImageView];
    
    plshX += headImageView.frame.size.width + 5;
    
    userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(plshX, plshY + 5, viewWidth - plshX -20, 20)];
    [userNameLab setFont:[UIFont systemFontOfSize:16]];
    [userNameLab setTextColor:[UIColor whiteColor]];
    [_headerView addSubview:userNameLab];
    
    plshY += userNameLab.frame.size.height;
    
    introLab = [[UILabel alloc] initWithFrame:CGRectMake(plshX, plshY + 2, viewWidth - plshX -20, 18)];
    [introLab setFont:[UIFont systemFontOfSize:14]];
    [introLab setTextColor:[UIColor whiteColor]];
    [_headerView addSubview:introLab];
    
    plshY += introLab.frame.size.height;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [editBtn setFrame:CGRectMake(plshX, plshY + 5, 60, 20)];
    [editBtn.layer setBorderColor:[CommonUtils colorFromHexString:kLikeLightRedColor].CGColor];
    [editBtn.layer setBorderWidth:1.0];
    [editBtn.layer setCornerRadius:10];
    [editBtn setEnabled:NO];

    [_headerView addSubview:editBtn];
    
    NSString *auid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"authentication"];

    if ([auid isEqualToString:@"-2"]||[auid isEqualToString:@"-1"]||[auid isEqualToString:@"0"]) {
        
        
    }else
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(plshX-20, plshY + 15, 18, 18)];
        imgView.image = [UIImage imageNamed:@"headerRenZheng"];
        [_headerView addSubview:imgView];
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPersonalData:)];
    [_headerView addGestureRecognizer:tap];
    
    //
}

- (void)layoutSubViewsInFootView
{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds))-80, CGRectGetWidth(self.view.bounds), 80)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    
    UIButton *signoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signoutBtn setBackgroundColor:[CommonUtils colorFromHexString:kLikeGrayColor]];
    [signoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [signoutBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [signoutBtn.layer setCornerRadius:10.0];
    [signoutBtn setFrame:CGRectMake(60, 20, CGRectGetWidth(self.view.bounds) - 60 *2, 40)];
    [signoutBtn addTarget:self action:@selector(showSigOut) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:signoutBtn];
}

#pragma mark - request- 未使用
- (void)requestGetUserInfo
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:uid];
    [AFNetwork getUserInfo:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
//            [self loadPersonalData];
            [_tableView reloadData];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
    }failed:^(NSError *error){
        
    }];
}



#pragma mark - 退出登陆
- (void)showSigOut{
    if (_logoutAlertView == nil) {
        _logoutAlertView = [[UIAlertView alloc] initWithTitle:@"确定退出登陆" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     }
    [_logoutAlertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1){
        [self doSignOut:nil];
    }
}


//action
- (void)doSignOut:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = [AFParamFormat formatSignOutParams:nil];
    [AFNetwork loginOut:params success:^(id data){
        [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:nil];
        [hud hide:YES];
        [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
    
        [(AppDelegate *)[UIApplication sharedApplication].delegate showMainViewController];
        
        return ;
        
    }failed:^(NSError *error){
        
    }];
}

- (void)editPersonalData:(id)sender
{
    McPersonalDataViewController *dataVC = [[McPersonalDataViewController alloc] init];
    dataVC.personalData = _personalData;
    [self.navigationController pushViewController:dataVC animated:NO];
}


#pragma mark - 计算本地的缓存大小
- (void)countCacheSize{
    //获取沙盒路径
    NSString *boxPath = NSHomeDirectory();
    NSLog(@"沙盒路径：%@",boxPath);
    //通过拼接得到图片缓存路径,模拟器下
    //NSString *imgPath0 = [boxPath stringByAppendingPathComponent:@"Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    //获取Library目录
    //真机下
    NSString *libraryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    //获取SDWebImageCache的图片缓存目录
   NSString *imgPath=[libraryPath stringByAppendingPathComponent:@"Caches/com.hackemist.SDWebImageCache.default"];
    
    //获取文件管理助手
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //得到文件下所有子文件夹
    NSError *error = nil;
    NSArray *fileArr = [fileManager subpathsOfDirectoryAtPath:imgPath error:&error];
    
    //计算总文件大小
    long long SumFileSize = 0;
    for (NSString *path in fileArr) {
        //拼接得到完整的文件路径
        NSString *realPath = [imgPath stringByAppendingPathComponent:path];
        //通过路径得到路径下文件的属性
        NSDictionary *fileProperties = [fileManager attributesOfItemAtPath:realPath error:&error];
        //得到文件大小
        //        long long fileSize = fileProperties objectForKey:@""
        NSNumber *fileSize = fileProperties[NSFileSize];
        //        NSLog(@"%@",fileProperties);
        SumFileSize += [fileSize longLongValue];
    }
    NSLog(@"缓存：%lld",SumFileSize);
    //以M为单位
    _cacheSize = SumFileSize/(1000.0*1000.0);
    NSLog(@"缓存：%.1f",_cacheSize);
}

@end
