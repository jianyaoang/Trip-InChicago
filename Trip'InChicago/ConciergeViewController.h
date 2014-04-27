//
//  ConciergeViewController.h
//  Trip'InChicago
//
//  Created by Marion Ano on 4/21/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConciergeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property NSString *sectionString;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UILabel *ratingTextLabel;


@end
