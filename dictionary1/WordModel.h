//
//  WordModel.h
//  dictionary
//
//  Created by vito7zhang on 16/7/26.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordModel : NSObject
@property (nonatomic,strong)NSString *simp;
@property (nonatomic,strong)NSString *pinyin;
@property (nonatomic,strong)NSString *zhuyin;
@property (nonatomic,strong)NSString *tra;
@property (nonatomic,strong)NSString *frame;
@property (nonatomic,strong)NSString *bushou;
@property (nonatomic,strong)NSString *bsnum;
@property (nonatomic,strong)NSString *num;
@property (nonatomic,strong)NSString *seq;
@property (nonatomic,strong)NSString *hanyu;
@property (nonatomic,strong)NSString *base;
@property (nonatomic,strong)NSString *english;
@property (nonatomic,strong)NSString *idiom;

@end
