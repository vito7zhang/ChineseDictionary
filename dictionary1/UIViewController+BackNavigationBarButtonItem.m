//
//  UIViewController+BackNavigationBarButtonItem.m
//  dictionary
//
//  Created by vito7zhang on 16/7/28.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "UIViewController+BackNavigationBarButtonItem.h"

@implementation UIViewController (BackNavigationBarButtonItem)
-(void)setBackButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStyleDone target:self action:@selector(backBarButtonItemAction:)];
}
-(void)setHomeButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStyleDone target:self action:@selector(homeBarButtonItemAction:)];
}

-(void)homeBarButtonItemAction:(UIBarButtonItem *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)backBarButtonItemAction:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
