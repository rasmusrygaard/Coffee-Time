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

@synthesize detailType, data;

- (id)init
{
    [super initWithStyle:UITableViewStyleGrouped];
    
    [self.tableView setEditing:YES];
    data = [[NSMutableArray alloc] init];
    
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
		
		// Create a basic cell
		UITableViewCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
		
		if (!basicCell)
			basicCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
												reuseIdentifier:@"UITableViewCell"] autorelease];
		// Set its label to say "Add New Item..."
		[[basicCell textLabel] setText:[NSString stringWithFormat:@"Add New %@...", [self.navigationItem title]]];
		
		return basicCell;	
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [data count] + 1;
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

-  (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        TimerStep *t = [[TimerStep alloc] initWithDescription:@"A timer step" timeInSeconds:30];
        [data addObject:t];
        [self.tableView reloadData];
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
  //                            withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
