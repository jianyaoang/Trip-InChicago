//
//  SectionListViewController.m
//  Trip'InChicago
//
//  Created by Marion Ano on 4/28/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "SectionListViewController.h"
#import "MapViewController.h"
#import "Location.h"
#import "DetailConciergeViewController2.h"
#import "PicsAndReviewsViewController.h"


@interface SectionListViewController ()
{
    NSMutableArray *locationMutableArray;
    NSMutableArray *venueMutableArray;
    NSMutableArray *locationDetailsArray;
    NSMutableArray *locationNameMutableArray;
    NSMutableArray *locationNameMutableArrayAndLocationMutableArray;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SectionListViewController

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
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.currentLocation = [CLLocation new];
    self.currentLocation = self.locationManager.location;

    locationNameMutableArrayAndLocationMutableArray = [NSMutableArray new];
    locationNameMutableArray = [NSMutableArray new];
    venueMutableArray = [NSMutableArray new];
    locationMutableArray = [NSMutableArray new];
    locationDetailsArray = [NSMutableArray new];
    [self extractVenueJSON];
    [self.myTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;

    [self extractVenueJSON];

    [self.myTableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(CLLocation*)location
{
    self.currentLocation = location;

    [self extractVenueJSON];

    [self.locationManager stopUpdatingLocation];

}

-(void)extractVenueJSON
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&oauth_token=02ALL4LOCE2LTXXTA4ASHFTYOEAAUIRWOYT2P5S2AHBBBADA&v=20140419", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, self.searchSection];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {


        if (connectionError != nil)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Data Connection Error"
                                                        message:@"No data connection try again later"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

            [av show];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        }
        else
        {

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

                Location* location = [Location new];

                location.lat = [venueDictionary[@"location"][@"lat"]floatValue];
                location.lng =  [venueDictionary[@"location"][@"lng"]floatValue];
                location.address = venueDictionary[@"location"][@"address"];
                location.name = venueDictionary[@"name"];
                location.phoneNumber = venueDictionary[@"contact"][@"formattedPhone"];
                location.tips = tipsFirstLayer[@"text"];
                location.tipsID = tipsFirstLayer[@"id"];
                location.canonicalUrl = tipsFirstLayer[@"canonicalUrl"];
                location.venueID = venueDictionary[@"id"];

                [locationNameMutableArray addObject:location];
                //NSLog(@"These are the locationNameMutableArray Items ----- %@", locationNameMutableArray);
                               
            }
            [self.myTableView reloadData];
            
        }
            }];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return locationNameMutableArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCellID"];
    Location *place = locationNameMutableArray[indexPath.row];
    cell.textLabel.text= place.name;
    cell.detailTextLabel.text = place.address;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"SectionMapSegue"])
    {
        MapViewController *vc = segue.destinationViewController;
        vc.foursquareLocationName = self.searchSection;
    }
    else if ([segue.identifier isEqualToString:@"FromSectionToPicAndReviews"])
    {
        PicsAndReviewsViewController *vc = (PicsAndReviewsViewController *)segue.destinationViewController;

        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        UITableViewCell *cell =  [self.myTableView cellForRowAtIndexPath:indexPath];
        Location *place = locationNameMutableArray[indexPath.row];
        vc.title = cell.textLabel.text;
        vc.address = cell.detailTextLabel.text;
        vc.phoneNumber = place.phoneNumber;

        vc.sectionListSearchName = cell.textLabel.text;
        

        //vc.phoneNumber = place.phoneNumber;


//        // Following code will use a placeMark cooridinate to construct an address
//        CLLocationDegrees placeLat = place.placemark.coordinate.latitude;
//        CLLocationDegrees placeLng = place.placemark.coordinate.longitude;
//
//        NSLog(@"%f, %f", placeLat, placeLng);
//        NSLog(@"%f, %f", place.placemark.coordinate.latitude, place.placemark.coordinate.longitude);
//
//        CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:placeLat longitude:placeLng];
//        vc.myLocation = newLocation;
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
