//
//  NotesViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/22/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "NotesViewController.h"
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>


@interface NotesViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *notesTableView;
@property (strong, nonatomic) IBOutlet UIView *notesViewSection;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) NSMutableArray *notesMutableArray;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundHelpImage;
@end

@implementation NotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayHelpScreen];

    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Notes"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    self.notesTextView.delegate = self;
    self.notesTableView.backgroundColor = [UIColor clearColor];
    
    self.notesViewSection.backgroundColor = [UIColor colorWithRed:1.02f green:1.02f blue:1.04f alpha:1];

    self.notesTextView.layer.cornerRadius = 10;
    self.notesLabel.layer.cornerRadius = 10;
    
    [self.dismissButton setBackgroundColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.58f alpha:0.7f]];
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dismissButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:22];
    
    [self.notesViewSection setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    self.notesMutableArray = [NSMutableArray new];

    self.notesTextView.layer.cornerRadius = 10;
    self.notesTextView.layer.masksToBounds = YES;
    
    PFQuery *queryNotes = [PFQuery queryWithClassName:@"Notes"];
//    [queryNotes whereKey:@"location" containsString:self.location.name];

    [queryNotes whereKey:@"location" equalTo:self.location.name];
    [queryNotes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            [self.notesMutableArray addObjectsFromArray:objects];
            NSLog(@"%@", self.notesMutableArray);
        }
        else
        {
            NSLog(@"%@ %@", error , [error userInfo]);
        }
        [self.notesTableView reloadData];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notesMutableArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotesCellID"];
    
    PFObject *comment = self.notesMutableArray[indexPath.row];
    [cell.textLabel setText:[comment objectForKey:@"notes"]];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.65];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *comment = self.notesMutableArray[indexPath.row];
    NSString *notes = [comment objectForKey:@"notes"];
    CGFloat width = 320;
    UIFont *font = [UIFont systemFontOfSize:19];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:notes attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    rect = CGRectInset(rect, -20, -20);
    CGSize size = rect.size;
    return size.height;
}

- (IBAction)onWriteNoteButtonPressed:(id)sender
{
    if (self.notesTextView.text.length > 0)
    {
        PFObject *comment = [PFObject objectWithClassName:@"Notes"];
        comment[@"notes"] = self.notesTextView.text;
        //    comment[@"location"] = self.location.name;
        [comment setObject:self.location.name forKey:@"location"];
        [self.notesTextView resignFirstResponder];
        self.notesTextView.text = @"";
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.notesMutableArray addObject:comment];
            [self.notesTableView reloadData];
        }];
    }    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *cellText = cell.textLabel.text;

        // Email Subject
        NSString *emailTitle = @"Trip In Chicago - Report Email";
        // Email Content

        NSString *messageBody = [NSString stringWithFormat:@"This row is being reported --> %@", cellText];
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"tripinchicagodev@gmail.com"];

        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];

        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Report comment";
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.notesLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.notesLabel.hidden = ([self.notesTextView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.notesLabel.hidden = ([self.notesTextView.text length] > 0);
}
- (IBAction)onCancelButtonPressed:(id)sender
{
    // Dismiss the help screen
    self.backgroundHelpImage.alpha = 0.0;
    self.dismissButton.alpha   = 0.0;

    self.navigationController.navigationBar.hidden = NO;
}

-(void)displayHelpScreen
{

    self.backgroundHelpImage.contentMode = UIViewContentModeScaleAspectFit;

    // If user defaults exist make the help screen transparent .. .. .
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"FirstTimeForNotes"] != nil)
    {

        self.backgroundHelpImage.alpha = 0.0;
        self.dismissButton.alpha       = 0.0;

        self.navigationController.navigationBar.hidden = NO;
    }
    else
    {
        // user defaults do not exist - overlay the screen with help screen.
        NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setInteger:1 forKey:@"FirstTimeForNotes"];


        self.backgroundHelpImage.alpha = 0.90;
        self.dismissButton.alpha       = 0.90;

//        self.navigationController.navigationBar.alpha = .25;
//        self.navigationController.navigationBar.hidden = YES;

    }
}


@end
