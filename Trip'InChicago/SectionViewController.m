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
    self.sectionNames = @[@"Sights", @"Coffee", @"Food", @"Arts", @"Shop", @"Outdoors", @"Entertainment"];
    
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
    NSString *sectionName = [self.sectionNames objectAtIndex:indexPath.row];

    MapViewController *mapViewController = (MapViewController *)segue.destinationViewController;
    mapViewController.foursquareLocationName = sectionName;
}





@end
