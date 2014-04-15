//
//  TemperatureChecker.h
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/15/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TemperatureCheckerNotification @"TemperatureCheckerNotification"


@interface TemperatureChecker : NSObject

// fires TemperatureCheckerNotification via NSNotificationCenter
// the provided userInfo is a TemperatureChecker object
+ (void)tempPoller;

@property NSNumber *fTemp;
@property NSNumber *cTemp;
@property NSString *weatherDescription;

@end
