//
//  MapViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//Chicago coordinates: 41.8791052, -87.6360277
//

#import "MapViewController.h"
#import "MapPoint.h"
#import "PicsAndReviewsViewController.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *reference;
    NSMutableArray *referenceKeyString;
    NSMutableArray *nameOfPlace;
    NSMutableArray *nameOfPlaceAndReferenceKeyString;
}

@property (nonatomic) BOOL didUpdatePins;
@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.didUpdatePins = NO;
    self.currentLocation = self.locationManager.location;
//    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.03, 0.03);
//    MKCoordinateRegion region = MKCoordinateRegionMake(self.locationManager.location.coordinate, coordinateSpan);
//    self.sectionMapView.region = region;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    referenceKeyString = [NSMutableArray new];
    reference = [NSMutableArray new];
    nameOfPlace =[NSMutableArray new];
    nameOfPlaceAndReferenceKeyString = [NSMutableArray new];
//    [self extractReferenceKeyFromPlaces];
    
    firstLaunch=YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    //self.currentLocation = self.locationManager.location;
    

    [self.sectionMapView setShowsUserLocation:YES];

    [self.locationManager startUpdatingLocation];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;


    //Make this controller the delegate for the map view.
    self.sectionMapView.delegate = self;
    
    //Set some parameters for the location object.
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
//    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.03, 0.03);
//    MKCoordinateRegion region = MKCoordinateRegionMake(self.locationManager.location.coordinate, coordinateSpan);
//    self.sectionMapView.region = region;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

   self.sectionMapView.centerCoordinate = userLocation.location.coordinate;
   self.sectionMapView.region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.03, 0.03));


    //[self.sectionMapView setCenterCoordinate:userLocation.coordinate animated:YES];
 //[self.locationManager stopUpdatingLocation];
    if (!self.didUpdatePins)
    {
        self.didUpdatePins = YES;
        [self queryGooglePlaces:self.googleType];
    }
}

-(void) queryGooglePlaces: (NSString *) googleType
{
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&types=%@&sensor=true&maxprice=2&rankby=prominence&key=%@", self.sectionMapView.userLocation.coordinate.latitude, self.sectionMapView.userLocation.coordinate.longitude, 500, googleType, kGOOGLE_API_KEY]; //took out self.currentCenter.latitude & , self.currentCenter.longitude

    //NSLog(@" this is %f %f", self.currentCenter.latitude, self.currentCenter.longitude);
    //NSLog(@"%@", url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];

    NSURLRequest *request = [NSURLRequest requestWithURL:googleRequestURL];

         [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

             [self fetchedData:data];
         }];
    NSLog(@"At Query GooglePlaces");
}

//This method simply processes the results you receive from the Google API
-(void)fetchedData:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    for (NSDictionary *items in places)
    {
        MapPoint *mapPoint = [MapPoint new];
        mapPoint.name = items[@"name"];
        mapPoint.referenceKey = items[@"reference"];
        [referenceKeyString addObject:mapPoint];
    }
        //NSLog(@"Google Data: %@", places);

    NSLog(@"At fetched Data");
    [self.locationManager stopUpdatingLocation];

    [self plotPositions:places];
}


#pragma mark - MKMapViewDelegate methods.
-(void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    //Zoom back to the user location after adding a new set of annotations.
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    MKCoordinateRegion region;
    //If this is the first launch of the app, then set the center point of the map to the user's location.
    if (firstLaunch)
    {
        region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate,500,500);
        firstLaunch=NO;
    }
    else
    {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre,500,500); //self.currenDist,self.currenDist
    }
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
}


// delegate method that will take your annotations as you add them using [mapView addAnnotation:placeObject], and draw them on the map. This method sets up a reuse identifier named “MapPoint” and uses it to draw the pins on the map. Notice that you use some properties of the MKPinAnnotationView object you created to show animation and enable call outs when the pin is tapped.
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // Define your reuse identifier.
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]])
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.sectionMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    return nil;

    // Jaime - Make it stop updating...
    NSLog(@"mapView --> viewFor Annotation");
    //[self.locationManager stopUpdatingLocation];

}

//This delegate method will be called every time the user changes the map by zooming or by scrolling around to a new position.
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
       MKMapRect mRect = self.sectionMapView.visibleMapRect;
        MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
        MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));

////        //Set your current distance instance variable.
      self.currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);

        //Set your current center point on the map instance variable.
        self.currentCenter = self.sectionMapView.centerCoordinate;

        // Jaime - Make it stop updating
        NSLog(@"mapView --> regionDidChangeAnimated");
        //firstLaunch = NO;
        //[self.locationManager stopUpdatingLocation];
}

-(void)plotPositions:(NSArray *)data
{
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.sectionMapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [self.sectionMapView removeAnnotation:annotation];
        }
    }
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];

        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];

        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];

        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];

        //NSString *vicinity=[place objectForKey:[NSString stringWithFormat:@"Rating: %@ of 5", place[@"rating"]]]; //changed from "vicinity"
        NSString *vicinity=[NSString stringWithFormat:@"Rating: %@ of 5 Address: %@",[place objectForKey:@"rating"],[place objectForKey:@"vicinity"]];

        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;

        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];

        // 5 - Create a new annotation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [self.sectionMapView addAnnotation:placeObject];
       // NSLog(@"plot positions");
    }
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showPicsAndReview" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PicsAndReviewsViewController *vc = segue.destinationViewController;
    NSString *title = [[(MKAnnotationView*)sender annotation]title];

    if ([segue.identifier isEqualToString:@"showPicsAndReview"])
    {
        for (MapPoint *mapPoint in referenceKeyString)
        {
            NSLog(@"mapPoint.name: %@, title: %@", mapPoint.name, title);
            if ([mapPoint.name isEqualToString:title])
            {
                vc.mapPoint = mapPoint;
                break;
            }
        }
    }
}

#pragma mark -- experiment with user's location 
-(void)zoomInUserLocation
{
    MKUserLocation *userLocation = self.sectionMapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000);
    [self.sectionMapView setRegion:region animated:NO];
}









@end
