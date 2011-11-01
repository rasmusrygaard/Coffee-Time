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

    NSArray *methods = [BrewMethod initBrewMethods];

    [bmlViewController setBrewMethods:methods];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:bmlViewController];
    
	[[self window] setRootViewController:navController];
    [navController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}


- (void)dealloc
{
    [_window release];
    [bmlViewController release];
    [super dealloc];
}

@end
