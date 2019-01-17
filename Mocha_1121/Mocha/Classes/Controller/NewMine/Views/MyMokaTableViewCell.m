//
//  MyMokaTableViewCell.m
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "MyMokaTableViewCell.h"
#import "PhotoBrowseViewController.h"
#import "BuildDetailViewController.h"

@implementation MyMokaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.setToDefault.frame = CGRectMake(kScreenWidth-83, self.cardView.frame.origin.y+ self.cardView.frame.size.height-5, 83, 38);
    self.titleLabel.frame = CGRectMake(10, self.cardView.frame.origin.y+ self.cardView.frame.size.height, kScreenWidth-120, 30);
    self.arrowImgView.frame = CGRectMake(81, 5+self.cardView.frame.origin.y+ self.cardView.frame.size.height, 20, 20);
    self.touchButton.frame = CGRectMake(8, self.cardView.frame.origin.y+ self.cardView.frame.size.height-6, 150, 40);
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([uid isEqualToString:self.currentUid]) {
        self.setToDefault.hidden = NO;
        self.arrowImgView.hidden = NO;
        self.titleLabel.text = @"编辑此模卡";
        self.arrowImgView.frame = CGRectMake(95, 5+self.cardView.frame.origin.y+ self.cardView.frame.size.height, 20, 20);

    }else
    {
        self.setToDefault.hidden = YES;
        self.arrowImgView.hidden = YES;

    }
}

- (void)initViewWithData:(NSDictionary *)diction
{
    self.dataDic = diction;
    NSString *titleString = [NSString stringWithFormat:@"%@",diction[@"styleName"]];
    NSString *defaultName = [NSString stringWithFormat:@"%@",diction[@"default"]];
    self.titleLabel.text = titleString;
    if ([defaultName isEqualToString:@"1"]) {
        [self.setToDefault setTitle:@"默认" forState:UIControlStateNormal];
        [self.setToDefault setTitleColor:RGB(139, 190, 35) forState:UIControlStateNormal];
        [self.setToDefault setImage:[UIImage imageNamed:@"correct"] forState:UIControlStateNormal];

    }else
    {
        [self.setToDefault setTitle:@"设为默认" forState:UIControlStateNormal];
        [self.setToDefault setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
        [self.setToDefault setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    }
    if (self.cardDetailView) {
        [self.cardDetailView removeFromSuperview];
    }
    [self.imgViewArray removeAllObjects];
    [self.buttonArray removeAllObjects];
    
    NSString *style = [NSString stringWithFormat:@"%@",diction[@"style"]];
    UIView *mokaView = [MokaCardManager getMokaCardWithType:style images:self.imgViewArray buttons:self.buttonArray];
    self.cardDetailView = mokaView;
    [self.cardView addSubview:mokaView];
    [self resetButtonTarget];

    [self resetImgViewURL];
}
- (void)resetButtonTarget
{
    for (int i=0; i<self.buttonArray.count; i++) {
        UIButton *btn = self.buttonArray[i];
        [btn addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
}
- (void)resetImgViewURL
{
    NSArray *imagesArr = self.dataDic[@"photos"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dic = imagesArr[i];
        NSString *sequence = [NSString stringWithFormat:@"%@",dic[@"sequence"]];
        if (self.imgViewArray.count>[sequence intValue]) {
            UIImageView *imgView = self.imgViewArray[[sequence intValue]];
            NSString *cardType = self.dataDic[@"style"];
            NSString *urlString = dic[@"url"];
            if ([cardType isEqualToString:@"3"]) {
                NSInteger wid = (NSInteger)((kScreenWidth-30)/3)*2;
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:wid];
                urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
            }
            else{
                //                if (i>1) {
                //                    NSLog(@"hahahahahah  %d",i);
                //                    NSInteger wid = (NSInteger)(imgView.frame.size.width)*2;
                //                    NSInteger hei = (NSInteger)(imgView.frame.size.height)*2;
                //                    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                //                    urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
                //                }
                NSInteger wid = (NSInteger)(imgView.frame.size.width)*2;
                NSInteger hei = (NSInteger)(imgView.frame.size.height)*2;
//                NSLog(@"hahahahahah  width:%ld  height:%ld",(long)wid,(long)hei);
                
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
//                NSLog(@"%@",urlString);
            }
            
//            UIImageView *imgView = self.imgViewArray[[sequence intValue]];
//            NSString *urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
            [imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        }
        
    }
    
}

- (void)clickCamera:(UIButton *)sender
{
//    NSLog(@"%ld",(long)sender.tag);
    NSArray *imagesArr = self.dataDic[@"photos"];
    if ([self isInTheArrayWithIndex:(int)sender.tag]) {
        NSString *uid = self.currentUid;
        PhotoBrowseViewController *photo = [[PhotoBrowseViewController alloc] initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
        photo.startWithIndex = [self getTheIndexWithTag:sender.tag];
        photo.currentUid = uid;
        [photo setDataFromYingJiWithUid:uid andArray:imagesArr.mutableCopy];
        [self.supCon.navigationController pushViewController:photo animated:YES];
    }
    


}

- (int)getTheIndexWithTag:(int)tag
{
    int index = 0;
    NSArray *imagesArr = self.dataDic[@"photos"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dition = imagesArr[i];
        NSString *squence = [NSString stringWithFormat:@"%@",dition[@"sequence"]];
        int dicSqu = [squence intValue];
        if (tag==dicSqu) {
            index = i;
        }
    }
    return index;
}

- (BOOL)isInTheArrayWithIndex:(int)index
{
    BOOL isIn = NO;
    NSArray *imagesArr = self.dataDic[@"photos"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dition = imagesArr[i];
        NSString *squence = [NSString stringWithFormat:@"%@",dition[@"sequence"]];
        int dicSqu = [squence intValue];
        if (index==dicSqu) {
            isIn = YES;
        }
    }
    return isIn;
}

- (IBAction)setToDefault:(id)sender {
    
    NSString *mid = [NSString stringWithFormat:@"%@",self.dataDic[@"albumId"]];
    
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":mid}];
    [AFNetwork getMokaSetDefault:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableState" object:nil];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self.supCon withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [LeafNotification showInController:self.supCon withText:@"当前网络不太顺畅哟"];
        
    }];

    
}

- (IBAction)gotoMokaDetail:(id)sender {
//    NSLog(@"gotoMokaDetail");
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([self.currentUid isEqualToString:uid]) {
        NSString *style = [NSString stringWithFormat:@"%@",self.dataDic[@"style"]];
        NSString *albumId = [NSString stringWithFormat:@"%@",self.dataDic[@"albumId"]];
        
        BuildDetailViewController *newActivity = [[BuildDetailViewController alloc] initWithNibName:@"BuildDetailViewController" bundle:[NSBundle mainBundle]];
        newActivity.albumid = albumId;
        newActivity.mokaType = style;
        newActivity.isEditing = YES;
        
        [self.supCon.navigationController pushViewController:newActivity animated:YES];
    }
    
}



+ (MyMokaTableViewCell *)getMyMokaTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyMokaTableViewCell" owner:self options:nil];
    MyMokaTableViewCell *cell = array[0];
    cell.imgViewArray = @[].mutableCopy;
    cell.buttonArray = @[].mutableCopy;
    return cell;
    
}


@end
