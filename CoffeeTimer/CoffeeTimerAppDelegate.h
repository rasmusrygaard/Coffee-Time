//
//  CoffeeTimerAppDelegate.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrewMethodListViewController.h"
#import <QuartzCore/QuartzCore.h>

@class BrewMethodViewController;

@interface CoffeeTimerAppDelegate : NSObject <UIApplicationDelegate>
{
    BrewMethodListViewController *bmlViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
