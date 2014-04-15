//
//  TemperatureChecker.m
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/15/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//


/* To get the notification center to work we need to add the below methods and actions when you call it {they are commented}
 
 ***This one actually calls the method***
 [TemperatureChecker tempPoller];
 
 ***This one registers the observer to listen***
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tempPoller:) name:TemperatureCheckerNotification object:nil];
 
 ***Finally this method is where you can grab the information - ie temps from [note.User cTemp] etc..***
 -(void)tempPoller:(NSNotification *)note
 {
 NSLog(@"%@", note.userInfo);
 
 }
 

*/

#import "TemperatureChecker.h"

@implementation TemperatureChecker

+ (void)tempPoller
{
    // Build URL for Weather passing it APIKey 4ce3a0a2e0101a58
    // Location Chicago
    // Pulling both F and C temperatures
    
    NSURL *url = [NSURL URLWithString:@"http://api.wunderground.com/api/4ce3a0a2e0101a58/conditions/q/IL/Chicago.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        TemperatureChecker *temperature = [TemperatureChecker new];
        
        temperature.fTemp = 0;
        temperature.cTemp = 0;
        temperature.weatherDescription = @"";
        
        float convertedCTemp = 0.0;
        float convertedFTemp = 0.0;
        
        NSDictionary *weatherDict = [NSDictionary new];
        weatherDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSDictionary *currentObservationDict = weatherDict[@"current_observation"];
        
        
        // Conversion to be able to pass NSNumbers
        convertedFTemp = [currentObservationDict[@"temp_f"]floatValue];
        convertedCTemp = [currentObservationDict[@"temp_c"]floatValue];
        
        temperature.fTemp = [NSNumber numberWithFloat:convertedFTemp];
        temperature.cTemp = [NSNumber numberWithFloat:convertedCTemp];
        
        temperature.weatherDescription = currentObservationDict[@"weather"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TemperatureCheckerNotification object:nil userInfo:(id)temperature];
    }];
    
}

@end

