//
//  ChoiceViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/22/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "ChoiceViewController.h"

@interface ChoiceViewController ()

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
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SectionViewController"]];
    [self.view addSubview:backgroundImage];
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
