//
//  CHWTimeLineViewController.m
//  overtime
//
//  Created by Charles Wang on 15-9-29.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import "CHWTimeLineViewController.h"
#import "CHWTimeTableView.h"
#import "ContentDatabase.h"
#import "ContentModel.h"
#import "CHWTimeTableViewCell.h"

@interface CHWTimeLineViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *contentCounts;
}
@property (weak, nonatomic) IBOutlet UITableView *timeTableView;

//@property (nonatomic,strong) CHWTimeTableView *timeTableView;

@end

@implementation CHWTimeLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.timeTableView.backgroundColor = [UIColor whiteColor];
    self.timeTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.timeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"timeline";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    NSString *cellID = @"timeCell";
    CHWTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CHWTimeTableViewCell" owner:self options:nil] lastObject];
    }
    
    ContentModel *contentM = contentCounts [indexPath.row];
    cell.dateLabel.text = contentM.dateString;
    cell.dateLabel.font = [UIFont systemFontOfSize:15];
    cell.startTimeLabel.text = contentM.timeString;
    cell.startTimeLabel.font = [UIFont systemFontOfSize:15];
    cell.workTimeLabel.text = contentM.workTimeString;
    cell.workTimeLabel.font = [UIFont systemFontOfSize:15];
    cell.overTimeLabel.text = contentM.overTimeString;
    cell.overTimeLabel.font = [UIFont systemFontOfSize:15];
    cell.workPlaceLabel.text = contentM.addressString;
    cell.workPlaceLabel.font = [UIFont systemFontOfSize:15];
    
    NSLog(@"cellOverTimeText:%@\n,startime:-->%@",contentM.overTimeString,contentM.timeString);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat x = self.view.frame.size.width / 2 - 100 / 2;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(x, -100, 100, 100)];
    contentView.tag = 100;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, 44, 44);
    closeBtn.backgroundColor = [UIColor yellowColor];
    [closeBtn addTarget:self action:@selector(closeContentView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    
    [UIView animateWithDuration:2.0 animations:^{
        
        contentView.backgroundColor = [UIColor redColor];
        [self.view addSubview:contentView];
        
    } completion:^(BOOL finished) {
        contentView.frame = CGRectMake(x, 100, 100, 100);
        [self.view addSubview:contentView];
    }];
}

- (void)closeContentView
{
    UIView *contentV = (UIView *)[self.view viewWithTag:100];
    [contentV removeFromSuperview];
    contentV = nil;
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
