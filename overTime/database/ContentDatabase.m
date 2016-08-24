//
//  ContentDatabase.m
//  overtime
//
//  Created by Charles Wang on 15-10-25.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "ContentDatabase.h"

#define DBFILE_NAME @"Content.sqlite3"

@implementation ContentDatabase

static ContentDatabase *sharedManager;

+ (ContentDatabase *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createEditingCopyOfDatabaseIfNeeded];
    });
    return sharedManager;
}

- (void)createEditingCopyOfDatabaseIfNeeded
{
    NSString *writingDBPath = [self applicationDocumentDirectoryFile];
    
    BOOL ret;
    
    db = [FMDatabase databaseWithPath:writingDBPath];
    if (nil == db)
    {
        NSLog(@"数据库[%@]创建失败",writingDBPath);
        return;
    }
    ret = [db open];
    if (!ret)
    {
        NSLog(@"数据库[%@]打开失败",writingDBPath);
        return;
    }
    NSString *creatSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS content(id integer PRIMARY KEY AUTOINCREMENT, dateString TEXT, startTimeString TEXT, workTimeString TEXT, contentString TEXT, addressString TEXT ,stopTimeString TEXT, userNameString TEXT, companyString TEXT, overTimeString TEXT)"];
    ret = [db executeUpdate:creatSQL];
    if (!ret)
    {
        NSLog(@"ERROR [%@] EXEC[%@]",writingDBPath,creatSQL);
        return;
    }
    [db close];
}

- (int)create:(ContentModel *)model
{
    NSString *path = [self applicationDocumentDirectoryFile];
    BOOL ret;
    db = [FMDatabase databaseWithPath:path];
    if (nil == db)
    {
        NSLog(@"数据库[%@]创建失败!",path);
        return -1;
    }
    ret = [db open];
    if (!ret)
    {
        NSLog(@"数据库[%@]打开失败!",path);
        return -1;
    }
    
    NSString *sqlString = @"INSERT OR REPLACE INTO content(dateString, startTimeString, workTimeString, contentString, addressString, stopTimeString, userNameString, companyString, overTimeString) VALUES(?,?,?,?,?,?,?,?,?)";
    [db executeUpdate:sqlString, model.dateString,model.timeString,model.workTimeString,model.contentString,model.addressString,model.stopTimeString,model.userNameString,model.companyString,model.overTimeString];
    [db close];
    return 0;
}

- (NSMutableArray *)findAll
{
    NSString *path = [self applicationDocumentDirectoryFile];
    NSMutableArray *listDatas = [NSMutableArray array];

    BOOL ret;
    db = [FMDatabase databaseWithPath:path];
    if (nil == db)
    {
        NSLog(@"数据库[%@]创建失败！",path);
        return listDatas;
    }
    ret = [db open];
    
    if (!ret)
    {
        NSLog(@"数据库[%@]打开失败！",path);
        return listDatas;
    }
    NSString *qsql = @"SELECT dateString, startTimeString, workTimeString, contentString, addressString, stopTimeString, userNameString, companyString,overTimeString FROM content";
    FMResultSet *set = [db executeQuery:qsql];
    while ([set next])
    {
        ContentModel *row = [[ContentModel alloc] init];
        
        row.dateString = [set stringForColumn:@"dateString"];
        row.timeString = [set stringForColumn:@"startTimeString"];
        row.workTimeString = [set stringForColumn:@"workTimeString"];
        row.contentString = [set stringForColumn:@"contentString"];
        row.addressString = [set stringForColumn:@"addressString"];
        row.stopTimeString = [set stringForColumn:@"stopTimeString"];
        row.userNameString = [set stringForColumn:@"userNameString"];
        row.companyString = [set stringForColumn:@"companyString"];
        row.overTimeString = [set stringForColumn:@"overTimeString"];
        [listDatas addObject:row];
    }
    [db close];
    return listDatas;
}

- (ContentModel *)findByDateString:(NSString *)date
{
    NSString *path = [self applicationDocumentDirectoryFile];
    BOOL ret;
    ContentModel *row;
    
    db = [FMDatabase databaseWithPath:path];
    if (nil == db)
    {
        NSLog(@"数据库[%@]创建失败！",path);
        return nil;
    }
    ret = [db open];
    if (!ret)
    {
        NSLog(@"数据库[%@]打开失败！",path);
        return nil;
    }
    
    NSString *qsql = @"SELECT dateString, startTimeString, workTimeString, contentString, addressString, stopTimeString, userNameString, companyString,overTimeString FROM content where dateString=? ";
    FMResultSet *s = [db executeQuery:qsql];
    while ([s next])
    {
        row = [[ContentModel alloc] init];
        
        row.dateString = [s stringForColumn:@"dateString"];
        row.timeString = [s stringForColumn:@"startTimeString"];
        row.workTimeString = [s stringForColumn:@"workTimeString"];
        row.contentString = [s stringForColumn:@"contentString"];
        row.addressString = [s stringForColumn:@"addressString"];
        row.stopTimeString = [s stringForColumn:@"stopTimeString"];
        row.userNameString = [s stringForColumn:@"userNameString"];
        row.companyString = [s stringForColumn:@"companyString"];
        row.overTimeString = [s stringForColumn:@"overTimeString"];
    }
    [db close];
    return row;
}

- (ContentModel *)findByStartTimeString:(NSString *)timeString
{
    NSString *path = [self applicationDocumentDirectoryFile];
    BOOL ret;
    ContentModel *row;
    
    db = [FMDatabase databaseWithPath:path];
    if (nil == db)
    {
        NSLog(@"数据库[%@]创建失败！",path);
        return nil;
    }
    ret = [db open];
    if (!ret)
    {
        NSLog(@"数据库[%@]打开失败！",path);
        return nil;
    }
    
    NSString *qsql = @"SELECT dateString, startTimeString, workTimeString, contentString, addressString, stopTimeString, userNameString, companyString,overTimeString FROM content where startTimeString=? ";
    FMResultSet *s = [db executeQuery:qsql];
    while ([s next])
    {
        row = [[ContentModel alloc] init];
        
        row.dateString = [s stringForColumn:@"dateString"];
        row.timeString = [s stringForColumn:@"startTimeString"];
        row.workTimeString = [s stringForColumn:@"workTimeString"];
        row.contentString = [s stringForColumn:@"contentString"];
        row.addressString = [s stringForColumn:@"addressString"];
        row.stopTimeString = [s stringForColumn:@"stopTimeString"];
        row.userNameString = [s stringForColumn:@"userNameString"];
        row.companyString = [s stringForColumn:@"companyString"];
        row.overTimeString = [s stringForColumn:@"overTimeString"];
    }
    [db close];
    return row;
}

- (NSString *)applicationDocumentDirectoryFile
{
    NSString *documentDirectionDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectionDirectory stringByAppendingPathComponent:DBFILE_NAME];
    
    return path;
}
@end
