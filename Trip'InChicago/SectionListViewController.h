//
//  SectionListViewController.h
//  Trip'InChicago
//
//  Created by Marion Ano on 4/28/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SectionListViewController : UIViewController<UITableViewDataSource, UITableViewDataSource, CLLocationManagerDelegate>
@property NSString *searchSection;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

@end
