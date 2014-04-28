//
//  SectionListViewController.m
//  Trip'InChicago
//
//  Created by Marion Ano on 4/28/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "SectionListViewController.h"

@interface SectionListViewController ()<UITableViewDataSource, UITableViewDataSource>

@end

@implementation SectionListViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCellID"];

//    MKMapItem *place = intineraryPlaces[indexPath.row];
//
//    // removing the "," (comma) if there is nothing in place.phoneNumber
//    NSString *myComma = [NSString new];
//
//    if ([place.phoneNumber isEqualToString:@""])
//    {
//        myComma = @"";
//    }
//    else
//    {
//        myComma = @",";
//    }
//
//    //cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", place.name, myComma, place.phoneNumber];
//
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", place.name];
//
//    int distance = roundf([place.placemark.location distanceFromLocation:self.locationManager.location]);
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance from you: %2.2f miles", (distance/1609.34)];
//    cell.detailTextLabel.textColor = [UIColor blueColor];
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
