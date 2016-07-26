//
//  CHWContentViewController.h
//  overtime
//
//  Created by Charles Wang on 15-9-30.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHWContentViewController : UIViewController

@property (nonatomic,copy) NSString *startTimeString;
@property (nonatomic,copy) NSString *workTimeString;
@property (nonatomic,copy) NSString *stopTimeString;
@property (nonatomic,copy) NSString *overTimeString;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;

@end
