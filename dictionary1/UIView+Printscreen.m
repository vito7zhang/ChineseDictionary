//
//  UIView+Printscreen.m
//  dictionary
//
//  Created by vito7zhang on 16/7/28.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "UIView+Printscreen.h"

@implementation UIView (Printscreen)
-(UIImage *)printsScreen{
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
