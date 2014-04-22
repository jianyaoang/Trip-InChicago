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

    self.routeMapViewMap.delegate = self;

    self.routeMapViewMap.region = region;

    [self getDirections];

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

-(void)getDirections
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    bool firstTimeinLoop = YES;

//    request.source = [MKMapItem mapItemForCurrentLocation];

    for (MKMapItem *item in self.routesArray)
    {
        if (firstTimeinLoop == YES)
        {
            request.source = [MKMapItem mapItemForCurrentLocation];
            firstTimeinLoop = NO;
        }
        else
        {
            request.source = request.destination;
        }

        MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:item.placemark.coordinate addressDictionary:nil];
        MKMapItem   *mapItem   = [[MKMapItem alloc]initWithPlacemark:placemark];

        request.destination = mapItem;

        request.requestsAlternateRoutes = NO;
        request.transportType = MKDirectionsTransportTypeWalking;

        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
         {
             if (error)
             {
                 NSLog(@"E:%@", error);
             }
             else
             {
                 NSLog(@"SKDJFHJKSDHFJKSDHFJKHSDFJKHSDFJK");
                 [self showRoute:response];
             }
         }];
    }
}

-(void)showRoute:(MKDirectionsResponse *)response
{

    for (MKRoute *route in response.routes)
    {
        [self.routeMapViewMap addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth   = 5.0;

    return renderer;
}
@end
