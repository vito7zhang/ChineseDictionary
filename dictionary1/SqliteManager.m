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
#import <FMDB.h>

FMDatabase *db;

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

+(BOOL)createSqliteWithTable{
    BOOL flag = NO;
    NSString *dataPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/collection.sqlite"];
    db = [FMDatabase databaseWithPath:dataPath];
    [db open];
    flag = [db executeUpdate:@"create table if not exists Collection(simp text,pinyin text,zhuyin text,tra text,frame text,bushou text,bsnum text,num text,seq text,hanyu text,base text,english text,idiom text)"];
    return flag;
}

+(BOOL)insertDataWithModel:(WordModel *)m{
    BOOL flag = NO;
    [self createSqliteWithTable];
    flag = [db executeUpdate:@"insert or replace into Collection(simp,pinyin,zhuyin,tra,frame,bushou,bsnum,num,seq,hanyu,base,english,idiom)values(?,?,?,?,?,?,?,?,?,?,?,?,?)",m.simp,m.pinyin,m.zhuyin,m.tra,m.frame,m.bushou,m.bsnum,m.num,m.seq,m.hanyu,m.base,m.english,m.idiom];
    return flag;
}
+(BOOL)deleteDataWithModel:(WordModel *)m{
    BOOL flag = NO;
    [self createSqliteWithTable];
    flag = [db executeUpdate:@"delete from Collection where simp = ?",m.simp];
    return flag;
}
+(NSArray *)findAllCollection{
    NSMutableArray *mArray = [NSMutableArray array];
    [self createSqliteWithTable];
    FMResultSet *set = [db executeQuery:@"select * from Collection"];
    while ([set next]) {
        WordModel *m = [WordModel new];
        m.simp =  [set stringForColumn:@"simp"];
        m.pinyin =  [set stringForColumn:@"pinyin"];
        m.zhuyin =  [set stringForColumn:@"zhuyin"];
        m.tra =  [set stringForColumn:@"tra"];
        m.frame =  [set stringForColumn:@"frame"];
        m.bushou =  [set stringForColumn:@"bushou"];
        m.bsnum =  [set stringForColumn:@"bsnum"];
        m.num =  [set stringForColumn:@"num"];
        m.seq =  [set stringForColumn:@"seq"];
        m.hanyu =  [set stringForColumn:@"hanyu"];
        m.base =  [set stringForColumn:@"base"];
        m.english =  [set stringForColumn:@"english"];
        m.idiom =  [set stringForColumn:@"idiom"];
        [mArray addObject:m];
    }
    return mArray;
}
+(BOOL)isExistWithModel:(WordModel *)m{
    FMResultSet *set = [db executeQuery:@"select * from Collection where simp=?",m.simp];
    while ([set next]) {
        return YES;
    }
    return NO;
}

@end












