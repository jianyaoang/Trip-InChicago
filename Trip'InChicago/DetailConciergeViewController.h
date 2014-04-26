//
//  DetailConciergeViewController.h
//  Trip'InChicago
//
//  Created by Marion Ano on 4/25/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConciergeViewController.h"

@interface DetailConciergeViewController : UIViewController
@property (strong,nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *distancefromUser;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *distanceTextField;
@end
