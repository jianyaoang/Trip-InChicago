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
}
@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property NSMutableArray *images;

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
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);

    self.routeMapViewMap.delegate = self;

    self.routeMapViewMap.region = region;

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

-(void)createItenAnnotations
{
    NSInteger index = 1;
    for (MKMapItem *item in self.routesArray)
    {
        PointAnnotation *annotation = [PointAnnotation new];
        annotation.coordinate = item.placemark.coordinate;
        annotation.title      = item.name;
        annotation.index      = index;
        index++;


        [self.routeMapViewMap addAnnotation:annotation];
        [self.routeMapViewMap reloadInputViews];
    }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //this enables properties of the annotation (the pin)
//  if (annotation != self.locationManager.location)
//    {
//        return nil;
//    }
    //note that this method is very similar to the (UITableViewCell*) or UITableViewDataSource method
    //annotation view is a representation of the data (which is ʻannotationʻ)
    //if pin does not show up make sure you connected the MapView delegate outlet to the VC. Remember, VC is the delegate
    //for (MKMapItem *item in self.routesArray)
   // {



    MKPinAnnotationView* pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    //pin.annotation = item.placemark;
//    NSArray *numberImages = @[@"numberOne",@"numberTwo",@"numberThree",@"numberFour",@"numberFive"];
//    NSArray *images = [NSArray arrayWithObjects:@"numberOne",@"numberTwo",@"numberThree",@"numberFour",@"numberFive", nil];

    [self.images addObject:[UIImage imageNamed:@"numberOne"]];
    [self.images addObject:[UIImage imageNamed:@"numberTwo"]];
    [self.images addObject:[UIImage imageNamed:@"numberThree"]];
    [self.images addObject:[UIImage imageNamed:@"numberFour"]];
    [self.images addObject:[UIImage imageNamed:@"numberFive"]];
    
    NSLog(@"image count is %d",self.images.count);
    
    NSInteger index = [(PointAnnotation *)annotation index];
    pin.image = self.images[index];
    //[(PointAnnotation*)annotation index]
    //pin.image = self.images[]
    
           //}
    //adds info button to the callout
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//
//    pin.canShowCallout = YES;
    return pin;

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
