//
//  PicsAndReviewsViewController.h
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPoint.h"
#import "Location.h"
@interface PicsAndReviewsViewController : UIViewController
//@property MapPoint *mapPoint;
@property Location *location;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSString *address;
@property NSString *phoneNumber;
@end
