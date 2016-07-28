//
//  CHWTimeTableView.m
//  overtime
//
//  Created by Charles Wang on 15-10-4.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "CHWTimeTableView.h"
#import "ACTimeScroller.h"
#import "ContentDatabase.h"

#define MAINWIDTH [UIScreen mainScreen].bounds.size.width
#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height

NSString * const PSTableViewCellIdentifier = @"PSTableViewCellIdentifier";

@interface CHWTimeTableView () <UITableViewDelegate,UITableViewDataSource>
{
//    NSMutableArray *_datasource;
//    ACTimeScroller *_timeScroller;
    NSArray *contentCounts;
}
@property (nonatomic,strong) NSMutableArray *dataSources;

@property (nonatomic,strong) ACTimeScroller *timeScroller;

@end

@implementation CHWTimeTableView

//static CHWTimeTableView *shareManager;
//
//+ (CHWTimeTableView *)shareManager
//{
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        shareManager = [[self alloc] init];
//    });
//    return shareManager;
//}


- (CHWTimeTableView *)initTimeTableView
{
    CGRect timeTableViewFrame = CGRectMake(0, 64, MAINWIDTH, MAINHEIGHT - 64);
    if (self = [super initWithFrame:timeTableViewFrame style:UITableViewStylePlain])
    {
        
//        _dataSources = [[NSMutableArray alloc] init];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *components = [[NSDateComponents alloc] init];
//        NSDate *today = [NSDate date];
//        NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
//        
//        for (NSInteger i = [todayComponents day]; i >= -50; i--)
//        {
//            [components setYear:[todayComponents year]];
//            [components setMonth:[todayComponents month]];
//            [components setDay:i];
//            [components setHour:arc4random() % 23];
//            [components setMinute:arc4random() % 59];
//            
//            NSDate *date = [calendar dateFromComponents:components];
//            [_dataSources addObject:date];
//        }
        self.delegate = self;
        self.dataSource = self;
//        self.backgroundColor = [UIColor yellowColor];
//        [self setupDatasource];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)setupDatasource
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDate *today = [NSDate date];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    
    for (NSInteger i = [todayComponents day]; i >= -50; i--)
    {
        [components setYear:[todayComponents year]];
        [components setMonth:[todayComponents month]];
        [components setDay:i];
        [components setHour:arc4random() % 23];
        [components setMinute:arc4random() % 59];
        
        NSDate *date = [calendar dateFromComponents:components];
        [_dataSources addObject:date];
    }
}

#pragma mark - ACTimeScrollorDelegate

//- (UITableView *)tableViewForTimeScroller:(ACTimeScroller *)timeScroller
//{
//    return self;
//}
//
//- (NSDate *)timeScroller:(ACTimeScroller *)timeScroller dateForCell:(UITableViewCell *)cell
//{
//    NSIndexPath *indexPath = [self indexPathForCell:cell];
//    return _dataSources[[indexPath row]];
//}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    contentCounts = [[ContentDatabase sharedManager] findAll];
    return contentCounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PSTableViewCellIdentifier];
    
//    NSDate *date = _dataSources[[indexPath row]];
//    [[cell textLabel] setText:[date description]];
    cell.textLabel.text = contentCounts[indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate Methods

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [_timeScroller scrollViewWillBeginDragging];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [_timeScroller scrollViewDidScroll];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [_timeScroller scrollViewDidEndDecelerating];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
