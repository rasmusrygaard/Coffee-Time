//
//  CoffeeTimerAppDelegate.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoffeeTimerAppDelegate.h"
#import "BrewMethodViewController.h"
#import "BrewMethodListViewController.h"
#import "BrewMethod.h"

@implementation CoffeeTimerAppDelegate

@synthesize window = _window, enteredBackgroundWithTimerRunning;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    bmlViewController = [[BrewMethodListViewController alloc] init];
    
    [bmlViewController setBrewMethods:[BrewMethod initBrewMethods]];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:bmlViewController];
    
	[[self window] setRootViewController:navController];
    [navController release];
    
    if ([bmlViewController hasStarredMethod]) {
        [bmlViewController launchWithStarredMethod];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    BrewMethodViewController *runningMethod = [bmlViewController bmViewController];
    
    BOOL animated = (application.applicationState == UIApplicationStateActive);
            
    NSArray *scheduledNotifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if ([scheduledNotifs count] > 0) { // Don't remove cell if we've executed all notifications
        [runningMethod removeTopInstructionsCellWithAnimation:animated];
    } else { // Final method
        [runningMethod brewMethodFinished];
    }
}

/*
 * Function: - (void)applicationDidBecomeActive:(UIApplication *)application
 * Run the starred brew method if such a method is configured and the user is not
 * already running a timer. 
 */

- (void)applicationDidBecomeActive:(UIApplication *)application
{   
    if (bmlViewController &&
        ![self->bmlViewController timerIsRunning] &&
        [self->bmlViewController hasStarredMethod] &&
        !self.enteredBackgroundWithTimerRunning) {
        [bmlViewController runStarredMethod];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    self.enteredBackgroundWithTimerRunning = [self->bmlViewController timerIsRunning];
}


- (void)dealloc
{
    [_window release];
    [bmlViewController release];
    [super dealloc];
}

@end
