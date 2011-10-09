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
    NSLog(@"%d", [brewMethods count]);
    return [brewMethods count];
}

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
 */

- (void)styleInfoTableSubtitleLabelForCell:(UITableViewCell *)cell
{
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    cell.detailTextLabel.shadowColor = [UIColor blackColor];
    cell.detailTextLabel.shadowOffset = CGSizeMake(0, -1);
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
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigCellWRoundedTop.png"]];
        } 
             
    } else if (indexPath.row == [brewMethods count] - 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrewMethodBottomCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:@"BrewMethodBottomCell"];
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigCellWRoundedBottom.png"]];
        }
    } else { // Remaining Cells
        cell = [tableView dequeueReusableCellWithIdentifier:@"BrewMethodCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:@"BrewMethodCell"];
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigCell.png"]];

        }
    }

    [cell setContentMode:UIViewContentModeScaleToFill];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    if ([cell backgroundView] == nil) {
        [cell setBackgroundView:img];
         NSLog(@"img: %@", img);
   
        [img release];
//            pNSLog(@"nil");
    }
    
    BrewMethod *method = [brewMethods objectAtIndex:[indexPath row]];

    // Text styling
    cell.textLabel.text = [method name];
    [self styleInfoTableTextLabelForCell:cell];
    
    // Subtitle styling
    cell.detailTextLabel.text = [TimerStep formattedTimeInSecondsForInterval:[method totalTimeInSeconds]];
    [self styleInfoTableSubtitleLabelForCell:cell];
    
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
    
    NSString *methodToDisplay = [[bmViewController currentMethod] name];
    [[bmViewController navigationItem] setTitle:methodToDisplay];
    
    [[self navigationController] pushViewController:bmViewController 
                                           animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
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
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SimpleMatteBackground.png"]];

    [[self view] setBackgroundColor:[UIColor blackColor]];
    [[self view] setBackgroundColor:background];
    
    [background release];   
    
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
