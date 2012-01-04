//
//  CoffeeTimerTestController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoffeeTimerTestController.h"
#import "EXTestController.h"

@implementation CoffeeTimerTestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToLogIn]];
    // Add additional scenarios you want to test here
}

@end