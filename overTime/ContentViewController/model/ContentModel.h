//
//  ContentModel.h
//  overtime
//
//  Created by Charles Wang on 15-10-25.
//  Copyright (c) 2015年 CharlesWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property (nonatomic,copy) NSString *contentString;

@property (nonatomic,copy) NSString *timeString;

@property (nonatomic,copy) NSString *dateString;

@property (nonatomic,copy) NSString *workTimeString;

@property (nonatomic,copy) NSString *addressString;

@property (nonatomic,copy) NSString *stopTimeString;

@property (nonatomic,copy) NSString *userNameString;

@property (nonatomic,copy) NSString *companyString;

@property (nonatomic,copy) NSString *overTimeString;

@end
