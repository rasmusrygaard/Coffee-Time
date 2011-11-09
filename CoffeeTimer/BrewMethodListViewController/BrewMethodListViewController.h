//
//  BrewMethodListViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrewMethodViewController.h"

@interface BrewMethodListViewController : UITableViewController {
    NSArray *brewMethods;
    BrewMethodViewController *bmViewController;
    UITableViewCell *tvlCell;
    
    NSIndexPath *activeCell;
    int starredMethodIndex;
}

-(IBAction)starredMethod:(id)sender;

/* -(BOOL)hasStarredMethod;
 * Returns true if the user has selected some method as a favorite
 */

-(BOOL)hasStarredMethod;

- (void)launchWithStarredMethod;

@property (nonatomic, retain) NSArray *brewMethods;
@property (nonatomic, retain) BrewMethodViewController *bmViewController;
@property (nonatomic, assign) IBOutlet UITableViewCell *tvlCell;
@property (nonatomic, retain) NSIndexPath *activeCell;

@end
