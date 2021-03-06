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
            }
            [self.myTableView reloadData];
            
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            }];

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
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *place = locationNameMutableArray[indexPath.row];
    NSString *placeName = place.name;
    CGFloat width = 280;
    UIFont *font = [UIFont systemFontOfSize:5];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:placeName attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    rect = CGRectInset(rect, -30, -30);
    CGSize size = rect.size;
    return size.height;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"SectionMapSegue"])
    {
        MapViewController *vc = segue.destinationViewController;
        vc.foursquareLocationName = self.searchSection;
        vc.navigationItem.title = [NSString stringWithFormat:@"%@ Map",self.navigationItem.title];
    }
    else if ([segue.identifier isEqualToString:@"FromSectionToPicAndReviews"])
    {
        PicsAndReviewsViewController *vc = (PicsAndReviewsViewController *)segue.destinationViewController;

        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        Location *place = locationNameMutableArray[indexPath.row];
        vc.location = place;
        vc.title = place.name;
        vc.address = place.address;
        vc.location.name = place.name;
        vc.phoneNumber = place.phoneNumber;

    }
}


@end
