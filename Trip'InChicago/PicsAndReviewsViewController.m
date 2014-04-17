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
    NSArray *reviewsText;
    NSArray *reviewArray;
}

@end

@implementation PicsAndReviewsViewController

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
    reviewArray = [NSArray new];
    reviewsText = [NSArray new];
    [self extractReviewJSON];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviewsText count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCellID"];
    cell.textLabel.text = [reviewsText objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
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
        
        for (NSDictionary *reviews in reviewArray)
        {
            reviewsText = [NSArray arrayWithObject:reviews[@"text"]];
            NSLog(@"reviewsText:%@",reviewsText);
        }

        [reviewsTableView reloadData];
    }];
}

@end
