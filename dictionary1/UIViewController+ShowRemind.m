//
//  UIViewController+ShowRemind.m
//  dictionary
//
//  Created by vito7zhang on 16/7/28.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "UIViewController+ShowRemind.h"

@implementation UIViewController (ShowRemind)
-(void)showRemindWithText:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:label];
    
    label.text = text;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}];
    label.frame = CGRectMake(SCREEN_WIDTH/2-size.width/2-10, SCREEN_HEIGHT/2-30, size.width+20, 60);
    [UIView animateWithDuration:2 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

@end
