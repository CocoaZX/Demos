//
//  McFiltersDetailViewController.m
//  Mocha
//
//  Created by renningning on 14-11-21.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McFiltersDetailViewController.h"
#import "JSONKit.h"
#import "ReadPlistFile.h"

@interface McFiltersDetailViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *typeArray;
    NSArray *typeContentArray;
    NSDictionary *typeDict;
    NSString *selectedStr;
    
    NSString *detailStr;
    
    BOOL ShowPicker;
    NSIndexPath *ShowIndex;
    NSArray *pickerContentArray;
    NSInteger cellNumber;
}

@property (nonatomic, assign) McFiltersType fliterType;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *contentArray;

@end

@implementation McFiltersDetailViewController

- (instancetype)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.fliterType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    detailStr = @"无";
    ShowPicker=NO;
    ShowIndex=[NSIndexPath indexPathForRow:100 inSection:100];
    pickerContentArray = [NSArray array];
    
    typeArray = [NSArray array];
    typeContentArray = [NSArray array];
    
    NSString *naviTitle = @"";
    switch (_fliterType) {
        case McFiltersTypeSex:
            naviTitle = @"性别";
            typeArray = @[@"不限",@"女",@"男"];
            typeContentArray = @[@"",@"2",@"1"];
            selectedStr = _filterData.sex;
            break;
        case McFiltersTypeAge:
            naviTitle = @"年龄";
            typeArray = @[@"不限",@"小于19岁",@"19~22岁",@"22~28岁",@"28~35岁",@"大于35岁"];
            typeContentArray = @[@[@"",@""],@[@"",@"19"],@[@"19",@"22"],@[@"22",@"28"],@[@"28",@"35"],@[@"35",@""]];
            selectedStr = _filterData.age;
            break;
        case McFiltersTypeJob:
            naviTitle = @"职业";
            selectedStr = _filterData.job;
            [self loadDataWithFile];
            break;
        case McFiltersTypeHeight:
            selectedStr = _filterData.height;
            naviTitle = @"身高";
            typeArray = @[@"不限",@"155cm以上",@"160cm以上",@"165cm以上",@"168cm以上",@"170cm以上",@"175cm以上",@"180cm以上",@"185cm以上"];
            typeContentArray = @[@[@"",@""],@[@"155",@""],@[@"160",@""],@[@"165",@""],@[@"168",@""],@[@"170",@""],@[@"175",@""],@[@"180",@""],@[@"185",@""]];
            break;
        case McFiltersTypeWeight:
            selectedStr = _filterData.weight;
            naviTitle = @"体重";
            typeArray = @[@"不限",@"小于40kg",@"40~45kg",@"45~50kg",@"50~55kg",@"大于55kg"];
            typeContentArray = @[@[@"",@""],@[@"",@"40"],@[@"40",@"45"],@[@"45",@"50"],@[@"50",@"55"],@[@"55",@""]];
            break;
        case McFiltersTypeBust:
            selectedStr = _filterData.bust;
            naviTitle = @"胸围";
            typeArray = @[@"不限",@"80cm以下",@"80cm以上",@"90cm以上",@"100cm以上",@"110cm以上",@"120cm以上",];
            typeContentArray = @[@[@"",@""],@[@"",@"80"],@[@"80",@""],@[@"90",@""],@[@"100",@""],@[@"110",@""],@[@"120",@""]];
            break;
        case McFiltersTypeWaist:
            selectedStr = _filterData.waist;
            naviTitle = @"腰围";
            typeArray = @[@"不限",@"小于60cm",@"60~65cm",@"65~70cm",@"大于70cm"];
            typeContentArray = @[@[@"",@""],@[@"",@"60"],@[@"60",@"65"],@[@"65",@"70"],@[@"70",@""]];
            break;
        case McFiltersTypeHipline:
            selectedStr = _filterData.hips;
            naviTitle = @"臀围";
            typeArray = @[@"不限",@"90cm以下",@"90cm以上",@"100cm以上",@"110cm以上",@"120cm以上"];
            typeContentArray = @[@[@"",@""],@[@"",@"90"],@[@"90",@""],@[@"100",@""],@[@"110",@""],@[@"120",@""]];
            break;
        case McFiltersTypeFoot:
            selectedStr = _filterData.foot;
            naviTitle = @"脚码";
            typeArray = @[@"不限",@"小于36码",@"小于37码",@"小于38码",@"小于39码",@"小于40码",@"40码以上"];
            typeContentArray = @[@[@"",@""],@[@"",@"36"],@[@"",@"37"],@[@"",@"38"],@[@"",@"39"],@[@"",@"40"],@[@"40",@""]];
            break;
        case McFiltersTypeHair:
            selectedStr = _filterData.hair;
            naviTitle = @"头发";
            typeArray = @[@"不限",@"超短+",@"齐耳+",@"齐肩＋",@"齐腰＋",@"齐臀＋"];
            typeContentArray = @[@"",@"1",@"2",@"3",@"4",@"5"];
            break;
        case McFiltersTypeLeg:
            selectedStr = _filterData.leg;
            naviTitle = @"腿长";
            typeArray = @[@"不限",@"80cm以上",@"85cm以上",@"90cm以上",@"95cm以上",@"100cm以上"];
            typeContentArray = @[@[@"",@""],@[@"80",@""],@[@"85",@""],@[@"90",@""],@[@"95",@""],@[@"100",@""]];
            break;
        case McFiltersTypeDesiredSalary:
            selectedStr = _filterData.desiredSalary;
            naviTitle = @"期望薪水";
            typeArray = @[@"不限",@"小于100元/天",@"100~200元/天",@"200~500元/天",@"500~1000元/天",@"大于1000元/天"];
            typeContentArray = @[@[@"",@""],@[@"",@"100"],@[@"100",@"200"],@[@"200",@"500"],@[@"500",@"1000"],@[@"1000",@""]];
            break;
        case McFiltersTypeUserType:
            naviTitle = @"职业";
            selectedStr = _filterData.userType;
            typeArray = @[@"不限",@"模特",@"摄影师"];
            typeContentArray = @[@"",@"1",@"2"];
            break;
        default:
            break;
    }
    
    self.navigationItem.title = naviTitle;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
