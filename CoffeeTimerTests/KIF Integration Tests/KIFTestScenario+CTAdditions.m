//
//  KIFTestScenario+CTAdditions.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFTestScenario+CTAdditions.h"
#import "KIFTestScenario.h"
#import "KIFTestStep.h"

@implementation KIFTestScenario (CTAdditions)

+ (id)scenarioToRunMethod
{
    KIFTestScenario *sc = [KIFTestScenario scenarioWithDescription:@"Test that the user can select and run a method"];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Aeropress, 0 minutes, 30 seconds"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Start"]];
        
    return sc;
}

@end
