//
//  ChoiceViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/22/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "ChoiceViewController.h"

@interface ChoiceViewController ()
@property (strong, nonatomic) IBOutlet UIButton *browseChicagoButton;
@property (strong, nonatomic) IBOutlet UIButton *conciergeButton;

@end

@implementation ChoiceViewController

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
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Section2"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.browseChicagoButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self.browseChicagoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.browseChicagoButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:22];
    
    [self.conciergeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.conciergeButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    self.conciergeButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:22];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}




@end
