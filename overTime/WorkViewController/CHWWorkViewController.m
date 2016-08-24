//
//  CHWWorkViewController.m
//  overtime
//
//  Created by Charles Wang on 15-9-30.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "CHWWorkViewController.h"
#import "CHWContentViewController.h"
#import "NSString+CompareDate.h"

#define IMAGEWIDTH 200
#define IMAGEHEIGHT 200
#define MAINWIDTH [UIScreen mainScreen].bounds.size.width
#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height

// 颜色定义
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface CHWWorkViewController ()

@property (nonatomic,strong) NSUserDefaults *ud;
@property (nonatomic,copy) NSString *startTimeString;

@end

@implementation CHWWorkViewController

static CHWWorkViewController *sharedManager;

+ (CHWWorkViewController *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"working";
    self.view.backgroundColor = RGBAColor(64.0, 64.0, 100.0, 1.0);
    [self showedWorkingConfigView];
    
    _startTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showCurrentTime:) userInfo:nil repeats:YES];
    _ud = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_startTimer)
    {
        [_startTimer invalidate];
        _startTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showedWorkingConfigView
{
    //图片，暂时未定
    int workIVOriginX = MAINWIDTH/2 - (IMAGEWIDTH/2);
    UIImageView *workIV = [[UIImageView alloc] initWithFrame:CGRectMake(workIVOriginX, 80, IMAGEWIDTH, IMAGEHEIGHT)];
    workIV.backgroundColor = [UIColor yellowColor];
    
    //开始工作时间
    self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(workIVOriginX, 80 + IMAGEHEIGHT + 20, IMAGEWIDTH, 40)];
    self.startLabel.textAlignment = NSTextAlignmentCenter;
    self.startLabel.textColor = [UIColor grayColor];
    self.startLabel.font = [UIFont systemFontOfSize:20];
    
    //工作时间段
    self.workDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(workIVOriginX, self.startLabel.frame.origin.y + 40 + 20, IMAGEWIDTH, 40)];
    self.workDurationLabel.textColor = [UIColor whiteColor];
    self.workDurationLabel.textAlignment = NSTextAlignmentCenter;
    
    //下班按钮
    UIButton *workOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    workOffBtn.frame = CGRectMake(workIVOriginX, self.workDurationLabel.frame.origin.y + 40 + 20 ,IMAGEWIDTH, 44);
    [workOffBtn setTitle:@"我下班了！" forState:UIControlStateNormal];
    [workOffBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [workOffBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [workOffBtn addTarget:self action:@selector(addWorkOffContent:) forControlEvents:UIControlEventTouchUpInside];
    workOffBtn.layer.cornerRadius = 3.0f;
    workOffBtn.layer.masksToBounds = YES;
    workOffBtn.layer.borderWidth = 1.0f;
    workOffBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self.view addSubview:workIV];
    [self.view addSubview:self.startLabel];
    [self.view addSubview:self.workDurationLabel];
    [self.view addSubview:workOffBtn];
}

- (void)startTimeLabel
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSDate *nowTimeDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.startTimeString = [dateFormatter stringFromDate:nowTimeDate];
    NSString *udString = [ud objectForKey:@"startTimeString"];
    if (!udString)
    {
        [ud setObject:self.startTimeString forKey:@"startTimeString"];
        [ud synchronize];
    }
    
    self.startLabel.text = self.startTimeString;
    NSLog(@"startLabel.text-->%@",self.startTimeString);
}

- (void)addWorkOffContent:(UIButton *)button
{
    NSLog(@"I'm working off");
    
    //开始工作时间
    NSUserDefaults *startUD = [NSUserDefaults standardUserDefaults];
    NSString *oldStartString = [startUD objectForKey:@"startTimeString"];
    
    //结束时间
    NSDate *stopTimeDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *stopTimeString = [dateFormatter stringFromDate:stopTimeDate];
    
    NSLog(@"stopTimeStr:%@\n startTimeStr:%@\n oldStartStr:%@\n",stopTimeDate,_startTimeString,oldStartString);
    
    NSDate *oldStartDate = [self contentDateForTransformStyleDateString:oldStartString];
    NSDate *stopDate = [self contentDateForTransformStyleDateString:stopTimeString];
    //正常下班时间
    NSDate *normalWorkOffDate = [[NSDate alloc] initWithTimeInterval: 60 * 60 * 8 sinceDate:oldStartDate];
    NSLog(@"normalWorkOffDate:%@",normalWorkOffDate);
    NSLog(@"oldStartDate:%@\n stopDate:%@",oldStartDate,stopDate);
    
    NSString *workString = [self workTimeDurationWithLateTime:oldStartDate stopTime:stopDate];
    NSString *overTimeString = [self overTimeDurationWithLateTime:normalWorkOffDate stopTime:stopDate];
    NSLog(@"workString:%@",workString);
    
    CHWContentViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    contentVC.startTimeString = oldStartString;
    contentVC.workTimeString = workString;
    contentVC.stopTimeString = stopTimeString;
    contentVC.overTimeString = overTimeString;
    [self presentViewController:contentVC animated:YES completion:nil];
}

