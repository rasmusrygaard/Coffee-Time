//
//  KIFTestScenario+CTAdditions.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 04/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFTestScenario.h"
#import "KIFTestStep.h"

@interface KIFTestScenario (CTAdditions)

+ (id)scenarioToOpenAllMethods;

+ (id)scenarioToRunMethod;

+ (id)scenarioToSwitchMethod;

+ (id)scenarioToRunManyMethods;

+ (id)scenarioToAddInstructions;

+ (id)scenarioToTestFullBrewMethod;

+ (id)scenarioToTestInstructions;

@end
