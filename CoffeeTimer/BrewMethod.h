//
//  BrewMethod.h
//  CoffeeTimer
//
//  Created by Rasmus Rygaard on 01/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerStep.h"

@interface BrewMethod : NSObject
{
    NSString *name; // Name of brew method

    NSArray *timerSteps; // Timer steps
    int stepCounter;
}

+(NSMutableArray *)initBrewMethods;

- (id)initWithName:(NSString *)name timerStepArray:(NSArray *)steps;

- (TimerStep *)firstTimerStep;
- (TimerStep *)nextTimerStep;
- (NSString *)commaSeparatedTimerSteps;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSArray *timerSteps;

@end
