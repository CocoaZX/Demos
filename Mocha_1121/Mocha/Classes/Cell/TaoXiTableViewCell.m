//
//  TaoXiTableViewCell.m
//  Mocha
//
//  Created by XIANPP on 16/2/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiTableViewCell.h"
#import "TaoXiViewController.h"
#import "BuildTaoXiViewController.h"


@interface TaoXiTableViewCell()
{
    
}

//封面图片距离顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageView_top;

//封面图片的高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageView_height;


//左边线条高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTwo_height;
//右边线条高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelFour_height;

//中间提示文字距离顶端距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabel_top;
//套系名字的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TaoxiName_width;


//价格宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabel_width;




@end

@implementation TaoXiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - set && layout
- (void)setDic:(NSDictionary *)dic{
    if (_dic != dic) {
        _dic = dic;
        //[self _initWithDictionary:dic];
    }
    [self setNeedsLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.currentUid = getSafeString(_dic[@"uid"]);
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    self.backgroundColor = [UIColor whiteColor];
    
    //分割线
    _topFengeXianLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    //图片高度跟随秀里面套系图片的比例
    _imgViewHeight = kDeviceWidth/375*200;
    
    //顶部部分与图片视图
    if (_isFirstCell) {
        _titleLabel.hidden = NO;
        _labelView.hidden = NO;
        _buildBtn.hidden = NO;
        _buildBtn.tintColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
        _coverImageView_top.constant = 50;

    }else{
        _titleLabel.hidden = YES;
        _labelView.hidden = YES;
        _buildBtn.hidden = YES;
        _coverImageView_top.constant = 0;
    }
    _coverImageView_height.constant = _imgViewHeight;

    //线条框设置，判断是否存在数据
    if (self.dic[@"albumId"]) {
        //如果数据存在
        _labeone.hidden = YES;
        _labeltwo.hidden = YES;
        _labelthree.hidden = YES;
        _labelfour.hidden = YES;
        _decriptionLabel.hidden = YES;
        //存在数据时布局
        [self layoutViewsForDataExist];
        
    }else{
        //=======没有数据
        self.buildBtn.hidden = YES;
        //显示线条的显示
        _labeone.hidden = NO;
        _labeltwo.hidden = NO;
        _labelthree.hidden = NO;
        _labelfour.hidden = NO;
        _decriptionLabel.hidden = NO;
        _descriptionLabel_top.constant = 50 +_imgViewHeight/2;
        //修改线条高度
        _labelTwo_height.constant = _imgViewHeight-10;
        _labelFour_height.constant = _imgViewHeight -10;
        
        self.coverImageView.image = nil;

        //修改按钮的状态
        [_detailBtn removeTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.currentUid isEqualToString:uid]) {
            _decriptionLabel.text = @"点击创建新的专题";
            _detailBtn.userInteractionEnabled = YES;
            _detailBtn.hidden = NO;
            [_detailBtn addTarget:self action:@selector(buildNewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _decriptionLabel.text = @"还没上传专题哦~";
            _detailBtn.userInteractionEnabled = NO;
            self.detailBtn.hidden = YES;
        }
        //布局底部信息控件
        self.typeLabel.hidden = YES;
        self.nameLabel.hidden = YES;
        self.priceLabel.hidden = YES;
    }
}


- (void)layoutViewsForDataExist{
    //中间的按钮
    _detailBtn.userInteractionEnabled = YES;
    [_detailBtn removeTarget:self action:@selector(buildNewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_detailBtn addTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *content = self.dic[@"content"];
    NSLog(@"%@",self.dic);
    //信息展示
    if (!((NSNull *)content == [NSNull null])) {
        if (((NSString *)_dic[@"content"][@"coverurl"]).length) {
            [self.coverImageView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_dic[@"content"][@"coverurl"],[CommonUtils imageStringWithWidth:self.coverImageView.width * 2 height:self.coverImageView.height * 2]]]];
        }else{
            self.coverImageView.image = nil;
        }
        //套系类别
        if (((NSString *)_dic[@"content"][@"settype"]).length) {
            _typeLabel.text = _dic[@"content"][@"settype"];
            if (_typeLabel.text.length) {
                _typeLabel.hidden = NO;
                _typeLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
                _typeLabel.layer.borderWidth = 1;
                _typeLabel.layer.borderColor = [[CommonUtils colorFromHexString:kLikeOrangeColor] CGColor];
            }
        }else{
            _typeLabel.hidden = YES;
        }
        
        //套系名
        if (_dic[@"content"][@"setname"]) {
            _nameLabel.hidden = NO;
            NSString *taoxiName = _dic[@"content"][@"setname"];
            _nameLabel.text = taoxiName;
            CGFloat taoxiNameWidth = [SQCStringUtils getCustomWidthWithText:taoxiName viewHeight:20 textSize:15];
            _TaoxiName_width.constant = taoxiNameWidth;
            
        }else{
            _nameLabel.hidden = YES;
        }
        //套系价格
        if (((NSString *)_dic[@"content"][@"setprice"]).length) {
            _priceLabel.hidden = NO;
            NSString *priceTxt = [NSString stringWithFormat:@"￥%@",_dic[@"content"][@"setprice"]];
            CGFloat priceWidth = [SQCStringUtils getCustomWidthWithText:priceTxt viewHeight:20 textSize:15];
            _priceLabel.text =priceTxt;
            _priceLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
            _priceLabel_width.constant = priceWidth;
        }else{
            _priceLabel.hidden = YES;
        }
        
        //不是本人，即使是第一行页不显示新建按钮
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        self.currentUid = getSafeString(_dic[@"uid"]);
        if (![self.currentUid isEqualToString:uid]) {
            self.buildBtn.hidden = YES;
        }
    }
}


#pragma mark - getCell

+(TaoXiTableViewCell *)getTaoXiTableViewCell{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TaoXiTableViewCell" owner:nil options:nil];
    TaoXiTableViewCell *cell = array[0];
    return cell;
}




//-(void)initWithDictionary:(NSDictionary *)dict{
//    
//    //线条框设置，判断是否存在数据
//    if (self.dic[@"albumId"]) {
//        //如果数据存在
//        _labeone.hidden = YES;
//        _labeltwo.hidden = YES;
//        _labelthree.hidden = YES;
//        _labelfour.hidden = YES;
//        _decriptionLabel.hidden = YES;
//        //修改线条高度
//        _labelTwo_height.constant = _imgViewHeight;
//        _labelFour_height.constant = _imgViewHeight;
//        
//        
//    
//    //如果有数据，detailbtn能点击到详情
//    if (dict[@"albumId"]) {
//        _decriptionLabel.hidden = YES;
//        
//        _detailBtn.userInteractionEnabled = YES;
//        [_detailBtn removeTarget:self action:@selector(buildNewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_detailBtn addTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        NSDictionary *content = dict[@"content"];
//        if (!((NSNull *)content == [NSNull null])) {
//            if (((NSString *)dict[@"content"][@"coverurl"]).length) {
//                [self.coverImageView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"content"][@"coverurl"],[CommonUtils imageStringWithWidth:self.coverImageView.width * 2 height:self.coverImageView.height * 2]]]];
//                _decriptionLabel.hidden = YES;
//                _labeone.hidden = YES;
//                _labeltwo.hidden = YES;
//                _labelthree.hidden = YES;
//                _labelfour.hidden = YES;
//            }else{
//                self.coverImageView.image = nil;
//            }
//            if (dict[@"content"][@"setname"]) {
//                _nameLabel.hidden = NO;
//                _nameLabel.text = dict[@"content"][@"setname"];
//            }else{
//                _nameLabel.hidden = YES;
//            }
//            
//            if (((NSString *)dict[@"content"][@"settype"]).length) {
//                _typeLabel.text = dict[@"content"][@"settype"];
//                if (_typeLabel.text.length) {
//                    _typeLabel.hidden = NO;
//                    _typeLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
//                    _typeLabel.layer.borderWidth = 1;
//                    _typeLabel.layer.borderColor = [[CommonUtils colorFromHexString:kLikeOrangeColor] CGColor];
//                }
//            }else{
//                _typeLabel.hidden = YES;
//            }
//            
//            if (((NSString *)dict[@"content"][@"setprice"]).length) {
//                _priceLabel.hidden = NO;
//                _priceLabel.text = [NSString stringWithFormat:@"￥%@",dict[@"content"][@"setprice"]];
//                _priceLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
//            }else{
//                _priceLabel.hidden = YES;
//            }
//            
//            if (![self.currentUid isEqualToString:uid]) {
//                self.buildBtn.hidden = YES;
//            }
//        }
//    }else{
//        
//        _labeone.hidden = NO;
//        _labeltwo.hidden = NO;
//        _labelthree.hidden = NO;
//        _labelfour.hidden = NO;
//        _decriptionLabel.hidden = NO;
//        
//        [_detailBtn removeTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        self.priceLabel.hidden = YES;
//        self.typeLabel.hidden = YES;
//        self.buildBtn.hidden = YES;
//        self.nameLabel.hidden = YES;
//        self.coverImageView.image = nil;
//        if ([self.currentUid isEqualToString:uid]) {
//            _decriptionLabel.text = @"点击创建新的专题";
//            _detailBtn.userInteractionEnabled = YES;
//            [_detailBtn addTarget:self action:@selector(buildNewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//            
//        }else{
//            _decriptionLabel.text = @"还没上传专题哦~";
//            _detailBtn.userInteractionEnabled = NO;
//            self.buildBtn.hidden = YES;
//            
//        }
//    }
//}


#pragma mark - 点击事件
//进入详情
- (IBAction)detailBtnAction:(UIButton *)sender {
    NSLog(@"detail");
    TaoXiViewController *taoxiVC = [[TaoXiViewController alloc]init];
    taoxiVC.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    [taoxiVC initWithDictionary:self.dic.copy];
    taoxiVC.currentUid = getSafeString(self.currentUid);
    //处理数据
    [self.supCon.navigationController pushViewController:taoxiVC animated:YES];
}


//进入创建界面
- (IBAction)buildNewBtnAction:(UIButton *)sender {
    
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
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.supCon];
        return;
    }
    
    NSLog(@"buildNew");
    BuildTaoXiViewController *buildTaoXi = [[BuildTaoXiViewController alloc]init];
    buildTaoXi.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    [self.supCon.navigationController pushViewController:buildTaoXi animated:YES];
}



@end
