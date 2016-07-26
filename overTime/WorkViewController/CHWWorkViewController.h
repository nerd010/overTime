//
//  CHWWorkViewController.h
//  overtime
//
//  Created by Charles Wang on 15-9-30.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHWWorkViewController : UIViewController

@property (nonatomic,strong) NSTimer *startTimer;
@property (nonatomic,strong) UILabel *startLabel;
@property (nonatomic,strong) UILabel *workDurationLabel;

+ (CHWWorkViewController *)sharedManager;
@end
