
//  PicsAndReviewsViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "PicsAndReviewsViewController.h"
#import "NotesViewController.h"
#import "FoursquareWebViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SectionListViewController.h"
//    7ce03f98cbe66weefe8451cff602f08ec
@interface PicsAndReviewsViewController () <UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    IBOutlet UITableView *reviewsTableView;
    NSMutableArray *reviewsText;
    NSArray *reviewArray;
    NSMutableArray *imageArray;
    UIImageView *imageView;
    IBOutlet UIScrollView *imageScrollView;
    IBOutlet UIPageControl *imagePageControl;
    IBOutlet UIImageView *placeholderImageView;
    IBOutlet MKMapView *placeMapView;
    IBOutlet UILabel *addressLabel;
    IBOutlet UIButton *telephoneNumber;
}
@property (strong, nonatomic) IBOutlet UIButton *FoursquareInfoButton;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (strong, nonatomic) IBOutlet MKMapView *expandedMapView;
@property (weak, nonatomic) IBOutlet UITextView *tipsTextView;
@property BOOL showTipsAndReviews;
@property (strong, nonatomic) IBOutlet UIView *myTextView;
@property (strong, nonatomic) IBOutlet UITextView *myTipsAndReviewsTextView;

@property (strong, nonatomic) IBOutlet UIButton *TipsAndReviewButton;

@end

@implementation PicsAndReviewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.FoursquareInfoButton.tintColor = [UIColor whiteColor];
    self.expandedMapView.hidden = YES;

    self.showTipsAndReviews = NO;
    self.myTextView.hidden = NO;
    self.myTipsAndReviewsTextView.hidden= YES;

    [self.TipsAndReviewButton setTitle:@"Where am I?" forState:UIControlStateNormal];
    self.myTextView.layer.cornerRadius = 10;
    self.myTextView.layer.masksToBounds = YES;
    self.tipsTextView.layer.cornerRadius = 10;
    self.tipsTextView.layer.masksToBounds = YES;
    self.tipsTextView.font = [UIFont fontWithName:@"Helvetica" size:20];
    self.tipsTextView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.65];

    [self.TipsAndReviewButton setBackgroundColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.58f alpha:0.7f]];
    [self.TipsAndReviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.TipsAndReviewButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:22];

    reviewArray = [NSArray new];
    reviewsText = [NSMutableArray new];
    imageArray = [NSMutableArray new];

    self.tipsTextView.text = self.location.tips;

    self.locationManager = [CLLocationManager new];
    [placeMapView setShowsUserLocation:YES];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = [CLLocation new];
    self.currentLocation = self.locationManager.location;

    CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.015, 0.015);
    MKCoordinateRegion region = MKCoordinateRegionMake (centerCoordinate, coordinateSpan);
    placeMapView.region = region;

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.location.lat, self.location.lng);
    [placeMapView addAnnotation:annotation];

    addressLabel.text = self.address;
    self.phoneNumberTextField.text = self.phoneNumber;
    telephoneNumber.layer.cornerRadius = 10;
    telephoneNumber.layer.masksToBounds = YES;
    
    [self extractFlickrJSON];
    
    imageScrollView.delegate = self;
    
    placeholderImageView.image = [UIImage imageNamed:@"imagePlaceholder"];

    addressLabel.numberOfLines = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self hidePhoneButton];
}

