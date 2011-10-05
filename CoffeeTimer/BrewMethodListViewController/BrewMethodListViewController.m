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

@synthesize brewMethods;

- (id)init 
{
    [super initWithStyle:UITableViewStyleGrouped];
    [[self navigationItem] setTitle:@"Brew Methods"];
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	return [self init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [brewMethods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UIImageView *img;
    
    if (indexPath.row == 0) { // Top cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrewMethodTopCell"];
    
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                   reuseIdentifier:@"BrewMethodTopCell"];
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedTop.png"]];
        } 
             
    } else if (indexPath.row == [brewMethods count] - 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrewMethodBottomCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:@"BrewMethodBottomCell"];
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellRoundedBottom.png"]];
        }
    } else { // Remaining Cells
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrewMethodCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:@"BrewMethodCell"];
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell.png"]];

        }
    }

    [cell setContentMode:UIViewContentModeScaleToFill];
    [cell setBackgroundView:img];
    [img release];
    
    BrewMethod *method = [brewMethods objectAtIndex:[indexPath row]];

    // Text styling
    cell.textLabel.text = [method name];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    cell.textLabel.shadowColor = [UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    // Subtitle styling
    cell.detailTextLabel.text = [method totalTime];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    cell.detailTextLabel.shadowColor = [UIColor blackColor];
    cell.detailTextLabel.shadowOffset = CGSizeMake(0, -1);
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return [cell autorelease];
}

- (void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!bmViewController) {
        bmViewController = [[BrewMethodViewController alloc] init];
    }

    [bmViewController setCurrentMethod:[brewMethods objectAtIndex:[indexPath row]]];
    [[bmViewController navigationItem] setTitle:[[bmViewController currentMethod] name]];
    
    [[self navigationController] pushViewController:bmViewController 
                                           animated:YES];
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
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"MatteBackground.png"]];
    [[self view] setBackgroundColor:background];
    
    [[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackOpaque];
    [[self navigationItem] setTitle:@"Methods"];
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

@end
