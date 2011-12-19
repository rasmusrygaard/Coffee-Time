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
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
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
    UITableViewCell *cell;
    if (indexPath.section == 0) {
       
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:@"UITableViewCell"];
        }
        
        if (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"Add New %@...", [self.navigationItem title]];
        } else {
            cell = [[UITableViewCell alloc] init];
            
            [[NSBundle mainBundle] loadNibNamed:@"AddInstructionsCell" 
                                          owner:self 
                                        options:nil];
            cell = detailCell;
            self.detailCell = nil;    
            
            
            TimerStep *t = [data objectAtIndex:indexPath.row];

            if (t.timeInSeconds != 0) {
                UITextField *tf = (UITextField *)[cell viewWithTag:2]; // Time
                tf.text = [t descriptionWithoutTime];
                
                tf = (UITextField *)[cell viewWithTag:2];
                tf.text = [TimerStep formattedTimeInSecondsForInterval:[t timeInSeconds]];
            }
        }
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"DefaultCell"];
        }
        
        cell.textLabel.text = @"Save";
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.shadowColor = [UIColor lightTextColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
        cell.textLabel.textAlignment = UITextAlignmentCenter;

    }
    
    
    return cell;	
}

/* Function: - (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
 * The number of rows is either 1 (in the case of the "Save" button section) or 
 * however many steps are currently shown/stored in the data array + an additional
 * row to allow for editing.
 */

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? [data count] + 1 : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ADD_DETAIL_SECTIONS;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        for (TimerStep *t in data) {
            NSLog(@"Step: %@", t);
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

/* 
 * Handle editing of the tableView. Add a new TimerStep when inserting, remove when deleting
 */

-  (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {

        TimerStep *t = [[TimerStep alloc] init];
        [data addObject:t];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationRight];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[cell viewWithTag:1] becomeFirstResponder];

    } else if (editingStyle == UITableViewCellEditingStyleDelete) {

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[cell viewWithTag:1] resignFirstResponder];
        [data removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationRight];

    }
}

/* Function: - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 * Disallow editing of the "Save" button.
 */

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0);
}

#pragma mark UITextFieldDelegate

/* Function: - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
             replacementString:(NSString *)string
 * This method makes sure that the user can only enter valid text in the time interval UITextField.
 * Valid text is anything that matches the "mm:ss" format string. To allow input through a number
 * pad, this method automatically adds and removes the ':' separating minutes and seconds.
 * Furthermore, the length of the input is restricted to 5 characters (ie. the length of "mm:ss"
 */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string
{
    BOOL shouldAllow = YES;
    if (textField.tag == TIME_TAG) {

        if (textField.text.length == 2) { // Append ':'
            
            textField.text = [NSString stringWithFormat:@"%@:", textField.text];
            
        } else if (textField.text.length == 3 &&
                   [string isEqualToString:@""]) { // Truncate ':' iff user is deleting
            
            textField.text = [textField.text substringToIndex:2];
            
        }
        
        int len = textField.text.length + string.length;
        
        // Only allow strings of format "mm:ss"
        shouldAllow = (len <= 5);

        // Auto-advance to description field if the user has entered a valid time interval
        // and is not deleting. A bit of a hack since the text is appended yet returns NO.
        if (len == 5 && 
            ![string isEqualToString:@""]) {

            [textField resignFirstResponder];
            textField.text = [textField.text stringByAppendingString:string];
            
            UITableViewCell *cell = (UITableViewCell *)[textField superview];
            UITextField *tf = (UITextField *)[cell viewWithTag:2];
            [tf becomeFirstResponder];
            
            // Make sure we don't append twice
            shouldAllow = NO;
        }
    }
    
    return shouldAllow;
}

/* Function: - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
 * Only allow the time field to return if we have a full format string, ie. mm:ss
 */

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // Only update data source if we aren't removing an empty cell
    if (![textField.text isEqualToString:@""]) {
        TimerStep *t = [data objectAtIndex:indexPath.row];
        if (textField.tag == DESCRIPTION_TAG) {
            t.stepDescription = textField.text;
        } else {
            t.timeInSeconds = [TimerStep timeInSecondsForFormattedInterval:textField.text];
        }
    }
    
    return (textField.tag == DESCRIPTION_TAG ||
            textField.text.length == 5);
}

/* Function: - (BOOL)textFieldShouldReturn:(UITextField *)textField
 * Save the information in the UITextFields if the user hits the return key.
 * Grab the text from the two fields and store them appropriately in the data array.
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[textField superview];
    UITextField *timeField = (UITextField *)[cell viewWithTag:1];

    if (textField.tag == DESCRIPTION_TAG && 
        ![timeField.text isEqualToString:@""]) {

        [textField resignFirstResponder];
        
    } else if (textField.tag == TIME_TAG) {
        
        if (textField.text.length != 5) {
            textField.text = @"";
        }
    }
    
    return YES;
}

- (void)dealloc {
    [data release];
    data = nil;
    
    [super dealloc];
}

@end
