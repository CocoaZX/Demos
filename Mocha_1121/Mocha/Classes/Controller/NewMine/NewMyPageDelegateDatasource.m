//
//  NewMyPageDelegateDatasource.m
//  Mocha
//
//  Created by yfw－iMac on 15/12/30.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "NewMyPageDelegateDatasource.h"
#import "NewPersonalOneTableViewCell.h"
#import "NewMokaCardTableViewCell.h"
#import "BuildNewMcTableViewCell.h"
#import "TaoXiTableViewCell.h"

@implementation NewMyPageDelegateDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + self.taoxiArray.count + 1;
}


//返回单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 84;
    //套系
    if (indexPath.row < self.taoxiArray.count) {
        CGFloat imgH = kDeviceWidth *TaoXiScale;
        NSDictionary *diction = [NSDictionary dictionaryWithDictionary:self.taoxiArray[indexPath.row]];
        if (indexPath.row == 0) {
            if (diction[@"albumId"]) {
                return  50 + imgH + 40;
            }else{
                return  50 + imgH;
            }
        }else{
            return  imgH +40;
        }

        return imgH + 50 + 40;
    }
    //相册
    if (!(indexPath.row < self.taoxiArray.count) && indexPath.row < self.taoxiArray.count + 1) {
        cellHeight = 365;
    }
    //个人介绍
    if (indexPath.row == 1 + self.taoxiArray.count) {
        cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.jieshao];
    }
    //工作经验
    if (indexPath.row == self.taoxiArray.count + 1 + 1) {
        cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.jingyan];
    }

    //工作室
    if (indexPath.row == self.taoxiArray.count + 1 + 2) {
        NSLog(@"%ld",(long)indexPath.row);
        cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.gongzuoshi];
    }
    //去掉分割线需要减去分割线的15高
    return cellHeight;
}

