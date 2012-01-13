//
//  BrewMethodListViewController.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrewMethodViewController.h"
#import "AddMethodViewController.h"

@interface BrewMethodListViewController : UITableViewController <BrewMethodList, NSCoding, UIAlertViewDelegate> {

    NSArray *brewMethods;
    BrewMethodViewController *bmViewController;
    UITableViewCell *tvlCell;
    
    NSIndexPath *activeCell;
    int starredMethodIndex;
    
    IBOutlet UIBarButtonItem *addButton;
    
    BOOL wantsToSwitchMethod;
    NSIndexPath *toSwitchTo;
}

-(IBAction)starredMethod:(id)sender;
-(IBAction)addMethod:(id)sender;

/* -(BOOL)hasStarredMethod;
 * Returns true if the user has selected some method as a favorite
 */

-(BOOL)hasStarredMethod;
-(void)setStarredMethodIndex:(int)index;
-(BOOL)timerIsRunning;

- (BOOL)isRunningSameMethod:(NSString *)method;

- (void)runStarredMethod;
- (void)launchWithStarredMethod;

- (void)archiveBrewMethods;
- (NSString *)brewMethodsPath;

- (void)initBrewMethods;


@property (nonatomic, retain) NSArray *brewMethods;
@property (nonatomic, retain) BrewMethodViewController *bmViewController;
@property (nonatomic, assign) IBOutlet UITableViewCell *tvlCell;
@property (nonatomic, retain) NSIndexPath *activeCell;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic, assign) int starredMethodIndex;
@property (nonatomic, assign) BOOL wantsToSwitchMethod;
@property (nonatomic, retain) NSIndexPath *toSwitchTo;

@end
