//
//  PicsAndReviewsViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "PicsAndReviewsViewController.h"
#import "NotesViewController.h"

@interface PicsAndReviewsViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *reviewsTableView;
    NSMutableArray *reviewsText;
    NSArray *reviewArray;
    NSMutableArray *imageArray;
    UIImageView *imageView;
    IBOutlet UIScrollView *imageScrollView;
    IBOutlet UIPageControl *imagePageControl;
}

@end

@implementation PicsAndReviewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    reviewArray = [NSArray new];
    reviewsText = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    
    [self extractFlickrJSON];
    
    imageScrollView.delegate = self;
}

-(void)extractFlickrJSON
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=7ce03f98cbe66eefe8451cff602f08ec&tags=%@&per_page=10&accuracy=16&content_type=1&safe_search=1&sort=relevance&format=json&nojsoncallback=1",self.location.name];
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
    }];
}

-(void)imageInScrollView
{
    CGFloat width = 0.0f;
    
    for (NSData *imageData in imageArray)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        imageView = [[UIImageView alloc]initWithImage:image];
        [imageScrollView addSubview:imageView];
        
        imageView.frame = CGRectMake(width, 0, self.view.frame.size.width, self.view.frame.size.height);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.contentMode = UIViewContentModeCenter;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.contentMode = UIViewContentModeScaleToFill;
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
    NSLog(@"%d",imageArray.count);
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
    UIFont *font = [UIFont fontWithName:@"Arial" size:15];
    cell.textLabel.text = self.location.tips;
    cell.textLabel.font = font;
    
    [cell.textLabel.text stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"showNotesView"])
    {
        NotesViewController *vc = segue.destinationViewController;
        vc.location = self.location;
    }
}

@end
