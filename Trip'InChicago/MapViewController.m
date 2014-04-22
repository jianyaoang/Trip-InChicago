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
    NSMutableArray *locationNameMutableArray;
    NSMutableArray *locationNameMutableArrayAndLocationMutableArray;
    float northernBorder;
    float southernBorder;
    float easternBorder;
    float westernBorder;
}

@property (nonatomic) BOOL didUpdatePins;
@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.didUpdatePins = NO;
    self.currentLocation = self.locationManager.location;
    [self.locationManager startUpdatingLocation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    northernBorder = 0.0;
    //setting the southernBorder
    southernBorder = 100000.0;
    //setting the easternBorder
    easternBorder = -10000.0;
    //setting the westernBorder
    westernBorder = 0.0;
    self.locationManager = [CLLocationManager new];
    [self.sectionMapView setShowsUserLocation:YES];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;
    locationNameMutableArrayAndLocationMutableArray = [NSMutableArray new];
    locationNameMutableArray = [NSMutableArray new];
    venueMutableArray = [NSMutableArray new];
    locationMutableArray = [NSMutableArray new];
    locationDetailsArray = [NSMutableArray new];
    [self extractVenueJSON];



}
#pragma mark - mapdelegate method
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//
//}

-(void)extractVenueJSON
{

    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&oauth_token=02ALL4LOCE2LTXXTA4ASHFTYOEAAUIRWOYT2P5S2AHBBBADA&v=20140419", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, self.foursquareLocationName];



//    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&near=Chicago&section=%@&oauth_token=02ALL4LOCE2LTXXTA4ASHFTYOEAAUIRWOYT2P5S2AHBBBADA&v=20140419", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, self.foursquareLocationName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *firstLayer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSDictionary *responseDictionary = firstLayer[@"response"];
        NSArray *groupsArray = responseDictionary[@"groups"];
        NSDictionary *groupsArrayDictionary = groupsArray.firstObject;
        NSArray *items = groupsArrayDictionary[@"items"];
        
        [locationNameMutableArray removeAllObjects];
        
        for (NSDictionary *venueAndTips in items)
        {
            NSDictionary *venueDictionary = venueAndTips[@"venue"];
            
            NSArray *tips = venueAndTips[@"tips"];
            NSDictionary *tipsFirstLayer = tips.firstObject;
//            NSDictionary *tipsText = tipsFirstLayer[@"text"];
            
            Location* location = [Location new];
            
            location.lat = [venueDictionary[@"location"][@"lat"]floatValue];
            location.lng =  [venueDictionary[@"location"][@"lng"]floatValue];
            location.address = venueDictionary[@"location"][@"address"];
            location.name = venueDictionary[@"name"];
//            location.tips = tipsText[@"text"];
            location.tips = tipsFirstLayer[@"text"];
            [locationNameMutableArray addObject:location];
            
//            NSLog(@"mylocation %@, lat:%f lng:%f address:%@ ", location.name, location.lat, location.lng, location.address);
           // NSLog(@"location.tips : %@", location.tips);
        }
        [self placingPinsOnLocations];
    }];
}

-(void)placingPinsOnLocations
{
    for (Location *location in locationNameMutableArray)
    {
//if the pins are within our view, drop the pins
        if (!(fabsf(location.lat - self.locationManager.location.coordinate.latitude) > 0.015)&&
            !(fabsf(location.lng - self.locationManager.location.coordinate.longitude) > 0.012)) {
            [self creatingMapAndPins:location];
        }
    }
//the centerCoordinate is set to the locationManager's coordinates
    CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;

//setting the width and the height of mapwindow
    float x = ((fabsf(westernBorder)-fabsf(easternBorder)) + 0.005);
    float y = ((fabsf(northernBorder) - fabsf(southernBorder)) + 0.005);

    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
    self.sectionMapView.region = region;


}

-(void)creatingMapAndPins:(Location*)location
{

    MKPointAnnotation *annotation = [MKPointAnnotation new];
    if (location.lat > northernBorder) {
        northernBorder = location.lat;
    }
    if (location.lat < southernBorder) {
        southernBorder = location.lat;
    }
    if (location.lng < westernBorder) {
        westernBorder = location.lng;
    }
    if (location.lng > easternBorder) {
        easternBorder = location.lng;
    }


    annotation.coordinate = CLLocationCoordinate2DMake(location.lat, location.lng);

    NSLog(@"%f", annotation.coordinate.latitude - self.locationManager.location.coordinate.latitude);
    NSLog(@"%f", annotation.coordinate.longitude - self.locationManager.location.coordinate.longitude);


    annotation.title = location.name;
    NSLog(@"%@", location.name);
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
        for (Location *location in locationNameMutableArray)
        {
            if ([location.name isEqualToString:title])
            {
                vc.location = location;
                break;
            }
        }
    }
}


@end
