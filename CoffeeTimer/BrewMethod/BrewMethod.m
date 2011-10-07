//
//  BrewMethod.m
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrewMethod.h"
#import "TimerStep.h"

@implementation BrewMethod

@synthesize name, timerSteps, prepArray, equipArray;

- (id)init
{
    return [self initWithName:@"" timerStepArray:nil];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Method: %@. Steps: %@", name, [self commaSeparatedTimerSteps]];
    return desc;
}

- (id)initWithName:(NSString *)methodName 
    timerStepArray:(NSArray *)steps
{
    if (self = [super init]) {
        [self setName:methodName];
        
        [self setTimerSteps:steps];
        
        stepCounter = 1;
    }
    return self;
}

- (id)initWithName:(NSString *)methodName 
    timerStepArray:(NSArray *)steps
       preparation:(NSArray *)preparation
         equipment:(NSArray *)equipment
{
    if (self = [super init]) {
        [self setName:methodName];
        
        [steps retain];
        [self setTimerSteps:steps];
        [preparation retain];
        [self setPrepArray:preparation];
        [equipment retain];
        [self setEquipArray:equipment];
        
        stepCounter = 1;
    }
    
    return self;
}

+(BrewMethod *)initTestMethod
{
    // Initialize instructions
    TimerStep *ts1 = [[[TimerStep alloc] initWithDescription:@"first step" 
                                               timeInSeconds:10] autorelease];
    TimerStep *ts2 = [[[TimerStep alloc] initWithDescription:@"second step" 
                                               timeInSeconds:5] autorelease];
    TimerStep *ts3 = [[[TimerStep alloc] initWithDescription:@"third, final step" 
                                               timeInSeconds:15] autorelease];
    NSArray *testStepArray = [NSArray arrayWithObjects:ts1, ts2, ts3, nil];
    
    BrewMethod *method = [[BrewMethod alloc] initWithName:@"Test Method"
                                           timerStepArray:testStepArray];
    
    return [method autorelease];
}

+(BrewMethod *)initAeropressMethod
{
    // Initialize instructions
    TimerStep *apStepOne = [[[TimerStep alloc] initWithDescription:@"Pour water over the grounds"
                                                    timeInSeconds:5] autorelease];
    TimerStep *apStepTwo = [[[TimerStep alloc] initWithDescription:@"Turn the Aeropress upside down, plunge slowly"
                                                    timeInSeconds:20] autorelease];
    
    NSArray *apStepArray = [NSArray arrayWithObjects:apStepOne, apStepTwo, nil];
    
    
    // Initialize preparation
    NSArray *apPrepArray = [NSArray arrayWithObjects:
                            @"Grind the beans medium fine",
                            @"Pre-wet the filter with plenty of cold water",
                            @"Turn the Aeropress upside down",
                            @"Push the plunger to the \"4\" mark", nil];
    
    // Initialize equipment
    NSArray *apEquipArray = [NSArray arrayWithObjects:
                             @"Aeropress", 
                             @"14g of coffee beans",
                             @"300 ml water at 90 degrees", nil];
    
    
    
    BrewMethod *method = [[BrewMethod alloc] initWithName:@"Aeropress" 
                                           timerStepArray:apStepArray
                                              preparation:apPrepArray
                                                equipment:apEquipArray];
    
    return [method autorelease];
}

+(BrewMethod *)initChemexMethod
{
    // Initialize instructions
    TimerStep *cStepOne = [[[TimerStep alloc] initWithDescription:@"Pour water over grounds to start the bloom" 
                                                   timeInSeconds:45] autorelease];
    TimerStep *cStepTwo = [[[TimerStep alloc] initWithDescription:@"Pour more water to fully saturate the grounds" 
                                                   timeInSeconds:60] autorelease];
    TimerStep *cStepThree = [[[TimerStep alloc] initWithDescription:@"Pour more water until the weight reaches 700g" 
                                                     timeInSeconds:135] autorelease];
    NSArray *cStepArray = [NSArray arrayWithObjects:cStepOne, cStepTwo, cStepThree, nil];
    
    
    NSArray *cPrepArray = [NSArray arrayWithObjects:
                           @"Place the filter with the three-layered side by the sprout",
                           @"Run plenty of water through the filter",
                           @"Empty the Chemex",
                           @"Grind 45 g of beans medium fine and place them in the filter", nil];
    
    NSArray *cEquipArray = [NSArray arrayWithObjects:
                            @"Chemex",
                            @"45 g of coffee beans",
                            @"700 ml of water at 90 degrees", nil];
    
    BrewMethod *method = [[BrewMethod alloc] initWithName:@"Chemex"
                                           timerStepArray:cStepArray
                                              preparation:cPrepArray 
                                                equipment:cEquipArray];  
    
    return [method autorelease];
}

+ (NSArray *)initBrewMethods
{
    BrewMethod *test = [self initTestMethod];
    
    BrewMethod *aeropress = [self initAeropressMethod];
    NSLog(@"Aeropress: %@", aeropress);

    BrewMethod *chemex = [self initChemexMethod];
    
    NSArray *brewMethods = [NSArray arrayWithObjects:test, aeropress, chemex, nil];
    
    return brewMethods;
}

- (TimerStep *)firstTimerStep
{
    return [timerSteps objectAtIndex:0];
}

- (TimerStep *)nextTimerStep
{
    TimerStep *next = nil;
    
    if (stepCounter < [timerSteps count]) {
        next = [timerSteps objectAtIndex:stepCounter];
        stepCounter++;
    }
    
    return next;
}

- (void)resetTimerSteps
{
    stepCounter = 1;
}

/* - (NSString *)totalTime;
 * Returns the total time for the brewmethod formatted using formatedTimeInSeconds.
 * E.G a total time of 70 seconds would return the string "01:10";
 */

- (int)totalTimeInSeconds;
{
    int total = 0;
    
    for (TimerStep *t in timerSteps) {
        total += [t timeInSeconds];
    }
    
    return total;
}

// Returns a copy of the array!

- (NSArray *)descriptionsForTab:(NSString *)tabName
{
    NSMutableArray *copyArr = nil;
    
    if ([tabName isEqualToString:@"Equipment"]) {
        copyArr = [equipArray copy];
    } else if ([tabName isEqualToString:@"Preparation"]) {
        copyArr = [prepArray copy];
    } else if ([tabName isEqualToString:@"Instructions"]) {
        copyArr = [[NSMutableArray alloc] initWithCapacity:[timerSteps count]];
        for (TimerStep *t in timerSteps) {
            [copyArr addObject:[t descriptionWithoutTime]];
        }
    }

    return [copyArr autorelease];
}

- (NSArray *)timeIntervals
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[timerSteps count]];

    for (TimerStep *t in timerSteps) {
        [array addObject:[t formattedTimeInSeconds]];
    }
    return [array autorelease];
}

- (NSString *)commaSeparatedTimerSteps
{
    NSString *result = [NSString stringWithFormat:@"%@", [[self firstTimerStep] description]];
    int count = [timerSteps count];

    for (int i = 1; i < count; ++i) {
        result = [result stringByAppendingFormat:@", %@", [[timerSteps objectAtIndex:i] description]];
    }
    return result;
}

@end
