//
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
@interface PicsAndReviewsViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
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
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberTextField;

@end

@implementation PicsAndReviewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    reviewArray = [NSArray new];
    reviewsText = [NSMutableArray new];
    imageArray = [NSMutableArray new];

    self.locationManager = [CLLocationManager new];
    [placeMapView setShowsUserLocation:YES];
    [self.locationManager startUpdatingLocation];
    self.currentLocation = [CLLocation new];
    self.currentLocation = self.locationManager.location;

    CLLocationCoordinate2D centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(.01, .01);
    MKCoordinateRegion region = MKCoordinateRegionMake (centerCoordinate, coordinateSpan);
    placeMapView.region = region;

    addressLabel.text = self.address;
    self.phoneNumberTextField.text = self.phoneNumber;
    telephoneNumber.layer.cornerRadius = 10;
    telephoneNumber.layer.masksToBounds = YES;
    
    [self extractFlickrJSON];


    
    imageScrollView.delegate = self;
    
    placeholderImageView.image = [UIImage imageNamed:@"imagePlaceholder"];
    
    //addressLabel.text = self.location.address;
    addressLabel.numberOfLines = 0;
    
}

-(void)extractFlickrJSON
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    // Passing search term from two different controllers
    // check the ivar and populate accordingly
//    NSString *pictureStringSearchName = [NSString new];
//
//    if ([self.sectionListSearchName isEqual: @""])
//    {
//        pictureStringSearchName = self.location.name;
//    }
//    else
//    {
//        pictureStringSearchName = self.sectionListSearchName;
//    }
//
//    NSString *cleanLocationNameString = [pictureStringSearchName stringByReplacingOccurrencesOfString:@" " withString:@""];

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
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        imageView = [[UIImageView alloc]initWithImage:newImage];
        [imageScrollView addSubview:imageView];

        imageView.frame = CGRectMake(width, 0, self.view.frame.size.width, self.view.frame.size.height);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.contentMode = UIViewContentModeCenter;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.contentMode = UIViewContentModeCenter;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        width += imageView.frame.size.width;
//        [imageView sizeToFit];
    }
    [imageScrollView setContentMode:UIViewContentModeScaleAspectFit];
//    [imageView sizeToFit];
    imageScrollView.contentSize = CGSizeMake(width, imageScrollView.frame.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = imageScrollView.frame.size.width;
    int page = floor((imageScrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    imagePageControl.currentPage = page;
    imagePageControl.numberOfPages = imageArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = screenBounds.size;
//    
//    NSAttributedString *cellText = [[NSAttributedString alloc] initWithString:[reviewsText objectAtIndex:indexPath.row]];
//    UITextView *calculateView = [UITextView new];
//    [calculateView setAttributedText:cellText];
//    
//    CGSize size = [calculateView sizeThatFits:CGSizeMake(screenSize.width, FLT_MAX)];
//    return size.height;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCellID"];
    //cell.textLabel.text = [reviewsText objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.textLabel.text = self.location.tips;
    cell.textLabel.font = font;
    
    [cell.textLabel.text stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    return cell;
}

#pragma mark -- phone calling methods
- (IBAction)onPhoneCallButtonPressed:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Call"
                                                 message:self.phoneNumber
                                                delegate:self
                                       cancelButtonTitle:@"NO"
                                       otherButtonTitles:@"YES",nil];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"showNotesView"])
    {
        NotesViewController *vc = segue.destinationViewController;
        vc.location = self.location;
        vc.location.name = self.location.name;
        vc.navigationItem.title = self.location.name;
        //vc.navigationItem.title = self.sectionListSearchName ;
        //self.location.name      = self.sectionListSearchName;
        
    }
    else if ([segue.identifier isEqualToString:@"showFoursquareWebView"])
    {
        FoursquareWebViewController *vc = segue.destinationViewController;
        vc.location = self.location;
        vc.navigationItem.title = self.location.name;
    }
}

- (IBAction)onTelephoneNumberButtonPressed:(id)sender
{
    
}
@end
