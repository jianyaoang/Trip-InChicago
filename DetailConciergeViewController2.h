//
//  DetailConciergeViewController2.h
//  Trip'InChicago
//
//  Created by Jaime Hernandez on 4/26/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
@interface DetailConciergeViewController2 : UIViewController


@property NSString *distance;
@property NSString *phoneNumber;
@property NSString *address;
@property Location *location;

@property CLLocation *myLocation;

@property (weak, nonatomic) IBOutlet UITextView  *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;

@property (strong, nonatomic) IBOutlet UIButton *callNumberButton;


@end
