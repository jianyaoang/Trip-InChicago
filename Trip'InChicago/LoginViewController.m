//
//  LoginViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/14/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "ChoiceViewController.h"
#import "SignUpViewController.h"
@interface LoginViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation LoginViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.fields = PFLogInFieldsFacebook| PFLogInFieldsUsernameAndPassword|PFLogInFieldsLogInButton|PFLogInFieldsSignUpButton;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.signUpController = [SignUpViewController new];
    [PFFacebookUtils initializeFacebook];
    [self.navigationController setNavigationBarHidden:YES];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBackground"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
//    CALayer *layer = self.logInView.usernameField.layer;
//    layer.shadowOpacity = 0.0;
//    layer = self.logInView.passwordField.layer;
//    layer.shadowOpacity = 0.0;
    

//    [self.logInView.usernameField setBackground:[UIImage imageNamed:@""]];
//    [self.logInView.usernameField setBackgroundColor:[UIColor colorWithRed:0.52f green:0.52f blue:0.52f alpha:0.8f]];
    
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setBackgroundColor:[UIColor colorWithRed:0.52f green:0.51f blue:0.52f alpha:0.8f]];
    
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.58f alpha:0.8f]];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setBackgroundColor:[UIColor colorWithRed:0.07f green:0.48f blue:0.07f alpha:0.8f]];
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
//   self.logInView.usernameField.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    self.logInView.passwordField.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    
    ChoiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiceViewController"];
    if ([PFUser currentUser] || [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *permissionArray = @[@"user_about_me",@"user_relationships", @"user_birthday", @"user_location"];
    
    [self setFacebookPermissions:permissionArray];
//    PFLogInViewController *login = [PFLogInViewController new];
//    login.fields = PFLogInFieldsUsernameAndPassword|PFLogInFieldsLogInButton|PFLogInFieldsFacebook| PFLogInFieldsSignUpButton;
//    [login setFacebookPermissions:permissionArray];
//    login.signUpController.delegate = self;
//    login.delegate = self;
//    [self presentViewController:login animated:NO completion:nil];
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

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"showChoiceViewController" sender:user];
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
