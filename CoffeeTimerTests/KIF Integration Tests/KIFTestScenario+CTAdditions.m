//
//  KIFTestScenario+CTAdditions.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFTestScenario+CTAdditions.h"
#import "KIFTestStep+CTAdditions.h"

#import "KIFTestScenario.h"
#import "KIFTestStep.h"

@implementation KIFTestScenario (CTAdditions)

+ (id)scenarioToOpenAllMethods
{
    KIFTestScenario *sc = [KIFTestScenario scenarioWithDescription:@"Verifies that the user can open all methods"];
    
    for (int i = 0; i < 4; ++i) {
        [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" atIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
        [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];
    }
    
    return sc;
}

+ (id)scenarioToRunMethod
{
    KIFTestScenario *sc = [KIFTestScenario scenarioWithDescription:@"Test that the user can select and run a method"];
    // Select and start the "Aeropress" method
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Start"]];

    // Return to the list screen
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];
    // Return to the method
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    
    // Taps not fully functional
    /*
    [sc addStep:[KIFTestStep stepToTapSliderTabWithLabel:@"Preparation"]];
    [sc addStep:[KIFTestStep stepToTapSliderTabWithLabel:@"Instructions"]];
    
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Preparation"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Equipment"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Instructions"]];
    */
    
    KIFTestStep *t = [KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"00:00"];
    t.timeout = 20;
    [sc addStep:t];
    
    [sc addStep:[KIFTestStep stepToWaitForTimeInterval:2 description:@"Wait after method has completed"]];
    
//    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];

    return sc;
}

+ (id)scenarioToSwitchMethod
{
    KIFTestScenario *sc = [KIFTestScenario scenarioWithDescription:@"Test running, switching, and running two methods"];
    
    // Open and start Chemex method
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Start"]];
    [sc addStep:[KIFTestStep stepToWaitForTimeInterval:2 description:@"Let method run for a bit"]];
    
    // Return to list
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];
    
    // Try opening Aeropress method, hit cancel
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    // Reopen the Chemex method
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];

    // Return to list
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];
    
    // Open Aeropress, implicitly cancel Chemex timer
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list"
                                                               atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Yes"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Start"]];
    
    [sc addStep:[KIFTestStep stepToWaitForTimeInterval:2 description:@"Verify that Aeropress is running"]];
    
    // Return to list
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];
    [sc addStep:[KIFTestStep stepToWaitForTimeInterval:2 description:@"Verify that Aeropress is running"]];
    
    // Try opening a couple of other methods, but cancel when alert appears
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    // Reopen Aeropress, should still be running
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    // Stop the method
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Stop"]];
    
    // Return to list, return to Aeropress, start method again
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];
    [sc addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Brew method list" 
                                                               atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Start"]];
    
    // Reset state
    [sc addStep:[KIFTestStep stepToWaitForTimeInterval:5 description:@"Wait before resetting state"]];
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Stop"]];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [sc addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Brew Methods"]];

    
    return sc;
}

+ (id)scenarioToRunManyMethods
{
    KIFTestScenario *sc = [KIFTestScenario scenarioWithDescription:@"Test running a number of methods after each other"];
    
    return sc;
}

@end
