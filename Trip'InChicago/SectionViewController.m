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
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section = [self.sectionNames objectAtIndex:indexPath.row];
    CGFloat width = 320;
    UIFont *font = [UIFont systemFontOfSize:19];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:section attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    rect = CGRectInset(rect, -40, -40);
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
