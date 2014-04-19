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
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=41.8819,-87.6278&near=Chicago&section=%@&oauth_token=02ALL4LOCE2LTXXTA4ASHFTYOEAAUIRWOYT2P5S2AHBBBADA&v=20140419", self.foursquareLocationName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
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
