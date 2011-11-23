//
//  BrewMethod.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerStep.h"

@interface BrewMethod : NSObject <NSCoding>
{
    NSString *name; // Name of brew method

    NSArray *timerSteps; // Timer steps

    NSArray *prepArray; // Array of preparation 
    NSArray *equipArray; // Array of equipment
    
    int stepCounter;
}

// Initialize methods
+(BrewMethod *)initTestMethod;
+(BrewMethod *)initAeropressMethod;
+(BrewMethod *)initChemexMethod;

+(NSMutableArray *)initBrewMethods;

- (id)initWithName:(NSString *)name timerStepArray:(NSArray *)steps;

- (id)initWithName:(NSString *)methodName 
    timerStepArray:(NSArray *)steps
       preparation:(NSArray *)prepArray
         equipment:(NSArray *)equipArray;

/*
 * Function: - (TimerStep *)firstTimerStep;
 * Usage: TimerStep *ts = [currentMethod firstTimerStep];
 * Returns the first TimerStep for a BrewMethod
 */

- (TimerStep *)firstTimerStep;

/*
 * Function: - (TimerStep *)nextTimerStep;
 * Usage: TimerStep *next = [currentMethod nextTimerStep];
 * Returns the next TimerStep for a given function, starting at the _second_
 * step. To get the first step, use firstTimerStep. If no more steps are
 * left, this function returns nil;
 */

- (TimerStep *)nextTimerStep;

/*
 * Function: - (void)resetTimerSteps;
 * Usage: [currentMethod resetTimerSteps];
 * Resets the cycle of TimerStep's. After calling this, the next call
 * to nextTimerStep will return the second timerStep
 */

- (void)resetTimerSteps;

/*
 * Function: - (int)totalTimeInSeconds;
 * int time = [currentMethod totalTimeInSeconds];
 * Returns the total time for a given BrewMethod in seconds. Use
 * [TimerStep formattedTimeInSecondsForInterval:time] to get a minute/second
 * formatted string.
 */

- (int)totalTimeInSeconds;

/*
 * Function: - (NSArray *)timeIntervals;
 * Returns an array of NSString* with the formatted time for each
 * step in the BrewMethod.
 */

- (NSArray *)timeIntervals;

/*
 * Function: - (NSArray *)descriptionsForTab:(NSString *)tabName;
 * Returns an array of descriptions for a tab (i.e "Instructions", 
 * "Equipment", or "Preparation"). If called with a tab other than those
 * three, this method returns nil.
 */

- (NSArray *)descriptionsForTab:(NSString *)tabName;

- (NSString *)commaSeparatedTimerSteps;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *timerSteps;
@property (nonatomic, retain) NSArray *prepArray;
@property (nonatomic, retain) NSArray *equipArray;

@end
