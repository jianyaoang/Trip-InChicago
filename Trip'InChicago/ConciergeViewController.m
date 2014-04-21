//
//  ConciergeViewController.m
//  Trip'InChicago
//
//  Created by Marion Ano on 4/21/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "ConciergeViewController.h"
#import "ListViewController.h"



@interface ConciergeViewController ()
@property NSString *outdoorString;
@property NSString *indoorString;
@property NSString *mixString;

@property (strong, nonatomic) IBOutlet UISegmentedControl *typesSegmentedControl;
@end

@implementation ConciergeViewController

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
    self.typesSegmentedControl.selectedSegmentIndex=-1;

    self.indoorString = @"theater";//food,shop,arts
    self.mixString = @"coffee,food,sights,shop,outdoors,parks";
    self.outdoorString = @"outdoors,parks";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    NSIndexPath *indexPath = [self.sectionTableView indexPathForSelectedRow];
    //    NSString *sectionName = [self.sectionNames objectAtIndex:indexPath.row];

    ListViewController *vc = [ListViewController new];

    if (self.typesSegmentedControl.selectedSegmentIndex == 0)
    {
        vc = (ListViewController*)segue.destinationViewController;
        vc.sectionString = self.indoorString;
    }
    else if (self.typesSegmentedControl.selectedSegmentIndex == 1)

    {
        vc = (ListViewController*)segue.destinationViewController;
        vc.sectionString = self.mixString;
    }
    else if (self.typesSegmentedControl.selectedSegmentIndex == 2)
    {

        vc = (ListViewController*)segue.destinationViewController;
        vc.sectionString = self.outdoorString;
    }
    
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
