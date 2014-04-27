//
//  RouteMapViewController.m
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/21/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "RouteMapViewController.h"
#import "PointAnnotation.h"

@interface RouteMapViewController ()
{
    bool whatColor;
    float northernBorder;
    float southernBorder;
    float easternBorder;
    float westernBorder;
}
@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property NSMutableArray *images;
@property NSArray *numberImages;
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
    northernBorder = 0.0;
    //setting the southernBorder
    southernBorder = 100000.0;
    //setting the easternBorder
    easternBorder = -1000.0; //originally -10000.0
    //setting the westernBorder
    westernBorder = 0.0;
    self.images = [NSMutableArray new];
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

    //setting the width and the height of mapwindow
    float x = fabsf(((fabsf(westernBorder)-fabsf(easternBorder)) + 0.0045));
    float y = fabsf(((fabsf(northernBorder) - fabsf(southernBorder)) + 0.0045));

    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(x, y);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
    self.routeMapViewMap.region = region;

    self.routeMapViewMap.delegate = self;

    [self getDirections];

}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    // Make sure the new location is not a cached location by checking the timestamp
    NSTimeInterval newLocationAge = [newLocation.timestamp timeIntervalSinceNow];
    if (abs(newLocationAge) > 10) return;

    // Check if you need to set things up to display directions with new (non cached) location
    // Set the map region to whatever fits all your annotations
    // If there is a significant change in location, update the map region

    if ((oldLocation.coordinate.longitude != newLocation.coordinate.longitude)
        || (oldLocation.coordinate.latitude != newLocation.coordinate.latitude))
    {

        CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;

        //setting the width and the height of mapwindow
        float x = fabsf(((fabsf(westernBorder)-fabsf(easternBorder)) + 0.005));
        float y = fabsf(((fabsf(northernBorder) - fabsf(southernBorder)) + 0.005));

        MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(x, y);
        MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
        self.routeMapViewMap.region = region;
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

-(void)createItenAnnotations
{
    NSInteger index = 0;
    for (MKMapItem *item in self.routesArray)
    {
        PointAnnotation *annotation = [PointAnnotation new];
        annotation.coordinate = item.placemark.coordinate;
        annotation.title      = item.name;
        annotation.index      = index;
        index++;

        if (annotation.coordinate.latitude > northernBorder) {
            northernBorder = annotation.coordinate.latitude;
        }
        if (annotation.coordinate.latitude < southernBorder) {
            southernBorder = annotation.coordinate.latitude;
        }
        if (annotation.coordinate.longitude < westernBorder) {
            westernBorder = annotation.coordinate.longitude;
        }
        if (annotation.coordinate.longitude > easternBorder) {
            easternBorder = annotation.coordinate.longitude;
        }

        [self.routeMapViewMap addAnnotation:annotation];
        [self.routeMapViewMap reloadInputViews];
    }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView* pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    [self.images removeAllObjects];
    [self.images addObject:[UIImage imageNamed:@"numberOne"]];
    [self.images addObject:[UIImage imageNamed:@"numberTwo"]];
    [self.images addObject:[UIImage imageNamed:@"numberThree"]];
    [self.images addObject:[UIImage imageNamed:@"numberFour"]];
    [self.images addObject:[UIImage imageNamed:@"number5"]];
    [self.images addObject:[UIImage imageNamed:@"number6"]];
    [self.images addObject:[UIImage imageNamed:@"number7"]];
    [self.images addObject:[UIImage imageNamed:@"number8"]];
    [self.images addObject:[UIImage imageNamed:@"number9"]];
    [self.images addObject:[UIImage imageNamed:@"number10"]];


    NSLog(@"image count is %d",self.images.count);
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else
    {
        NSInteger index = [(PointAnnotation *)annotation index];
        pin.image = self.images[index];
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.canShowCallout = YES;
    }
    return pin;

}
//

-(void)getDirections
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    bool firstTimeinLoop = YES;

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

- (IBAction)onDirectionsButtonPressed:(id)sender
{

    self.infoView.hidden = NO;
    self.infoTextView.hidden = NO;
    self.infoView.layer.cornerRadius = 10;
    self.infoView.layer.masksToBounds = YES;
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
