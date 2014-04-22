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
@interface LoginViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PFFacebookUtils initializeFacebook];
    
    ChoiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChoiceViewController"];
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self.navigationController pushViewController:vc animated:NO];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *permissionArray = @[@"user_about_me",@"user_relationships", @"user_birthday", @"user_location"];
    
    PFLogInViewController *login = [PFLogInViewController new];
    login.fields = PFLogInFieldsUsernameAndPassword|PFLogInFieldsLogInButton|PFLogInFieldsFacebook| PFLogInFieldsSignUpButton;
    [login setFacebookPermissions:permissionArray];
    login.signUpController.delegate = self;
    login.delegate = self;
    [self presentViewController:login animated:NO completion:nil];
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
