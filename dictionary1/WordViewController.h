//
//  WordViewController.h
//  dictionary1
//
//  Created by vito7zhang on 16/7/25.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

@interface WordViewController : UIViewController
@property (nonatomic,strong)NSString *word;
@property (nonatomic,strong)WordModel *model;
@end
