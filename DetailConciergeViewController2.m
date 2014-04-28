//
//  DetailConciergeViewController2.m
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/26/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "DetailConciergeViewController2.h"
#import <AddressBook/AddressBook.h>

@interface DetailConciergeViewController2 () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *conciergeDetailMapView;

@end

@implementation DetailConciergeViewController2

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
    self.distanceTextField.text    = self.distance;
    self.phoneNumberTextField.text = self.phoneNumber;
    self.addressTextField.text = self.address;


    self.locationManager = [CLLocationManager new];
    [self.conciergeDetailMapView setShowsUserLocation:YES];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;


    CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake (centerCoordinate, coordinateSpan);
    self.conciergeDetailMapView.region = region;



    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.myLocation.coordinate.latitude, self.myLocation.coordinate.longitude);
    [self.conciergeDetailMapView addAnnotation:annotation];

    [self constructAddressString];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.addressTextField.textColor = [UIColor blackColor];
    self.addressTextField.alpha = 1.0;
    self.callNumberButton.layer.cornerRadius = 10;
    self.callNumberButton.layer.masksToBounds = YES;
    self.addressTextField.layer.cornerRadius = 10;
    self.addressTextField.layer.masksToBounds = YES;
//    self.distanceTextField.layer.cornerRadius = 10;
//    self.distanceTextField.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)constructAddressString
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.myLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
       if (error)
       {
           NSLog(@"Geocode failed with error: %@", error);
           return;
       }

       if (placemarks && placemarks.count > 0)
       {
           CLPlacemark *placemark = placemarks[0];

           NSDictionary *addressDictionary = placemark.addressDictionary;


           NSString *address = [addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
//           NSString *city    = [addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
//           NSString *state   = [addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
//           NSString *zip     = [addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey];

           self.addressTextField.text = address;

           NSLog(@"%@", addressDictionary);

           //tells the main thread the block result was completed, this will allow the UI to update
//           dispatch_async(dispatch_get_main_queue(), ^{
//               //put your asynchronous result in this block
//           });

       }
       
   }];

}

- (IBAction)onCallButtonPressed:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:self.phoneNumber delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {

        //I think we need to format the string to have no spaces in it
        NSString *newString = [[self.phoneNumber componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];

        NSLog(@"%@", newString);

        NSString *phoneNumber = [@"tel://" stringByAppendingString:newString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

    }
    else
    {
        //user goes back to app
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
