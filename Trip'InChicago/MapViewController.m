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
#import "Location.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *locationMutableArray;
    NSMutableArray *venueMutableArray;
    NSMutableArray *locationDetailsArray;
}

@property (nonatomic) BOOL didUpdatePins;
@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.didUpdatePins = NO;
    self.currentLocation = self.locationManager.location;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sectionMapView setShowsUserLocation:YES];
    venueMutableArray = [NSMutableArray new];
    locationMutableArray = [NSMutableArray new];
    locationDetailsArray = [NSMutableArray new];
    [self extractVenueJSON];
}

-(void)extractVenueJSON
{
<<<<<<< HEAD
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=41.8819,-87.6278&near=Chicago&section=%@&oauth_token=02ALL4LOCE2LTXXTA4ASHFTYOEAAUIRWOYT2P5S2AHBBBADA&v=20140419", self.foursquareLocationName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
=======

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
>>>>>>> f0aa9849ebd2c07e07441b9b0bfc29f5e2ad8639
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *firstLayer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSDictionary *responseDictionary = firstLayer[@"response"];
        NSArray *groupsArray = responseDictionary[@"groups"];
        NSDictionary *groupsArrayDictionary = groupsArray.firstObject;
        NSArray *items = groupsArrayDictionary[@"items"];
        
        for (NSDictionary *venue in items)
        {
            NSDictionary *venueDictionary = venue[@"venue"];
            [venueMutableArray addObject:venueDictionary];
            
            for (NSDictionary *location in venueMutableArray)
            {
                NSDictionary *locationDictionary = location[@"location"];
                [locationMutableArray addObject:locationDictionary];
            }
        }
        [self assigningInfoFromJSONToObject];
        [self placingPinsOnLocations];
    }];
}

-(void)assigningInfoFromJSONToObject
{
    for (NSDictionary *items in locationMutableArray)
    {
        Location *location = [Location new];
        location.address = items[@"address"];
        location.lat = [items[@"lat"]floatValue];
        location.lng = [items[@"lng"]floatValue];
        [locationDetailsArray addObject:location];
    }
}

-(void)placingPinsOnLocations
{
    for (Location *location in locationDetailsArray)
    {
        [self creatingMapAndPins:location];
    }
}

-(void)creatingMapAndPins:(Location*)location
{
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.lat, location.lng);
    
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(.03, .03);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
    
    self.sectionMapView.region = region;
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    
    annotation.coordinate = centerCoordinate;
    
    annotation.title = location.address;
    annotation.subtitle = location.address;
    
    [self.sectionMapView addAnnotation:annotation];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.animatesDrop = YES;
    
    return pin;
    
    [self.locationManager stopUpdatingLocation];
}











@end
