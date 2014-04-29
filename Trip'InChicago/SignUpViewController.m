//
//  SignUpViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/29/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "SignUpViewController.h"
#import "ChoiceViewController.h"
@interface SignUpViewController () <PFSignUpViewControllerDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBackground"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setBackgroundColor:[UIColor colorWithRed:0.07f green:0.48f blue:0.07f alpha:0.8f]];
    
    ChoiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiceViewController"];
    if ([PFUser currentUser])
    {
        [self.navigationController pushViewController:vc animated:NO];
    }
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self performSegueWithIdentifier:@"showChoiceViewControllerFromSignUp" sender:user];
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
