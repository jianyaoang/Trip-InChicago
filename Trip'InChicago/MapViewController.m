//
//  MapViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//Chicago coordinates: 41.8791052, -87.6360277
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *reference;
}

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    reference = [NSMutableArray new];
    [self extractReferenceKeyFromPlaces];
    
    firstLaunch=YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    //Make this controller the delegate for the location manager.
    self.locationManager.delegate = self;

    [self.sectionMapView setShowsUserLocation:YES];

//    [self.locationManager startUpdatingLocation];

    //Make this controller the delegate for the map view.
    self.sectionMapView.delegate = self;
    
    //Set some parameters for the location object.
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.sectionMapView.centerCoordinate = userLocation.location.coordinate;
    [self queryGooglePlaces:self.googleType];
    self.sectionMapView.region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self.locationManager stopUpdatingLocation];
}

-(void) queryGooglePlaces: (NSString *) googleType
{
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&types=%@&sensor=true&maxprice=2&rankby=prominence&key=%@", self.currentCenter.latitude, self.currentCenter.longitude, 10000, googleType, kGOOGLE_API_KEY]; //took out self.currentCenter.latitude & , self.currentCenter.longitude

    NSLog(@" this is %f %f", self.currentCenter.latitude, self.currentCenter.longitude);
    NSLog(@"%@", url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });

    // Jaime - Make it stop updating...
    [self.locationManager stopUpdatingLocation];
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
    
    NSLog(@"%@", json);
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);
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
        region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate,2000,2000); //started with 1000, 1000
        firstLaunch=NO;
    }
    else
    {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre, self.currenDist, self.currenDist);
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
    [self.locationManager stopUpdatingLocation];

}

//This delegate method will be called every time the user changes the map by zooming or by scrolling around to a new position.
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.sectionMapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    self.currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    self.currentCenter = self.sectionMapView.centerCoordinate;

    // Jaime - Make it stop updating
    [self.locationManager stopUpdatingLocation];

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
    }
}

-(void)extractReferenceKeyFromPlaces
{
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/search/json?location=41.8819,-87.6278&radius=500&types=cafe&sensor=true&maxprice=2&rankby=prominence&key=AIzaSyALMcBucS3F7QojSUO7tUu6B2ZSw_K6MaI"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *firstLayer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
         NSArray *resultsArray = firstLayer[@"results"];
         
         for (NSDictionary *referenceInDictionary in resultsArray)
         {
             reference = [NSMutableArray arrayWithObjects:referenceInDictionary[@"reference"], nil];
             NSLog(@"reference: %@",reference);
         }
     }];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showPicsAndReview" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}










@end
