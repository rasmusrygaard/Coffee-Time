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
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrewMethodTopCell"];
    
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                   reuseIdentifier:@"BrewMethodTopCell"] autorelease];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TileRoundedTop.png"]];
        [cell setBackgroundView:img];
        } 
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrewMethodCell"];
        
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:@"BrewMethodCell"] autorelease];
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tile.png"]];
            [cell setBackgroundView:img]; 
        }
    }
    
    BrewMethod *method = [brewMethods objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[method name]];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!bmViewController) {
        bmViewController = [[BrewMethodViewController alloc] init];
    }
    
    [bmViewController setCurrentMethod:[brewMethods objectAtIndex:[indexPath row]]];
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
    [[self navigationItem] setTitle:@"Brew Methods"];
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
