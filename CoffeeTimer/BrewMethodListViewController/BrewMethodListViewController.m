//
//  BrewMethodListViewController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrewMethodListViewController.h"
#import "BrewMethodViewController.h"
#import "BrewMethod.h"

@implementation BrewMethodListViewController

@synthesize brewMethods, tvlCell, bmViewController, activeCell;

- (id)init 
{
    if (self = [super init]) {
        [super initWithStyle:UITableViewStyleGrouped];
        [[self navigationItem] setTitle:@"Brew Methods"];
        
        starredMethodIndex = 1;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}

- (void)initBMViewController
{
    self.bmViewController = [[BrewMethodViewController alloc] init];
    self.bmViewController.superList = self;
    [bmViewController addObserver:self 
                       forKeyPath:@"secondsLeft" 
                          options:NSKeyValueObservingOptionNew
                          context:nil];
}

/* Function: -(IBAction)starredMethod:(id)sender
 * Called in response to a tap on the star button in the list. Get the indexPath
 * for the cell that was tapped and set that method as starred. If that method
 * was already starred, un-star it.
 */

-(IBAction)starredMethod:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    if (path.row == starredMethodIndex) {
        starredMethodIndex = -1;
    } else {
        starredMethodIndex = path.row;
    }

    [self.tableView reloadData];
}

-(BOOL)hasStarredMethod;
{
    return (starredMethodIndex != -1);
}

-(BOOL)timerIsRunning
{
    return (self.bmViewController != nil) &&
            [self.bmViewController timerIsRunning];
}

/* Function: - (void)launchWithStarredMethod
 * Used for launching a method on startup. Push a BrewMethodViewController with the
 * starred method and have that method start timing immediately.
 */

- (void)launchWithStarredMethod
{    
    if (!bmViewController) {
        [self initBMViewController];
    }
    
    [self runStarredMethod];
}

/* Function: - (void)runStarredMethod
 * This method is called after launching the app when a starred method is currently
 * set up. If there is already a viewcontroller from an old brew method, pop it.
 * Then, set up a new controller for the new method, set the active method and
 * run it. 
 */

- (void)runStarredMethod
{
    if (self.bmViewController.view.window) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    [self.bmViewController setCurrentMethod:[brewMethods objectAtIndex:starredMethodIndex]];
    
    NSString *methodToDisplay = [[bmViewController currentMethod] name];
    [[bmViewController navigationItem] setTitle:methodToDisplay];
    
    [self.navigationController pushViewController:bmViewController 
                                         animated:NO];
    
    self.activeCell = [NSIndexPath indexPathForRow:starredMethodIndex inSection:0];
    self.bmViewController.autoStartMethod = true;
    
    [self.bmViewController startStarredMethod];
}

-(void)resetAfterFinishedMethod
{
    self.activeCell = nil;
    [self.tableView reloadData]; 
}

#pragma mark TableView

/* Function: - (void)styleInfoTableTextLabelForCell:(UITableViewCell *)cell
 * Do any custom styling of a cell in the information table
 */

- (void)styleInfoTableTextLabelForCell:(UITableViewCell *)cell
{
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    cell.textLabel.shadowColor = [UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    cell.textLabel.textAlignment = UITextAlignmentCenter;
}

/*
 * Function: - (void)styleInfoTableSubtitleLabelForCell:(UITableViewCell *)cell
 * Style the subtitle of a cell in the information tableView
 */

- (void)styleInfoTableSubtitleLabelForCell:(UITableViewCell *)cell
{
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    cell.detailTextLabel.shadowColor = [UIColor blackColor];
    cell.detailTextLabel.shadowOffset = CGSizeMake(0, -1);
}

/*
 * Function: - (UIImageView *)getImageForCellAtIndexPath:(NSIndexPath *)indexPath
 * Returns an image based on where in the tableView the cell at indexPath is.
 * Note that this method returns an autoreleased UIImageView.
 */

- (UIImageView *)getImageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *img;
    
    if (indexPath.row == 0) { // Top cell
        
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigCellWRoundedTop.png"]];

    } else if (indexPath.row == [self.brewMethods count] - 1) {
    
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigCellWRoundedBottom.png"]];

    } else { // Remaining Cells
        
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigCell.png"]];
    
    }
    
    return [img autorelease];
}

