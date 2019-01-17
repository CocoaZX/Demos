//
//  McCitysViewController.m
//  Mocha
//
//  Created by renningning on 14-12-4.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McCitysViewController.h"
#import "McSeachViewController.h"
#import "McPersonalDataViewController.h"
#import "ActivityFilterModel.h"
#import "MokaCreateActivityViewController.h"

@interface McCitysViewController ()
{
    NSString *selectedStr;
    NSString *selectedId;
}

@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation McCitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *mutaArr = [NSMutableArray array];
//    if (_editOrSearch == 2) {
//        NSDictionary *addCict = @{@"id":@"0",@"name":@"不限"};
//        [mutaArr addObject:addCict];
//        
//    }
    if (self.isbuxian) {
        NSDictionary *addCict = @{@"id":@"0",@"name":@"不限"};
        [mutaArr addObject:addCict];
    }else
    {
       
        
    }
    
    [mutaArr addObjectsFromArray:_contentDictionnary[@"citys"]];
    self.contentArray = mutaArr;
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

#pragma mark Request
- (void)saveArea
{
    if (self.personalData) {
        NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
        NSString *uid = [userDict valueForKey:@"id"];
        NSString *mobile = [userDict valueForKey:@"mobile"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
        [dict setValue:_contentDictionnary[@"id"] forKey:@"province"];
        [dict setValue:selectedId forKey:@"city"];
        NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
        [AFNetwork editUserInfo:params success:^(id data){
            [self saveDataDone:data];
        }failed:^(NSError *error){
            NSLog(@"%@",error.description);
        }];
    }else
    {
        self.returenBlock([NSString stringWithFormat:@"%@%@",_contentDictionnary[@"name"],selectedStr]);
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[MokaCreateActivityViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                
            }
        }
    }
    
}

- (void)saveDataDone:(id)result
{
    if ([result[@"status"] integerValue] == kRight) {
        NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:result[@"data"]];
        [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        _personalData.area = [NSString stringWithFormat:@"%@%@",_contentDictionnary[@"name"],selectedStr];
        NSLog(@"%@",self.navigationController.viewControllers);
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[McPersonalDataViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                
            }
        }
        
        
        return;
    }
    [LeafNotification showInController:self withText:result[@"msg"]];
    NSLog(@"modify:%@",result);
    
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSDictionary *cityDict = [_contentArray objectAtIndex:indexPath.row];
    NSString *strCity = cityDict[@"name"];
    
    cell.textLabel.text = strCity;
    [cell.textLabel setFont:kFont16];
    [cell.textLabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
    if (![strCity isEqualToString:@"不限"]) {
        if ([strCity isEqualToString:selectedStr]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *cityDict = [_contentArray objectAtIndex:indexPath.row];
    NSString *strName = cityDict[@"name"];
    selectedStr = strName;
    selectedId = cityDict[@"id"];
    [ActivityDataModel sharedInstance].cityCode = getSafeString([NSString stringWithFormat:@"%@",cityDict[@"id"]]);
    [ActivityFilterModel sharedInstance].filterCity = getSafeString([NSString stringWithFormat:@"%@",cityDict[@"id"]]);
    
    if ([strName isEqualToString:@"不限"] && ![self.sourceVCName isEqualToString:@"homeVC_search"]) {
        
        if (self.personalData) {
            _filterData.area = _contentDictionnary[@"name"];
            [_paramsDictionary setValue:_contentDictionnary[@"id"] forKey:@"province"];
            [_paramsDictionary setValue:@"" forKey:@"city"];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[McSeachViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else
        {
//            self.returenBlock([NSString stringWithFormat:@"%@ 不限",_contentDictionnary[@"name"]]);
         }
        return;
    }
    
    if (_editOrSearch == 1) {
        [self saveArea];
        return;
    }
    else if(_editOrSearch == 2){
        _filterData.area = [NSString stringWithFormat:@"%@%@",_contentDictionnary[@"name"],selectedStr];
        [_paramsDictionary setValue:_contentDictionnary[@"id"] forKey:@"province"];
        
        //选择城市是不限的参数的设置
        if ([selectedStr isEqualToString:@"不限"]) {
            [_paramsDictionary setValue:@"" forKey:@"city"];
        }else{
            [_paramsDictionary setValue:selectedId forKey:@"city"];
        }

        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[McSeachViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                
            }
        }
        return;
    }
    else if(_editOrSearch == 3){
        _eventInfo.area = [NSString stringWithFormat:@"%@%@",_contentDictionnary[@"name"],selectedStr];
        [_paramsDictionary setValue:_contentDictionnary[@"id"] forKey:@"province"];
        [_paramsDictionary setValue:selectedId forKey:@"city"];
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }
    
    
}

@end
