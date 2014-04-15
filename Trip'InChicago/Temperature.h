//
//  Temperature.h
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Temperature : NSObject
+(Temperature*)tempPoller;

@property float    fTemp;
@property float    cTemp;
@property NSString *weatherdescription;

@end
