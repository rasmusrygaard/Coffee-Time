//
//  AddMethodViewController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "AddMethodViewController.h"

@implementation AddMethodViewController

@synthesize amCell, adVC, nameField, equipmentField, coffeeField, waterField;

-(id)init
{
    [super initWithStyle:UITableViewStyleGrouped];
    
    basicInfo = [[NSMutableDictionary alloc] init];
    instructions = [[NSMutableArray alloc] init];
    preparation = [[NSMutableArray alloc] init];
    
    self.tableView.isAccessibilityElement = NO;
    self.tableView.scrollEnabled = NO;
    
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

#pragma mark - Custom back button

- (IBAction)checkData:(id)sender
{    
    [self.navigationController popViewControllerAnimated:YES];
}

/* Function: - (BOOL)hasCompleteBrewMethod
 * Returns true iff the view controller contains sufficient information about a
 * complete method. This means that at least one instruction and preparation step
 * exist and that all the data in this view has been filled (ie. Name, Equipment, 
 * Coffee, and Water).
 */

- (BOOL)hasCompleteBrewMethod
{
    NSString *name, *equipment, *coffee, *water;
    NSLog(@"nf: '%@', eF: '%@', cF: '%@', wF: '%@' in: %d p: %d", nameField.text, equipmentField.text, coffeeField.text, waterField.text, instructions.count, preparation.count);
    if (![(name      = nameField.text)      isEqualToString:@""] &&
        ![(equipment = equipmentField.text) isEqualToString:@""] &&
        ![(coffee    = coffeeField.text)    isEqualToString:@""] &&
        ![(water     = waterField.text)     isEqualToString:@""]) {
        
        [basicInfo setObject:name       forKey:@"Name"];
        [basicInfo setObject:equipment  forKey:@"Equipment"];
        [basicInfo setObject:coffee     forKey:@"Coffee"];
        [basicInfo setObject:water      forKey:@"Water"];
        
        return ([instructions count] > 0 && [preparation count] > 0);
    }
    
    return NO;
}

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
            self.nameField = tf;
            break;
        case 1:
            text = @"Equipment"; 
            self.equipmentField = tf;
            break;
        case 2:
            text = @"Coffee"; 
            self.coffeeField = tf;
            break;
        case 3:
            text = @"Water";
            self.waterField = tf;
            break;
        default:
            break;
    }
    
    // Give tags in ascending order
    tf.tag = MAX_TEXTFIELD_TAG - ADD_METHOD_UPPER_ROWS + indexPath.row;
    tf.isAccessibilityElement   = YES;
    tf.accessibilityLabel       = text;
    tf.delegate = self;
    
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

/* Function: - (UITableViewCell *)createBasicInfoCellAtIndexPath:(NSIndexPath *)indexPath
 * Create a cell for the top section of the tableView. All of those cells should be of 
 * the type AddMethodCell (see nib), where each cell contains a UILabel indicating the
 * type of information to be stored and a UITextField indicating the value for the given
 * parameter.
 * Returns the cell initialized with information according to setTextForCell:atIndexPath:
 */

- (UITableViewCell *)createBasicInfoCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddMethodCell"];
    
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddMethodCell"] autorelease];
        
        [[NSBundle mainBundle] loadNibNamed:@"AddMethodTableViewCell" 
                                      owner:self 
                                    options:nil];
        cell = amCell;
        self.amCell = nil;
    }
    
    [self setTextForCell:cell 
             atIndexPath:indexPath];
    
    return cell;
}

/* Function: - (UITableViewCell *)createDetailCellAtIndexPath:(NSIndexPath *)indexPath
 * Initialize and return a UITableViewCell with stle UITableViewCellStyleDefault with
 * a label matching the indexPath (eg. either "Instructions" or "Preparation"
 */

- (UITableViewCell *)createDetailCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"DefaultCell"];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.shadowColor = [UIColor lightTextColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Instructions";
    } else {
        cell.textLabel.text = @"Preparation";
    }
    
    return cell;
}

-(UITableViewCell *)createSaveButton
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DefaultSaveCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"DefaultSaveCell"];
        
        cell.textLabel.text = @"Save";
        
        //        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.shadowColor = [UIColor lightTextColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, 1);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }    
    
    if ([self hasCompleteBrewMethod]) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        cell = [self createBasicInfoCellAtIndexPath:indexPath];
        
    } else if (indexPath.section == 1) { // Initialize lower cells
        
        cell = [self createDetailCellAtIndexPath:indexPath];
        
    } else {
        
        cell = [self createSaveButton];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *img = [self imageForCellAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:img];
    
    /* Accessibility */
    cell.isAccessibilityElement = NO;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ADD_METHOD_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    if (section == ADD_METHOD_SECTIONS - 2) {
        return ADD_METHOD_LOWER_ROWS;
    } else if (section == ADD_METHOD_SECTIONS - 1){
        return ADD_METHOD_BOTTOM_ROWS;
    } else {
        return ADD_METHOD_UPPER_ROWS;
    }
}

