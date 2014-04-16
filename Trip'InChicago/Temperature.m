//
//  Temperature.m
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "Temperature.h"

@implementation Temperature
+(Temperature*)tempPoller;
{
    // Build URL for Weather passing it APIKey 4ce3a0a2e0101a58
    // Location Chicago
    // Pulling both F and C temperatures
    
    Temperature *temperature = [Temperature new];
    
    NSURL *url = [NSURL URLWithString:@"http://api.wunderground.com/api/4ce3a0a2e0101a58/conditions/q/IL/Chicago.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *weatherDict = [NSDictionary new];
        weatherDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSDictionary *currentObservationDict = weatherDict[@"current_observation"];
        
        temperature.fTemp = 0.0;
        temperature.cTemp = 0.0;
        temperature.weatherdescription = @"";
        
        temperature.fTemp = [currentObservationDict[@"temp_f"]floatValue];
        temperature.cTemp = [currentObservationDict[@"temp_c"]floatValue];
        temperature.weatherdescription = currentObservationDict[@"weather"];
                             
    }];
    
    return temperature;

}

@end
