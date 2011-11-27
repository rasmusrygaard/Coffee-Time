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

@synthesize addMethodView, amCell;

-(id)init
{
    [super initWithStyle:UITableViewStyleGrouped];
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

- (void)setTextForCell:(UITableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UITextField *tf = (UITextField *)[cell viewWithTag:2];
    
    NSString *text, *textField;

    if (indexPath.row == 0) return;
        
    switch (indexPath.row) {
        case 1:
            text = @"Equipment:", textField = @"Aeropress";
            break;
        case 2:
            text = @"Coffee:", textField = @"26 g";
            break;
        case 3:
            text = @"Water:", textField = @"200 g";
            break;
        default:
            break;
    }
    
    label.text = text;
    tf.placeholder = textField;
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] init];
        
        if (indexPath.row == 0) {
            [[NSBundle mainBundle] loadNibNamed:@"AddMethodTableViewTopCell"
                                          owner:self
                                        options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"AddMethodTableViewCell" 
                                          owner:self 
                                        options:nil];
        }
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



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SimpleMatteBackground.png"]];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = background;
    
    self.tableView.bounces = FALSE;
    
    self.navigationItem.title = @"Add Method";
    
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
    [addMethodView release];
}

@end
