//
//  Location.h
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/19/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject
@property NSString *name;
@property float lat;
@property float lng;
@property NSString *address;
@property NSString *tips;
@property NSString *phoneNumber;
@property MKPlacemark *placemark;
@property NSString *tipsID;
@property NSString *canonicalUrl;
@property NSString *venueID;
@property NSString *formattedPhone;
@end
