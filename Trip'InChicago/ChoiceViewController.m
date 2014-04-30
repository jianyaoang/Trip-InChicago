//
//  ChoiceViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/22/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "ChoiceViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
@interface ChoiceViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *browseChicagoButton;
@property (strong, nonatomic) IBOutlet UIButton *conciergeButton;

@end

@implementation ChoiceViewController


//-(instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        self.fields = PFLogInFieldsFacebook| PFLogInFieldsUsernameAndPassword|PFLogInFieldsLogInButton|PFLogInFieldsSignUpButton;
//        self.delegate = self;
//    }
//    return self;
//}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Section2"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];

    [self.browseChicagoButton setBackgroundColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.58f alpha:0.7f]];
    
    [self.browseChicagoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.browseChicagoButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:22];
    
    [self.conciergeButton setBackgroundColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.58f alpha:0.7f]];
    [self.conciergeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.conciergeButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:22];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.delegate = self;
        SignUpViewController *signUp = [[SignUpViewController alloc] init];
        signUp.delegate = self;
        [loginVC setSignUpController:signUp];
        [loginVC setFields:PFLogInFieldsFacebook| PFLogInFieldsUsernameAndPassword|PFLogInFieldsLogInButton|PFLogInFieldsSignUpButton];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}




@end
