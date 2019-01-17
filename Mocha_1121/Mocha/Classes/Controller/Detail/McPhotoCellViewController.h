//
//  McPhotoCellViewController.h
//  Mocha
//
//  Created by renningning on 14-12-10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

typedef enum{
    McListTypeNone,
    McListTypeFavorite,
    McListTypeComment
}McListType;


@interface McPhotoCellViewController : McBaseViewController

@property (nonatomic,assign) NSInteger type;

@end