- (void)openAddDetailViewControllerOfType:(NSString *)type
{
    if ([type isEqualToString:@"Instructions"] ||
        [type isEqualToString:@"Preparation"]) {
        
        if (!self.adVC) {
            self.adVC = [[AddDetailViewController alloc] init];
        }
        
        if ([type isEqualToString:@"Instructions"]) {
            self.adVC.data          = instructions;
            self.adVC.detailType    = @"Instructions";
        } else {
            self.adVC.data          = preparation;
            self.adVC.detailType    = @"Preparation";
        }
        
        self.adVC.detailType = type;
        
        [self.adVC.navigationItem setTitle:type];
        
        
        self.adVC.navigationItem.leftBarButtonItem = 
        [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                         style:UIBarButtonItemStyleBordered 
                                        target:self.adVC
                                        action:@selector(checkData:)];
        
        
        [self.navigationController pushViewController:self.adVC animated:YES];
    }
}

- (void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *label = cell.textLabel.text;
    if (indexPath.section == 1) { // Tapped Instructions/preparation
        [self openAddDetailViewControllerOfType:label];
    } else if (indexPath.section == 2) { // Tapped save
        if ([self hasCompleteBrewMethod]) {
            //            [self saveBrewMethod];
        } else {
#if RUN_KIF_TESTS
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Not full method" message:@"Insufficient information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
#endif
        }
    }
    
    
    
}

#pragma mark - UITextField protocol

/* - (void)textFieldDidEndEditing:(UITextField *)textField;
 * Make sure that changes in the UITextFields persist by storing them
 * in the basicInfo dictionary. Note the textfield have tags t + 10,
 * where t is the tag of the textField.
 */

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    /*int tag = textField.tag;
     UILabel *label = (UILabel *)[self.view viewWithTag:(tag + 10)];
     NSString *text = textField.text;
     
     if (label != nil &&
     ![label.text isEqualToString:@""]) {
     
     if ([text isEqualToString:@""]) {
     [basicInfo removeObjectForKey:label.text];
     } else {
     [basicInfo setValue:textField.text forKey:label.text];
     }
     }*/
    
    
    NSString *key = nil;
    if ([textField isEqual:nameField]) {
        key = @"Name";
    } else if ([textField isEqual:equipmentField]) {
        key = @"Equipment";
    } else if ([textField isEqual:coffeeField]) {
        key = @"Coffee";
    } else if ([textField isEqual:waterField]) {
        key = @"Water";
    }
    
    if (key != nil) {
        if ([textField.text isEqualToString:@""]) {
            [basicInfo removeObjectForKey:key];
        } else {
            [basicInfo setValue:textField.text forKey:key];
        }
    }
    
    
    // Reload data to possibly enable Save button. Somewhat inefficient
    [self.tableView reloadData];
    
    
}

/* - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
 * Have the last cell in the upper section display a "Done" key
 */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /* if (textField.tag == MAX_TEXTFIELD_TAG - 1) {*/
    textField.returnKeyType = UIReturnKeyDone;
    /*    } else {
     textField.returnKeyType = UIReturnKeyNext;
     }*/
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
    /*
     int nextTag = textField.tag + 1;*/
    [textField resignFirstResponder];
    
    /*    if (nextTag < MAX_TEXTFIELD_TAG) {
     UITextField *tf = (UITextField *)[self.view viewWithTag:nextTag];
     [tf becomeFirstResponder];
     }*/
    
    return YES;
}


/* Function: -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
 *                                                                 replacementString:(NSString *)string
 * Make sure we never exceed the bounds of the text field.
 */

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string
{
    NSLog(@"string: %@", string);
    
    NSString *key = nil;
    if ([textField isEqual:nameField]) {
        key = @"Name";
    } else if ([textField isEqual:equipmentField]) {
        key = @"Equipment";
    } else if ([textField isEqual:coffeeField]) {
        key = @"Coffee";
    } else if ([textField isEqual:waterField]) {
        key = @"Water";
    }
    
    if (key != nil) {
        if (![string isEqualToString:@""]) {
            [basicInfo setObject:textField.text forKey:key];
        } else {
            [basicInfo removeObjectForKey:key];
        }
    } 
    /*     
     NSString *newString = [textField.text stringByAppendingString:string];
     CGSize textSize = [newString sizeWithFont:[textField font]];
     return YES;*/
    //    return textSize.width < TEXTFIELD_MAX_WIDTH;
    return YES;
} 

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SimpleMatteBackground.png"]];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = background;
    
    self.tableView.bounces = NO;
    
    self.navigationItem.title = @"Add Method";
    self.navigationItem.backBarButtonItem.title = @"Methods";
    
    self.tableView.isAccessibilityElement   = YES;
    self.tableView.accessibilityLabel       = @"Add Method Table";
    
    [background release]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [nameField release];
    nameField = nil;
    
    [equipmentField release];
    equipmentField = nil;
    
    [coffeeField release];
    coffeeField = nil;
    
    [waterField release];
    waterField = nil;
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
    
    [instructions release];
    instructions = nil;
    
    [preparation release];
    preparation = nil;
    
    [adVC release];
    adVC = nil;
    
    [super dealloc];
}

@end
