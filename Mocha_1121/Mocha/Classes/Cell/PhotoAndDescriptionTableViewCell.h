//
//  PhotoAndDescriptionTableViewCell.h
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol photoDelegateProtocol <NSObject>

- (void)delegatePhoto:(id)sender;

@end
@interface PhotoAndDescriptionTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UITextField *descriptionTextfield;

//图片显示
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

//描述文字区域
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtView;
//默认提示文字
@property(nonatomic,strong)UILabel *defaultLabel;

//黑色输入提示分割线
@property (weak, nonatomic) IBOutlet UILabel *backLabel;

//===========约束
//照片的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImgView_height;

 //txtview的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionTxtView_height;
 
//===========数据
@property(nonatomic,strong)NSDictionary *dataDic;
//图片url
@property(nonatomic,strong)UIImage *pictureImg;
//图片的描述
@property(nonatomic,copy)NSString *pictureDesc;


//类型
@property(nonatomic,copy)NSString *cellType;


@property (nonatomic , assign) id <photoDelegateProtocol> delegate;

+(PhotoAndDescriptionTableViewCell *)getPhotoAndDescriptionTableViewCell;

-(void)initWithDictionary:(NSDictionary *)dict;

+(float)getCellHeightWithDictionary:(NSDictionary *)dic;

@end
