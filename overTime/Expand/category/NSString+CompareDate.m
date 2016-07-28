//
//  NSString+CompareDate.m
//  overtime
//
//  Created by Charles Wang on 15-11-8.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "NSString+CompareDate.h"

@implementation NSString (CompareDate)

+ (NSString *)compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60)
        result = [NSString stringWithFormat:@"work for %ld seconds",temp];
    else if((temp = timeInterval/60) <60)
        result = [NSString stringWithFormat:@"work for %ld minute",temp];
    else if((temp = temp/60) <24)
        result = [NSString stringWithFormat:@"%ld",temp];
    else if((temp = temp/24) <30)
        result = [NSString stringWithFormat:@"%ld",temp];
    else if((temp = temp/30) <12)
        result = [NSString stringWithFormat:@"%ld",temp];
    else
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld",temp];
    
    return  result;
}

@end
