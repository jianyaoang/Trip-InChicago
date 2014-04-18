//
//  PicsAndReviewsViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "PicsAndReviewsViewController.h"

@interface PicsAndReviewsViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *reviewsTableView;
    NSMutableArray *reviewsText;
    NSArray *reviewArray;
    NSMutableArray *imageArray;
    UIImageView *imageView;
    IBOutlet UIScrollView *imageScrollView;

}

@end

@implementation PicsAndReviewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    reviewArray = [NSArray new];
    reviewsText = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    
    [self extractReviewJSON];
    [self extractFlickrJSON];
    
    imageScrollView.delegate = self;
}

-(void)extractFlickrJSON
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=7ce03f98cbe66eefe8451cff602f08ec&tags=%@&per_page=10&format=json&nojsoncallback=1",self.mapPoint.name];
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
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        width += imageView.frame.size.width;
    }
    [imageScrollView setContentMode:UIViewContentModeScaleAspectFit];
//    [imageView sizeToFit];
    imageScrollView.contentSize = CGSizeMake(width, imageScrollView.frame.size.height);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewsText count];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([indexPath row] == 0)
//    {
//        return (44 + (reviewsText.count - 1)* 19);
//    }
//    else
//    {
//        return 44;
//    }
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCellID"];
    cell.textLabel.text = [reviewsText objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    return cell;
}



-(void)extractReviewJSON
{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyDpJ3qwqVyq08eqvrq5x7_SyPD405ZeWLc",self.mapPoint.referenceKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSDictionary *firstDictionaryLayer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSDictionary *resultsDictionary = firstDictionaryLayer[@"result"];
        reviewArray = resultsDictionary[@"reviews"];
        
        //remember key value coding, especially if we wannt to extract only one key from dict. Code below = for loop below.
        reviewsText = [reviewArray valueForKey:@"text"];
        
//        [reviewsText removeAllObjects];
//        
//        for (NSDictionary *reviews in reviewArray)
//        {
//            [reviewsText addObject:reviews[@"text"]];
//            NSLog(@"(%i)reviewsText:%@",reviewsText.count, reviewsText);
//        }
        [reviewsTableView reloadData];
    }];
}

@end
