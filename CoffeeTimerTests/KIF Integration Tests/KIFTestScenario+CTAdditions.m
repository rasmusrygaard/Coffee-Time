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
    // Select the "Aeropress" method
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Aeropress, 0 minutes, 30 seconds"]];
    // Start the method
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Start"]];
    // Return to the list screen
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];
    // Return to the method
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Aeropress, 0 minutes, 30 seconds"]];
    
    /* Taps not fully functional
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Preparation"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Equipment"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Instructions"]];
    */
    
    [sc addStep:[KIFTestStep stepToWaitForTimeInterval:10 description:@"Waiting for timer"]];
    return sc;
}

@end
