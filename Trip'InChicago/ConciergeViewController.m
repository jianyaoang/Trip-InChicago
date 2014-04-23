//
//  ConciergeViewController.m
//  Trip'InChicago
//
//  Created by Marion Ano on 4/21/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "ConciergeViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "RouteMapViewController.h"

@interface ConciergeViewController ()<UITableViewDataSource, UITableViewDataSource, CLLocationManagerDelegate>
{
    NSMutableArray *locationMutableArray;
    NSMutableArray *venueMutableArray;
    NSMutableArray *locationDetailsArray;
    //array of places to visit
    NSArray *intineraryPlaces;
    NSMutableArray *sortArray;
    double timeforIntinerary;
}
@property NSString *outdoorString;
@property NSString *indoorString;
@property NSString *mixString;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

@property (strong, nonatomic) IBOutlet UISegmentedControl *typesSegmentedControl;
@end

@implementation ConciergeViewController

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

    self.typesSegmentedControl.selectedSegmentIndex=-1;

    // Arts & Entertainment 4d4b7104d754a06370d81259, Food 4d4b7105d754a06374d81259, Shop & Service 4d4b7105d754a06378d81259,
    // Cultural Center Cultural Center 52e81612bcbc57f1066b7a32
    self.indoorString = @"4d4b7104d754a06370d81259,4d4b7105d754a06374d81259,4d4b7105d754a06378d81259,52e81612bcbc57f1066b7a32";


    // *Nightlife Spot 4d4b7105d754a06376d81259 & both indoor and outdoor categories
    self.mixString    = @"4d4b7104d754a06370d81259,4d4b7105d754a06374d81259,4d4b7105d754a06378d81259,52e81612bcbc57f1066b7a32,4d4b7105d754a06376d81259,4d4b7105d754a06377d81259,4bf58dd8d48988d12d941735,4d4b7105d754a06373d81259,5267e4d9e4b0ec79466e48c7,5267e4d9e4b0ec79466e48d1,5267e4d9e4b0ec79466e48c8,52741d85e4b0d5d1e3c6a6d9,5267e4d8e4b0ec79466e48c5";

    /*  Outdoors & Recreation 4d4b7105d754a06377d81259,
        Monument/Landmark 4bf58dd8d48988d12d941735,
     *  Event 				 4d4b7105d754a06373d81259
     *	Festival 			 5267e4d9e4b0ec79466e48c7
     *	Music Festival		 5267e4d9e4b0ec79466e48d1
     *	Other Event 		 5267e4d9e4b0ec79466e48c8
     *	Parade				 52741d85e4b0d5d1e3c6a6d9
     *	Street Fair			 5267e4d8e4b0ec79466e48c5
     */
    self.outdoorString = @"4d4b7105d754a06377d81259,4bf58dd8d48988d12d941735,4d4b7105d754a06373d81259,5267e4d9e4b0ec79466e48c7,5267e4d9e4b0ec79466e48d1,5267e4d9e4b0ec79466e48c8,52741d85e4b0d5d1e3c6a6d9,5267e4d8e4b0ec79466e48c5";


    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    locationMutableArray = [NSMutableArray new];
    venueMutableArray    = [NSMutableArray new];
    locationDetailsArray = [NSMutableArray new];
    intineraryPlaces = [NSArray new];
    timeforIntinerary = 28000;

    [self.myTableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self searchIndoorMixOutdoor];
    [self.myTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000){

            self.currentLocation = location;

//            [self startReverseGeocode];
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }
}

-(void) startReverseGeocode {

    if (self.typesSegmentedControl.selectedSegmentIndex  < -1 || self.typesSegmentedControl.selectedSegmentIndex > 3)
        return;

    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    [self narrowDownPlaces:placemarks.firstObject];

    }];
}

- (IBAction)onSegmentButtonPressed:(UISegmentedControl*)sender // was id before the UISegmentedControl
{
    if (self.typesSegmentedControl.selectedSegmentIndex == 0)
    {
        self.sectionString = self.indoorString;
        
    }
    else if (self.typesSegmentedControl.selectedSegmentIndex == 1)
    {
        self.sectionString = self.mixString;
    }
    else if (self.typesSegmentedControl.selectedSegmentIndex == 2)
    {
        self.sectionString = self.outdoorString;
    }

    [self startReverseGeocode];
}

#pragma mark -- table view delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return intineraryPlaces.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCellID"];
    MKMapItem *place = intineraryPlaces[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ , %@", place.name, place.phoneNumber];
    int distance = roundf([place.placemark.location distanceFromLocation:self.locationManager.location]);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Crow's Distance: %i meters", distance];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSString* string;
    if ((int)round(timeforIntinerary) == 28000) {
        string = @"Estimated time is: Calculating";
    }
    else{
        string = [NSString stringWithFormat:@"Estimated time is: %d minutes", ((int)round(timeforIntinerary)/60)];
    }
    return string;
}

