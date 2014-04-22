//
//  RouteMapViewController.m
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/21/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "RouteMapViewController.h"

@interface RouteMapViewController ()

@end

@implementation RouteMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.routeMapViewMap setShowsUserLocation:YES];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;
    self.annotationView = [[MKAnnotationView alloc]init];
    [self createItenAnnotations];

    CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);

    self.routeMapViewMap.region = region;

}

-(void)createItenAnnotations
{
    for (MKMapItem *item in self.routesArray)
    {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.coordinate = item.placemark.coordinate;
        annotation.title      = item.name;

        [self.routeMapViewMap addAnnotation:annotation];
        [self.routeMapViewMap reloadInputViews];
    }
}

@end
