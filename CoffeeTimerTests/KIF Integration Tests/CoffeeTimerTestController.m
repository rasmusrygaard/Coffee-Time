//
//  CoffeeTimerTestController.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoffeeTimerTestController.h"
#import "EXTestController.h"
#import "KIFTestScenario+CTAdditions.h"

@implementation CoffeeTimerTestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToRunMethod]];
    [self addScenario:[KIFTestScenario scenarioToSwitchMethod]];
}

@end