//
//  SqliteManager.h
//  dictionary1
//
//  Created by vito7zhang on 16/7/21.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteManager : NSObject
+(NSArray *)findAllPinyin;
+(NSArray *)findAllBushou;
@end
