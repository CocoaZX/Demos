//
//  CommentView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/15.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "CommentView.h"
#import "CommentTableViewCell.h"

@interface CommentView ()


@property (weak, nonatomic) IBOutlet UIView *commentBack;

@property (weak, nonatomic) IBOutlet UIView *commentTopView;

@property (weak, nonatomic) IBOutlet UITextField *addCommentTextfield;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property (strong, nonatomic) NSMutableArray *commentDataArray;

@property (strong, nonatomic) NSString *photoid;

@end

@implementation CommentView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.commentDataArray = @[].mutableCopy;
    self.commentTopHeader.layer.cornerRadius = 21;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissSelfView:(id)sender {
    [self.commentTopHeader resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissCommentView" object:nil];
    
}

- (void)setCommentDataByPid:(NSString *)pid
{
    self.photoid = pid;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:pid forKey:@"photoid"];
    NSDictionary *params = [AFParamFormat formatGetCommentListParams:dict];
    [AFNetwork getCommentsList:params success:^(id data){
        NSLog(@"%@",data);
        NSArray *comment = data[@"data"];
        self.commentDataArray = comment.mutableCopy;
        [self.commentTableView reloadData];

    }failed:^(NSError *error){
        
    }];
    
    
}

//tableview


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [CommentTableViewCell getCommentCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    NSString *urlString = self.commentDataArray[indexPath.row][@"head_pic"];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString?urlString:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    NSString *name = self.commentDataArray[indexPath.row][@"nickname"];
    NSString *content = self.commentDataArray[indexPath.row][@"content"];
    NSString *createline = [NSString stringWithFormat:@"%@",self.commentDataArray[indexPath.row][@"createline"]];
    cell.nameLabel.text = name;
    cell.descriptionLabel.text = content;
    cell.headerImageView.layer.cornerRadius = 21;
    cell.timeString.text = [CommonUtils dateTimeIntervalString:createline];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addCommentTextfield resignFirstResponder];
    
    if (textField.text.length>0) {
        NSDictionary *params = [AFParamFormat formatCommentActionParams:self.photoid userId:self.uid content:textField.text object_type:@"6"];
        [AFNetwork commentsAdd:params success:^(id data){
            NSLog(@"%@",data);
            [self setCommentDataByPid:self.photoid];
            
        }failed:^(NSError *error){
            
        }];
    }
    
    return YES;
}

@end
