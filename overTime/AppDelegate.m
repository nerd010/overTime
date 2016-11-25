//
//  AppDelegate.m
//  overtime
//
//  Created by Charles Wang on 15-9-27.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "AppDelegate.h"
#import "CHWWorkViewController.h"
#import "CHWViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *startStr = [ud objectForKey:@"startTimeString"];
    if (startStr)
    {
        CHWWorkViewController *workVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
        [workVC.startTimer invalidate];
        workVC.startTimer = nil;
//        NSString *startStr = [ud objectForKey:@"startTimeString"];
        
        NSDateFormatter *dm = [[NSDateFormatter alloc]init];
        [dm setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        NSDate *nowTime = [NSDate date];
        NSString *nowTimeString = [dm stringFromDate:nowTime];
        NSDate *nowTimeDate = [self contentDateForTransformStyleDateString:nowTimeString];
        NSDate *startTimeDate = [self contentDateForTransformStyleDateString:startStr];
        
        long dd = (long)[nowTimeDate timeIntervalSince1970] - [startTimeDate timeIntervalSince1970];
        NSString *workTimeString=@"";
        if (dd/3600<1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd/60];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"minutes" unitStr:@"minute"];
        }
        if (dd/3600>1 && dd/86400<1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd/3600];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"hours" unitStr:@"hour"];
        }
        if (dd/86400>1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd/86400];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"days" unitStr:@"day"];
        }
        NSLog(@"=====%@",workTimeString);
        workVC.startLabel.text = nowTimeString;
        workVC.workDurationLabel.text = workTimeString;
        [ud setObject:workTimeString forKey:@"workTimeString"];
        [ud synchronize];

        self.window.rootViewController = workVC;
    }
    else
    {
        
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lateStartDate = [ud objectForKey:@"startTimeString"];
    if (nil != lateStartDate)
    {
        CHWWorkViewController *workVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
        
        [workVC.startTimer invalidate];
        workVC.startTimer = nil;
        NSString *startStr = [ud objectForKey:@"startTimeString"];
        
        NSDateFormatter *dm = [[NSDateFormatter alloc]init];
        [dm setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        NSDate *nowTime = [NSDate date];
        NSString *nowTimeString = [dm stringFromDate:nowTime];
        NSDate *nowTimeDate = [self contentDateForTransformStyleDateString:nowTimeString];
        NSDate *startTimeDate = [self contentDateForTransformStyleDateString:startStr];
        
        long dd = (long)[nowTimeDate timeIntervalSince1970] - [startTimeDate timeIntervalSince1970];
        NSString *workTimeString=@"";
        if (dd/3600<1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd/60];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"minutes" unitStr:@"minute"];
        }
        if (dd/3600>1 && dd/86400<1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd/3600];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"hours" unitStr:@"hour"];
        }
        if (dd/86400>1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd/86400];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"days" unitStr:@"day"];
        }
        NSLog(@"=====%@",workTimeString);
        workVC.startLabel.text = nowTimeString;
        workVC.workDurationLabel.text = workTimeString;
        [ud setObject:workTimeString forKey:@"workTimeString"];
        [ud synchronize];
        
        self.window.rootViewController = workVC;
    
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");

}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

static NSDateFormatter *sUserVisibleDateFormatter = nil;
- (NSDate *)contentDateForTransformStyleDateString:(NSString *)dateString
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

- (NSString *)worKDurationTime:(NSString *)worktime
                    unitString:(NSString *)unitString
                       unitStr:(NSString *)unitStr
{
    int workDay = worktime.intValue;
    
    if (workDay >1)
    {
        worktime=[NSString stringWithFormat:@"work for %@ %@", worktime,unitString];
        
    }
    else
    {
        worktime=[NSString stringWithFormat:@"work for %@ %@", worktime,unitStr];
    }
    
    return worktime;
}
@end
