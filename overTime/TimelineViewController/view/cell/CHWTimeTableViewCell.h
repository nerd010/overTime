//
//  CHWTimeTableViewCell.h
//  overtime
//
//  Created by Charles Wang on 15-11-5.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHWTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *overTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workPlaceLabel;

@end
