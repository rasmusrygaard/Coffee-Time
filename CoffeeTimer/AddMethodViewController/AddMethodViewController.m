//
//  AddMethodViewController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AddMethodViewController.h"
#import "Constants.h"

@implementation AddMethodViewController

@synthesize amCell;

-(id)init
{
    [super initWithStyle:UITableViewStyleGrouped];
    
    basicInfo = [[NSMutableDictionary alloc] init];
    
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

/* Function: - (UIImageView *)imageForCellAtIndexPath:(NSIndexPath *)indexPath
 * Get the cell images based on the cell's placement in the table. Make sure that
 * top and bottom cells have rounded corners. 
 */

- (UIImageView *)imageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *img;
    
    if (indexPath.row == 0) { // Top cell
        
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedTop.png"]];
        
    } else if ((indexPath.section == 0 && indexPath.row == ADD_METHOD_UPPER_ROWS - 1) ||
               (indexPath.section == 1 && indexPath.row == ADD_METHOD_LOWER_ROWS - 1)) {
        
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedBottom.png"]];
        
    } else { // Remaining Cells
        
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell.png"]];
        
    }
    
    return [img autorelease];
}

/* Function: - (void)setTextForCell:(UITableViewCell *)cell
 *                      atIndexPath:(NSIndexPath *)indexPath
 * Get the header and sample text for the cells in the upper rows. If
 * the user has already entered text in the field, fetch it from the
 * dictionary. Otherwise, set the placeholder text.
 */

- (void)setTextForCell:(UITableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UITextField *tf = (UITextField *)[cell viewWithTag:2];
    
    NSString *text, *textField;
        
    switch (indexPath.row) {
        case 0:
            text = @"Name";
            label.font = [UIFont systemFontOfSize:22];
            tf.font = [UIFont systemFontOfSize:22];
            break;
        case 1:
            text = @"Equipment"; break;
        case 2:
            text = @"Coffee"; break;
        case 3:
            text = @"Water"; break;
        default:
            break;
    }
    
    // Give tags in ascending order
    tf.tag = MAX_TEXTFIELD_TAG - ADD_METHOD_UPPER_ROWS + indexPath.row;
    
    textField = [basicInfo objectForKey:text]; // Get existing text
    if (textField == nil) {                    // Otherwise initialize it
        switch (indexPath.row) {
            case 0:
                textField = @"My Aeropress"; break;
            case 1:
                textField = @"Aeropress"; break;
            case 2:
                textField = @"26 g"; break;
            case 3:
                textField = @"300 g"; break;
            default:
                break;
        }
        tf.placeholder = textField;
    } else {
        tf.text = textField;
    }
    
    label.tag = tf.tag + 10;
    label.text = text;
    
    tf.adjustsFontSizeToFitWidth = YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] init];
        
        [[NSBundle mainBundle] loadNibNamed:@"AddMethodTableViewCell" 
                                      owner:self 
                                    options:nil];
        cell = amCell;
        self.amCell = nil;
        
        [self setTextForCell:cell 
                 atIndexPath:indexPath];
    } else { // Initialize lower cells
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"DefaultCell"];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Instructions";
        } else {
            cell.textLabel.text = @"Preparation";
        }
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.shadowColor = [UIColor lightTextColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *img = [self imageForCellAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:img];

    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ADD_METHOD_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    if (section == ADD_METHOD_SECTIONS - 1) {
        return ADD_METHOD_LOWER_ROWS;
    } else {
        return ADD_METHOD_UPPER_ROWS;
    }
}

#pragma mark - UITextField protocol

- (void)textFieldDidEndEditing:(UITextField *)textField;   
{
    int tag = textField.tag;
    UILabel *label = (UILabel *)[self.view viewWithTag:(tag + 10)];
    
    if (![label.text isEqualToString:@""]) {
        [basicInfo setValue:textField.text forKey:label.text];
    }
}

/* - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
 * Have the last cell in the upper section display a "Done" key
 */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == MAX_TEXTFIELD_TAG - 1) {
        textField.returnKeyType = UIReturnKeyDone;
    } else {
        textField.returnKeyType = UIReturnKeyNext;
    }
    return YES;
}

/* Function: - (BOOL)textFieldShouldReturn:(UITextField *)textField
 * Have the return key move to the next text field unless we are
 * at the very last one. Tags for the cells are in ascending order,
 * so the next cell has a tag that is one greater than the currenty
 * cell.
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int nextTag = textField.tag + 1;
    [textField resignFirstResponder];
    
    if (nextTag < MAX_TEXTFIELD_TAG) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:nextTag];
        [tf becomeFirstResponder];
    }
    
    return YES;
}

/* Function: -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
 *                                                                 replacementString:(NSString *)string
 * Make sure we never exceed the bounds of the text field.
 */

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
                                                      replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByAppendingString:string];
    CGSize textSize = [newString sizeWithFont:[textField font]];
    
    return textSize.width < TEXTFIELD_MAX_WIDTH;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SimpleMatteBackground.png"]];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = background;
    
    self.tableView.bounces = FALSE;
    
    self.navigationItem.title = @"Add Method";
    self.navigationItem.backBarButtonItem.title = @"Methods";
    
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

- (void)dealloc
{
    [basicInfo release];
    basicInfo = nil;
    
    [super dealloc];
}

@end