#pragma mark - Helper Methods
-(void) calculateDistance:(NSArray *) nextDestinaton{

    MKDirectionsRequest* request = [MKDirectionsRequest new];
    request.transportType = MKDirectionsTransportTypeWalking;

    for (int i = 0; i<nextDestinaton.count; i++) {
        if (i == 0) {
            request.source = [MKMapItem mapItemForCurrentLocation];
        }
        else
        {
            request.source = [nextDestinaton objectAtIndex:i-1];
        }
        request.destination = [nextDestinaton objectAtIndex:i];
        MKDirections* directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            MKRoute* route = response.routes.firstObject;
            timeforIntinerary += route.expectedTravelTime;
            [self.myTableView reloadData];
        }];
    }
}

-(void)caculateMinimunTime:(int)numberOfPlaces
{
    timeforIntinerary = (90*(numberOfPlaces-1))*60;

}
-(void) narrowDownPlaces: (CLPlacemark*)placemark
{

    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&radius=2500&intent=browse&categoryId=%@&oauth_token=02ALL4LOCE2LTXXTA4ASHFTYOEAAUIRWOYT2P5S2AHBBBADA&v=20140419", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, self.sectionString];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *firstLayer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

        NSDictionary *responseDictionary = firstLayer[@"response"];
        NSArray *groupsArray = responseDictionary[@"venues"];

//        NSDictionary *groupsArrayDictionary = groupsArray.firstObject;
//        NSArray *items = groupsArrayDictionary[@"categories"];

        sortArray = [NSMutableArray new];

        [sortArray removeAllObjects];

        for (NSDictionary *places in groupsArray)
        {
//            NSDictionary *venueDictionary = venueAndTips[@"venues"];


            Location* location = [Location new];

            location.lat = [places[@"location"][@"lat"]floatValue];
            location.lng =  [places[@"location"][@"lng"]floatValue];
            location.address = places[@"location"][@"address"];
            location.name = places[@"name"];

            location.phoneNumber = places[@"contact"][@"formattedPhone"];

            CLLocationCoordinate2D placeCoordinate = CLLocationCoordinate2DMake(location.lat, location.lng);
            MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:placeCoordinate addressDictionary:nil];
            location.placemark = placemark;


            MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:placemark];
            mapItem.name = location.name;
            mapItem.phoneNumber = location.phoneNumber;

            [sortArray addObject:mapItem];

        }

        NSArray *mapItems = sortArray;

        mapItems = [mapItems sortedArrayUsingComparator:^NSComparisonResult(MKMapItem* obj1, MKMapItem* obj2) {
            float d1 = [obj1.placemark.location distanceFromLocation:self.locationManager.location];
            float d2 = [obj2.placemark.location distanceFromLocation:self.locationManager.location];
            if (d1 < d2)
            {
                return NSOrderedAscending;
            }
            else
            {
                return NSOrderedDescending;
            }

        }];

        NSRange numberOfAvailablePlaces;
        if (mapItems.count >= 10)
        {
            numberOfAvailablePlaces = NSMakeRange(0, 10);
            mapItems = [mapItems subarrayWithRange:numberOfAvailablePlaces];
        }
        else
        {
            numberOfAvailablePlaces = NSMakeRange(0, mapItems.count);
            mapItems = [mapItems subarrayWithRange:numberOfAvailablePlaces];
        }

        intineraryPlaces = mapItems; //15 we get back items
        [self caculateMinimunTime:intineraryPlaces.count];


        NSLog(@"%@", intineraryPlaces);
        [self calculateDistance:mapItems];
        //everything in the array goes in as an id object
        for (MKMapItem *place in intineraryPlaces)
        {
            //        //create a new annotation object
            //        //CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude,longitude);
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = place.placemark.location.coordinate;
            //        //make an array of annotations
            //        [myView addAnnotation:annotation];

        }
        //[myView reloadInputViews];
        [self.myTableView reloadData];
    }];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
      //  NSIndexPath *path = [self.myTableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
            NSMutableArray *places = [[NSMutableArray alloc]initWithArray:intineraryPlaces];
            [places removeObjectAtIndex:indexPath.row];
            intineraryPlaces = places;
            cell.textLabel.textColor = [UIColor blackColor];
            [self caculateMinimunTime:intineraryPlaces.count];
            [self calculateDistance:intineraryPlaces];
            [self.myTableView reloadData];

    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//
//{
//    NSIndexPath *path = [self.myTableView indexPathForSelectedRow];
//    UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:path];
//    if (buttonIndex == 1)
//    {
//        NSMutableArray *places = [[NSMutableArray alloc]initWithArray:intineraryPlaces];
//        [places removeObjectAtIndex:path.row];
//        intineraryPlaces = places;
//        cell.textLabel.textColor = [UIColor blackColor];
//        [self caculateMinimunTime:intineraryPlaces.count];
//        [self calculateDistance:intineraryPlaces];
//        [self.myTableView reloadData];
//    }
//}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"ShowItenMapView"])
    {
        RouteMapViewController *vc = segue.destinationViewController;
        vc.routesArray = intineraryPlaces;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
