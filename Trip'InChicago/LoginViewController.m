//
//  LoginViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
//#import "ChoiceViewController.h"
#import "SignUpViewController.h"
@interface LoginViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation LoginViewController

//-(instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        self.fields = PFLogInFieldsFacebook| PFLogInFieldsUsernameAndPassword|PFLogInFieldsLogInButton|PFLogInFieldsSignUpButton;
//        self.delegate = self;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PFFacebookUtils initializeFacebook];
    [self.navigationController setNavigationBarHidden:YES];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBackgroundWithLogo"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setBackgroundColor:[UIColor colorWithRed:0.52f green:0.51f blue:0.52f alpha:0.8f]];
    
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.58f alpha:0.8f]];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setBackgroundColor:[UIColor colorWithRed:0.07f green:0.48f blue:0.07f alpha:0.8f]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *permissionArray = @[@"user_about_me",@"user_relationships", @"user_birthday", @"user_location"];
    
    [self setFacebookPermissions:permissionArray];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{

    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"showChoiceViewController" sender:user];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
