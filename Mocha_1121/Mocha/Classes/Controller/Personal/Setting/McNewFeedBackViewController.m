//
//  McNewFeedBackViewController.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McNewFeedBackViewController.h"
#import "NewFeedbackCellOneTableViewCell.h"
#import "NewFeedbackCellTwoTableViewCell.h"
#import "NewFeedbackCellThreeTableViewCell.h"

@interface McNewFeedBackViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) NewFeedbackCellOneTableViewCell *partOneCell;
@property (strong, nonatomic) NewFeedbackCellTwoTableViewCell *partTwoCell;
@property (strong, nonatomic) NewFeedbackCellThreeTableViewCell *partThreeCell;


@end

@implementation McNewFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";

    self.dataArray = @[@"partOneCell",@"partTwoCell",@"partThreeCell"].mutableCopy;

    self.mainTableView.backgroundColor = NewbackgroundColor;
    
    self.mainTableView.tableFooterView = [self getFootView];
    

}

- (void)resetFrame
{
    self.mainTableView.frame = CGRectMake(0, -100, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height);

}

- (void)resetBackFrame
{
    self.mainTableView.frame = CGRectMake(0, 0, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height);

}

- (UIView *)getFootView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setFrame:CGRectMake(40, 20, kScreenWidth-80, 50)];
    [submit setTitle:@"确认提交" forState:UIControlStateNormal];
    [submit setClipsToBounds:YES];
    submit.layer.cornerRadius = 10.0f;
    [submit setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    [submit addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submit];
    
    return bottomView;
}

- (void)submitData:(id)sender
{
    NSString *f_type = getSafeString(self.partOneCell.choseType);
    NSString *f_desc = getSafeString(self.partTwoCell.textView.text);
    NSString *f_phone = getSafeString(self.partThreeCell.inputTextfield.text);;

    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSDictionary *dict = @{@"uid":uid,@"content":f_desc,@"phone":f_phone,@"feedback_type":f_type};
    NSDictionary *param = [AFParamFormat formatSystemFeedBackParams:dict];
    [AFNetwork systemFeedback:param success:^(id data){
        if([data[@"status"] integerValue] == kRight){
            [LeafNotification showInController:self withText:@"反馈成功"];
            [self performSelector:@selector(popViewControllerDelay) withObject:nil afterDelay:1.5];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
    }failed:^(NSError *error){
        
    }];
}

- (void)popViewControllerDelay
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NewFeedbackCellOneTableViewCell *)partOneCell
{
    if (!_partOneCell) {
        _partOneCell = [NewFeedbackCellOneTableViewCell getNewFeedbackCellOneTableViewCell];
        _partOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partOneCell.backgroundColor = [UIColor clearColor];
    }
    return _partOneCell;
}

- (NewFeedbackCellTwoTableViewCell *)partTwoCell
{
    if (!_partTwoCell) {
        _partTwoCell = [NewFeedbackCellTwoTableViewCell getNewFeedbackCellTwoTableViewCell];
        _partTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partTwoCell.backgroundColor = [UIColor clearColor];

    }
    return _partTwoCell;
}

- (NewFeedbackCellThreeTableViewCell *)partThreeCell
{
    if (!_partThreeCell) {
        _partThreeCell = [NewFeedbackCellThreeTableViewCell getNewFeedbackCellThreeTableViewCell];
        _partThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partThreeCell.backgroundColor = [UIColor clearColor];
        _partThreeCell.controller = self;
    }
    return _partThreeCell;
}


#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        return self.partOneCell.cellHeight;
        
    }else if(indexPath.row==1)
    {
        return 170;
        
    }else if (indexPath.row==2)
    {
        return 90;
    }
    
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return self.partOneCell;
        
    }else if(indexPath.row==1)
    {
        return self.partTwoCell;
        
    }else if (indexPath.row==2)
    {
        return self.partThreeCell;
        
    }
    
    
    return nil;
}




@end
