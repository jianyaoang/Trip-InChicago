//
//  RouteMapViewController.h
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/21/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RouteMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property NSArray *routesArray;

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLLocationCoordinate2D currentCenter;
@property (weak, nonatomic) IBOutlet MKMapView *routeMapViewMap;
@property MKAnnotationView *annotationView;

@end
