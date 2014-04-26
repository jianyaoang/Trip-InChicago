//
//  DetailConciergeViewController2.m
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/26/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "DetailConciergeViewController2.h"

@interface DetailConciergeViewController2 ()

@end

@implementation DetailConciergeViewController2

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
    self.distanceTextField.text = self.distance;
    self.phoneNumberTextField.text = self.phoneNumber;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
