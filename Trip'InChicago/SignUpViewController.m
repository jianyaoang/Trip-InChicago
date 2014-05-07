//
//  SignUpViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/29/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "SignUpViewController.h"
//#import "ChoiceViewController.h"
@interface SignUpViewController () <PFSignUpViewControllerDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBackgroundWithLogo"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setBackgroundColor:[UIColor colorWithRed:0.07f green:0.48f blue:0.07f alpha:0.8f]];
    self.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
}

@end
