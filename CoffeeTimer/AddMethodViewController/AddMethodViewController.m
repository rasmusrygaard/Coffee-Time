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
        
//    } else if (indexPath.row == [self.brewMethods count] - 1) {
//        
//        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedBottom.png"]];
//        
    } else { // Remaining Cells
        
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell.png"]];
        
    }
    
    return [img autorelease];
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    [[NSBundle mainBundle] loadNibNamed:@"AddMethodTableViewCell" owner:self options:nil];
    cell = amCell;
    self.amCell = nil;
    
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
