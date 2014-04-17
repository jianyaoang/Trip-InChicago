//
//  SectionViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "SectionViewController.h"
#import "MapViewController.h"

@interface SectionViewController () <UITableViewDataSource, UITableViewDataSource>

@property NSArray *sectionNames;
@end

@implementation SectionViewController

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
    self.sectionNames = @[@"cafe", @"art_gallery", @"bar", @"establishment", @"museum", @"park", @"restaurant", @"shopping_mall", @"train_station", @"bus_station"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sectionNames.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCellID"];
    cell.textLabel.text = [self.sectionNames objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Prepare for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.sectionTableView indexPathForSelectedRow];
    NSString *string = [self.sectionNames objectAtIndex:indexPath.row];

    MapViewController *mapViewController = (MapViewController *)segue.destinationViewController;
    mapViewController.googleType = string;
    
    //mapViewController.restuarantDetail = [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
    //[self queryGooglePlaces:sender.textLabel.text];
//need to add in that query needs to take place 

}

//- (IBAction)onBarButtonPressed:(id)sender
//{
//    UIBarButtonItem *button = (UIBarButtonItem *)sender;
//    NSString *buttonTitle = [button.title lowercaseString];
//    //Use this title text to build the URL query and get the data from Google.
//    [self queryGooglePlaces:buttonTitle];
//}
//



@end
