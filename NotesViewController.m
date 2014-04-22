//
//  NotesViewController.m
//  Trip'InChicago
//
//  Created by Jian Yao Ang on 4/22/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "NotesViewController.h"
#import <Parse/Parse.h>


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
    self.notesMutableArray = [NSMutableArray new];
    
    PFQuery *queryNotes = [PFQuery queryWithClassName:@"Notes"];
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
    cell.textLabel.text = [comment objectForKey:@"notes"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:19];
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
    [self.notesTextView resignFirstResponder];
    self.notesTextView.text = @"";
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.notesMutableArray addObject:comment];
        [self.notesTableView reloadData];
    }];
}
@end