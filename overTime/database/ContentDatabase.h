//
//  ContentDatabase.h
//  overtime
//
//  Created by Charles Wang on 15-10-25.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ContentModel.h"

@interface ContentDatabase : NSObject
{
    FMDatabase *db;
}

+ (ContentDatabase *)sharedManager;

- (NSString *)applicationDocumentDirectoryFile;
- (void)createEditingCopyOfDatabaseIfNeeded;
- (int)create:(ContentModel *)model;
- (NSMutableArray *)findAll;
- (ContentModel *)findByDateString:(NSString *)date;
- (ContentModel *)findByStartTimeString:(NSString *)timeString;

@end
