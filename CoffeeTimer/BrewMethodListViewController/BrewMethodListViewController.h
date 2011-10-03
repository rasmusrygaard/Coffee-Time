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
}

@property (nonatomic, retain) NSArray *brewMethods;

@end