static int count = 0;
- (void)showCurrentTime:(NSTimer *)timer
{
    count++;
    [self startTimeLabel];
    
    if (count < 60 )
    {
        int second = count % 60;
        NSString *secondStr;
        if (second >1)
        {
            secondStr = [NSString stringWithFormat:@"work for %d seconds",second];
        }
        else
        {
            secondStr = [NSString stringWithFormat:@"work for %d second",second];
        }
        self.workDurationLabel.text = [self workDuraTionString:secondStr];
    }
    else if (count < 3600)
    {
        int minute = count / 60;
        NSString *minuteStr;
        if (minute > 1)
        {
            minuteStr = [NSString stringWithFormat:@"work for %d minutes",minute];
        }
        else
        {
            minuteStr = [NSString stringWithFormat:@"work for %d minute",minute];
        }
        self.workDurationLabel.text = [self workDuraTionString:minuteStr];
        
    }
    else
    {
        int hour = count / 3600;
        NSString *hourStr;
        if (hour > 1)
        {
            hourStr = [NSString stringWithFormat:@"work for %d hours",hour];
        }
        else
        {
            hourStr = [NSString stringWithFormat:@"work for %d hour",hour];
        }
        self.workDurationLabel.text = [self workDuraTionString:hourStr];
    }
}

- (NSString *)workDuraTionString:(NSString *)workString
{
    NSString *workTimeStr = [_ud objectForKey:@"workTimeString"];
    
    if (!workTimeStr || [workTimeStr isEqualToString:@""])
    {
        return workString;
    }
    
    return workTimeStr;
}


- (NSString *)workTimeDurationWithLateTime:(NSDate *)lateDateTime
                                  stopTime:(NSDate *)stopDateTime
{
    long dd = (long)[stopDateTime timeIntervalSince1970] - [lateDateTime timeIntervalSince1970];
    NSString *workTimeString=@"";
    if (dd < 0)
    {
        workTimeString = @"";
    }
    else
    {
        if (dd / 3600 < 1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd/60];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"minutes" unitStr:@"minute"];
        }
        if (dd / 3600 > 1 && dd / 86400 < 1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd / 3600];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"hours" unitStr:@"hour"];
        }
        if (dd / 86400 > 1)
        {
            workTimeString = [NSString stringWithFormat:@"%ld", dd / 86400];
            workTimeString = [self worKDurationTime:workTimeString unitString:@"days" unitStr:@"day"];
        }
    }
    NSLog(@"workTimeString:%@",workTimeString);
    return workTimeString;
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

- (NSString *)overTimeDurationWithLateTime:(NSDate *)lateDateTime stopTime:(NSDate *)stopDateTime
{
    long dd = (long)[stopDateTime timeIntervalSince1970] - [lateDateTime timeIntervalSince1970];
    NSString *overTimeString=@"";
    if (dd < 0)
    {
        overTimeString = @"";
    }
    else
    {
        if (dd / 3600 < 1)
        {
            overTimeString = [NSString stringWithFormat:@"%ld", dd/60];
            overTimeString = [self overDurationTime:overTimeString unitString:@"minutes" unitStr:@"minute"];
        }
        if (dd / 3600 > 1 && dd / 86400 < 1)
        {
            overTimeString = [NSString stringWithFormat:@"%ld", dd / 3600];
            overTimeString = [self overDurationTime:overTimeString unitString:@"hours" unitStr:@"hour"];
        }
        if (dd / 86400 > 1)
        {
            overTimeString = [NSString stringWithFormat:@"%ld", dd / 86400];
            overTimeString = [self overDurationTime:overTimeString unitString:@"days" unitStr:@"day"];
        }
    }
    NSLog(@"workTimeString:%@",overTimeString);
    return overTimeString;
}

- (NSString *)overDurationTime:(NSString *)worktime
                    unitString:(NSString *)unitString
                       unitStr:(NSString *)unitStr
{
    int workDay = worktime.intValue;
    
    if (workDay >1)
    {
        worktime=[NSString stringWithFormat:@"overwork for %@ %@", worktime,unitString];
    }
    else
    {
        worktime=[NSString stringWithFormat:@"overwork for %@ %@", worktime,unitStr];
    }
    
    return worktime;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
