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
@property NSMutableArray *sectionBackgroundImages;
@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionNames = @[@"Sights", @"Coffee", @"Food", @"Arts", @"Trending", @"Outdoors", @"TopPicks"];
    self.sectionBackgroundImages = [[NSMutableArray alloc] initWithObjects:
                                    [UIImage imageNamed:@"sightSection"],
                                    [UIImage imageNamed:@"coffeeSection"],
                                    [UIImage imageNamed:@"foodSection"],
                                    [UIImage imageNamed:@"artsSection"],
                                    [UIImage imageNamed:@"trendingSection"],
                                    [UIImage imageNamed:@"outdoorSection"],
                                    [UIImage imageNamed:@"topPicks"],
                                    nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sectionNames.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCellID"];
    cell.textLabel.text = [self.sectionNames objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:35];
    cell.textLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:35];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundView = [[UIImageView alloc]initWithImage:[self.sectionBackgroundImages objectAtIndex:indexPath.row]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[self.sectionBackgroundImages objectAtIndex:indexPath.row]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section = [self.sectionNames objectAtIndex:indexPath.row];
    CGFloat width = 320;
    UIFont *font = [UIFont systemFontOfSize:35];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:section attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    rect = CGRectInset(rect, -90, -90);
    CGSize size = rect.size;
    return size.height;
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
