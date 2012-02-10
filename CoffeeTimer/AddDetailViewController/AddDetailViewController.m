//
//  AddDetailViewController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 17/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddDetailViewController.h"
#import "AddMethodViewController.h"
#import "BrewMethodViewController.h"
#import "TimerStep.h"

@implementation AddDetailViewController

@synthesize detailType, data, detailCell, wantsToLeaveView;

#define TIME_TAG 1
#define DESCRIPTION_TAG 2

- (id)init
{
    [super initWithStyle:UITableViewStyleGrouped];
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.wantsToLeaveView = YES;
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wantsToLeaveView = YES;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    BOOL isDummyElem = NO;
    
    for (int i = [data count] - 1; i >= 0; --i) {
        if ([self.detailType isEqualToString:@"Instructions"]) {
            TimerStep *t = [data objectAtIndex:i];
            
            isDummyElem = [t.descriptionWithoutTime isEqualToString:@""] && t.timeInSeconds == 0;
        } else {
            isDummyElem = [[data objectAtIndex:i] isEqualToString:@""];
        }
        
        if (isDummyElem) {
            [data removeObjectAtIndex:i];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SimpleMatteBackground.png"]];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = background;
    
    [background release];
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

/* Function: - (UIImageView *)imageForCellAtIndexPath:(NSIndexPath *)indexPath
 * Get the cell images based on the cell's placement in the table. Make sure that
 * top and bottom cells have rounded corners and that  
 */

- (UIImageView *)imageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *img;
    
    int rowsInSection = [self.tableView numberOfRowsInSection:indexPath.section];
    
    if (rowsInSection == 1) { // Top/bottom cell
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedTopBottom.png"]]; 
    } else {
        if (indexPath.row == 0) {
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedTop.png"]];
        } else if (indexPath.row == rowsInSection - 1) {
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedBottom.png"]];
        } else {
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell.png"]];
        }
    }
    
    return [img autorelease];
}

/* Function: - (void)setUpAccessibilityForCell:(UITableViewCell *)cell 
 atIndexPath:(NSIndexPath *)indexPath
 * Set up the accessibility labels and hints for the cell ad indexPath. Use the indexPath to 
 * generate dynamic content (ie. "Step 1: Time"). Make this a bit smarter eventually.
 */

- (void)setUpAccessibilityForCell:(UITableViewCell *)cell 
                      atIndexPath:(NSIndexPath *)indexPath
{
    UITextField *tf;
    // Have the indexes start at 1
    int stepNum = indexPath.row + 1;
    
    if ([self.detailType isEqualToString:@"Instructions"]) {
        
        tf = (UITextField *)[cell viewWithTag:DESCRIPTION_TAG];
        
        tf.isAccessibilityElement   = YES;
        tf.accessibilityLabel       = [NSString stringWithFormat:@"Instruction %d: Description", stepNum];
        tf.accessibilityHint        = [NSString stringWithFormat:@"The description for step %d", stepNum];
        
        tf = (UITextField *)[cell viewWithTag:TIME_TAG];
        
        tf.isAccessibilityElement   = YES;
        tf.accessibilityLabel       = [NSString stringWithFormat:@"Instruction %d: Time", stepNum];
        tf.accessibilityHint        = [NSString stringWithFormat:@"The duration of step %d", stepNum];


    } else if ([self.detailType isEqualToString:@"Preparation"]) {
        
        tf = (UITextField *)[cell viewWithTag:DESCRIPTION_TAG];
        
        tf.isAccessibilityElement   = YES;
        tf.accessibilityLabel       = [NSString stringWithFormat:@"Preparation %d", stepNum];
    }
}

/* Function: - (UITableViewCell *)loadCellLayout
 * Load the cell layout from the corresponding nib file. For now, this method assumes
 * that the only instructions and preparation steps will be stored in this class' data
 * array. This will tell us which nib to load, but there is no sensible default nib
 * to load if the type of data doesn't match. The error handling could and should be
 * more graceful for this.
 */

- (UITableViewCell *)loadCellLayoutForCell:(UITableViewCell *)cell
{
    NSString *nibToLoad;
    
    if ([self.detailType isEqualToString:@"Instructions"]) {
        
        nibToLoad = @"AddInstructionsCell";
        
    } else if ([self.detailType isEqualToString:@"Preparation"]) {
        
        nibToLoad = @"AddPreparationCell";
        
    } else { // Default to open preparation cell but log the error.
        
        nibToLoad = @"AddPreparationCell";
        NSLog(@"Invalid detail type for AddDetailViewController class");
    }
    
    [[NSBundle mainBundle] loadNibNamed:nibToLoad
                                  owner:self 
                                options:nil];
    
    cell = detailCell;
    self.detailCell = nil;

    return cell;
}

/* Function: - (void)loadCellData:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
 * Populate the cell at indexPath with the corresponding data from this class'
 * instance variable array. Note that this method assumes that data will either
 * be TimerStep objects (for instructions) or NSString* (for preparation).
 */

- (void)loadCellData:(UITableViewCell *)cell 
         atIndexPath:(NSIndexPath *)indexPath 
            withData:(NSArray *)dataArray
{
    UITextField *tf;
    
    if ([self.detailType isEqualToString:@"Instructions"]) {
        
        TimerStep *t = [dataArray objectAtIndex:indexPath.row];
        
        if (t.timeInSeconds != 0) {
            tf      = (UITextField *)[cell viewWithTag:DESCRIPTION_TAG];
            tf.text = [t descriptionWithoutTime];
            
            tf      = (UITextField *)[cell viewWithTag:TIME_TAG];
            tf.text = [TimerStep formattedTimeInSecondsForInterval:[t timeInSeconds]];
        }
        
    } else {
        tf      = (UITextField *)[cell viewWithTag:DESCRIPTION_TAG];
        tf.text =  [dataArray objectAtIndex:indexPath.row];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;        
    if (indexPath.row == [self.tableView numberOfRowsInSection:indexPath.section] - 1) {
        
        /*
         * "Add New Instructions..." cell
         */
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                          reuseIdentifier:@"UITableViewCell"];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Add New %@...", [self.navigationItem title]];
        
        cell.textLabel.textColor    = [UIColor darkGrayColor];
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
        
        /* Accessibility */
        cell.accessibilityLabel = [NSString stringWithFormat:@"Add %@", [self.navigationItem title]];
        cell.isAccessibilityElement = YES;
        
    } else {
        
        cell = [self loadCellLayoutForCell:cell];
        
        [self loadCellData:cell 
               atIndexPath:indexPath 
                  withData:data];
        
        [self setUpAccessibilityForCell:cell 
                            atIndexPath:indexPath];
    }

    UIImageView *img = [self imageForCellAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:img];
    
    /* Accessibility */
    cell.isAccessibilityElement = NO;
    
    return cell;	
}

/* Function: - (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
 * Display everything in the data array plus a row to add new data.
 */

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [data count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ADD_DETAIL_SECTIONS;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int numRows = [self.tableView numberOfRowsInSection:0];
    
    if (indexPath.section == 0 &&
        indexPath.row == numRows - 1) {
     
        [self tableView:self.tableView 
     commitEditingStyle:UITableViewCellEditingStyleInsert 
      forRowAtIndexPath:[NSIndexPath indexPathForRow:(numRows - 1) inSection:0]];
        
    }
    if (indexPath.section == 1) {
        if ([self.detailType isEqualToString:@"Instructions"]) {
            for (TimerStep *t in data) {
                NSLog(@"Step: %@", t);        
            }
        } else {
            for (NSString *prep in data) {
                NSLog(@"Preparation: %@", prep);
            }
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

/* Function: - (void)updateTopBottomCellBackground
 * Update the images on the top and bottom cells in the tableview to make sure that
 * the rounded corners show up correctly on the top and bottom cells. 
 */

- (void)updateTopBottomCellBackground
{
    NSIndexPath *ip = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1) 
                                         inSection:0];
    [[self.tableView cellForRowAtIndexPath:ip] setBackgroundView:[self imageForCellAtIndexPath:ip]];
    ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self.tableView cellForRowAtIndexPath:ip] setBackgroundView:[self imageForCellAtIndexPath:ip]];
}

/* 
 * Handle editing of the tableView. Add a new TimerStep when inserting, remove when deleting
 */

-  (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {

        int newFirstResponderTag;
        id toAdd;

        if ([self.detailType isEqualToString:@"Instructions"]) {
            toAdd = [[TimerStep alloc] init];
            newFirstResponderTag = TIME_TAG;
        } else {
            toAdd = @"";
            newFirstResponderTag = DESCRIPTION_TAG;
        }
        
        [data addObject:toAdd];
        
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [[cell viewWithTag:newFirstResponderTag] becomeFirstResponder];
        
        [self updateTopBottomCellBackground];

    } else if (editingStyle == UITableViewCellEditingStyleDelete) {

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[cell viewWithTag:1] resignFirstResponder];

        [data removeObjectAtIndex:indexPath.row];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        [self updateTopBottomCellBackground];
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

/* Function: - (BOOL)shouldAllowText:(NSString *)string inTextField:(UITextField *)textField
 * This method makes sure that the user can only enter valid text in the time interval UITextField.
 * Valid text is anything that matches the "mm:ss" format string. To allow input through a number
 * pad, this method automatically adds and removes the ':' separating minutes and seconds.
 * Furthermore, the length of the input is restricted to 5 characters (ie. the length of "mm:ss"
 */

- (BOOL)shouldAllowText:(NSString *)string 
            inTextField:(UITextField *)textField
{
    BOOL shouldAllow = YES;
    if (textField.tag == TIME_TAG) {
        
        if (textField.text.length == 2) { // Append ':'
            
            textField.text = [NSString stringWithFormat:@"%@:", textField.text];
            
        } else if (textField.text.length == 3 &&
                   [string isEqualToString:@""]) { // Truncate ':' iff user is deleting
            
            textField.text = [textField.text substringToIndex:2];
            
        }
        
        if (textField.text.length == 3 && [string characterAtIndex:0] >= '6') {
            return NO;
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

/* Function: - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
             replacementString:(NSString *)string
 * Verify that the 
 */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string
{
    
    return [self shouldAllowText:string 
                     inTextField:textField];
}

/* Function: - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
 * Only allow the time field to return if we have a full format string, ie. mm:ss
 */

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0 &&
        indexPath.row >= [self.tableView numberOfRowsInSection:0] - 1) {
        // Catch the case where the user deletes 
        return YES;
    }
    
    if ([self.detailType isEqualToString:@"Instructions"]) {
        if (textField.tag == TIME_TAG &&
            textField.text.length < 4) { // Convert to a sensible integer value
            textField.text = @"";
            return YES;
        }
        
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
    } else {
        NSString *text = textField.text;
        if (![text isEqualToString:@""]) {
            [data replaceObjectAtIndex:indexPath.row withObject:textField.text];
        }
        return YES;
    }
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

/* Function: - (BOOL)hasDummyCells:(UITableView *)tableView
 * This function iterates over the internal data array of this class and returns
 * true if all fields are filled out.
 */

- (BOOL)hasDummyCells:(UITableView *)tableView
{
    for (int i = [data count] - 1; i >= 0; --i) {
        if ([self.detailType isEqualToString:@"Instructions"]) {
            TimerStep *t = [data objectAtIndex:i];
            
            if ([t.descriptionWithoutTime isEqualToString:@""] || t.timeInSeconds == 0) {
                return YES;
            }
        } else {
            if ([[data objectAtIndex:i] isEqualToString:@""]) {
                return YES;
            }
        }
    }
    
    return NO;
}

/* Function: - (IBAction)checkData:(id)sender
 * This function makes sure that the user is aware that leaving the View means
 * deleting any incomplete cells. If the tableView has half-filled or emtpy cells
 * this method displays a UIAlertView, warning the user that those cells will be
 * lost if the user returns.
 * This method uses the instance variable wantsToLeaveView to determine whether
 * the user really wants to leave. This variable should be set to true only if
 * the user hits the cancel button on the UIAlertView.
 */

- (IBAction)checkData:(id)sender
{
    if (!self.wantsToLeaveView && 
        [self hasDummyCells:self.tableView]) { // Still dummy cells 
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cancel?" 
                                                     message:@"It looks like some of your steps are missing times or descriptions. Are you sure you want to quit adding the method? This would delete all incomplete steps." 
                                                    delegate:self
                                           cancelButtonTitle:@"Yes, cancel"
                                           otherButtonTitles:@"No, I'll stay", nil];
            [av show];
            [av release];
    } else {
         [self.navigationController popViewControllerAnimated:YES];
    }
}

/* Function: -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 * This function is called after the user taps one of the buttons on the UIAlertView
 * presented by checkData:(id)sender. It sets the wantsToLeaveView instance variable
 * to true iff the user clicks the cancel button at index 0 and calls checkData: if
 * the user does so.
 */

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((self.wantsToLeaveView = (buttonIndex == 0))) { 
        [self checkData:nil];
    }
}

- (void)dealloc {
    [data release];
    data = nil;
    
    [super dealloc];
}

@end
