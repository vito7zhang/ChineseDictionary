//
//  SqliteManager.m
//  dictionary1
//
//  Created by vito7zhang on 16/7/21.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "SqliteManager.h"
#import <sqlite3.h>
#import "BushouModel.h"
#import "PinyinModel.h"

@implementation SqliteManager
+(NSArray *)findAllPinyin{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sqlitePath = [[NSBundle mainBundle]pathForResource:@"aaaaa2" ofType:@"sqlite"];
    NSString *sql = @"select * from ol_pinyins";
    
    sqlite3 *db;
    sqlite3_open(sqlitePath.UTF8String, &db);
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PinyinModel *pyM = [PinyinModel new];
            pyM.py_id = sqlite3_column_int(stmt, 0);
            pyM.pinyin = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 1) encoding:4];
            [array addObject:pyM];
        }
    }else{
        return nil;
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return array;
}
+(NSArray *)findAllBushou{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sqlitePath = [[NSBundle mainBundle]pathForResource:@"aaaaa2" ofType:@"sqlite"];
    NSString *sql = @"select * from ol_bushou";
    
    sqlite3 *db;
    sqlite3_open(sqlitePath.UTF8String, &db);
    sqlite3_stmt *stmt;
    if (sqlite3_prepare(db, sql.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            BushouModel *bsM = [BushouModel new];
            bsM.bs_id = sqlite3_column_int(stmt, 0);
            bsM.bihua = sqlite3_column_int(stmt, 1);
            bsM.bushou = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 2) encoding:4];
            [array addObject:bsM];
        }
    }else{
        return nil;
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return array;
}
@end












