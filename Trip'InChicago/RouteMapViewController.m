//
//  RouteMapViewController.m
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/21/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "RouteMapViewController.h"

@interface RouteMapViewController ()
{
    bool whatColor;
}
@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@end

@implementation RouteMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.infoTextView.hidden = YES;
    self.infoView.hidden = YES;

    self.locationManager = [CLLocationManager new];
    [self.routeMapViewMap setShowsUserLocation:YES];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;
    self.annotationView = [[MKAnnotationView alloc]init];
    [self createItenAnnotations];

    whatColor = YES;

    CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);

    self.routeMapViewMap.delegate = self;

    self.routeMapViewMap.region = region;

    [self getDirections];

}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    if ((oldLocation.coordinate.longitude != newLocation.coordinate.longitude)
        || (oldLocation.coordinate.latitude != newLocation.coordinate.latitude))
    {

        CLLocationCoordinate2D coord ={
            .latitude = newLocation.coordinate.latitude,
            .longitude = newLocation.coordinate.longitude};

        MKCoordinateRegion region;
        region.center = coord;

        MKCoordinateSpan span = {.latitudeDelta = 0.5, .longitudeDelta = 0.5};
        region.span = span;

        [self.routeMapViewMap setRegion:region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Data Connection Error"
                                                 message:@"Unable to retrieve direction data, try again later!"
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [av show];

    NSLog(@"E:%@", error);
    
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];

    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
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
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Data Connection Error"
                                                              message:@"Unable to retrieve direction data, try again later!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
                 [av show];

             }
             else
             {
                 [self showRoute:response];
                 NSLog(@"<-------------------------->");

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

            //self.myLabel.text = [NSString stringWithFormat:@"%@\n%@", self.myLabel.text, step.instructions];
            self.infoTextView.text = [NSString stringWithFormat:@"%@\n%@", self.infoTextView.text, step.instructions];

        }
    }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc]initWithOverlay:overlay];

    if (whatColor)
    {
        renderer.strokeColor = [UIColor blueColor];
        whatColor = NO;
        NSLog(@"Blue");
    }
    else
    {
        renderer.strokeColor = [UIColor greenColor];
        whatColor = YES;
        NSLog(@"Green");

    }
    renderer.lineWidth   = 5.0;
    return renderer;
}

- (IBAction)onInfoButtonPressed:(id)sender
{
    self.infoView.hidden = NO;
    //self.infoView.backgroundColor = [UIColor blackColor];
    self.infoTextView.hidden = NO;
    self.infoTextView.backgroundColor = [UIColor blackColor];
    self.infoTextView.alpha = 0.8;
    self.infoTextView.textColor = [UIColor whiteColor];
    self.infoView.alpha = 0.5;
    
}

- (IBAction)onClosedButtonPressed:(id)sender
{
    self.infoView.hidden = YES;
    self.infoTextView.hidden = YES;
}








@end
