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

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    bmlViewController = [[BrewMethodListViewController alloc] init];
    
    [bmlViewController setBrewMethods:[BrewMethod initBrewMethods]];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:bmlViewController];
    
	[[self window] setRootViewController:navController];
    [navController release];
    
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


- (void)dealloc
{
    [_window release];
    [bmlViewController release];
    [super dealloc];
}

@end
