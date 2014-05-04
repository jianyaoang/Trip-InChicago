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
@property (strong, nonatomic) IBOutlet UIButton *phoneCallButton;
@property (strong, nonatomic) IBOutlet UIImageView *phoneImageView;

@end

@implementation DetailConciergeViewController2

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

    self.locationManager = [CLLocationManager new];
    [self.conciergeDetailMapView setShowsUserLocation:YES];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = self.locationManager.location;

    self.distanceTextField.text    = self.distance;
    self.phoneNumberTextField.text = self.phoneNumber;
    [self hidePhoneButton];
    self.addressTextField.text = self.address;

    CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake (centerCoordinate, coordinateSpan);
    self.conciergeDetailMapView.region = region;

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.myLocation.coordinate.latitude, self.myLocation.coordinate.longitude);
    [self.conciergeDetailMapView addAnnotation:annotation];

    [self constructAddressString];
}


-(void)hidePhoneButton
{
    if ([self.phoneNumber isEqualToString:@""])
    {
        self.phoneNumberTextField.hidden = YES;
        self.phoneImageView.hidden = YES;
        self.phoneCallButton.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.addressTextField.textColor = [UIColor blackColor];
    self.addressTextField.alpha = 1.0;
    self.callNumberButton.layer.cornerRadius = 10;
    self.callNumberButton.layer.masksToBounds = YES;
    self.addressTextField.layer.cornerRadius = 10;
    self.addressTextField.layer.masksToBounds = YES;
    [self hidePhoneButton];
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
    NSString *newString = [[self.phoneNumber componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];

    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:newString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}


@end
