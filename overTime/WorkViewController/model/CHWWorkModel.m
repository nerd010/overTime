//
//  CHWWorkModel.m
//  overtime
//
//  Created by Charles Wang on 15-11-8.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "CHWWorkModel.h"

@implementation CHWWorkModel

static CHWWorkModel *sharedManager;
+ (CHWWorkModel *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}



@end
