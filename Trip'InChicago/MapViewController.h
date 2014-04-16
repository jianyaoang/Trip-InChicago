//
//  MapViewController.h
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"

#define kGOOGLE_API_KEY @"AIzaSyALMcBucS3F7QojSUO7tUu6B2ZSw_K6MaI"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

{
//
//    CLLocationCoordinate2D currentCenter;
//    int currenDist;
    //create an instance variable that checks to see if this is the first launch of the app and, if not, redraws the map according to how the user has set it up.
    BOOL firstLaunch;
}

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property CLLocationCoordinate2D currentCenter;
@property int currenDist;
@property (strong, nonatomic) IBOutlet MKMapView *sectionMapView;
@property (strong, nonatomic) NSString *googleType;

@end
