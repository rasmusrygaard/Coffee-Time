//
//  AddDetailViewController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 17/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddDetailViewController.h"
#import "BrewMethodViewController.h"
#import "TimerStep.h"

@implementation AddDetailViewController

@synthesize detailType, data, detailCell;

#define TIME_TAG 1
#define DESCRIPTION_TAG 2

- (id)init
{
    [super initWithStyle:UITableViewStyleGrouped];
    
    [self.tableView setEditing:YES];
    data = [[NSMutableArray alloc] init];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    if (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.row] - 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"Add New %@...", [self.navigationItem title]];
    } else {
        cell = [[UITableViewCell alloc] init];
        
        [[NSBundle mainBundle] loadNibNamed:@"AddInstructionsCell" 
                                      owner:self 
                                    options:nil];
        cell = detailCell;
        self.detailCell = nil;    
    
        /*
        TimerStep *t = [data objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", t.description, [TimerStep formattedTimeInSecondsForInterval:t.timeInSeconds]];*/
    }
    
    return cell;	
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [data count] + 1;
}

#pragma Mark Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) {

        return UITableViewCellEditingStyleInsert;

    } else {
    
        return UITableViewCellEditingStyleDelete;

    }
}

-  (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {

        TimerStep *t = [[TimerStep alloc] initWithDescription:@"A timer step" timeInSeconds:30];
        [data addObject:t];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationLeft];

    } else if (editingStyle == UITableViewCellEditingStyleDelete) {

        [data removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                              withRowAnimation:YES];

    }
}

#pragma mark UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string
{
    BOOL shouldAllow = YES;
    if (textField.tag == TIME_TAG) {

        if (textField.text.length == 2) {
            
            textField.text = [NSString stringWithFormat:@"%@:", textField.text];
            
        } else if (textField.text.length == 3) {
            
            textField.text = [textField.text substringToIndex:2]; // Truncate ':'
            
        }
        
        // Only allow strings of format "mm:ss"
        shouldAllow = (textField.text.length + string.length <= 5);
    }
    
    return shouldAllow;
}

/* - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
 * Only allow the time field to return if we have a full format string, ie. mm:ss
 */

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == TIME_TAG) NSLog(@"Time in seconds: %d", [TimerStep timeInSecondsForFormattedInterval:textField.text]);
    return (textField.tag == DESCRIPTION_TAG ||
            textField.text.length == 5);
}

@end