//    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
//    [button setTitle:@"保存" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    [button addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = buttonItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
//    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 240, kDeviceWidth, 216)];
//    _pickerView.dataSource = self;
//    _pickerView.delegate = self;
//    _pickerView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_pickerView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private
//- (void)doBackAction:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)modifyAction:(id)sender
{
    
}

#pragma mark load
- (void)loadDataWithFile
{
    switch (_fliterType) {
        case McFiltersTypeJob:
        {
            //path 读取当前程序定义好的文件
            typeDict = [ReadPlistFile readProfession];
            NSMutableArray *mArray = [NSMutableArray arrayWithObject:@"不限"];
            [mArray addObjectsFromArray:[typeDict allValues]];
            typeArray = mArray;

        }
            break;
            
        default:
            break;
    }
}

#pragma mark picker
- (void)loadPickerView
{
    
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [typeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSString *str = [typeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = str;
    [cell.textLabel setFont:kFont16];
    [cell.textLabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
    if ([str isEqualToString:selectedStr]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    selectedStr = [typeArray objectAtIndex:indexPath.row];
    
    switch (_fliterType) {
        case McFiltersTypeSex:
            _filterData.sex = selectedStr;

            [_paramsDictionary setValue:[typeContentArray objectAtIndex:indexPath.row] forKey:@"sex"];
            break;
        
        case McFiltersTypeAge:{
            _filterData.age = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"minage"];
            [_paramsDictionary setValue:[arr objectAtIndex:1] forKey:@"maxage"];
        }
            break;
        case McFiltersTypeJob:{
            _filterData.job = selectedStr;
            if ([selectedStr isEqualToString:@"不限"]) {
                [_paramsDictionary setValue:@"" forKey:@"job"];
            }
            else{
                for (NSString *key in [typeDict allKeys]) {
                    if ([selectedStr isEqualToString:[typeDict objectForKey:key]]) {
                        [_paramsDictionary setValue:key forKey:@"job"];
                        break;
                    }
                }
            }
        }

            break;
        case McFiltersTypeHeight:{
            _filterData.height = selectedStr;
            NSArray *arrH = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arrH objectAtIndex:0] forKey:@"minheight"];
            [_paramsDictionary setValue:[arrH objectAtIndex:1] forKey:@"maxheight"];
        }
            break;
        case McFiltersTypeWeight:{
            _filterData.weight = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"minweight"];
            [_paramsDictionary setValue:[arr objectAtIndex:1] forKey:@"maxweight"];
        }
            break;
            
        case McFiltersTypeBust:{
            _filterData.bust = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"minbust"];
            [_paramsDictionary setValue:[arr objectAtIndex:1] forKey:@"maxbust"];
        }
            break;
            
        case McFiltersTypeWaist:{
            _filterData.waist = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"minwaist"];
            [_paramsDictionary setValue:[arr objectAtIndex:1] forKey:@"maxwaist"];
        }
            break;
            
        case McFiltersTypeHipline:{
            _filterData.hips = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"minhipline"];
            [_paramsDictionary setValue:[arr objectAtIndex:1] forKey:@"maxhipline"];
        }
            break;
            
        case McFiltersTypeFoot:{
            _filterData.foot = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"minfoot"];
            [_paramsDictionary setValue:[arr objectAtIndex:1] forKey:@"maxfoot"];
        }
            break;
            
        case McFiltersTypeHair:{
            _filterData.hair = selectedStr;
            [_paramsDictionary setValue:[typeContentArray objectAtIndex:indexPath.row] forKey:@"hair"];
        }
            break;
            
        case McFiltersTypeLeg:{
            _filterData.leg = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"leg"];
            
        }
            break;
            
        case McFiltersTypeDesiredSalary:{
            _filterData.desiredSalary = selectedStr;
            NSArray *arr = [typeContentArray objectAtIndex:indexPath.row];
            [_paramsDictionary setValue:[arr objectAtIndex:0] forKey:@"minpayment"];
            [_paramsDictionary setValue:[arr objectAtIndex:1] forKey:@"maxpayment"];
        }
            break;
        
        case McFiltersTypeUserType:{
            _filterData.userType = selectedStr;
            [_paramsDictionary setValue:typeContentArray[indexPath.row] forKey:@"type"];
        }
            break;
        default:
            break;
    }
    
    [tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *ageStr = @"";
    
    return ageStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableString *strM = [NSMutableString stringWithString:@""];
    
    detailStr = strM;
    
    [_tableView reloadData];
}

@end
