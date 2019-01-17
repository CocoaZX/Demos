//
//  DeleteTableViewCell.h
//  Mocha
//
//  Created by XIANPP on 16/3/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



+(DeleteTableViewCell *)getDeleteCell;

@end