-(void)hidePhoneButton
{
    if (self.phoneNumber == nil)
    {
        telephoneNumber.hidden = YES;
        self.phoneImageView.hidden = YES;

        placeMapView.hidden = YES;
        self.expandedMapView.hidden = NO;

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(self.location.lat, self.location.lng);
        [self.expandedMapView addAnnotation:annotation];


        self.locationManager = [CLLocationManager new];
        [self.expandedMapView setShowsUserLocation:YES];
        [self.locationManager startUpdatingLocation];
        self.currentLocation = [CLLocation new];
        self.currentLocation = self.locationManager.location;
        CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;
        CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(self.location.lat, self.location.lng);
        // Make map points
        MKMapPoint userPoint = MKMapPointForCoordinate(centerCoordinate);
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotationCoordinate);
        // Make map rects with 0 size
        MKMapRect userRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0);
        MKMapRect annotationRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        // Make union of those two rects
        MKMapRect unionRect = MKMapRectUnion(userRect, annotationRect);
        // You have the smallest possible rect containing both locations

        MKMapRect unionRectThatFits = [self.expandedMapView mapRectThatFits:unionRect];
        [self.expandedMapView setVisibleMapRect:unionRectThatFits animated:YES];
    }
}

-(void)extractFlickrJSON
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSString *cleanLocationNameString = [self.location.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=e1619af9b853f421758f264b91c39677&tags=%@&per_page=5&accuracy=16&content_type=1&safe_search=1&sort=relevance&format=json&nojsoncallback=1",cleanLocationNameString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *firstFLickrLayer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSDictionary *photos = firstFLickrLayer[@"photos"];
        NSArray *photo = photos[@"photo"];
        
        for (NSDictionary *items in photo)
        {
            NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_z.jpg",items[@"farm"], items[@"server"], items[@"id"],items[@"secret"]];
            NSURL *url = [NSURL URLWithString:photoURL];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            
            [imageArray addObject:imageData];
        }
        [self imageInScrollView];
        imagePageControl.numberOfPages = imageArray.count;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (imageArray.count == 0 )
        {
            placeholderImageView.image = [UIImage imageNamed:@"NoImagePlaceholder"];
        }
    }];
}

-(void)imageInScrollView
{
    CGFloat width = 0.0f;
    
    for (NSData *imageData in imageArray)
    {

        UIImage *image = [UIImage imageWithData:imageData];

        // Resize the image block
        CGSize newSize = CGSizeMake(imageScrollView.frame.size.width, imageScrollView.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        imageView = [[UIImageView alloc]initWithImage:newImage];
        [imageScrollView addSubview:imageView];
        
        imageView.frame = CGRectOffset(imageScrollView.bounds, width, 0);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        width += imageView.frame.size.width;

    }
    [imageScrollView setContentMode:UIViewContentModeScaleAspectFit];

    imageScrollView.contentSize = CGSizeMake(width, imageScrollView.frame.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = imageScrollView.frame.size.width;
    int page = floor((imageScrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    imagePageControl.currentPage = page;
    imagePageControl.numberOfPages = imageArray.count;
}

#pragma mark -- phone calling methods
- (IBAction)onPhoneCallButtonPressed:(id)sender
{

    NSString *newString = [[self.phoneNumber componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];

    NSLog(@"%@", newString);

    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:newString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}

- (IBAction)onTipsAndReviewsButtonPressed:(id)sender
{

    self.showTipsAndReviews =! self.showTipsAndReviews;

    if (self.showTipsAndReviews)
    {
        [self.TipsAndReviewButton setTitle:@"Tips" forState:UIControlStateNormal];
        self.myTextView.hidden= YES;
        self.myTextView.layer.cornerRadius = 10;
        self.myTextView.layer.masksToBounds = YES;
        self.tipsTextView.layer.cornerRadius = 10;
        self.tipsTextView.layer.masksToBounds = YES;
    }
    else
    {
        [self.TipsAndReviewButton setTitle:@"Where am I?" forState:UIControlStateNormal];
        self.myTextView.hidden = NO;

    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"showNotesView"])
    {
        NotesViewController *vc = segue.destinationViewController;
        vc.location = self.location;
        vc.location.name = self.location.name;
        vc.navigationItem.title = self.location.name;
        
    }
    else if ([segue.identifier isEqualToString:@"showFoursquareWebView"])
    {
        FoursquareWebViewController *vc = segue.destinationViewController;
        vc.location = self.location;
        vc.navigationItem.title = self.location.name;
    }
}

@end