//返回的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellView = nil;
    //套系
    if (indexPath.row < self.taoxiArray.count) {
        NSString *identifier = [NSString stringWithFormat:@"TaoXiTableViewCell"];
        TaoXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TaoXiTableViewCell" owner:nil options:nil].lastObject;
            cell.supCon = self.controller;
        }
        if (indexPath.row == 0) {
            cell.isFirstCell = YES;
//            cell.titleLabel.hidden = NO;
//            cell.buildBtn.hidden = NO;
//            cell.labelView.hidden = YES;
//            //cell.topFengeXianLabel.hidden = YES;
        }else{
            cell.isFirstCell = NO;
//            cell.titleLabel.hidden = YES;
//            cell.buildBtn.hidden = YES;
//            cell.labelView.hidden = YES;
//            cell.topFengeXianLabel.hidden = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *diction = [NSDictionary dictionaryWithDictionary:self.taoxiArray[indexPath.row]];
        cell.currentUid = self.currentUid;
        cell.dic = diction;

        cellView = cell;
    }
    
    //相册
    if (indexPath.row == self.taoxiArray.count) {
        NewMokaCardTableViewCell *cell = nil;
        NSString *identifier = @"NewMokaCardTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [NewMokaCardTableViewCell getNewMokaCardTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.currentUserName = self.currentName;
        NSDictionary *albumDic = @{};
        if (self.albumsArray.count>indexPath.row - self.taoxiArray.count) {
            albumDic = self.albumsArray[indexPath.row - self.taoxiArray.count];
        }
        NSString *isNeedToAppear = @"0";
        NSString *needAppear = getSafeString(albumDic[@"style"]);
        if (needAppear.length) {
            isNeedToAppear = @"1";
        }
        NSString *style = [NSString stringWithFormat:@"%@",albumDic[@"style"]?albumDic[@"style"]:@"0"];
        //判断是模特
        cell.hiddenFootView = NO;
        //判断主人态
        if (!_isMaster) {
            [cell.clickButton removeFromSuperview];
            [cell.rightArrow removeFromSuperview];
        }else{
            [cell addSubview:cell.clickButton];
            [cell addSubview:cell.rightArrow];
        }
        cell.supCon = self.controller;
        cell.indexpath = indexPath;
        NSNumber *boolNumber = [NSNumber numberWithBool:self.isMaster];
        NSDictionary *diction = nil;
        if (self.moKaMutArr.count>0) {
            diction = @{@"cardType":style,@"uid":self.currentUid,@"username":self.currentTitle,@"isNeedToAppear":isNeedToAppear,@"albums":self.albumsArray?:@[],@"imagesArr":albumDic[@"photos"]?albumDic[@"photos"]:@[],@"albumcount":self.albumcount?self.albumcount:@"0",@"isModel":self.isModel,@"height":self.viewModel.height?self.viewModel.height:@"0",@"weight":self.viewModel.weight?self.viewModel.weight:@"0",@"sanwei":self.viewModel.sanwei?self.viewModel.sanwei:@"",@"isMaster":boolNumber,@"mokaListDic":self.moKaMutArr[indexPath.row - self.taoxiArray.count],@"mokaNumber":self.mokaNumber?self.mokaNumber:@""};
        }else{
            diction = @{@"cardType":style,@"uid":self.currentUid,@"username":self.currentTitle,@"isNeedToAppear":isNeedToAppear,@"albums":self.albumsArray?:@[],@"imagesArr":albumDic[@"photos"]?albumDic[@"photos"]:@[],@"albumcount":self.albumcount?self.albumcount:@"0",@"isModel":self.isModel,@"height":self.viewModel.height?self.viewModel.height:@"0",@"weight":self.viewModel.weight?self.viewModel.weight:@"0",@"sanwei":self.viewModel.sanwei?self.viewModel.sanwei:@"",@"isMaster":boolNumber,@"mokaNumber":self.mokaNumber?self.mokaNumber:@""};
        }
        cell.hiddenFootView = YES;
        [cell initViewWithData:diction];
        cell.currentUid = self.currentUid;
        cellView = cell;
    }
    
    NewPersonalOneTableViewCell *cell = nil;
    NSString *identifier = @"NewPersonalOneTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [NewPersonalOneTableViewCell getNewPersonalOneTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    //个人介绍
    if (indexPath.row == self.taoxiArray.count + 1) {
        NSString *title = @"个人介绍";
        NSString *content = self.jieshao;
        NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
        
        [cell initViewWithData:diction];
        cellView = cell;
    }
    
    //工作经验
    if (indexPath.row == self.taoxiArray.count + 2) {
        NSString *title = @"工作经验";
        NSString *content = self.jingyan;
        NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
        
        [cell initViewWithData:diction];
        cellView = cell;
    }
    
    //工作室
    if (indexPath.row == self.taoxiArray.count + 3) {
        NSString *title = @"工作室";
        NSString *content = self.gongzuoshi;
        NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
        [cell initViewWithData:diction];
        cellView = cell;
    }
    
    return cellView;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollImage];
}


- (void)scrollImage {
    CGPoint offset = _controller.tableView.contentOffset;
    CGFloat y_offset = offset.y;
    CGRect cardRect =  CGRectMake(kDeviceWidth - 100 - 10, 10, 100, 32);;
    //身价
    CGRect personValueRect = _controller.headerView.personValueCtrol.frame;
    if (y_offset < 0) {
        CGRect rect =  _controller.headerView.backgroundImageView.frame;
        //        rect.origin.x = 0 + y_offset ;
        rect.origin.y = 0 + y_offset ;
        rect.size.height = 190 - y_offset;
        //rect.size.width = imageRect.size.width - y_offset;
        _controller.headerView.backgroundImageView.frame = rect;
        
        cardRect.origin.y = 10 + y_offset;
        _controller.headerView.MokaCardView.frame = cardRect
        ;
        //身价
        personValueRect.origin.y = 10+y_offset;
        _controller.headerView.personValueCtrol.frame = personValueRect;
    }
}


@end
