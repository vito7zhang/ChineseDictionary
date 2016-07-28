//
//  SqliteManager.h
//  dictionary1
//
//  Created by vito7zhang on 16/7/21.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordModel.h"

@interface SqliteManager : NSObject
+(NSArray *)findAllPinyin;
+(NSArray *)findAllBushou;

+(BOOL)createSqliteWithTable;
+(BOOL)insertDataWithModel:(WordModel *)m;
+(BOOL)deleteDataWithModel:(WordModel *)m;
+(NSArray *)findAllCollection;
+(BOOL)isExistWithModel:(WordModel *)m;
@end
