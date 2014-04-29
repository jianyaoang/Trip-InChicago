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


@interface NotesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *notesTableView;
@property (strong, nonatomic) IBOutlet UIView *notesViewSection;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) NSMutableArray *notesMutableArray;
@end

@implementation NotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Notes"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    self.notesTableView.backgroundColor = [UIColor clearColor];
//    [self.notesTextView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [self.notesViewSection setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    self.notesMutableArray = [NSMutableArray new];
    
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
//    cell.textLabel.text = [comment objectForKey:@"notes"];
    [cell.textLabel setText:[comment objectForKey:@"notes"]];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:19];
//    cell.textLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:19];
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

@end