- (UIColor *)goldenOrange
{
    return [UIColor colorWithRed:(240.0 / 255.0) 
                           green:(213.0 / 255.0) 
                            blue:(132.0 / 255.0) 
                           alpha:1];   
}

/*
 * Function: - (void)styleLabelsForCell:(UITableViewCell *)cell 
 *                            forMethod:(BrewMethod *)method
 * Sets the text for the labels of the UITableViewCell.
 */

- (void)styleLabelsForCell:(UITableViewCell *)cell 
                 forMethod:(BrewMethod *)method
{
    UILabel *label;
    
    // Style title label
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [method name];
    label.numberOfLines = 0;
    
    if (self.bmViewController != nil &&
        [[method name] isEqualToString:[self.bmViewController methodBeingTimed]]) {
        UIColor *color = [self goldenOrange];
        label.textColor = color;
    } else {
        label.textColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    }
    
    // Set up time label
    label = (UILabel *)[cell viewWithTag:2];
    NSString *text = [TimerStep formattedTimeInSecondsForInterval:[method totalTimeInSeconds]];
    label.text = text;
}

/* Function: - (UITableViewCell *)tableView:(UITableView *)tableView 
 *                    cellForRowAtIndexPath:(NSIndexPath *)indexPath
 * Get a new cell for the tableView. Load the custom nib, get the right image,
 * grab a method for it and style the text appropriately.
 */

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    [[NSBundle mainBundle] loadNibNamed:@"BrewMethodListCell" owner:self options:nil];
    cell = tvlCell;
    self.tvlCell = nil;
    
    UIImageView *image = [self getImageForCellAtIndexPath:indexPath];
    
    [cell setContentMode:UIViewContentModeScaleToFill];
    [cell setBackgroundView:image];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    BrewMethod *method = [brewMethods objectAtIndex:[indexPath row]];
    
    [self styleLabelsForCell:cell 
                   forMethod:method];
    
    if (indexPath.row == starredMethodIndex) {
        UIButton *label = (UIButton *)[cell viewWithTag:3];
        NSLog(@"label %@", label);
        label.titleLabel.textColor = [self goldenOrange];
//        text = [NSString stringWithFormat:@"Starred: %@", [method name]];
  //      label.numberOfLines = 0;
    }

    return cell;
}

/* Function: - (void) tableView:(UITableView *)tableView 
 *      didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 * Create a viewController for the new method if it does not already exist. Have
 * it display the method selectio and push it.
 */

- (void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!bmViewController) {
        [self initBMViewController];
     }

    [self.bmViewController setCurrentMethod:[brewMethods objectAtIndex:[indexPath row]]];
    
    NSString *methodToDisplay = [[bmViewController currentMethod] name];
    [[bmViewController navigationItem] setTitle:methodToDisplay];
    
    [self.navigationController pushViewController:bmViewController 
                                         animated:YES];
    
    self.activeCell = indexPath;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LIST_CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [self.brewMethods count];
}

- (void)didReceiveMemoryWarning
{
    // No extra views, no instance variables to release, no cached data
    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.tableView.bounces = NO;
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SimpleMatteBackground.png"]];

    self.view.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = background;
    
    [background release]; 
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"secondsLeft"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:activeCell];
        
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        
        NSNumber *ch = [change objectForKey:NSKeyValueChangeNewKey];
        int ti = [ch integerValue];

        NSString *text = [TimerStep formattedTimeInSecondsForInterval:ti];
        label.text = text;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.bmViewController = nil;
    [bmViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
